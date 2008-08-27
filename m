Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 21:03:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7R43PR6016912
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 21:03:26 -0700
Subject: TAKE 986141 - xfs_repair - remove convert_extents function
Message-Id: <20080827040446.0762258C52A8@chook.melbourne.sgi.com>
Date: Wed, 27 Aug 2008 14:04:45 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Call libxfs_bmbt_disk_get_all directly instead of using a wrapper
function


Date:  Wed Aug 27 14:03:52 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31982a
xfsprogs/repair/dinode.c - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dinode.c.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
xfsprogs/repair/prefetch.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/prefetch.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- Call libxfs_bmbt_disk_get_all directly instead of using a wrapper function
