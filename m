Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 20:46:59 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G3koWB005606
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 20:46:50 -0700
Subject: PARTIAL TAKE 987246 - remove exports of inline functions
Message-Id: <20081016034825.5B3841F08F3@chapter11.melbourne.sgi.com>
Date: Thu, 16 Oct 2008 14:48:25 +1100 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.mangrove@engr.sgi.com

Recent gcc starts to complain about exports of functions marked static
inline, so let's get rid of those.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Thu Oct 16 14:47:55 EST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/donaldd/isms/2.6.x-xfs
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32345a
fs/xfs/linux-2.6/xfs_ksyms.c - 1.93 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.93&r2=text&tr2=1.92&f=h
	- remove exports of inline functions
