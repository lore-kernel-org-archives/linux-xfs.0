Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Aug 2008 01:50:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m768oAll008900
	for <xfs@oss.sgi.com>; Wed, 6 Aug 2008 01:50:11 -0700
Subject: TAKE 981498 - Make xfs_bmap_*_count_leaves void.
Message-Id: <20080806085121.E146D3D2B6DB@chapter11.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 18:51:21 +1000 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Make xfs_bmap_*_count_leaves void.

xfs_bmap_count_leaves and xfs_bmap_disk_count_leaves always
return always 0, make them void. 

Signed-off-by: Ruben Porras <ruben.porras@linworks.de>

Date:  Wed Aug  6 18:50:30 AEST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/donaldd/isms/2.6.x-xfs
Inspected by:  ruben.porras@linworks.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31844a
fs/xfs/xfs_bmap.c - 1.401 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.401&r2=text&tr2=1.400&f=h
	- Make xfs_bmap_*_count_leaves void.
