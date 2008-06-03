Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Jun 2008 18:07:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5317lHC028933
	for <xfs@oss.sgi.com>; Mon, 2 Jun 2008 18:07:49 -0700
Subject: PARTIAL TAKE 982421 - xfs_repair: Doesn't work with 16KB filesystem blocksize.
Message-Id: <20080603010836.A9BDB58C4C3F@chook.melbourne.sgi.com>
Date: Tue,  3 Jun 2008 11:08:36 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix up inode cluster I/O size in repair for >8KB block size filesystems


Date:  Tue Jun  3 11:07:54 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31267a
xfsprogs/repair/xfs_repair.c - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/xfs_repair.c.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
xfsprogs/repair/prefetch.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/prefetch.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- Fix up inode cluster I/O size in repair for >8KB block size filesystems
