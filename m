Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAK4X1JL012922 for <xfs@oss.sgi.com>; Wed, 19 Nov 2008 22:33:01 -0600
Subject: TAKE 986557 - Update libxfs and xfsprogs to latest kernel interfaces
	and implementation
Message-Id: <20081120043258.11D2258AE1E9@chook.melbourne.sgi.com>
Date: Thu, 20 Nov 2008 15:32:58 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Sync up xfsprogs to latest kernel code


Date:  Thu Nov 20 15:32:14 EST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32503a
xfsprogs/db/bmap.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/bmap.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/db/bmroot.c - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/bmroot.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/db/frag.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/frag.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsprogs/db/freesp.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/freesp.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/db/check.c - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/check.c.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
xfsprogs/mkfs/xfs_mkfs.c - 1.96 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.96&r2=text&tr2=1.95&f=h
xfsprogs/include/xfs_ialloc_btree.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_ialloc_btree.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/include/xfs_bmap_btree.h - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_bmap_btree.h.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsprogs/include/xfs_mount.h - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_mount.h.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
xfsprogs/include/xfs_btree.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_btree.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/include/xfs_inode.h - 1.43 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_inode.h.diff?r1=text&tr1=1.43&r2=text&tr2=1.42&f=h
xfsprogs/include/xfs_alloc_btree.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_alloc_btree.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/include/xfs_dinode.h - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dinode.h.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
xfsprogs/repair/dinode.c - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dinode.c.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
xfsprogs/repair/phase5.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase5.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
xfsprogs/repair/scan.h - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/scan.h.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
xfsprogs/repair/scan.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/scan.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsprogs/libxfs/init.c - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/init.c.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
xfsprogs/libxfs/xfs_ialloc_btree.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_ialloc_btree.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/libxfs/xfs_bmap_btree.c - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_bmap_btree.c.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
xfsprogs/libxfs/xfs_mount.c - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_mount.c.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
xfsprogs/libxfs/xfs_btree.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_btree.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsprogs/libxfs/xfs_inode.c - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_inode.c.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
xfsprogs/libxfs/xfs_alloc.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_alloc.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
xfsprogs/libxfs/xfs_bmap.c - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_bmap.c.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
xfsprogs/libxfs/xfs_alloc_btree.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_alloc_btree.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/copy/xfs_copy.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/copy/xfs_copy.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsprogs/repair/prefetch.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/prefetch.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/db/metadump.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/metadump.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfsprogs/db/btblock.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/btblock.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Sync up xfsprogs to latest kernel code


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
