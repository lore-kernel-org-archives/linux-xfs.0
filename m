Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17553 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdHOEDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 00:03:15 -0400
Date: Mon, 14 Aug 2017 21:03:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: evict all inodes involved with log redo item
Message-ID: <20170815040310.GU4796@magnolia>
References: <150274842319.16269.6356165894145725007.stgit@magnolia>
 <150274843988.16269.18072771696022634179.stgit@magnolia>
 <20170815021602.GG21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170815021602.GG21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk

On Tue, Aug 15, 2017 at 12:16:02PM +1000, Dave Chinner wrote:
> On Mon, Aug 14, 2017 at 03:07:19PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we introduced the bmap redo log items, we set MS_ACTIVE on the
> > mountpoint and XFS_IRECOVERY on the inode to prevent unlinked inodes
> > from being truncated prematurely during log recovery.  This also had the
> > effect of putting linked inodes on the lru instead of evicting them.
> > 
> > Unfortunately, we neglected to find all those unreferenced lru inodes
> > and evict them after finishing log recovery, which means that we leak
> > them if anything goes wrong in the rest of xfs_mountfs, because the lru
> > is only cleaned out on unmount.
> 
> That's because if we fail xfs_mountfs() we haven't yet set up
> sb->s_root so generic_shutdown_super() won't call evict_inodes(),
> right? Is there anything else we might miss from the generic
> shutdown path that we need to do here?

I don't /think/ so?  Maybe I should sleep on that, though. :)

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
