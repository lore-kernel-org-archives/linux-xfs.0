Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Oct 2008 23:33:09 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m926X6qW020139
	for <xfs@oss.sgi.com>; Wed, 1 Oct 2008 23:33:06 -0700
Subject: TAKE 987785 - Consolidate btree block handling for xfs_db
Message-Id: <20081002063436.22F7858C52B4@chook.melbourne.sgi.com>
Date: Thu,  2 Oct 2008 16:34:36 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Consolidate btree block handling for xfs_db

Currently xfs_db has five different implementations for poking at btree
blocks, even duplicating code for btree blocks with entirely identical
layout (bmapbta vs bmapbtd and bno vs cnt).  Merge all these into
a single implementation that uses a table of btree characteristics keyed
of their magic number.
 
There's probably a way to further consolidate the magic arrays for the
different types, but I don't quite understand xfs_db's table driven
command parser for that.
 
 
Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Thu Oct  2 16:33:59 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32248a
xfsprogs/db/btblock.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/btblock.h
xfsprogs/db/btblock.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/btblock.c
xfsprogs/db/field.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/field.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsprogs/db/cntbt.c - 1.11 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/cntbt.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/db/cntbt.h - 1.8 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/cntbt.h.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfsprogs/db/bnobt.c - 1.11 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/bnobt.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/db/bnobt.h - 1.8 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/bnobt.h.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfsprogs/db/bmapbt.h - 1.8 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/bmapbt.h.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfsprogs/db/bmapbt.c - 1.11 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/bmapbt.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/db/inobt.c - 1.11 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/inobt.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/db/inobt.h - 1.8 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/inobt.h.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfsprogs/db/fprint.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/fprint.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/db/type.c - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/type.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/db/Makefile - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/Makefile.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsprogs/db/check.c - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/check.c.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
	- Consolidate btree block handling for xfs_db
