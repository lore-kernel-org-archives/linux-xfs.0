Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Sep 2006 13:09:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8QK8vaG002507
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 13:08:57 -0700
Received: from mail.max-t.com (h216-18-124-229.gtcust.grouptelecom.net [216.18.124.229])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE42845F4CD
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 13:08:14 -0700 (PDT)
Date: Tue, 26 Sep 2006 16:05:41 -0400 (EDT)
From: Stephane Doyon <sdoyon@max-t.com>
In-Reply-To: <1159297579.5492.21.camel@lade.trondhjem.org>
Message-ID: <Pine.LNX.4.64.0609261531430.10642@madrid.max-t.internal>
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal>
 <1159297579.5492.21.camel@lade.trondhjem.org>
MIME-Version: 1.0
Subject: Re: [NFS] Long sleep with i_mutex in xfs_flush_device(), affects
 NFS service
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: xfs@oss.sgi.com, nfs@lists.sourceforge.net

On Tue, 26 Sep 2006, Trond Myklebust wrote:

[...]
>> When the file system becomes nearly full, we eventually call down to
>> xfs_flush_device(), which sleeps for 0.5seconds, waiting for xfssyncd to
>> do some work.
>>
>> xfs_flush_space()does
>>          xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> before calling xfs_flush_device(), but i_mutex is still held, at least
>> when we're being called from under xfs_write(). It seems like a fairly
>> long time to hold a mutex. And I wonder whether it's really necessary to
>> keep going through that again and again for every new request after we've
>> hit NOSPC.
>>
>> In particular this can cause a pileup when several threads are writing
>> concurrently to the same file. Some specialized apps might do that, and
>> nfsd threads do it all the time.
[...]
>> The linux NFS client typically sends bunches of 16 requests, and so if the
>> client is writing a single file, some NFS requests are therefore delayed
>> by up to 8seconds, which is kind of long for NFS.
>
> Why? The file is still open, and so the standard close-to-open rules
> state that you are not guaranteed that the cache will be flushed unless
> the VM happens to want to reclaim memory.

I mean there will be a delay on the server, in responding to the requests. 
Sorry for the confusion.

When the NFS client does flush its cache, each request will take an extra 
0.5s to execute on the server, and the i_mutex will prevent their parallel 
execution on the server.

>> What's worse, when my linux NFS client writes out a file's pages, it does
>> not react immediately on receiving a NOSPC error. It will remember and
>> report the error later on close(), but it still tries and issues write
>> requests for each page of the file. So even if there isn't a pileup on the
>> i_mutex on the server, the NFS client still waits 0.5s for each 32K
>> (typically) request. So on an NFS client on a gigabit network, on an
>> already full filesystem, if I open and write a 10M file and close() it, it
>> takes 2m40.083s for it to issue all the requests, get an NOSPC for each,
>> and finally have my close() call return ENOSPC. That can stretch to
>> several hours for gigabyte-sized files, which is how I noticed the
>> problem.
>>
>> I'm not too familiar with the NFS client code, but would it not be
>> possible for it to give up when it encounters NOSPC? Or is there some
>> reason why this wouldn't be desirable?
>
> How would it then detect that you have fixed the problem on the server?

I suppose it has to try again at some point. Yet when flushing a file, if 
even one write requests gets an error response like ENOSPC, we know some 
part of the data has not been written on the server, and close() will 
return the appropriate error to the program on the client. If a single 
write error is enough to cause close() to return an error, why bother 
sending all the other write requests for that file? If we get an error 
while flushing, couldn't that one flushing operation bail out early? As I 
said I'm not too familiar with the code, but AFAICT nfs_wb_all() will keep 
flushing everything, and afterwards nfs_file_flush() wil check ctx->error. 
Perhaps ctx->error could be checked at some lower level, maybe in 
nfs_sync_inode_wait...

I suppose it's not technically wrong to try to flush all the pages of the 
file, but if the server file system is full then it will be at its worse. 
Also if you happened to be on a slower link and have a big cache to flush, 
you're waiting around for very little gain.
