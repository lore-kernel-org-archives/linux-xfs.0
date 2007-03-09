Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 09 Mar 2007 09:23:05 -0800 (PST)
Received: from lab41.emea.sgi.com (lab41.emea.sgi.com [144.253.75.41])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l29HMu6p019124
	for <xfs@oss.sgi.com>; Fri, 9 Mar 2007 09:22:57 -0800
Subject: TAKE 961990 - propogate return codes from flush routines
Message-Id: <20070309174215.E9FA222ADE@lab41.emea.sgi.com>
Date: Fri,  9 Mar 2007 17:42:15 +0000 (GMT)
From: lachlan@lab41.emea.sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

propogate return codes from flush routines

This patch handles error return values in fs_flush_pages and fs_flushinval_pages.
It changes the prototype of fs_flushinval_pages so we can propogate the errors
and handle them at higher layers.  I also modified xfs_itruncate_start so that
it could propogate the error further.

Date:  Sat Mar 10 04:19:34 AEDT 2007
Workarea:  vpn-emea-sw-emea-160-34.emea.sgi.com:/home/lachlan/isms/2.6.x-mod
Inspected by:  stewart@flamingspork.com
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28231a
fs/xfs/xfs_vnodeops.c - 1.692 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.692&r2=text&tr2=1.691&f=h
fs/xfs/xfs_vfsops.c - 1.517 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.517&r2=text&tr2=1.516&f=h
fs/xfs/xfs_dfrag.c - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
fs/xfs/xfs_inode.c - 1.462 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.462&r2=text&tr2=1.461&f=h
fs/xfs/xfs_inode.h - 1.218 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.218&r2=text&tr2=1.217&f=h
fs/xfs/xfs_utils.c - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.c.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
fs/xfs/linux-2.6/xfs_lrw.c - 1.257 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.257&r2=text&tr2=1.256&f=h
fs/xfs/linux-2.6/xfs_vnode.h - 1.127 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.127&r2=text&tr2=1.126&f=h
fs/xfs/linux-2.6/xfs_fs_subr.c - 1.50 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_fs_subr.c.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
fs/xfs/linux-2.6/xfs_fs_subr.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_fs_subr.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
fs/xfs/linux-2.4/xfs_vnode.h - 1.115 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_vnode.h.diff?r1=text&tr1=1.115&r2=text&tr2=1.114&f=h
fs/xfs/linux-2.4/xfs_fs_subr.c - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_fs_subr.c.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
fs/xfs/linux-2.4/xfs_fs_subr.h - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_fs_subr.h.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- propogate return codes from flush routines
