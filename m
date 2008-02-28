Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Feb 2008 16:36:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1S0aErq009346
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2008 16:36:17 -0800
Subject: TAKE 971186 - 
Message-Id: <20080228003638.5851158C4C0F@chook.melbourne.sgi.com>
Date: Thu, 28 Feb 2008 11:36:38 +1100 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill t_sema member of struct xfs_trans

It's completely unused so we might aswell kill it.  Note that there is
another t_sema in struct xlog_ticket, which is used and actually an sv_t
despite the name.  That one is left untouched by this patch.


Date:  Thu Feb 28 11:36:24 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/home/xaiki/isms/2.6-xfs
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30591a
fs/xfs/xfs_trans.h - 1.148 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.148&r2=text&tr2=1.147&f=h
	- kill t_sema member of struct xfs_trans
