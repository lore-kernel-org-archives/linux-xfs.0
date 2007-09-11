Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 21:40:36 -0700 (PDT)
Received: from redback.melbourne.sgi.com (redback.melbourne.sgi.com [134.14.55.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8B4eU4p016093
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2007 21:40:32 -0700
Date: Tue, 11 Sep 2007 14:43:14 +1000
From: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Message-Id: <200709110443.l8B4hEFF012233@redback.melbourne.sgi.com>
Subject: TAKE 970335 - clean up vnode/inode tracing
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

clean up vnode/inode tracing

Simplify vnode tracing calls by embedding function name & return addr
in the calling macro.

Also do a lot of vnode->inode renaming for consistency, while
we're at it.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Tue Sep 11 14:40:02 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-fixes
Inspected by:  Eric Sandeen <sandeen@sandeen.net>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29650a
fs/xfs/xfsidbg.c - 1.332 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.332&r2=text&tr2=1.331&f=h
	- clean up vnode/inode tracing

fs/xfs/xfs.h - 1.50 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs.h.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
	- clean up vnode/inode tracing

fs/xfs/xfs_vnodeops.c - 1.717 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.717&r2=text&tr2=1.716&f=h
	- clean up vnode/inode tracing

fs/xfs/xfs_iget.c - 1.233 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.233&r2=text&tr2=1.232&f=h
	- clean up vnode/inode tracing

fs/xfs/xfs_inode.c - 1.479 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.479&r2=text&tr2=1.478&f=h
	- clean up vnode/inode tracing

fs/xfs/xfs_inode.h - 1.233 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.233&r2=text&tr2=1.232&f=h
	- clean up vnode/inode tracing

fs/xfs/xfs_utils.c - 1.77 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.c.diff?r1=text&tr1=1.77&r2=text&tr2=1.76&f=h
	- clean up vnode/inode tracing

fs/xfs/xfs_utils.h - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.h.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
	- clean up vnode/inode tracing

fs/xfs/xfs_rename.c - 1.76 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.76&r2=text&tr2=1.75&f=h
	- clean up vnode/inode tracing

fs/xfs/xfs_dir2.c - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
	- clean up vnode/inode tracing

fs/xfs/linux-2.6/xfs_ioctl.c - 1.152 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.152&r2=text&tr2=1.151&f=h
	- clean up vnode/inode tracing

fs/xfs/linux-2.6/xfs_vnode.c - 1.151 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.151&r2=text&tr2=1.150&f=h
	- clean up vnode/inode tracing

fs/xfs/linux-2.6/xfs_vnode.h - 1.139 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.139&r2=text&tr2=1.138&f=h
	- clean up vnode/inode tracing

fs/xfs/linux-2.6/xfs_super.c - 1.396 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.396&r2=text&tr2=1.395&f=h
	- clean up vnode/inode tracing

fs/xfs/linux-2.6/xfs_aops.c - 1.152 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.152&r2=text&tr2=1.151&f=h
	- clean up vnode/inode tracing

fs/xfs/linux-2.6/xfs_ksyms.c - 1.71 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.71&r2=text&tr2=1.70&f=h
	- clean up vnode/inode tracing
