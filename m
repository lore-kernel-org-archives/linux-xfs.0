Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Sep 2008 19:09:58 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9129tAZ011855
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2008 19:09:55 -0700
Subject: TAKE 987683 - Check AGF agf_btreeblks when reading the AGF with lazy-counters
Message-Id: <20081001021131.5D40458C52B4@chook.melbourne.sgi.com>
Date: Wed,  1 Oct 2008 12:11:31 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Check agf_btreeblks is valid when reading in the AGF


Date:  Wed Oct  1 12:10:43 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32232a
fs/xfs/xfs_alloc.c - 1.203 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.203&r2=text&tr2=1.202&f=h
	- Check agf_btreeblks is valid when reading in the AGF
