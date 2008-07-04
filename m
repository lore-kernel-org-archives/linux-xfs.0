Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Jul 2008 00:52:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m647qXg7005370
	for <xfs@oss.sgi.com>; Fri, 4 Jul 2008 00:52:35 -0700
Subject: TAKE 984019 - fix compilation without CONFIG_PROC_FS
Message-Id: <20080704075330.EF20858C4C29@chook.melbourne.sgi.com>
Date: Fri,  4 Jul 2008 17:53:30 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

fix compilation without CONFIG_PROC_FS

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Jul  4 17:52:09 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31408a
fs/xfs/linux-2.6/xfs_stats.h - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_stats.h.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- fix compilation without CONFIG_PROC_FS
	  very obvious problem :)
