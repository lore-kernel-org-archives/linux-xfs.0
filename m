Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 21:34:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8D4YJ4p030868
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 21:34:23 -0700
From: donaldd@sgi.com
Subject: TAKE 970240 - kill BMAPI_DEVICE
Message-Id: <20070913043416.CCFAC2F9EBDB@linuxbuild.melbourne.sgi.com>
Date: Thu, 13 Sep 2007 14:34:16 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

kill BMAPI_DEVICE

There is no reason to go into the iomap machinery just to get the
right block device for an inode.  Instead look at the realtime flag
in the inode and grab the right device from the mount structure.

I created a new helper, xfs_find_bdev_for_inode instead of opencoding
it because I plan to use it in other places in the future.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Sep 13 14:33:42 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29680a
fs/xfs/xfs_iomap.h - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
	- kill BMAPI_DEVICE

fs/xfs/xfs_iomap.c - 1.55 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.55&r2=text&tr2=1.54&f=h
	- kill BMAPI_DEVICE

fs/xfs/linux-2.6/xfs_aops.c - 1.154 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.154&r2=text&tr2=1.153&f=h
	- kill BMAPI_DEVICE
