Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 21:35:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5J4ZOfU003819
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 21:35:27 -0700
Subject: TAKE 981498 - Remove infinite loop from xfsidbg_xaildump
Message-Id: <20080619043618.0B4A258C4C3F@chook.melbourne.sgi.com>
Date: Thu, 19 Jun 2008 14:36:17 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Remove infinite loop from xfsidbg_xaildump

The 'for' loop is non-terminating as 'lip' cannot become NULL.
Actually, the loop isn't even needed so remove it. 

Date:  Thu Jun 19 13:56:47 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-agno2
Inspected by:  xaiki
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31331a
fs/xfs/xfsidbg.c - 1.352 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.352&r2=text&tr2=1.351&f=h
	- Remove infinite loop from xfsidbg_xaildump
