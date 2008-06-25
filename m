Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 17:45:37 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5P0jZks023834
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 17:45:36 -0700
Received: from larry.melbourne.sgi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 03093181D0F0
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 17:46:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130]) by cuda.sgi.com with SMTP id C7GWoKRmBortJt9b for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 17:46:34 -0700 (PDT)
Subject: TAKE 983508 - attrmulti cleanup
Message-Id: <20080625004628.D88AB58C4C3F@chook.melbourne.sgi.com>
Date: Wed, 25 Jun 2008 10:46:28 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

xfs_attrmulti_by_handle currently request the size based on
sizeof(attr_multiop_t) but should be using sizeof(xfs_attr_multiop_t)
because that is what it is dealing with.  Despite beeing wrong this
actually harmless in practice because both structures are the same size
on all platforms.

But this sizeof was the only user of struct attr_multiop so we can just
kill it.  Also move the ATTR_OP_* defines xfs_attr.h into the
struct xfs_attr_multiop defintion in xfs_fs.h because they are only used
with that structure, and are part of the user ABI for the
XFS_IOC_ATTRMULTI_BY_HANDLE ioctl.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Wed Jun 25 10:45:34 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31352a
fs/xfs/xfs_fs.h - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fs.h.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
	- attrmulti cleanup

fs/xfs/xfs_attr.h - 1.44 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.h.diff?r1=text&tr1=1.44&r2=text&tr2=1.43&f=h
	- attrmulti cleanup

fs/xfs/linux-2.6/xfs_ioctl.c - 1.167 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.167&r2=text&tr2=1.166&f=h
	- attrmulti cleanup
