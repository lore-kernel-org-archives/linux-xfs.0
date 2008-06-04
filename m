Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 17:59:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m540x6v1007375
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 17:59:07 -0700
Subject: TAKE 907752 - 
Message-Id: <20080604005954.0D43558C4C3F@chook.melbourne.sgi.com>
Date: Wed,  4 Jun 2008 10:59:53 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

074 takes ages to complete on my kvm test VM, but scaling it back to the
level used on IRIX makes it complete in slightly under 10 minutes.

I'm not sure if checking for UP vs SMP is the right way to go into slow
mode, but I couldn't think of anything better.


Signed-off-by: Christoph Hellwig <hch@lst.de>



Date:  Wed Jun  4 10:59:31 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/xaiki/isms/xfs-cmds
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31272a
xfstests/074 - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/074.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
