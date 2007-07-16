Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 00:47:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G7lNbm021496
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 00:47:25 -0700
Subject: TAKE 962219 - xfs-repair - Improve libxfs xfs_buf_t caching
Message-Id: <20070716074722.34BCC58C38F1@chook.melbourne.sgi.com>
Date: Mon, 16 Jul 2007 17:47:22 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Add priority tagging and buffer reuse for libxfs cache


Date:  Mon Jul 16 17:46:48 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xcmds-patch
Inspected by:  markgw@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29150a
xfsprogs/VERSION - 1.174 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.174&r2=text&tr2=1.173&f=h
xfsprogs/doc/CHANGES - 1.243 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.243&r2=text&tr2=1.242&f=h
	- Update to 2.9.2

xfsprogs/include/libxfs.h - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/libxfs.h.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
xfsprogs/repair/phase6.c - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase6.c.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
xfsprogs/libxfs/rdwr.c - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/rdwr.c.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
xfsprogs/include/list.h - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/list.h.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
xfsprogs/include/cache.h - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/cache.h.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
xfsprogs/libxfs/cache.c - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/cache.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/repair/prefetch.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/prefetch.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- Add priority tagging and buffer reuse for libxfs cache
