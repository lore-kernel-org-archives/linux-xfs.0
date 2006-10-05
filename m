Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Oct 2006 01:31:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k958VKaG005250
	for <xfs@oss.sgi.com>; Thu, 5 Oct 2006 01:31:23 -0700
Date: Thu, 5 Oct 2006 18:30:15 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: several messages
Message-ID: <20061005083015.GC19345@melbourne.sgi.com>
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal> <451A618B.5080901@agami.com> <Pine.LNX.4.64.0610020939450.5072@madrid.max-t.internal> <20061002223056.GN4695059@melbourne.sgi.com> <Pine.LNX.4.64.0610030917060.31738@madrid.max-t.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0610030917060.31738@madrid.max-t.internal>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, nfs@lists.sourceforge.net, Shailendra Tripathi <stripathi@agami.com>

On Tue, Oct 03, 2006 at 09:39:55AM -0400, Stephane Doyon wrote:
> Sorry for insisting, but it seems to me there's still a problem in need of 
> fixing: when writing a 5GB file over NFS to an XFS file system and hitting 
> ENOSPC, it takes on the order of 22hours before my application gets an 
> error, whereas it would normally take about 2minutes if the file system 
> did not become full.
>
> Perhaps I was being a bit too "constructive" and drowned my point in 
> explanations and proposed workarounds... You are telling me that neither 
> NFS nor XFS is doing anything wrong, and I can understand your points of 
> view, but surely that behavior isn't considered acceptable?

I agree that this a little extreme and I can't recall of seeing
anything like this before, but I can see how that may happen if the
NFS client continues to try to write every dirty page after getting
an ENOSPC and each one of those writes has to wait for 500ms.

However, you did not mention what kernel version you are running.
One recent bug (introduced by a fix for deadlocks at ENOSPC) could
allow oversubscription of free space to occur in XFS, resulting in
the write being allowed to proceed (i.e. sufficient space for the
data blocks) but then failing the allocation because there weren't
enough blocks put aside for potential btree splits that occur during
allocation. If the linux client is using sync writes on retry, then
this would trigger a 500ms sleep on every write.  That's the right
sort of ballpark for the slowness you were seeing - 5GB / 32k * 0.5s
= ~22 hours....

This got fixed in 2.6.18-rc6 - can you retry with a 2.6.18 server
and see if your problem goes away?

Cheers,

Dave.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
