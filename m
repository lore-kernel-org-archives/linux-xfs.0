Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Nov 2006 16:28:05 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB10RraG008351
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 16:27:56 -0800
Date: Fri, 1 Dec 2006 11:26:56 +1100 (AEDT)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200612010026.kB10QuG449074185@snort.melbourne.sgi.com>
Subject: TAKE 958517 - mkfs.xfs can create a corrupt filesystem
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix up mkfs.xfs which can create a corrupt filesystem with large block sizes.


Date:  Fri Dec  1 11:26:25 AEDT 2006
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27594a
xfsprogs/doc/CHANGES - 1.227 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.227&r2=text&tr2=1.226&f=h
xfsprogs/mkfs/xfs_mkfs.c - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
	- Fix up determination of realtime extent size so mkfs can't create
	  a corrupt filesystem

xfsprogs/include/xfs_rtalloc.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_rtalloc.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Remove default realtime extent size definition.
