Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 21:35:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K4Z6H7020762
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 21:35:08 -0700
Subject: PARTIAL TAKE 976035 - de-duplicate calls to xfs_attr_trace_enter]
Message-Id: <20080520043551.7512B58C4C29@chook.melbourne.sgi.com>
Date: Tue, 20 May 2008 14:35:51 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

de-duplicate calls to xfs_attr_trace_enter

Every call to xfs_attr_trace_enter() shares the exact
same 16 args in the middle... just send in the context
pointer and let the next level down split it into the
ktrace.

Compile tested only.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Niv Sardi <xaiki@sgi.com>


Date:  Tue May 20 14:30:00 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/xaiki/isms/2.6-xfs
Inspected by:  jeffpc,esandeen,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31200a
fs/xfs/xfs_attr_sf.h - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_sf.h.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
fs/xfs/xfs_attr.c - 1.150 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.150&r2=text&tr2=1.149&f=h
