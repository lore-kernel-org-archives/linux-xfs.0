Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 22:40:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m765e9kx012776
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 22:40:10 -0700
Subject: TAKE 981498 - use KM_MAYFAIL in xfs_mountfs
Message-Id: <20080806054121.CB2F258C52A4@chook.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 15:41:21 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

use KM_MAYFAIL in xfs_mountfs

Use KM_MAYFAIL for the m_perag allocation, we can deal with the error
easily and blocking forever during mount is not a good idea either.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Aug  6 15:40:44 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31837a
fs/xfs/xfs_mount.c - 1.445 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.445&r2=text&tr2=1.444&f=h
	- use KM_MAYFAIL in xfs_mountfs
