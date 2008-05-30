Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 18:27:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4U1RA7i002730
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 18:27:11 -0700
Subject: TAKE 982545 - Only use xfs_buf_t locks when doing prefetched repair
Message-Id: <20080530012759.12BD458C4C3F@chook.melbourne.sgi.com>
Date: Fri, 30 May 2008 11:27:58 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Fri May 30 11:27:33 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  tes@sgi.com, sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31256a
xfsprogs/man/man8/xfs_repair.8 - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_repair.8.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Update -P description in xfs_repair man page

xfsprogs/include/libxfs.h - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/libxfs.h.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
	- Add "usebuflock" field to xfs_init

xfsprogs/repair/init.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/init.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
	- Set "usebuflock" flag if doing prefetched repair

xfsprogs/libxfs/rdwr.c - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/rdwr.c.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
	- Only lock xfs_buf_t when use_xfs_buf_lock flag set

xfsprogs/libxfs/init.c - 1.56 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/init.c.diff?r1=text&tr1=1.56&r2=text&tr2=1.55&f=h
	- Handle usebuflock flag in xfs_init
