Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Oct 2006 09:34:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k95GYiaG005750
	for <xfs@oss.sgi.com>; Thu, 5 Oct 2006 09:34:46 -0700
Received: from mail.max-t.com (h216-18-124-229.gtcust.grouptelecom.net [216.18.124.229])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA7E1471372
	for <xfs@oss.sgi.com>; Thu,  5 Oct 2006 09:34:02 -0700 (PDT)
Date: Thu, 5 Oct 2006 12:33:05 -0400 (EDT)
From: Stephane Doyon <sdoyon@max-t.com>
In-Reply-To: <20061005083015.GC19345@melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0610051139540.31641@madrid.max-t.internal>
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal>
 <451A618B.5080901@agami.com> <Pine.LNX.4.64.0610020939450.5072@madrid.max-t.internal>
 <20061002223056.GN4695059@melbourne.sgi.com> <Pine.LNX.4.64.0610030917060.31738@madrid.max-t.internal>
 <20061005083015.GC19345@melbourne.sgi.com>
MIME-Version: 1.0
Subject: Re: several messages
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, xfs@oss.sgi.com, nfs@lists.sourceforge.net, Shailendra Tripathi <stripathi@agami.com>

On Thu, 5 Oct 2006, David Chinner wrote:

> On Tue, Oct 03, 2006 at 09:39:55AM -0400, Stephane Doyon wrote:
>> Sorry for insisting, but it seems to me there's still a problem in need of
>> fixing: when writing a 5GB file over NFS to an XFS file system and hitting
>> ENOSPC, it takes on the order of 22hours before my application gets an
>> error, whereas it would normally take about 2minutes if the file system
>> did not become full.
>>
>> Perhaps I was being a bit too "constructive" and drowned my point in
>> explanations and proposed workarounds... You are telling me that neither
>> NFS nor XFS is doing anything wrong, and I can understand your points of
>> view, but surely that behavior isn't considered acceptable?
>
> I agree that this a little extreme and I can't recall of seeing
> anything like this before, but I can see how that may happen if the
> NFS client continues to try to write every dirty page after getting
> an ENOSPC and each one of those writes has to wait for 500ms.
>
> However, you did not mention what kernel version you are running.
> One recent bug (introduced by a fix for deadlocks at ENOSPC) could
> allow oversubscription of free space to occur in XFS, resulting in

I do have that fix in my kernel. (I'm the one who pointed you to the patch 
that introduced that particular problem.)

> the write being allowed to proceed (i.e. sufficient space for the
> data blocks) but then failing the allocation because there weren't
> enough blocks put aside for potential btree splits that occur during
> allocation. If the linux client is using sync writes on retry, then

The writes from nfsd shouldn't be sync. Technically it's not even 
retrying, just plowing on...

> this would trigger a 500ms sleep on every write.  That's the right
> sort of ballpark for the slowness you were seeing - 5GB / 32k * 0.5s
> = ~22 hours....
>
> This got fixed in 2.6.18-rc6 -

You mean commit 4be536debe3f7b0c right? (Actually -rc7 I believe...) I do 
have that one in my kernel. My kernel is 2.6.17 plus assorted XFS fixes.

> can you retry with a 2.6.18 server
> and see if your problem goes away?

Unfortunately it will be several days before I have a chance to do that.

The backtrace looked like this:

... nfsd_write nfsd_vfs_write vfs_writev do_readv_writev xfs_file_writev 
xfs_write generic_file_buffered_write xfs_get_blocks __xfs_get_blocks 
xfs_bmap xfs_iomap xfs_iomap_write_delay xfs_flush_space xfs_flush_device 
schedule_timeout_uninterruptible.

with a 500ms sleep in xfs_flush_device().

Thanks
