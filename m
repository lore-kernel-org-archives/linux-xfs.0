Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Aug 2006 17:06:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7I05MDW025665
	for <linux-xfs@oss.sgi.com>; Thu, 17 Aug 2006 17:05:34 -0700
Subject: TAKE 955302 - misc cleanup
Message-Id: <20060818000436.2DEEA58C8A48@chook.melbourne.sgi.com>
Date: Fri, 18 Aug 2006 10:04:36 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Add a debug flag for allocations which are known to be larger than one page.

Date:  Fri Aug 18 09:41:40 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26800a
xfs_log.c - 1.326 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.326&r2=text&tr2=1.325&f=h
xfs_iget.c - 1.218 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.218&r2=text&tr2=1.217&f=h
support/ktrace.c - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/ktrace.c.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
quota/xfs_qm.c - 1.42 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.42&r2=text&tr2=1.41&f=h
linux-2.6/xfs_buf.c - 1.225 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.225&r2=text&tr2=1.224&f=h
linux-2.6/kmem.h - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/kmem.h.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
linux-2.4/xfs_buf.c - 1.217 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_buf.c.diff?r1=text&tr1=1.217&r2=text&tr2=1.216&f=h
linux-2.4/kmem.h - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/kmem.h.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
linux-2.4/kmem.c - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/kmem.c.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
linux-2.6/kmem.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/kmem.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h


Improve error handling for the zero-fsblock extent detection code.

Date:  Fri Aug 18 09:51:19 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  dgc,gwehrman,nb

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26802a
xfs_error.h - 1.45 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.h.diff?r1=text&tr1=1.45&r2=text&tr2=1.44&f=h
xfs_bmap.c - 1.357 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.357&r2=text&tr2=1.356&f=h
xfs_iomap.c - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
linux-2.6/xfs_globals.c - 1.69 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_globals.c.diff?r1=text&tr1=1.69&r2=text&tr2=1.68&f=h
linux-2.4/xfs_globals.c - 1.77 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_globals.c.diff?r1=text&tr1=1.77&r2=text&tr2=1.76&f=h


Add a greedy allocation interface, allocating within a min/max size range.

Date:  Fri Aug 18 09:53:31 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch,cw

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26803a
xfs_itable.c - 1.145 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.145&r2=text&tr2=1.144&f=h
xfs_iget.c - 1.219 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.219&r2=text&tr2=1.218&f=h
quota/xfs_qm.c - 1.43 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.43&r2=text&tr2=1.42&f=h
linux-2.6/kmem.h - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/kmem.h.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
linux-2.4/kmem.h - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/kmem.h.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
linux-2.4/kmem.c - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/kmem.c.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
linux-2.6/kmem.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/kmem.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h


Remove a no-longer-correct debug assert from dio completion handling.

Date:  Fri Aug 18 09:58:13 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  zach.brown@oracle.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26804a
linux-2.6/xfs_aops.c - 1.133 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.133&r2=text&tr2=1.132&f=h


Minor code rearranging and cleanup to prevent some coverity false positives.

Date:  Fri Aug 18 10:02:34 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  sandeen,jesper.juhl@gmail.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26805a
xfs_da_btree.c - 1.172 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.c.diff?r1=text&tr1=1.172&r2=text&tr2=1.171&f=h
xfs_rtalloc.c - 1.102 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rtalloc.c.diff?r1=text&tr1=1.102&r2=text&tr2=1.101&f=h
xfs_alloc.c - 1.184 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.184&r2=text&tr2=1.183&f=h
