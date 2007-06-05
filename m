Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 19:44:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l552i4Wt013922
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 19:44:06 -0700
Subject: TAKE 957724 - need an xfsdump/xfscopy style tools that collects metadata only
Message-Id: <20070605024359.18DCB58C38C1@chook.melbourne.sgi.com>
Date: Tue,  5 Jun 2007 12:43:59 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

XFS metadata dump tool


Date:  Tue Jun  5 12:43:11 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/metadump
Inspected by:  Christoph Hellwig <hch@infradead.org>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28782a
xfsprogs/mdrestore/xfs_mdrestore.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mdrestore/xfs_mdrestore.c
xfsprogs/mdrestore/Makefile - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mdrestore/Makefile
	- Metadump restore tool

xfsprogs/db/metadump.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/metadump.c
	- Add metadump to xfs_db

xfsprogs/man/man8/xfs_mdrestore.8 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_mdrestore.8
	- Update man page for xfs_metadump

xfsprogs/db/xfs_metadump.sh - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/xfs_metadump.sh
	- Scripto wrapper for xfs_db metadump command

xfsprogs/include/xfs_metadump.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_metadump.h
	- Header for xfs_metadump structures

xfsprogs/db/metadump.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/metadump.h
	- Add metadump to xfs_db

xfsprogs/man/man8/xfs_metadump.8 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_metadump.8
	- Update man page for xfs_metadump

xfsprogs/db/init.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/init.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/db/Makefile - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/Makefile.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/db/command.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/command.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- Add metadump to xfs_db

xfsprogs/Makefile - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/Makefile.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
	- Add xfs_mdrestore directory to makefile

xfsprogs/VERSION - 1.172 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.172&r2=text&tr2=1.171&f=h
xfsprogs/doc/CHANGES - 1.241 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.241&r2=text&tr2=1.240&f=h
	- Update to version 2.9.0

xfsprogs/man/man8/xfs_db.8 - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_db.8.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/man/man8/xfs_repair.8 - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_repair.8.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- Update man page for xfs_metadump
