Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Nov 2007 21:32:09 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA55Vwg1009794
	for <xfs@oss.sgi.com>; Sun, 4 Nov 2007 21:32:02 -0800
Subject: PARTITAL TAKE 971186 - optimize XFS_IS_REALTIME_INODE w/o realtime config
Message-Id: <20071105053157.9887158C38F7@chook.melbourne.sgi.com>
Date: Mon,  5 Nov 2007 16:31:57 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

optimize XFS_IS_REALTIME_INODE w/o realtime config

Use XFS_IS_REALTIME_INODE in more places, and #define it to
0 if CONFIG_XFS_RT is off.  This should be safe because mount
checks in xfs_rtmount_init:

# define xfs_rtmount_init(m)    (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))

so if we get mounted w/o CONFIG_XFS_RT, no realtime inodes should
be encountered after that.

Defining XFS_IS_REALTIME_INODE to 0 saves a bit of stack space,
presumeably gcc can optimize around the various "if (0)" type
checks:

xfs_alloc_file_space    -8
xfs_bmap_adjacent       -16
xfs_bmapi               -8
xfs_bmap_rtalloc        -16
xfs_bunmapi             -28
xfs_free_file_space     -64
xfs_imap                +8  <-- ?  hmm.
xfs_iomap_write_direct  -12
xfs_qm_dqusage_adjust   -4
xfs_qm_vop_chown_reserve -4

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Mon Nov  5 16:31:21 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30014a
fs/xfs/xfs_rw.h - 1.86 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rw.h.diff?r1=text&tr1=1.86&r2=text&tr2=1.85&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fs/xfs/xfs_vnodeops.c - 1.725 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.725&r2=text&tr2=1.724&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fs/xfs/xfs_rtalloc.h - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rtalloc.h.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fs/xfs/xfs_dfrag.c - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fs/xfs/xfs_bmap_btree.c - 1.167 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.167&r2=text&tr2=1.166&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fs/xfs/xfs_inode.c - 1.486 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.486&r2=text&tr2=1.485&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fs/xfs/xfs_bmap.c - 1.381 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.381&r2=text&tr2=1.380&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fs/xfs/xfs_dinode.h - 1.83 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dinode.h.diff?r1=text&tr1=1.83&r2=text&tr2=1.82&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fs/xfs/xfs_iomap.c - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fs/xfs/linux-2.6/xfs_lrw.c - 1.271 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.271&r2=text&tr2=1.270&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fs/xfs/linux-2.6/xfs_ioctl.c - 1.158 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.158&r2=text&tr2=1.157&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fs/xfs/linux-2.6/xfs_iops.c - 1.269 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.269&r2=text&tr2=1.268&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fs/xfs/linux-2.6/xfs_aops.c - 1.158 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.158&r2=text&tr2=1.157&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fs/xfs/dmapi/xfs_dm.c - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
	- Use XFS_IS_REALTIME_INODE() rather than open coding the check.
