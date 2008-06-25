Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 17:17:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5P0Hcbv021296
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 17:17:38 -0700
Received: from larry.melbourne.sgi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id ACF0B275912
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 17:18:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130]) by cuda.sgi.com with SMTP id LvsxDrTfEesHvOTR for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 17:18:36 -0700 (PDT)
Subject: TAKE 983677 - check for invalid flags in xfs_attrlist_by_handle
Message-Id: <20080625001829.B60BD58C4C3F@chook.melbourne.sgi.com>
Date: Wed, 25 Jun 2008 10:18:29 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Check for invalid flags in xfs_attrlist_by_handle.

xfs_attrlist_by_handle should only take the ATTR_ flags for the root
namespaces.  The ATTR_KERN* flags may change at anytime and expect special
preconditions that can't be guaranteed for userspace-originating
requests.  For example passing down ATTR_KERNNOVAL through
xfs_attrlist_by_handle will hit an assert in debug builds currently.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Jun 25 10:17:00 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31351a
fs/xfs/linux-2.6/xfs_ioctl.c - 1.166 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.166&r2=text&tr2=1.165&f=h
	- check for invalid flags in xfs_attrlist_by_handle
