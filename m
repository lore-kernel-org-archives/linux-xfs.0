Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Nov 2006 21:17:26 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB15HEaG013072
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 21:17:16 -0800
Subject: TAKE 958736 - fix up xfsidbg.c for removal of old items
Message-Id: <20061201051619.7864858FF58C@chook.melbourne.sgi.com>
Date: Fri,  1 Dec 2006 16:16:19 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Oops, I lost my kdb in my .config and so didn't build xfsidbg.c
So now need to fix up the corresponding log item changes for xfsidbg.c.


Date:  Fri Dec  1 16:15:37 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs
Inspected by:  vapo@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27602a
fs/xfs/xfsidbg.c - 1.309 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.309&r2=text&tr2=1.308&f=h
	- Fix up old uses of log items for pv#958736.
	  Also abstract out the item string lookup table.
	  And add in a missing item string (quotaoff) while we are there.
