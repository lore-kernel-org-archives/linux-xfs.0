Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 20:37:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6P3aoDW012627
	for <linux-xfs@oss.sgi.com>; Mon, 24 Jul 2006 20:37:01 -0700
Subject: PARTIAL TAKE 944409 - DMAPI bulkstat optimisations
Message-Id: <20060725033609.3AC4F58C38C1@chook.melbourne.sgi.com>
Date: Tue, 25 Jul 2006 13:36:09 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Ensure we specify the type of bulkstat call we will issue
(uninited variable).

Date:  Tue Jul 25 13:31:08 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26601a
dmapi/xfs_dm.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h


Rework DMAPI bulkstat calls in such a way that we can directly extract
inline attributes out of the bulkstat buffer (for that case), rather
than using an (extremely expensive for large icount filesystems) iget
for fetching attrs.

Date:  Tue Jul 25 13:34:45 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26602a
xfs_itable.c - 1.141 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.141&r2=text&tr2=1.140&f=h
xfs_itable.h - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.h.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
dmapi/xfs_dm.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
