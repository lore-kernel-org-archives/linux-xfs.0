Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Sep 2006 21:10:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8749xDW013700
	for <linux-xfs@oss.sgi.com>; Wed, 6 Sep 2006 21:10:12 -0700
Subject: TAKE 955993 - quota oops fix
Message-Id: <20060907040908.2DDBF58CF851@chook.melbourne.sgi.com>
Date: Thu,  7 Sep 2006 14:09:08 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix a bad pointer dereference in the quota statvfs handling.

Date:  Thu Sep  7 14:08:44 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26934a
quota/xfs_qm_bhv.c - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_bhv.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
