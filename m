Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Sep 2007 21:59:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l874x04p013996
	for <xfs@oss.sgi.com>; Thu, 6 Sep 2007 21:59:02 -0700
Subject: TAKE 969188 - xfs_metadump doesn't do enough validation of bad offsets
Message-Id: <20070907045857.DC64D58C4C09@chook.melbourne.sgi.com>
Date: Fri,  7 Sep 2007 14:58:57 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make xfs_metadump more robust against bad data


Date:  Fri Sep  7 14:58:32 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29620a
xfsprogs/db/metadump.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/metadump.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Make xfs_metadump more robust against bad data

xfsprogs/db/xfs_metadump.sh - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/xfs_metadump.sh.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Add -m command line option
