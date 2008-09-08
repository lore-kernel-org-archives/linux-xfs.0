Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Sep 2008 22:24:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m885NwVA010554
	for <xfs@oss.sgi.com>; Sun, 7 Sep 2008 22:23:59 -0700
Subject: TAKE 986557 - Update libxfs and xfsprogs to latest kernel interfaces and implementation
Message-Id: <20080908052524.6A19258C52AB@chook.melbourne.sgi.com>
Date: Mon,  8 Sep 2008 15:25:24 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Update xfsprogs to latest kernel headers and functions

Date:  Mon Sep  8 15:23:45 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/libxfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32070a
xfsprogs/doc/sparse.txt - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/sparse.txt
xfsprogs/include/unaligned.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/unaligned.h
xfsdump/include/swab.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/include/swab.h
xfsprogs/include/kmem.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/kmem.h
xfsprogs/libxfs/kmem.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/kmem.c
xfsprogs/include/bitops.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/bitops.h
xfsprogs/db/bmap.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/bmap.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
xfsprogs/db/dir2sf.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/dir2sf.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfsprogs/db/dir2.c - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/dir2.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/db/attr.c - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/attr.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/db/sb.c - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/sb.c.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
xfsprogs/db/dir.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/dir.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/db/cntbt.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/cntbt.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/db/bnobt.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/bnobt.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/db/bmapbt.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/bmapbt.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/db/bmroot.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/bmroot.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/db/inobt.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/inobt.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/db/dirshort.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/dirshort.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfsprogs/db/inode.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/inode.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsprogs/db/init.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/init.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
xfsprogs/db/bit.c - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/bit.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/db/frag.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/frag.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsprogs/db/freesp.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/freesp.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/db/check.c - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/check.c.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
xfsprogs/Makefile - 1.29 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/Makefile.diff?r1=text&tr1=1.29&r2=text&tr2=1.28&f=h
xfsprogs/VERSION - 1.183 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.183&r2=text&tr2=1.182&f=h
xfsprogs/doc/CHANGES - 1.256 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.256&r2=text&tr2=1.255&f=h
xfsprogs/mkfs/proto.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/proto.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/mkfs/xfs_mkfs.c - 1.93 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.93&r2=text&tr2=1.92&f=h
xfsprogs/logprint/log_print_all.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/logprint/log_print_all.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/logprint/log_print_trans.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/logprint/log_print_trans.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/logprint/logprint.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/logprint/logprint.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
xfsprogs/logprint/log_misc.c - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/logprint/log_misc.c.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
xfsprogs/libdisk/fstype.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libdisk/fstype.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/libdisk/Makefile - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libdisk/Makefile.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/libxlog/Makefile - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxlog/Makefile.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfsprogs/libxlog/xfs_log_recover.c - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxlog/xfs_log_recover.c.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
xfsprogs/libxlog/util.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxlog/util.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/include/xfs_trans_space.h - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_trans_space.h.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsprogs/include/xfs_log.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_log.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/include/xfs_ialloc.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_ialloc.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/include/xfs_ag.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_ag.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/include/xfs_buf_item.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_buf_item.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/include/buildrules - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/buildrules.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/include/xfs_attr_sf.h - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_attr_sf.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/include/xfs_log_priv.h - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_log_priv.h.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsprogs/include/xfs_da_btree.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_da_btree.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/include/xfs_bit.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_bit.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/include/xfs_sb.h - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_sb.h.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsprogs/include/xfs_dir2_block.h - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dir2_block.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/include/xfs_fs.h - 1.42 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_fs.h.diff?r1=text&tr1=1.42&r2=text&tr2=1.41&f=h
xfsprogs/include/xfs_dir.h - 1.11 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dir.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/include/xfs_arch.h - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_arch.h.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsprogs/include/libxfs.h - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/libxfs.h.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
xfsprogs/include/xfs_rtalloc.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_rtalloc.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/include/xfs_ialloc_btree.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_ialloc_btree.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/include/xfs_inode_item.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_inode_item.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/include/Makefile - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/Makefile.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
xfsprogs/include/xfs_dfrag.h - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dfrag.h.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/include/libxlog.h - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/libxlog.h.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsprogs/include/xfs_bmap_btree.h - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_bmap_btree.h.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/include/builddefs.in - 1.52 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/builddefs.in.diff?r1=text&tr1=1.52&r2=text&tr2=1.51&f=h
xfsprogs/include/xfs_dir2_sf.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dir2_sf.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/include/xfs_dir_leaf.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dir_leaf.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/include/platform_defs.h.in - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/platform_defs.h.in.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
xfsprogs/include/xfs_mount.h - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_mount.h.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
xfsprogs/include/xfs_btree.h - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_btree.h.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/include/xfs_dir2_data.h - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dir2_data.h.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/include/xfs_inode.h - 1.41 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_inode.h.diff?r1=text&tr1=1.41&r2=text&tr2=1.40&f=h
xfsprogs/include/xfs_dir2_leaf.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dir2_leaf.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/include/xfs_attr_leaf.h - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_attr_leaf.h.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/include/xfs_types.h - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_types.h.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
xfsprogs/include/xfs_trans.h - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_trans.h.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsprogs/include/xfs_dir_sf.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dir_sf.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/include/xfs_alloc.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_alloc.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/include/xfs_imap.h - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_imap.h.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsprogs/include/xfs_bmap.h - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_bmap.h.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
xfsprogs/include/xfs_alloc_btree.h - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_alloc_btree.h.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/include/xfs_quota.h - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_quota.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsprogs/include/xfs_dir2_node.h - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dir2_node.h.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/include/xfs_dir2.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dir2.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/include/xfs_dinode.h - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dinode.h.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsprogs/repair/phase6.c - 1.45 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase6.c.diff?r1=text&tr1=1.45&r2=text&tr2=1.44&f=h
xfsprogs/repair/phase7.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase7.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsprogs/repair/dir2.c - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dir2.c.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
xfsprogs/repair/sb.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/sb.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsprogs/repair/dir.c - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dir.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
xfsprogs/repair/dinode.c - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dinode.c.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
xfsprogs/repair/dinode.h - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dinode.h.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsprogs/repair/phase5.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase5.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/repair/agheader.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/agheader.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/repair/rt.c - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/rt.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/repair/versions.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/versions.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/repair/phase2.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase2.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/repair/phase3.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase3.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
xfsprogs/repair/xfs_repair.c - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/xfs_repair.c.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
xfsprogs/repair/scan.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/scan.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/repair/attr_repair.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/attr_repair.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/repair/attr_repair.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/attr_repair.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsprogs/libhandle/Makefile - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libhandle/Makefile.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/libhandle/jdm.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libhandle/jdm.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
xfsprogs/libxfs/xfs_ialloc.c - 1.27 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_ialloc.c.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
xfsprogs/libxfs/rdwr.c - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/rdwr.c.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
xfsprogs/libxfs/xfs_da_btree.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_da_btree.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
xfsprogs/libxfs/logitem.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/logitem.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/libxfs/xfs.h - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs.h.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
xfsprogs/libxfs/trans.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/trans.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/libxfs/init.c - 1.57 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/init.c.diff?r1=text&tr1=1.57&r2=text&tr2=1.56&f=h
xfsprogs/libxfs/xfs_dir2_block.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_dir2_block.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/libxfs/xfs_dir.c - 1.21 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_dir.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/libxfs/xfs_rtalloc.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_rtalloc.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
xfsprogs/libxfs/xfs_ialloc_btree.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_ialloc_btree.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/libxfs/Makefile - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/Makefile.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
xfsprogs/libxfs/xfs_bmap_btree.c - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_bmap_btree.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
xfsprogs/libxfs/xfs_dir2_sf.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_dir2_sf.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/libxfs/xfs_dir_leaf.c - 1.20 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_dir_leaf.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsprogs/libxfs/xfs_mount.c - 1.27 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_mount.c.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
xfsprogs/libxfs/xfs_btree.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_btree.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/libxfs/xfs_dir2_data.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_dir2_data.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/libxfs/xfs_inode.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_inode.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
xfsprogs/libxfs/xfs_dir2_leaf.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_dir2_leaf.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/libxfs/xfs_attr_leaf.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_attr_leaf.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsprogs/libxfs/util.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/util.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsprogs/libxfs/xfs_trans.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_trans.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfsprogs/libxfs/xfs_alloc.c - 1.29 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_alloc.c.diff?r1=text&tr1=1.29&r2=text&tr2=1.28&f=h
xfsprogs/libxfs/xfs_bmap.c - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_bmap.c.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
xfsprogs/libxfs/xfs_alloc_btree.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_alloc_btree.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsprogs/libxfs/xfs_dir2_node.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_dir2_node.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsprogs/libxfs/xfs_dir2.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_dir2.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsdump/Makefile - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/Makefile.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsdump/estimate/Makefile - 1.8 - renamed to xfsprogs/estimate/Makefile 1.1
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/estimate/Makefile.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfsdump/estimate/xfs_estimate.c - 1.9 - renamed to xfsprogs/estimate/xfs_estimate.c 1.1
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/estimate/xfs_estimate.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfstests/src/loggen.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/loggen.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfstests/tools/srcdiff - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/tools/srcdiff.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
xfsprogs/include/buildmacros - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/buildmacros.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsprogs/libxfs/bit.c - 1.5 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/bit.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
xfsprogs/po/Makefile - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/po/Makefile.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsdump/po/Makefile - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/po/Makefile.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
xfstests/m4/package_xfslibs.m4 - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/m4/package_xfslibs.m4.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsprogs/copy/xfs_copy.h - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/copy/xfs_copy.h.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfsprogs/copy/xfs_copy.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/copy/xfs_copy.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
xfsprogs/logprint/log_dump.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/logprint/log_dump.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfsprogs/include/irix.h - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/irix.h.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/include/freebsd.h - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/freebsd.h.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
xfsprogs/include/darwin.h - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/darwin.h.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
xfsprogs/include/linux.h - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/linux.h.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsprogs/libxcmd/projects.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxprojects.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
xfsprogs/libxcmd/Makefile - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxMakefile.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfsprogs/quota/quot.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/quota/quot.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
xfsprogs/db/attrset.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/attrset.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
xfsprogs/libxfs/xfs_attr.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_attr.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
xfsprogs/io/parent.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/io/parent.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
xfsdump/include/swap.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/include/swap.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfstests/122 - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/122.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfstests/122.out - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/122.out.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
xfsprogs/repair/prefetch.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/prefetch.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsprogs/mdrestore/xfs_mdrestore.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mdrestore/xfs_mdrestore.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfsprogs/db/metadump.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/metadump.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
xfstests/src/genhashnames.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/genhashnames.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
