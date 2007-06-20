Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 22:02:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5K52Ido020148
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 22:02:21 -0700
Subject: PARTIAL TAKE 966505 - cleanup dir2 macro shouting
Message-Id: <20070620050215.B291958C38F1@chook.melbourne.sgi.com>
Date: Wed, 20 Jun 2007 15:02:15 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Reduce shouting by removing unnecessary macros from dir2 code.

Signed-Off-By: Christoph Hellwig <hch@lst.de>

Date:  Wed Jun 20 15:01:44 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28947a
fs/xfs/xfs_dir2_block.c - 1.55 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_block.c.diff?r1=text&tr1=1.55&r2=text&tr2=1.54&f=h
	- Call inline functions directly rather than the macros that
	  wrap them and remove the unneeded macros.

fs/xfs/xfs_dir2_block.h - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_block.h.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Call inline functions directly rather than the macros that
	  wrap them and remove the unneeded macros.

fs/xfs/xfs_dir2_sf.h - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_sf.h.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
	- Call inline functions directly rather than the macros that
	  wrap them and remove the unneeded macros.

fs/xfs/xfs_dir2_sf.c - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_sf.c.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
	- Call inline functions directly rather than the macros that
	  wrap them and remove the unneeded macros.

fs/xfs/xfs_dir2_data.c - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_data.c.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
	- Call inline functions directly rather than the macros that
	  wrap them and remove the unneeded macros.

fs/xfs/xfs_dir2_data.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_data.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
	- Call inline functions directly rather than the macros that
	  wrap them and remove the unneeded macros.

fs/xfs/xfs_dir2_leaf.c - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_leaf.c.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
	- Call inline functions directly rather than the macros that
	  wrap them and remove the unneeded macros.

fs/xfs/xfs_dir2_leaf.h - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_leaf.h.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
	- Call inline functions directly rather than the macros that
	  wrap them and remove the unneeded macros.

fs/xfs/xfs_dir2_node.c - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_node.c.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
	- Call inline functions directly rather than the macros that
	  wrap them and remove the unneeded macros.

fs/xfs/xfs_dir2_node.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_node.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- Call inline functions directly rather than the macros that
	  wrap them and remove the unneeded macros.

fs/xfs/xfs_dir2.c - 1.56 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.56&r2=text&tr2=1.55&f=h
	- Call inline functions directly rather than the macros that
	  wrap them and remove the unneeded macros.
