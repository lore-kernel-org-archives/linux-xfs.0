Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Feb 2007 16:10:33 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l170AQ3c011509
	for <xfs@oss.sgi.com>; Tue, 6 Feb 2007 16:10:28 -0800
Subject: TAKE 960895 - Remove unused xfs_cap.h and xfs_mac.h header files
Message-Id: <20070207001020.E27EF58C4C27@chook.melbourne.sgi.com>
Date: Wed,  7 Feb 2007 11:10:20 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove unused header files for MAC and CAP checking functionality.

xfs_mac.h and xfs_cap.h provide definitions and macros that aren't
used anywhere in XFS at all. They are left-overs from "to be implement
at some point in the future" functionality that Irix XFS has. If this
functionality ever goes into Linux, it will be provided at a different
layer, most likely through the security hooks in the kernel so we will
never need this functionality in XFS.

Patch provided by Eric Sandeen (sandeen@sandeen.net).
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Wed Feb  7 11:09:50 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc,sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28036a
fs/xfs/xfs_rw.c - 1.397 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rw.c.diff?r1=text&tr1=1.397&r2=text&tr2=1.396&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_mac.h - 1.11 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mac.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_vnodeops.c - 1.689 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.689&r2=text&tr2=1.688&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_cap.h - 1.13 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_cap.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_dfrag.c - 1.57 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.57&r2=text&tr2=1.56&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_acl.c - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_inode.c - 1.460 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.460&r2=text&tr2=1.459&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/quota/xfs_trans_dquot.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_trans_dquot.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/quota/xfs_qm_bhv.c - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_bhv.c.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/quota/xfs_qm_stats.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_stats.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/quota/xfs_qm_syscalls.c - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/quota/xfs_dquot_item.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot_item.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/quota/xfs_dquot.c - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/quota/xfs_qm.c - 1.46 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.46&r2=text&tr2=1.45&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_iomap.c - 1.50 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/linux-2.6/xfs_lrw.c - 1.255 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.255&r2=text&tr2=1.254&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/linux-2.6/xfs_ioctl.c - 1.144 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.144&r2=text&tr2=1.143&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/linux-2.6/xfs_super.c - 1.379 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.379&r2=text&tr2=1.378&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/linux-2.6/xfs_iops.c - 1.257 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.257&r2=text&tr2=1.256&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/linux-2.4/xfs_lrw.c - 1.239 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_lrw.c.diff?r1=text&tr1=1.239&r2=text&tr2=1.238&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/linux-2.4/xfs_ioctl.c - 1.135 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_ioctl.c.diff?r1=text&tr1=1.135&r2=text&tr2=1.134&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/linux-2.4/xfs_super.c - 1.335 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_super.c.diff?r1=text&tr1=1.335&r2=text&tr2=1.334&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/linux-2.4/xfs_iops.c - 1.229 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_iops.c.diff?r1=text&tr1=1.229&r2=text&tr2=1.228&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/linux-2.6/xfs_ksyms.c - 1.55 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.55&r2=text&tr2=1.54&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/linux-2.4/xfs_ksyms.c - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_ksyms.c.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
	- Remove unused xfs_cap.h/xfs_mac.h header files.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
