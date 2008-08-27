Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 19:46:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7R2kGYl007671
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 19:46:17 -0700
Subject: TAKE 983809 - Un-popped buffers for failed reads in xfs_db can SEGV
Message-Id: <20080827024737.25ECF58C52A8@chook.melbourne.sgi.com>
Date: Wed, 27 Aug 2008 12:47:37 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make sure to pop buffers for a failed read in xfs_check and xfs_metadump
(both in xfs_db)


Date:  Wed Aug 27 12:46:20 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31976a
xfsprogs/db/check.c - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/check.c.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
xfsprogs/db/metadump.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/metadump.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Pop buffers for failed reads
