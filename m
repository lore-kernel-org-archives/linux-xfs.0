Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 19:39:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6P2dfdw030553
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 19:39:43 -0700
Subject: TAKE 981498 - remove remaining VN_HOLD calls
Message-Id: <20080725024051.1F8F058C4C3F@chook.melbourne.sgi.com>
Date: Fri, 25 Jul 2008 12:40:50 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

remove remaining VN_HOLD calls

Use IHOLD(ip) instead of VN_HOLD(VFS_I(ip)).


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Jul 25 12:39:39 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31765a
fs/xfs/xfs_dfrag.c - 1.69 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.69&r2=text&tr2=1.68&f=h
fs/xfs/xfs_bmap.c - 1.398 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.398&r2=text&tr2=1.397&f=h
fs/xfs/quota/xfs_dquot.c - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
	- remove remaining VN_HOLD calls
