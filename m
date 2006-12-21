Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 16:12:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBL0Cbqw012750
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 16:12:39 -0800
Date: Thu, 21 Dec 2006 11:11:33 +1100 (AEDT)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200612210011.kBL0BXSl68569165@snort.melbourne.sgi.com>
Subject: TAKE 958747 - attr2 corruption on Linux
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix attr2 corruption with btree data extents


Date:  Thu Dec 21 11:11:01 AEDT 2006
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/linux-tot
Inspected by:  cattelan@thebarn.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27792a
fs/xfs/xfs_attr_leaf.c - 1.105 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.105&r2=text&tr2=1.104&f=h
	- Lock forkoff when data extent is in btree form. Also allow more space for
	  attr if extents must convert to btree form.

fs/xfs/xfs_bmap.c - 1.360 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.360&r2=text&tr2=1.359&f=h
	- Lock forkoff when data extent is in btree form.

fs/xfs/xfs_attr.c - 1.141 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.141&r2=text&tr2=1.140&f=h
	- Fix up initial creation of shortform attributes
