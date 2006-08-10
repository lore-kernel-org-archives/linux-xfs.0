Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Aug 2006 23:14:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7A6DlDW007136
	for <linux-xfs@oss.sgi.com>; Wed, 9 Aug 2006 23:13:59 -0700
Subject: PARTIAL TAKE 955302 - cleanup
Message-Id: <20060810061303.75B3A58C6F7C@chook.melbourne.sgi.com>
Date: Thu, 10 Aug 2006 16:13:03 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove a couple of unused BUF macros

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Thu Aug 10 16:04:22 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  sandeen

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26746a
xfs_buf_item.c - 1.159 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.159&r2=text&tr2=1.158&f=h
linux-2.6/xfs_buf.h - 1.115 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.h.diff?r1=text&tr1=1.115&r2=text&tr2=1.114&f=h
linux-2.4/xfs_buf.h - 1.116 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_buf.h.diff?r1=text&tr1=1.116&r2=text&tr2=1.115&f=h
	- Remove a couple of unused BUF macros


Remove unused iop_abort log item operation

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Thu Aug 10 16:09:47 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  sandeen

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26747a
xfs_extfree_item.c - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_extfree_item.c.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
xfs_buf_item.c - 1.160 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.160&r2=text&tr2=1.159&f=h
xfs_inode_item.c - 1.129 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.c.diff?r1=text&tr1=1.129&r2=text&tr2=1.128&f=h
xfs_trans.h - 1.141 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.141&r2=text&tr2=1.140&f=h
quota/xfs_dquot_item.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot_item.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- Remove unused iop_abort log item operation


Remove several macros that are no longer used anywhere

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Thu Aug 10 16:12:32 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  sandeen

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26749a
xfs_log.h - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.h.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
xfs_log_priv.h - 1.116 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.116&r2=text&tr2=1.115&f=h
xfs_sb.h - 1.67 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_sb.h.diff?r1=text&tr1=1.67&r2=text&tr2=1.66&f=h
xfs_fs.h - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fs.h.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
xfs_error.h - 1.44 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.h.diff?r1=text&tr1=1.44&r2=text&tr2=1.43&f=h
xfs_quota.h - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_quota.h.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
quota/xfs_quota_priv.h - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_quota_priv.h.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
quota/xfs_qm.h - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.h.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
linux-2.6/xfs_linux.h - 1.149 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.149&r2=text&tr2=1.148&f=h
linux-2.4/xfs_linux.h - 1.160 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_linux.h.diff?r1=text&tr1=1.160&r2=text&tr2=1.159&f=h
linux-2.6/xfs_buf.h - 1.116 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.h.diff?r1=text&tr1=1.116&r2=text&tr2=1.115&f=h
linux-2.4/xfs_buf.h - 1.117 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_buf.h.diff?r1=text&tr1=1.117&r2=text&tr2=1.116&f=h
	- Remove several macros that are no longer used anywhere
