Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Sep 2008 19:17:56 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8T2HqQf019306
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 19:17:52 -0700
Subject: TAKE 986789 - Fix build brakage from patch "Clean up dquot pincount code"
Message-Id: <20080929021924.3A7E53C5C3D6@chapter11.melbourne.sgi.com>
Date: Mon, 29 Sep 2008 12:19:24 +1000 (EST)
From: pleckie@sgi.com (Peter Leckie)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-bugs-internal@sgi.com, xfs@oss.sgi.com

Fix build brakage from patch "Clean up dquot pincount code"

This is a fix for patch " Clean up dquot pincount code"
which introduced a build breakage due to a missing & in
xfs_qm_dquot_logitem_pin.


Signed-off-by: Peter Leckie <pleckie@sgi.com> 


Date:  Mon Sep 29 12:18:30 AEST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/pleckie/2.6.x-xfs
Inspected by:  donaldd

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32221a
fs/xfs/quota/xfs_dquot_item.c - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot_item.c.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
	- Fix build brakage from patch "Clean up dquot pincount code"
