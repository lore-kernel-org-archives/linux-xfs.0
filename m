Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 18:12:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M2C9of021203
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 18:12:13 -0800
Subject: PARTIAL TAKE 976035 - kill xfs_get_dir_entry
Message-Id: <20080222021231.A01E358C4C0F@chook.melbourne.sgi.com>
Date: Fri, 22 Feb 2008 13:12:31 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill xfs_get_dir_entry

Instead of of xfs_get_dir_entry use a macro to get the xfs_inode from
the dentry in the callers and grab the reference manually.

Only grab the reference once as it's fine to keep it over the dmapi
calls.  (And even that reference is actually superflous in Linux but
I'll leave that for another patch)

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Feb 22 13:11:59 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30531a
fs/xfs/xfs_vnodeops.c - 1.737 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.737&r2=text&tr2=1.736&f=h
fs/xfs/xfs_utils.c - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.c.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
fs/xfs/xfs_utils.h - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.h.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
fs/xfs/xfs_rename.c - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
fs/xfs/linux-2.6/xfs_vnode.h - 1.145 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.145&r2=text&tr2=1.144&f=h
	- kill xfs_get_dir_entry
