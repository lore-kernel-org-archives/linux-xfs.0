Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 17:58:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5R0wE9o007682
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 17:58:16 -0700
Subject: TAKE 982343 - fix up the _ACL_TYPE refs when CONFIG_XFS_POSIX_ACL not set.
Message-Id: <20080627005910.640EC58C4C29@chook.melbourne.sgi.com>
Date: Fri, 27 Jun 2008 10:59:10 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix up problem when CONFIG_XFS_POSIX_ACL is not set and yet we still can use
the _ACL_TYPE_* definitions in linux-2.6/xfs_xattr.c.
The forthcoming generic acl code will also fix this problem.

--Tim

Date:  Fri Jun 27 10:58:01 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  lachlan@sgi.com,hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31369a
fs/xfs/xfs_acl.h - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.h.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
	- Fix up problem when CONFIG_XFS_POSIX_ACL is not set and yet we still can use
	  the _ACL_TYPE_* definitions in linux-2.6/xfs_xattr.c.
	  Move the definitions further up before the #ifdef config stuff.
