Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 02:01:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5890xWt024214
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 02:01:00 -0700
Subject: TAKE 966004 - cleanup obtaining extent size hints from the inode
Message-Id: <20070608090055.7309658C38F3@chook.melbourne.sgi.com>
Date: Fri,  8 Jun 2007 19:00:55 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Cleanup inode extent size hint extraction

Date:  Fri Jun  8 19:00:21 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28866a
fs/xfs/xfs_rw.h - 1.82 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rw.h.diff?r1=text&tr1=1.82&r2=text&tr2=1.81&f=h
	- Define a common function for extracting the valid extent size
	  hint from a given inode.

fs/xfs/xfs_vnodeops.c - 1.698 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.698&r2=text&tr2=1.697&f=h
	- Use xfs_get_extsz_hint rather than open coded statements.

fs/xfs/xfs_bmap.c - 1.369 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.369&r2=text&tr2=1.368&f=h
	- Use xfs_get_extsz_hint rather than open coded statements.

fs/xfs/xfs_iomap.c - 1.54 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.54&r2=text&tr2=1.53&f=h
	- Use xfs_get_extsz_hint rather than open coded statements.
