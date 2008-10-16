Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 23:12:03 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G6BxP3025813
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 23:11:59 -0700
Subject: TAKE 988145 - XFS: Check for valid transaction headers in recovery
Message-Id: <20081016061334.B1A4358FA22E@chook.melbourne.sgi.com>
Date: Thu, 16 Oct 2008 17:13:34 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Check for valid transaction headers in recovery

When we are about to add a new item to a transaction in recovery, we
need to check that it is valid first. Currently we just assert that
header magic number matches, but in production systems that is not
present and we add a corrupted transaction to the list to be
processed. This results in a kernel oops later when processing the
corrupted transaction.

Instead, if we detect a corrupted transaction, abort recovery and
leave the user to clean up the mess that has occurred.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Thu Oct 16 17:11:12 EST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  david@fromorbit.com,sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32356a
fs/xfs/xfs_log_recover.c - 1.355 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.355&r2=text&tr2=1.354&f=h
	- check for valid trans headers in recovery
