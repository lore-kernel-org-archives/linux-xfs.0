Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Feb 2007 11:35:20 -0800 (PST)
Received: from omx1.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l11JZBqw017261
	for <xfs@oss.sgi.com>; Thu, 1 Feb 2007 11:35:12 -0800
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by omx1.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id l11JLADW026591
	for <xfs@oss.sgi.com>; Thu, 1 Feb 2007 13:21:10 -0600
Subject: TAKE 960730 - incremental xfsdump can skip modified/new files
Message-Id: <20070201192109.13F9F1F71F6@attica.americas.sgi.com>
Date: Thu,  1 Feb 2007 13:21:09 -0600 (CST)
From: wkendall@sgi.com (Bill Kendall)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com, xfs@sgi.com, sgi.bugs.xfs@sgi.com

Issue a sync call before doing the initial inode scan so that
any inode changes in the inode cache are reflected in the bulk
stat calls. This is necessary for incremental dumps to work
properly (i.e. not skip files) so that all inodes changed before
the dump time are included in the dump.


Date:  Thu Feb  1 11:20:37 PST 2007
Workarea:  attica.americas.sgi.com:/data/lwork/attica1/dmfgrp/4.0_chroot/wkendall/xfs-cmds
Inspected by:  kfr

The following file(s) were checked into:
  bonnie.engr.sgi.com:/isms/xfs-cmds/master


Modid:  master:xfs-cmds:220676a
xfsdump/dump/inomap.c - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/dump/inomap.c.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
