Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 00:40:24 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9R7dkXH026547
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 00:39:46 -0700
Subject: TAKE 987246 - correctly select first log item to push
Message-Id: <20081027073935.916FB58AE1E5@chook.melbourne.sgi.com>
Date: Mon, 27 Oct 2008 18:39:35 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

correctly select first log item to push

Under heavy metadata load we are seeing log hangs. The
AIL has items in it ready to be pushed, and they are within
the push target window. However, we are not pushing them
when the last pushed LSN is less than the LSN of the
first log item on the AIL. This is a regression introduced
by the AIL push cursor modifications.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Mon Oct 27 18:39:08 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  tes
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32409a
fs/xfs/xfs_trans_ail.c - 1.93 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.93&r2=text&tr2=1.92&f=h
	- correctly select first log item to push
