Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Oct 2006 22:50:02 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9U6nkaG031490
	for <xfs@oss.sgi.com>; Sun, 29 Oct 2006 22:49:48 -0800
Date: Mon, 30 Oct 2006 17:48:52 +1100 (AEDT)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200610300648.k9U6mqUN19981764@snort.melbourne.sgi.com>
Subject: TAKE 957164 - xfs_repair does not fix corruption detected by xfs_check
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fixed an endian based flaw in setting the old nlink count in phase 7
of xfs_repair


Date:  Mon Oct 30 17:48:04 AEDT 2006
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  mvalluri@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27311a
xfsprogs/VERSION - 1.166 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.166&r2=text&tr2=1.165&f=h
xfsprogs/doc/CHANGES - 1.224 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.224&r2=text&tr2=1.223&f=h
	- Updated xfsprogs to 2.8.16

xfsprogs/repair/phase7.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase7.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- Fixed an endian based flaw in setting the old nlink count in phase 7
	  of xfs_repair
