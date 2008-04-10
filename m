Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 17:37:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A0axTh027678
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 17:37:01 -0700
Subject: PARTIAL TAKE 980084 - Ensure errors from xfs_bdstrat() are correctly checked.
Message-Id: <20080410003737.6DBC958C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 10:37:37 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Ensure errors from xfs_bdstrat() are correctly checked.

xfsbdstrat() is declared to return an error. That is never checked
because the error is propagated by the xfs_buf_t that is passed
through the function.

Mark xfsbdstrat() as returning void and comment the prototype
on the methods needed for error checking.


Date:  Thu Apr 10 10:37:02 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30823a
fs/xfs/xfs_vnodeops.c - 1.748 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.748&r2=text&tr2=1.747&f=h
	- Ensure errors from xfs_bdstrat() are correctly checked.

fs/xfs/xfs_log_recover.c - 1.341 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.341&r2=text&tr2=1.340&f=h
	- Ensure errors from xfs_bdstrat() are correctly checked.

fs/xfs/xfs_mount.c - 1.426 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.426&r2=text&tr2=1.425&f=h
	- Ensure errors from xfs_bdstrat() are correctly checked.

fs/xfs/xfs_trans_buf.c - 1.130 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_buf.c.diff?r1=text&tr1=1.130&r2=text&tr2=1.129&f=h
	- Ensure errors from xfs_bdstrat() are correctly checked.

fs/xfs/linux-2.6/xfs_lrw.h - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.h.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
	- Ensure errors from xfs_bdstrat() are correctly checked.

fs/xfs/linux-2.6/xfs_lrw.c - 1.278 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.278&r2=text&tr2=1.277&f=h
	- Ensure errors from xfs_bdstrat() are correctly checked.
