Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Nov 2007 19:13:08 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAN3Cv5O011727
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2007 19:13:03 -0800
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id OAA17835 for <xfs@oss.sgi.com>; Fri, 23 Nov 2007 14:13:05 +1100
Subject: TAKE 972554 - Clear XBF_READ_AHEAD flag on I/O completion.
Message-Id: <20071123031305.4E3D758C4C0A@chook.melbourne.sgi.com>
Date: Fri, 23 Nov 2007 14:13:05 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Clear XBF_READ_AHEAD flag on I/O completion.

Date:  Fri Nov 23 14:08:40 AEDT 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-bufflag
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30128a
fs/xfs/linux-2.6/xfs_buf.c - 1.248 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.248&r2=text&tr2=1.247&f=h
	- Clear XBF_READ_AHEAD flag on I/O completion.
