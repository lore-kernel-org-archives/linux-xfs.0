Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Sep 2008 19:28:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m852S8CZ012694
	for <xfs@oss.sgi.com>; Thu, 4 Sep 2008 19:28:09 -0700
Subject: TAKE 986494 - xfs_repair - restoring missing ".." entries doesn't work
Message-Id: <20080905022935.8D81F58C52AB@chook.melbourne.sgi.com>
Date: Fri,  5 Sep 2008 12:29:35 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make sure xfs_repair can restore bad or missing ".." entries


Date:  Fri Sep  5 12:28:57 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32054a
xfsprogs/VERSION - 1.182 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.182&r2=text&tr2=1.181&f=h
xfsprogs/doc/CHANGES - 1.255 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.255&r2=text&tr2=1.254&f=h
	- Bump to version 2.10.1

xfsprogs/repair/phase6.c - 1.44 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase6.c.diff?r1=text&tr1=1.44&r2=text&tr2=1.43&f=h
	- Make sure xfs_repair can restore bad or missing ".." entries
