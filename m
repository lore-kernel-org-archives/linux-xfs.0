Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Sep 2008 18:26:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m851PqGQ008804
	for <xfs@oss.sgi.com>; Thu, 4 Sep 2008 18:25:53 -0700
Subject: TAKE 986491 - Improve caching in libxfs
Message-Id: <20080905012719.51B6A58C52AB@chook.melbourne.sgi.com>
Date: Fri,  5 Sep 2008 11:27:19 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Change the libxfs cache MRU to only store unreferenced blocks
so the searching doesn't scan through referenced blocks.


Date:  Fri Sep  5 11:26:21 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32049a
xfsprogs/libxfs/rdwr.c - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/rdwr.c.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
	- Improve libxfs cache

xfsprogs/include/cache.h - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/cache.h.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- Improve libxfs cache

xfsprogs/libxfs/cache.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/cache.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/repair/prefetch.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/prefetch.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- Improve libxfs cache
