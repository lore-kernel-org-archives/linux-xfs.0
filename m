Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Feb 2007 22:26:01 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1J6P3m7030398
	for <xfs@oss.sgi.com>; Sun, 18 Feb 2007 22:25:05 -0800
From: donaldd@sgi.com
Subject: TAKE 961225 - Fix grace time display problems in xfs_quota
Message-Id: <20070219062458.6C7F822C4DBE@linuxbuild.melbourne.sgi.com>
Date: Mon, 19 Feb 2007 17:24:58 +1100 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix grace time display problems in xfs_quota

Subject: [PATCH] fix the grace time in xfs_quota
Date: Thu, 15 Feb 2007 16:39:52 +0900
From: Utako Kusaka <utako@tnes.nec.co.jp>
To: xfs@oss.sgi.com
Hi,

When a quota limit is reached at a soft limit, xfs_quota(8) shows the 
incorrect grace time.
Because, the subtraction with '__uint32_t' and 'time_t' are done in 
time_to_string(), and the result does not become a negative value, but
a huge value. This patch fixes it.

Date:  Mon Feb 19 17:19:54 AEDT 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/xfs-cmds
Inspected by:  Utako Kusaka <utako@tnes.nec.co.jp>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28131a
xfsprogs/doc/CHANGES - 1.235 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.235&r2=text&tr2=1.234&f=h
xfsprogs/quota/quota.h - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/quota/quota.h.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
xfsprogs/quota/util.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/quota/util.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
