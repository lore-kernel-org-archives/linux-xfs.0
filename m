Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Feb 2007 11:20:18 -0800 (PST)
Received: from omx1.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l11JKAqw014062
	for <xfs@oss.sgi.com>; Thu, 1 Feb 2007 11:20:11 -0800
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by omx1.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id l11JCJDW025224
	for <xfs@oss.sgi.com>; Thu, 1 Feb 2007 13:12:19 -0600
Subject: TAKE 959168 - xfsdump's logging facility not initialized early enough
Message-Id: <20070201191217.42CE61F71F6@attica.americas.sgi.com>
Date: Thu,  1 Feb 2007 13:12:17 -0600 (CST)
From: wkendall@sgi.com (Bill Kendall)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com, xfs@sgi.com, sgi.bugs.xfs@sgi.com

Initialize xfsdump's logging facility earlier during initialization.
Thanks to Kouta Ooizumi.


Date:  Thu Feb  1 11:10:50 PST 2007
Workarea:  attica.americas.sgi.com:/data/lwork/attica1/dmfgrp/4.0_chroot/wkendall/xfs-cmds
Inspected by:  dgc

The following file(s) were checked into:
  bonnie.engr.sgi.com:/isms/xfs-cmds/master


Modid:  master:xfs-cmds:220673a
xfsdump/common/stream.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/stream.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsdump/common/mlog.h - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/mlog.h.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsdump/common/mlog.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/mlog.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsdump/common/main.c - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/main.c.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
