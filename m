Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 21:45:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8D4jX4p001045
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 21:45:35 -0700
From: donaldd@sgi.com
Subject: TAKE 970241 - kill BMAPI_UNWRITTEN 
Message-Id: <20070913044530.8021B219E49F@linuxbuild.melbourne.sgi.com>
Date: Thu, 13 Sep 2007 14:45:30 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

kill BMAPI_UNWRITTEN

There is no reason to go through xfs_iomap for the BMAPI_UNWRITTEN
because it has nothing in common with the other cases.  Instead
check for the shutdown filesystem in xfs_end_bio_unwritten and perform
a direct call to xfs_iomap_write_unwritten (which should be renamed
to something more sensible one day)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Sep 13 14:44:43 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29681a
fs/xfs/xfs_iomap.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- kill BMAPI_UNWRITTEN

fs/xfs/xfs_iomap.c - 1.56 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.56&r2=text&tr2=1.55&f=h
	- kill BMAPI_UNWRITTEN

fs/xfs/linux-2.6/xfs_aops.c - 1.155 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.155&r2=text&tr2=1.154&f=h
	- kill BMAPI_UNWRITTEN
