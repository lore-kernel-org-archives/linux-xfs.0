Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47257 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdEQBGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2017 21:06:32 -0400
Date: Tue, 16 May 2017 18:06:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: avoid mount-time deadlock in CoW extent recovery
Message-ID: <20170517010627.GR4519@birch.djwong.org>
References: <20170516192748.GQ4519@birch.djwong.org>
 <20170517003931.GN17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170517003931.GN17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, May 17, 2017 at 10:39:31AM +1000, Dave Chinner wrote:
> On Tue, May 16, 2017 at 12:27:48PM -0700, Darrick J. Wong wrote:
> > If a malicious user corrupts the refcount btree to cause a cycle between
> > different levels of the tree, the next mount attempt will deadlock in
> > the CoW recovery routine while grabbing buffer locks.  We can use the
> > ability to re-grab a buffer that was previous locked to a transaction to
> > avoid deadlocks, so do that here.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Missing comments in the code explaining the deadlock being avoided
> by using xfs_trans_alloc_empty()....

Heh, ok.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
