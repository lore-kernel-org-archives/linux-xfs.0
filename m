Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 20:00:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7R2xvc7008591
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 19:59:59 -0700
Subject: TAKE 986140 - Increase xfs_metadump's max valid ext size for dirs
Message-Id: <20080827030118.42B8F58C52A8@chook.melbourne.sgi.com>
Date: Wed, 27 Aug 2008 13:01:18 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Increase default "valid" maximum extent size for xfs_metadump when copying
directory contents to 1000 blocks per extent (from 20).


Date:  Wed Aug 27 13:00:05 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31977a
xfsprogs/db/metadump.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/metadump.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
	- Increase default max extent size to 1000 blocks
