Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 May 2007 17:14:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4M0E6fB023053
	for <xfs@oss.sgi.com>; Mon, 21 May 2007 17:14:08 -0700
Subject: TAKE 962012 - invalid fullstat when recalling files
Message-Id: <20070522001402.4147858CA531@chook.melbourne.sgi.com>
Date: Tue, 22 May 2007 10:14:02 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Make hole punching at EOF atomic.

If hole punching at EOF is done as two steps (i.e. truncate then extend)
the file is in a transient state between the two steps where an
application can see the incorrect file size. Punching a hole to
EOF needs to be treated in teh same way as all other hole punching
cases so that the file size is never seen to change.


Date:  Tue May 22 10:13:27 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  vapo@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28641a
fs/xfs/xfs_rw.h - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rw.h.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
	- export and define flags for xfs_free_eofblocks.

fs/xfs/xfs_vnodeops.c - 1.696 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.696&r2=text&tr2=1.695&f=h
	- convert callers to new xfs_free_eofblocks() interface and allow it
	  to be called with the iolock already held.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
	- export xfs_free_eofblocks.

fs/xfs/dmapi/xfs_dm.c - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
	- Use UNRESVSP to punch a hole at EOF rather than FREESP + xfs_setattr
	  to return truncate and extend the file. THis means we also need to
	  truncate away blocks past EOF using xfs_free_eofblocks().
