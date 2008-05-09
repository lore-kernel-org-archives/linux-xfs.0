Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 May 2008 18:10:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m491AOle006439
	for <xfs@oss.sgi.com>; Thu, 8 May 2008 18:10:29 -0700
Subject: PARTIAL TAKE 981498 - Remove unused arg from kmem_free()
Message-Id: <20080509011106.68F2B58C4C15@chook.melbourne.sgi.com>
Date: Fri,  9 May 2008 11:11:06 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Remove unused arg from kmem_free()

kmem_free() function takes (ptr, size) arguments but doesn't
actually use second one.

This patch removes size argument from all callsites.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Date:  Fri May  9 11:10:35 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  vda.linux@googlemail.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31050a
fs/xfs/xfs_log.c - 1.357 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.357&r2=text&tr2=1.356&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_extfree_item.c - 1.69 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_extfree_item.c.diff?r1=text&tr1=1.69&r2=text&tr2=1.68&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_buf_item.c - 1.166 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.166&r2=text&tr2=1.165&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_trans_inode.c - 1.55 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_inode.c.diff?r1=text&tr1=1.55&r2=text&tr2=1.54&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_da_btree.c - 1.177 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.c.diff?r1=text&tr1=1.177&r2=text&tr2=1.176&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_dir2_block.c - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_block.c.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_rtalloc.c - 1.112 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rtalloc.c.diff?r1=text&tr1=1.112&r2=text&tr2=1.111&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_itable.c - 1.165 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.165&r2=text&tr2=1.164&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_inode_item.c - 1.136 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.c.diff?r1=text&tr1=1.136&r2=text&tr2=1.135&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_log_recover.c - 1.344 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.344&r2=text&tr2=1.343&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_trans_item.c - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_item.c.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_vfsops.c - 1.564 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.564&r2=text&tr2=1.563&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_dfrag.c - 1.67 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.67&r2=text&tr2=1.66&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_dir2_sf.c - 1.51 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_sf.c.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_mount.c - 1.431 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.431&r2=text&tr2=1.430&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_inode.c - 1.502 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.502&r2=text&tr2=1.501&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_dir2_leaf.c - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_leaf.c.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_attr_leaf.c - 1.111 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.111&r2=text&tr2=1.110&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_trans.c - 1.185 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.185&r2=text&tr2=1.184&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_error.c - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.c.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_bmap.c - 1.392 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.392&r2=text&tr2=1.391&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_dir2.c - 1.64 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.64&r2=text&tr2=1.63&f=h
	- Remove unused arg from kmem_free()

fs/xfs/support/ktrace.c - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/ktrace.c.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
	- Remove unused arg from kmem_free()

fs/xfs/quota/xfs_qm_syscalls.c - 1.43 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.43&r2=text&tr2=1.42&f=h
	- Remove unused arg from kmem_free()

fs/xfs/quota/xfs_dquot_item.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot_item.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
	- Remove unused arg from kmem_free()

fs/xfs/quota/xfs_qm.c - 1.69 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.69&r2=text&tr2=1.68&f=h
	- Remove unused arg from kmem_free()

fs/xfs/linux-2.6/xfs_super.c - 1.416 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.416&r2=text&tr2=1.415&f=h
	- Remove unused arg from kmem_free()

fs/xfs/linux-2.6/xfs_buf.c - 1.255 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.255&r2=text&tr2=1.254&f=h
	- Remove unused arg from kmem_free()

fs/xfs/linux-2.6/kmem.h - 1.46 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/kmem.h.diff?r1=text&tr1=1.46&r2=text&tr2=1.45&f=h
	- Remove unused arg from kmem_free()

fs/xfs/linux-2.6/kmem.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/kmem.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Remove unused arg from kmem_free()

fs/xfs/xfs_mru_cache.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mru_cache.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- Remove unused arg from kmem_free()
