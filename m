Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Jun 2007 01:07:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5D871Wt005710
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2007 01:07:03 -0700
Subject: TAKE 966238 - libattr Makefile replacing LTLDFLAGS instead of appending
Message-Id: <20070613080657.2E9F758C38C1@chook.melbourne.sgi.com>
Date: Wed, 13 Jun 2007 18:06:57 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

LTLDFLAGS set in environment are overwritten, but they shouldn't be.


Date:  Wed Jun 13 18:06:11 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  Arfrever.FTA@GMail.Com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28906a
attr/libattr/Makefile - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/libattr/Makefile.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- LTLDFLAGS set in environment are overwritten, but they shouldn't be.
