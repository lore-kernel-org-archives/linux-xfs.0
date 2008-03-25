Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 23:48:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P6lwCE010364
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 23:48:03 -0700
Subject: PARTIAL TAKE 976035 - split xfs_ioc_xattr
Message-Id: <20080325064828.AEB5158C4C0F@chook.melbourne.sgi.com>
Date: Tue, 25 Mar 2008 17:48:28 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

split xfs_ioc_xattr

The three subcases of xfs_ioc_xattr don't share any semantics and almost
no code, so split it into three separate helpers.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Mar 25 17:47:37 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30709a
fs/xfs/linux-2.6/xfs_ioctl.c - 1.163 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.163&r2=text&tr2=1.162&f=h
	- split xfs_ioc_xattr
