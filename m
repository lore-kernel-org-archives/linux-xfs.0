Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 21:34:11 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M5Xfqm016964
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 21:33:46 -0800
Subject: TAKE 977546 - Use power-of-2 sized ktrace buffers to reduce overhead
Message-Id: <20080222053402.12ACC58C4C0F@chook.melbourne.sgi.com>
Date: Fri, 22 Feb 2008 16:34:01 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Use power-of-2 sized buffers to reduce overhead

Now that the ktrace_enter() code is using atomics,
the non-power-of-2 buffer sizes - which require modulus
operations to get the index - are showing up as using
substantial CPU in the profiles.

Force the buffer sizes to be rounded up to the nearest
power of two and use masking rather than modulus operations
to convert the index counter to the buffer index. This
reduces ktrace_enter overhead to 8% of a CPU time, and
again almost halves the trace intensive test runtime.


Date:  Fri Feb 22 16:33:15 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com, hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30538a
fs/xfs/support/ktrace.c - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/ktrace.c.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
	- Use power-of-2 buffer sizes so we can use more efficient
	  masking operations to get the buffer index.

fs/xfs/support/ktrace.h - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/ktrace.h.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- Use power-of-2 buffer sizes so we can use more efficient
	  masking operations to get the buffer index.
