Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Nov 2006 00:05:04 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAU84taG004977
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 00:04:57 -0800
Subject: TAKE 957159 - Reduce XFS 4k stack kernel issues
Message-Id: <20061130080359.E3F7C58FF58B@chook.melbourne.sgi.com>
Date: Thu, 30 Nov 2006 19:03:59 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Keep stack usage down for 4k stacks by using noinline.

gcc-4.1 and more recent aggressively inline static functions which
increases XFS stack usage by ~15% in critical paths. Prevent
this from occurring by adding noinline to the STATIC definition.

Also uninline some functions that are too large to be inlined and
were causing problems with CONFIG_FORCED_INLINING=y.

Finally, clean up all the different users of inline, __inline and
__inline__ and put them under one STATIC_INLINE macro. For debug
kernels the STATIC_INLINE macro uninlines those functions.

Date:  Thu Nov 30 19:02:40 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes,chatz

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27585a
fs/xfs/xfs_ialloc.c - 1.193 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.193&r2=text&tr2=1.192&f=h
	- noinline static function declaration cleanup.

fs/xfs/xfs_extfree_item.c - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_extfree_item.c.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
	- noinline static function declaration cleanup.

fs/xfs/xfs_buf_item.c - 1.161 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.161&r2=text&tr2=1.160&f=h
	- noinline static function declaration cleanup.

fs/xfs/xfs_bit.c - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bit.c.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
	- noinline static function declaration cleanup.

fs/xfs/xfs_inode_item.c - 1.130 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.c.diff?r1=text&tr1=1.130&r2=text&tr2=1.129&f=h
	- noinline static function declaration cleanup.

fs/xfs/xfs_bmap_btree.c - 1.158 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.158&r2=text&tr2=1.157&f=h
	- noinline static function declaration cleanup.

fs/xfs/xfs_mount.c - 1.387 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.387&r2=text&tr2=1.386&f=h
	- noinline static function declaration cleanup.

fs/xfs/xfs_inode.c - 1.456 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.456&r2=text&tr2=1.455&f=h
	- noinline static function declaration cleanup.

fs/xfs/xfs_attr_leaf.c - 1.104 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.104&r2=text&tr2=1.103&f=h
	- noinline static function declaration cleanup.

fs/xfs/xfs_attr.c - 1.140 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.140&r2=text&tr2=1.139&f=h
	- noinline static function declaration cleanup.

fs/xfs/support/debug.h - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/debug.h.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- noinline static function declaration cleanup.

fs/xfs/quota/xfs_qm_bhv.c - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_bhv.c.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
	- noinline static function declaration cleanup.

fs/xfs/quota/xfs_dquot_item.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot_item.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- noinline static function declaration cleanup.

fs/xfs/quota/xfs_qm.c - 1.45 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.45&r2=text&tr2=1.44&f=h
	- noinline static function declaration cleanup.

fs/xfs/xfs_refcache.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_refcache.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.6/xfs_vfs.c - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.c.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.6/xfs_file.c - 1.146 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.146&r2=text&tr2=1.145&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.6/xfs_vnode.c - 1.143 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.143&r2=text&tr2=1.142&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.6/xfs_vnode.h - 1.126 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.126&r2=text&tr2=1.125&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.6/xfs_super.c - 1.374 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.374&r2=text&tr2=1.373&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.6/xfs_iops.c - 1.256 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.256&r2=text&tr2=1.255&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.6/xfs_aops.c - 1.136 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.136&r2=text&tr2=1.135&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.6/xfs_sysctl.c - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sysctl.c.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.4/xfs_file.c - 1.129 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_file.c.diff?r1=text&tr1=1.129&r2=text&tr2=1.128&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.4/xfs_vnode.h - 1.114 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_vnode.h.diff?r1=text&tr1=1.114&r2=text&tr2=1.113&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.4/xfs_super.c - 1.333 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_super.c.diff?r1=text&tr1=1.333&r2=text&tr2=1.332&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.6/xfs_buf.c - 1.232 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.232&r2=text&tr2=1.231&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.4/xfs_buf.c - 1.218 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_buf.c.diff?r1=text&tr1=1.218&r2=text&tr2=1.217&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.4/mrlock.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/mrlock.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
	- noinline static function declaration cleanup.

fs/xfs/linux-2.6/xfs_export.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- noinline static function declaration cleanup.

fs/xfs/dmapi/xfs_dm.c - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
	- noinline static function declaration cleanup.
