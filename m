Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Dec 2006 15:20:01 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBLNJsqw023740
	for <linux-xfs@oss.sgi.com>; Thu, 21 Dec 2006 15:19:55 -0800
Date: Fri, 22 Dec 2006 10:05:29 +1100 (AEDT)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200612212305.kBLN5T7f70006633@snort.melbourne.sgi.com>
Subject: TAKE 959492 - xfs_growfs should return an error on failure
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

Return error (1) if something fails in xfs_growfs


Date:  Fri Dec 22 10:05:06 AEDT 2006
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  nathans@debian.org,sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27802a
xfsprogs/growfs/xfs_growfs.c - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/growfs/xfs_growfs.c.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
	- Return error (1) if something fails in xfs_growfs
