Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 00:38:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m757cO22013889
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 00:38:24 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 563B11246DB8
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 00:39:38 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id ZbgDJJKgTugaTSgH for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 00:39:38 -0700 (PDT)
Date: Tue, 5 Aug 2008 17:39:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Use KM_NOFS for debug trace buffers
Message-ID: <20080805073937.GC21635@disturbed>
References: <4897FCC7.400@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4897FCC7.400@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, Aug 05, 2008 at 05:09:59PM +1000, Lachlan McIlroy wrote:
> Use KM_NOFS to prevent recursion back into the filesystem which can
> cause deadlocks.
>
> In the case of xfs_iread() we hold the lock on the inode cluster buffer
> while allocating memory for the trace buffers.  If we recurse back into
> XFS to flush data that may require a transaction to allocate extents
> which needs log space.  This can deadlock with the xfsaild thread which
> can't push the tail of the log because it is trying to get the inode
> cluster buffer lock.

Looks OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
