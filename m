Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Oct 2006 09:41:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k93GfbaG004402
	for <xfs@oss.sgi.com>; Tue, 3 Oct 2006 09:41:38 -0700
Subject: Re: several messages
From: Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <Pine.LNX.4.64.0610030917060.31738@madrid.max-t.internal>
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal>
	 <451A618B.5080901@agami.com>
	 <Pine.LNX.4.64.0610020939450.5072@madrid.max-t.internal>
	 <20061002223056.GN4695059@melbourne.sgi.com>
	 <Pine.LNX.4.64.0610030917060.31738@madrid.max-t.internal>
Content-Type: text/plain
Date: Tue, 03 Oct 2006 12:40:42 -0400
Message-Id: <1159893642.5592.12.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, nfs@lists.sourceforge.net, Shailendra Tripathi <stripathi@agami.com>

On Tue, 2006-10-03 at 09:39 -0400, Stephane Doyon wrote:
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

Sure it is. You are allowing the kernel to cache 5GB, and that means you
only get the error message when close() completes.

If you want faster error reporting, there are modes like O_SYNC,
O_DIRECT, that will attempt to flush the data more quickly. In addition,
you can force flushing using fsync(). Finally, you can tweak the VM into
flushing more often using /proc/sys/vm.

Cheers,
 Trond
