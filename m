Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 00:40:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l557eVWt008006
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 00:40:34 -0700
Subject: TAKE 964465 - Transaction delta counts are not applied atomically
Message-Id: <20070605074026.B7F6358C38C1@chook.melbourne.sgi.com>
Date: Tue,  5 Jun 2007 17:40:26 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Apply transaction delta counts atomically to incore counters

With the per-cpu superblock counters, batch updates are no longer
atomic across the entire batch of changes. This is not an issue
if each individual change in teh batch is applied atomically.
Unfortunately, free block count changes are not applied atomically,
and they are applied in a manner guaranteed to cause problems.

Essentially, the free block count reservation that the transaction
took initially is returned to the in core counters before a second
delta takes away what is used. because these two operations are
not atomic, we can race with another thread that can use the
returned transaction reservation before the transaction takes
the space away again and we can then get ENOSPC being reported
in a spot where we don't have an ENOSPC condition, nor should
we ever see one there.

Fix it up by rolling the two deltas into the one so it can be
applied safely (i.e. atomically) to the incore counters.

Date:  Tue Jun  5 17:39:41 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28796a
fs/xfs/xfs_trans.c - 1.181 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.181&r2=text&tr2=1.180&f=h
	- Apply transaction deltas atomically by ensuring we only ever update
	  each counter once per transaction.
