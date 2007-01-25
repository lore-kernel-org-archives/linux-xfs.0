Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 19:51:32 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0P3pPqw009594
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 19:51:26 -0800
Date: Thu, 25 Jan 2007 14:50:23 +1100 (AEDT)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200701250350.l0P3oN8f103391539@snort.melbourne.sgi.com>
Subject: TAKE 960471 - fix extent length in xfs_io bmap
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix xfs_bmap -n option displaying a truncated extent.


Date:  Thu Jan 25 14:49:53 AEDT 2007
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  Utako Kusaka <utako@tnes.nec.co.jp>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27990a
xfsprogs/io/bmap.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/io/bmap.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Fix xfs_bmap -n option displaying a truncated extent.
