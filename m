Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 Mar 2007 09:43:02 -0800 (PST)
Received: from lab41.emea.sgi.com (lab41.emea.sgi.com [144.253.75.41])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l22Hgr6p016941
	for <xfs@oss.sgi.com>; Fri, 2 Mar 2007 09:42:54 -0800
Subject: TAKE 961694 - the "aendp" arg to xfs_dir2_data_freescan is always NULL, remove it.
Message-Id: <20070302180146.A48CF52AD5@lab41.emea.sgi.com>
Date: Fri,  2 Mar 2007 18:01:46 +0000 (GMT)
From: lachlan@lab41.emea.sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

the "aendp" arg to xfs_dir2_data_freescan is always NULL, remove it.

Patch provided by Eric Sandeen.
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>



Date:  Sat Mar  3 04:40:38 AEDT 2007
Workarea:  vpn-emea-sw-emea-160-1.emea.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  
lachlan
sandeen@sandeen.net
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28204a
fs/xfs/xfs_dir2_block.c - 1.54 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_block.c.diff?r1=text&tr1=1.54&r2=text&tr2=1.53&f=h
fs/xfs/xfs_dir2_data.c - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_data.c.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
fs/xfs/xfs_dir2_data.h - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_data.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
fs/xfs/xfs_dir2_leaf.c - 1.57 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_leaf.c.diff?r1=text&tr1=1.57&r2=text&tr2=1.56&f=h
fs/xfs/xfs_dir2_node.c - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_node.c.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
	- the "aendp" arg to xfs_dir2_data_freescan is always NULL, remove it.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
