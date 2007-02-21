Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 22:48:57 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1L6mpm7027870
	for <xfs@oss.sgi.com>; Tue, 20 Feb 2007 22:48:53 -0800
Subject: TAKE 961299 - xfs_repair crashes in phase4 with an fsfuzzer'd image
Message-Id: <20070221064846.A36C658CA547@chook.melbourne.sgi.com>
Date: Wed, 21 Feb 2007 17:48:46 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Verify quota inodes before looking them up


Date:  Wed Feb 21 17:47:48 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  Eric Sandeen [sandeen@sandeen.net]

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28152a
xfsprogs/repair/phase4.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase4.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- Verify quota inodes before looking them up
