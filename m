Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Jan 2007 20:19:43 -0800 (PST)
Received: from omx1.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0V4Jdqw023171
	for <xfs@oss.sgi.com>; Tue, 30 Jan 2007 20:19:40 -0800
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by omx1.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id l0V40lDW006693
	for <xfs@oss.sgi.com>; Tue, 30 Jan 2007 22:00:47 -0600
Received: from clink.americas.sgi.com (clink.americas.sgi.com [128.162.236.153])
	by imr2.americas.sgi.com (8.12.9/8.12.10/SGI_generic_relay-1.2) with ESMTP id l0V3UHnc80585414
	for <xfs@oss.sgi.com>; Tue, 30 Jan 2007 19:30:17 -0800 (PST)
Received: (from mvalluri@localhost)
	by clink.americas.sgi.com (SGI-8.12.5/8.12.5/Submit) id l0V40hUI15749846
	for xfs@oss.sgi.com; Tue, 30 Jan 2007 22:00:43 -0600 (CST)
Date: Tue, 30 Jan 2007 22:00:43 -0600 (CST)
From: Madan Valluri <mvalluri@sgi.com>
Message-Id: <200701310400.l0V40hUI15749846@clink.americas.sgi.com>
Subject: TAKE 959450 - 
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

QA 033 failing due to root inode being put in lost+found


Date:  Tue Jan 30 19:58:09 PST 2007
Workarea:  clink.americas.sgi.com:/data/clink/a01/mvalluri/totrepair
Inspected by:  bnaujok@sgi.com

The following file(s) were checked into:
  bonnie.engr.sgi.com:/isms/xfs-cmds/master


Modid:  master:xfs-cmds:220539a
xfsprogs/repair/phase6.c - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase6.c.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
	- Do no skip a rootino even if it doesn't appear to be a directory, in traverse_function().
