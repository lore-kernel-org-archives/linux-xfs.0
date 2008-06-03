Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Jun 2008 18:47:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m531lrof031651
	for <xfs@oss.sgi.com>; Mon, 2 Jun 2008 18:47:54 -0700
Subject: TAKE 982606 - Strange unlink behaviour
Message-Id: <20080603014842.C552F58C4C3F@chook.melbourne.sgi.com>
Date: Tue,  3 Jun 2008 11:48:42 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Zero uninitialised xfs_da_args structure in xfs_dir2.c

Fixes a problem in the xfs_dir2_remove and xfs_dir2_replace
paths which intenally call directory format specific lookup
funtions that assume args->cmpresult is zeroed.



Date:  Tue Jun  3 11:47:47 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31268a
fs/xfs/xfs_dir2.c - 1.69 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.69&r2=text&tr2=1.68&f=h
	- Zero uninitialised xfs_da_args structures
