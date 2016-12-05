Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48784 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbcLEPKa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 10:10:30 -0500
Date: Mon, 5 Dec 2016 06:39:06 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161205143906.GA16352@infradead.org>
References: <20161205092112.GS29149@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161205092112.GS29149@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 05, 2016 at 05:21:12PM +0800, Eryu Guan wrote:
> Hi,
> 
> I hit an xfs/109 crash today while testing reflink XFS with 2k block
> size on x86_64 hosts (both baremetal and kvm guest).
> 
> It can be reproduced by running xfs/109 many times, I tried 50-times
> loop twice and it crashed at the 21st and 46th runs. And I can reproduce
> it with both linus tree (4.9-rc4) and linux-xfs tree for-next branch
> (updated on 2016-11-30). I haven't been able to reproduce it with 4k
> block size XFS.

Haven't been able to reproduce it yet unfortunately.  But from looking
at the out of range block this looks like it could be NULLFSBLOCK
converted to a daddr.

I assume you are running without CONFIG_XFS_DEBUG or CONFIG_XFS_WARN
enabled?

Below would catch this issue in a non-debug build.  Still trying to
reproduce in the meantime..


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c6eb219..2c19b11 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -780,12 +780,14 @@ try_another_ag:
 	if (xfs_sb_version_hasreflink(&cur->bc_mp->m_sb) &&
 	    args.fsbno == NULLFSBLOCK &&
 	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
+		printk("trying another AG\n");
 		dfops->dop_low = true;
 		goto try_another_ag;
 	}
 	/*
 	 * Allocation can't fail, the space was reserved.
 	 */
+	BUG_ON(args.fsbno == NULLFSBLOCK);
 	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(*firstblock == NULLFSBLOCK ||
 	       args.agno == XFS_FSB_TO_AGNO(mp, *firstblock) ||
