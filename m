Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Oct 2006 12:17:26 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k92JHFaG028425
	for <xfs@oss.sgi.com>; Mon, 2 Oct 2006 12:17:16 -0700
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k92IC2nx015183
	for <xfs@oss.sgi.com>; Mon, 2 Oct 2006 13:12:02 -0500
Subject: TAKE 956714 - inode scan speedup for subtree and incremental dumps
Message-Id: <20061002181159.786252C8E83@attica.americas.sgi.com>
Date: Mon,  2 Oct 2006 13:11:59 -0500 (CDT)
From: wkendall@sgi.com (Bill Kendall)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@sgi.comxfs@sgi.com

Change xfsdump to use its inode map to determine the next inode
of interest when doing inode scans. This prevents unecessary
bulkstat calls when dumping only a fraction of a filesystem,
e.g., when doing a subtree or incremental dump.


Date:  Mon Oct  2 11:10:30 PDT 2006
Workarea:  attica.americas.sgi.com:/data/lwork/attica2/wkendall/stout/work/pl_root/xfs
Inspected by:  kfr

The following file(s) were checked into:
  bonnie.engr.sgi.com:/isms/xfs-cmds/master


Modid:  master:xfs-cmds:215399a
xfsdump/VERSION - 1.84 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/VERSION.diff?r1=text&tr1=1.84&r2=text&tr2=1.83&f=h
xfsdump/doc/CHANGES - 1.97 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/doc/CHANGES.diff?r1=text&tr1=1.97&r2=text&tr2=1.96&f=h
xfsdump/dump/content.c - 1.43 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/dump/content.c.diff?r1=text&tr1=1.43&r2=text&tr2=1.42&f=h
xfsdump/dump/inomap.h - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/dump/inomap.h.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsdump/dump/inomap.c - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/dump/inomap.c.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
xfsdump/common/util.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/util.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsdump/common/util.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/util.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
