Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Sep 2007 17:53:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8S0rGRi009166
	for <xfs@oss.sgi.com>; Thu, 27 Sep 2007 17:53:18 -0700
Message-ID: <46FC50DF.2050907@sgi.com>
Date: Fri, 28 Sep 2007 10:54:55 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 971182 - [PATCH] kill xfs_dm_fsops.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs mailing list <xfs@oss.sgi.com>

kill xfs_dm_fsops.c

No point having a separate file for these few methods, especially if
we want to merge the crufty ops vector into the dmapiops one day.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Sep 28 10:51:03 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-patch-reviews
Inspected by:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29798a
fs/xfs/dmapi/Makefile - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/Makefile.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
    - pv 971182, author hch@lst.de, rv vapo - kill xfs_dm_fsops.c

fs/xfs/dmapi/xfs_dm_fsops.c - 1.14 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm_fsops.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
    - pv 971182, author hch@lst.de, rv vapo - kill xfs_dm_fsops.c

fs/xfs/dmapi/xfs_dm.h - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
    - pv 971182, author hch@lst.de, rv vapo - kill xfs_dm_fsops.c

fs/xfs/dmapi/xfs_dm.c - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
    - pv 971182, author hch@lst.de, rv vapo - kill xfs_dm_fsops.c
