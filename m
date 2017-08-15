Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:14508
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752906AbdHOCQK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 22:16:10 -0400
Date: Tue, 15 Aug 2017 12:16:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: evict all inodes involved with log redo item
Message-ID: <20170815021602.GG21024@dastard>
References: <150274842319.16269.6356165894145725007.stgit@magnolia>
 <150274843988.16269.18072771696022634179.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150274843988.16269.18072771696022634179.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk

On Mon, Aug 14, 2017 at 03:07:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we introduced the bmap redo log items, we set MS_ACTIVE on the
> mountpoint and XFS_IRECOVERY on the inode to prevent unlinked inodes
> from being truncated prematurely during log recovery.  This also had the
> effect of putting linked inodes on the lru instead of evicting them.
> 
> Unfortunately, we neglected to find all those unreferenced lru inodes
> and evict them after finishing log recovery, which means that we leak
> them if anything goes wrong in the rest of xfs_mountfs, because the lru
> is only cleaned out on unmount.

That's because if we fail xfs_mountfs() we haven't yet set up
sb->s_root so generic_shutdown_super() won't call evict_inodes(),
right? Is there anything else we might miss from the generic
shutdown path that we need to do here?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
