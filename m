Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 21:44:32 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L5iOVB018908
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 21:44:27 -0800
Subject: TAKE 970652 - It's possible for an empty directory to be undeletable
Message-Id: <20080121054438.1D03B58C4C0F@chook.melbourne.sgi.com>
Date: Mon, 21 Jan 2008 16:44:38 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make sure "." and ".." are the first two entries in a directory


Date:  Mon Jan 21 16:44:01 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  bnaujok

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30385a
xfsprogs/repair/phase6.c - 1.41 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase6.c.diff?r1=text&tr1=1.41&r2=text&tr2=1.40&f=h
xfsprogs/repair/incore_ino.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/incore_ino.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- Make sure "." and ".." are the first two entries in a directory
