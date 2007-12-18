Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 09:36:40 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBIHaYII023884
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 09:36:35 -0800
Received: from pentafluge.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3518011839E7
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 09:36:45 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40]) by cuda.sgi.com with ESMTP id ExATT1u1nM4qPmRy for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 09:36:45 -0800 (PST)
Date: Tue, 18 Dec 2007 17:36:42 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs mknod regression
Message-ID: <20071218173642.GA7338@infradead.org>
References: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bret Towe <magnade@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com


This was broken by my '[XFS] simplify xfs_create/mknod/symlink prototype',
which assigned the re-shuffled ondisk dev_t back to the rdev variable in
xfs_vn_mknod.  Because of that i_rdev is set to the ondisk dev_t instead
of the linux dev_t later down the function.

Fortunately the fix for it is trivial:  we can just remove the
assignment because xfs_revalidate_inode has done the proper job before
unlocking the inode.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:32.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:43.000000000 +0100
@@ -345,9 +345,7 @@ xfs_vn_mknod(
 		ASSERT(vp);
 		ip = vn_to_inode(vp);
 
-		if (S_ISCHR(mode) || S_ISBLK(mode))
-			ip->i_rdev = rdev;
-		else if (S_ISDIR(mode))
+		if (S_ISDIR(mode))
 			xfs_validate_fields(ip);
 		d_instantiate(dentry, ip);
 		xfs_validate_fields(dir);
