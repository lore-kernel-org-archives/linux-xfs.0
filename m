Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 21:47:35 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A4lXZ5031794
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 21:47:33 -0700
Subject: PARTIAL TAKE 988146 - make xfsidbg independent of the main btree implementation.
Message-Id: <20081010044912.2E3A61F08E6@chapter11.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 15:49:12 +1100 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

make xfsidbg independent of the main btree implementation.

Add a small btree framework inside xfsidbg which makes it independent
of the main btree implementation and it's soon to be changing macros.
This will also allow xfsidbg to easily select the right btree type
depending on the magic number in the header.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Oct 10 15:47:30 EST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/donaldd/isms/2.6.x-xfs
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32289a
fs/xfs/xfsidbg.c - 1.368 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.368&r2=text&tr2=1.367&f=h
	- make xfsidbg independent of the main btree implementation.
