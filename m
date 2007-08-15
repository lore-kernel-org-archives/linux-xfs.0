Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Aug 2007 19:04:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7F240bm013217
	for <xfs@oss.sgi.com>; Tue, 14 Aug 2007 19:04:04 -0700
Subject: TAKE 968090 - xfs_repair fails when fsblock size is different do dir block size
Message-Id: <20070815020400.90ED858C1767@chook.melbourne.sgi.com>
Date: Wed, 15 Aug 2007 12:04:00 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fixed up I/O size when doing da_reads for directories


Date:  Wed Aug 15 12:03:26 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  vapo@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29390a
xfsprogs/repair/dir2.c - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dir2.c.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
xfsprogs/repair/prefetch.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/prefetch.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
	- Fixed up I/O size for directory blocks.
