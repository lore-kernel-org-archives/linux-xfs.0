Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 19:23:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6P2No3w029453
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 19:23:51 -0700
Subject: TAKE 981498 - remove spurious VN_HOLD/VN_RELE calls from xfs_acl.c
Message-Id: <20080725022459.AF43D58C4C3F@chook.melbourne.sgi.com>
Date: Fri, 25 Jul 2008 12:24:59 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

remove spurious VN_HOLD/VN_RELE calls from xfs_acl.c

All the ACL routines are called from inode operations which are
guaranteed to have a referenced inode by the VFS, so there's no need
for the ACL code to grab another temporary one.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Jul 25 12:23:52 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31763a
fs/xfs/xfs_acl.c - 1.78 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.78&r2=text&tr2=1.77&f=h
	- remove spurious VN_HOLD/VN_RELE calls from xfs_acl.c
