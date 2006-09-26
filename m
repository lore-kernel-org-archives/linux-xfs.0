Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Sep 2006 13:07:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8QK7baG002256
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 13:07:38 -0700
Received: from pat.uio.no (pat.uio.no [129.240.10.4])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 28657D118FEA
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 12:06:32 -0700 (PDT)
Subject: Re: [NFS] Long sleep with i_mutex in xfs_flush_device(), affects
	NFS service
From: Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal>
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal>
Content-Type: text/plain
Date: Tue, 26 Sep 2006 15:06:19 -0400
Message-Id: <1159297579.5492.21.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: xfs@oss.sgi.com, nfs@lists.sourceforge.net

On Tue, 2006-09-26 at 14:51 -0400, Stephane Doyon wrote:
> Hi,
> 
> I'm seeing an unpleasant behavior when an XFS file system becomes full, 
> particularly when accessed over NFS. Both XFS and the linux NFS client 
> appear to be contributing to the problem.
> 
> When the file system becomes nearly full, we eventually call down to 
> xfs_flush_device(), which sleeps for 0.5seconds, waiting for xfssyncd to 
> do some work.
> 
> xfs_flush_space()does
>          xfs_iunlock(ip, XFS_ILOCK_EXCL);
> before calling xfs_flush_device(), but i_mutex is still held, at least 
> when we're being called from under xfs_write(). It seems like a fairly 
> long time to hold a mutex. And I wonder whether it's really necessary to 
> keep going through that again and again for every new request after we've 
> hit NOSPC.
> 
> In particular this can cause a pileup when several threads are writing 
> concurrently to the same file. Some specialized apps might do that, and 
> nfsd threads do it all the time.
> 
> To reproduce locally, on a full file system:
> #!/bin/sh
> for i in `seq 30`; do
>    dd if=/dev/zero of=f bs=1 count=1 &
> done
> wait
> time that, it takes nearly exactly 15s.
> 
> The linux NFS client typically sends bunches of 16 requests, and so if the 
> client is writing a single file, some NFS requests are therefore delayed 
> by up to 8seconds, which is kind of long for NFS.

Why? The file is still open, and so the standard close-to-open rules
state that you are not guaranteed that the cache will be flushed unless
the VM happens to want to reclaim memory.

> What's worse, when my linux NFS client writes out a file's pages, it does 
> not react immediately on receiving a NOSPC error. It will remember and 
> report the error later on close(), but it still tries and issues write 
> requests for each page of the file. So even if there isn't a pileup on the 
> i_mutex on the server, the NFS client still waits 0.5s for each 32K 
> (typically) request. So on an NFS client on a gigabit network, on an 
> already full filesystem, if I open and write a 10M file and close() it, it 
> takes 2m40.083s for it to issue all the requests, get an NOSPC for each, 
> and finally have my close() call return ENOSPC. That can stretch to 
> several hours for gigabyte-sized files, which is how I noticed the 
> problem.
> 
> I'm not too familiar with the NFS client code, but would it not be 
> possible for it to give up when it encounters NOSPC? Or is there some 
> reason why this wouldn't be desirable?

How would it then detect that you have fixed the problem on the server?

Cheers,
  Trond
