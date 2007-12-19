Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 19:18:30 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBJ3IKtB018437
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 19:18:24 -0800
Subject: PARTIAL TAKE 974873 - Fix mknod regression
Message-Id: <20071219031828.40C2358C4C0F@chook.melbourne.sgi.com>
Date: Wed, 19 Dec 2007 14:18:28 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix mknod regression

This was broken by my '[XFS] simplify xfs_create/mknod/symlink prototype',
which assigned the re-shuffled ondisk dev_t back to the rdev variable in
xfs_vn_mknod.  Because of that i_rdev is set to the ondisk dev_t instead
of the linux dev_t later down the function.

Fortunately the fix for it is trivial:  we can just remove the
assignment because xfs_revalidate_inode has done the proper job before
unlocking the inode.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Wed Dec 19 14:17:51 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30273a
fs/xfs/linux-2.6/xfs_iops.c - 1.272 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.272&r2=text&tr2=1.271&f=h
	- fix xfs_vn_mknod regression due to writing the wrong format dev_t to
	  i_rdev.
