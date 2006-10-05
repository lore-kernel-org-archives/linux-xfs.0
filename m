Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Oct 2006 09:52:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k95Gq6aG008765
	for <xfs@oss.sgi.com>; Thu, 5 Oct 2006 09:52:08 -0700
Received: from mail.max-t.com (h216-18-124-229.gtcust.grouptelecom.net [216.18.124.229])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F4F0471B84
	for <xfs@oss.sgi.com>; Thu,  5 Oct 2006 09:51:24 -0700 (PDT)
Date: Thu, 5 Oct 2006 11:39:45 -0400 (EDT)
From: Stephane Doyon <sdoyon@max-t.com>
In-Reply-To: <1159893642.5592.12.camel@lade.trondhjem.org>
Message-ID: <Pine.LNX.4.64.0610051108140.9190@madrid.max-t.internal>
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal>
 <451A618B.5080901@agami.com>  <Pine.LNX.4.64.0610020939450.5072@madrid.max-t.internal>
  <20061002223056.GN4695059@melbourne.sgi.com>
 <Pine.LNX.4.64.0610030917060.31738@madrid.max-t.internal>
 <1159893642.5592.12.camel@lade.trondhjem.org>
MIME-Version: 1.0
Subject: Re: several messages
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, nfs@lists.sourceforge.net, Shailendra Tripathi <stripathi@agami.com>

On Tue, 3 Oct 2006, Trond Myklebust wrote:

> On Tue, 2006-10-03 at 09:39 -0400, Stephane Doyon wrote:
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
> Sure it is.

If you say so :-).

> You are allowing the kernel to cache 5GB, and that means you
> only get the error message when close() completes.

But it's not actually caching the entire 5GB at once... I guess you're 
saying that doesn't matter...?

> If you want faster error reporting, there are modes like O_SYNC,
> O_DIRECT, that will attempt to flush the data more quickly. In addition,
> you can force flushing using fsync().

What if the program is a standard utility like cp?

> Finally, you can tweak the VM into
> flushing more often using /proc/sys/vm.

It doesn't look to me like a question of degrees about how early to flush. 
Actually my client can't possibly be caching all of 5GB, it doesn't have 
the RAM or swap for that. Tracing it more carefully, it appears dirty data 
starts being flushed after a few hundred MBs. No error is returned on the 
subsequent writes, only on the final close(). I see some of the write() 
calls are delayed, presumably when the machine reaches the dirty 
threshold. So I don't see how the vm settings can help in this case.

I hadn't realized that the issue isn't just with the final flush on 
close(). It's actually been flushing all along, delaying some of the 
subsequent write()s, getting NOSPC errors but not reporting them until the 
end.

I understand that since my application did not request any syncing, the 
system cannot guarantee to report errors until cached data has been 
flushed. But some data has indeed been flushed with an error; can't this 
be reported earlier than on close?

Would it be incorrect for a subsequent write to return the error that 
occurred while flushing data from previous writes? Then the app could 
decide whether to continue and retry or not. But I guess I can see how 
that might get convoluted.

Thanks for your patience,
