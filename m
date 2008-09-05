Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Sep 2008 18:54:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m851sFpN010516
	for <xfs@oss.sgi.com>; Thu, 4 Sep 2008 18:54:16 -0700
Subject: TAKE 983923 - 	xfs_repair - inode di_size not checked for validity with directories
Message-Id: <20080905015542.A68ED58C52AB@chook.melbourne.sgi.com>
Date: Fri,  5 Sep 2008 11:55:42 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Check for invalid di_size in xfs_repair


Date:  Fri Sep  5 11:54:59 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32051a
xfsprogs/repair/dinode.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dinode.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
	- Check for invalid inode di_size
