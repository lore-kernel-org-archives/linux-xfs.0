Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Feb 2007 23:20:49 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l167Kg3c027848
	for <xfs@oss.sgi.com>; Mon, 5 Feb 2007 23:20:44 -0800
Subject: TAKE 960868 - Clean up use of vfs attr flags
Message-Id: <20070206072037.1ECC458FF657@chook.melbourne.sgi.com>
Date: Tue,  6 Feb 2007 18:20:37 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Clean up use of VFS attr flags

Use the the generic VFS attr flags where appropriate instead
of open coding them to the same values.

Patch provided by Eric Sandeen.
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Tue Feb  6 18:19:58 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc,sandeen@sandeen.net,hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28033a
fs/xfs/linux-2.6/xfs_ioctl.c - 1.143 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.143&r2=text&tr2=1.142&f=h
	- Use generic VFS attr flags rather than open coding them.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
