Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 May 2007 00:59:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4M7xaWt014097
	for <xfs@oss.sgi.com>; Tue, 22 May 2007 00:59:38 -0700
Subject: PARTIAL TAKE 964999 - lazy superblock counters for XFS
Message-Id: <20070522075932.E665058CA531@chook.melbourne.sgi.com>
Date: Tue, 22 May 2007 17:59:32 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Lazy Superblock Counters

When we have a couple of hundred transactions on the fly at once,
they all typically modify the on disk superblock in some way.
create/unclink/mkdir/rmdir modify inode counts, allocation/freeing
modify free block counts.

When these counts are modified in a transaction, the must eventually
lock the superblock buffer and apply the mods.  The buffer then
remains locked until the transaction is committed into the incore
log buffer. The result of this is that with enough transactions on
the fly the incore superblock buffer becomes a bottleneck.

The result of contention on the incore superblock buffer is that
transaction rates fall - the more pressure that is put on the
superblock buffer, the slower things go.

The key to removing the contention is to not require the superblock
fields in question to be locked. We do that by not marking the
superblock dirty in the transaction. IOWs, we modify the incore
superblock but do not modify the cached superblock buffer. In short,
we do not log superblock modifications to critical fields in the
superblock on every transaction. In fact we only do it just before
we write the superblock to disk every sync period or just before
unmount.

This creates an interesting problem - if we don't log or write out
the fields in every transaction, then how do the values get
recovered after a crash? the answer is simple - we keep enough
duplicate, logged information in other structures that we can
reconstruct the correct count  after log recovery has been
performed.

It is the AGF and AGI structures that contain the duplicate
information; after recovery, we walk every AGI and AGF and sum their
individual counters to get the correct value, and we do a
transaction into the log to correct them. An optimisation of this is
that if we have a clean unmount record, we know the value in the
superblock is correct, so we can avoid the summation walk under
normal conditions and so mount/recovery times do not change under
normal operation.

One wrinkle that was discovered during development was that the
blocks used in the freespace btrees are never accounted for in the
AGF counters. This was once a valid optimisation to make; when the
filesystem is full, the free space btrees are empty and consume no
space. Hence when it matters, the "accounting" is correct.  But that
means the when we do the AGF summations, we would not have a correct
count and xfs_check would complain.  Hence a new counter was added
to track the number of blocks used by the free space btrees. This is
an *on-disk format change*.

As a result of this, lazy superblock counters are a mkfs option
and at the moment on linux there is no way to convert an old
filesystem. This is possible - xfs_db can be used to twiddle the
right bits and then xfs_repair will do the format conversion
for you. Similarly, you can convert backwards as well. At some point
we'll add functionality to xfs_admin to do the bit twiddling
easily....

Date:  Tue May 22 17:58:49 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28652a
fs/xfs/xfsidbg.c - 1.314 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.314&r2=text&tr2=1.313&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_log.c - 1.332 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.332&r2=text&tr2=1.331&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_ialloc.h - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.h.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_ialloc.c - 1.194 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.194&r2=text&tr2=1.193&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_ag.h - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ag.h.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_sb.h - 1.68 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_sb.h.diff?r1=text&tr1=1.68&r2=text&tr2=1.67&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_fs.h - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fs.h.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_log_recover.c - 1.319 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.319&r2=text&tr2=1.318&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_vfsops.c - 1.520 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.520&r2=text&tr2=1.519&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_mount.h - 1.236 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.236&r2=text&tr2=1.235&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_mount.c - 1.395 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.395&r2=text&tr2=1.394&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_trans.c - 1.179 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.179&r2=text&tr2=1.178&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_trans.h - 1.145 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.145&r2=text&tr2=1.144&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_alloc.c - 1.186 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.186&r2=text&tr2=1.185&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_alloc.h - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.h.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_fsops.c - 1.124 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.124&r2=text&tr2=1.123&f=h
	- Changes to support lazy superblock counters.

fs/xfs/xfs_alloc_btree.c - 1.91 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.91&r2=text&tr2=1.90&f=h
	- Changes to support lazy superblock counters.

fs/xfs/linux-2.6/xfs_vfs.h - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
	- Changes to support lazy superblock counters.

fs/xfs/linux-2.6/xfs_super.c - 1.381 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.381&r2=text&tr2=1.380&f=h
	- Changes to support lazy superblock counters.

fs/xfs/linux-2.4/xfs_vfs.h - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_vfs.h.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
	- Changes to support lazy superblock counters.

fs/xfs/linux-2.4/xfs_super.c - 1.336 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_super.c.diff?r1=text&tr1=1.336&r2=text&tr2=1.335&f=h
	- Changes to support lazy superblock counters.
