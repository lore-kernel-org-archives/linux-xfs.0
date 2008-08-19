Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 00:59:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7J7xHsT032544
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 00:59:18 -0700
Subject: TAKE 981498 - convert beX_add to beX_add_cpu (new common API)
Message-Id: <20080819080034.D962F58C52A8@chook.melbourne.sgi.com>
Date: Tue, 19 Aug 2008 18:00:34 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

convert beX_add to beX_add_cpu (new common API)

remove beX_add functions and replace all uses with beX_add_cpu
    
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>

Date:  Tue Aug 19 17:59:33 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  
marcin.slusarz@gmail.com
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31920a
fs/xfs/xfs_log.c - 1.366 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.366&r2=text&tr2=1.365&f=h
fs/xfs/xfs_ialloc.c - 1.200 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.200&r2=text&tr2=1.199&f=h
fs/xfs/xfs_da_btree.c - 1.183 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.c.diff?r1=text&tr1=1.183&r2=text&tr2=1.182&f=h
fs/xfs/xfs_dir2_block.c - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_block.c.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
fs/xfs/xfs_arch.h - 1.54 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_arch.h.diff?r1=text&tr1=1.54&r2=text&tr2=1.53&f=h
fs/xfs/xfs_ialloc_btree.c - 1.88 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.88&r2=text&tr2=1.87&f=h
fs/xfs/xfs_bmap_btree.c - 1.174 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.174&r2=text&tr2=1.173&f=h
fs/xfs/xfs_dir2_data.c - 1.41 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_data.c.diff?r1=text&tr1=1.41&r2=text&tr2=1.40&f=h
fs/xfs/xfs_dir2_leaf.c - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_leaf.c.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
fs/xfs/xfs_attr_leaf.c - 1.117 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.117&r2=text&tr2=1.116&f=h
fs/xfs/xfs_trans.c - 1.188 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.188&r2=text&tr2=1.187&f=h
fs/xfs/xfs_alloc.c - 1.194 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.194&r2=text&tr2=1.193&f=h
fs/xfs/xfs_fsops.c - 1.136 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.136&r2=text&tr2=1.135&f=h
fs/xfs/xfs_alloc_btree.c - 1.92 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.92&r2=text&tr2=1.91&f=h
fs/xfs/xfs_dir2_node.c - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_node.c.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
fs/xfs/quota/xfs_trans_dquot.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_trans_dquot.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
fs/xfs/quota/xfs_qm.c - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
	- convert beX_add to beX_add_cpu (new common API)
