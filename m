Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Aug 2008 00:06:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7I76GIi004896
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2008 00:06:17 -0700
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA24375 for <xfs@oss.sgi.com>; Mon, 18 Aug 2008 17:07:36 +1000
Subject: TAKE xfsidbg.c
Message-Id: <20080818070736.933C258C52A8@chook.melbourne.sgi.com>
Date: Mon, 18 Aug 2008 17:07:36 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

attr_list_context.count is a ssize_t adn thus we need to use %zd, not
%ld to print it.
Note: non mainline file - only in xfs-dev.
Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Aug 18 17:06:56 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31917a
fs/xfs/xfsidbg.c - 1.362 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.362&r2=text&tr2=1.361&f=h
	- attr_list_context.count is a ssize_t adn thus we need to use %zd, not
	  %ld to print it.
