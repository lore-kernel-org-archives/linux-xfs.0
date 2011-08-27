Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7R83NNL185952 for <xfs@oss.sgi.com>; Sat, 27 Aug 2011 03:03:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 464271939190
	for <xfs@oss.sgi.com>; Sat, 27 Aug 2011 01:03:21 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	rYdhDQDIVWC3Cdaa for <xfs@oss.sgi.com>;
	Sat, 27 Aug 2011 01:03:21 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QxDrN-0005Gk-Fb
	for xfs@oss.sgi.com; Sat, 27 Aug 2011 08:03:21 +0000
Date: Sat, 27 Aug 2011 04:03:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS metadata flushing design - current and future
Message-ID: <20110827080321.GA16661@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Here is a little writeup I did about how we handle dirty metadata
flushing in XFS currently, and how we can improve on it in the
relatively short term:


---
Metadata flushing in XFS
========================

This document describes the state of the handling of dirty XFS in-core
metadata, and how it gets flushed to disk, as well as ideas how to
simplify it in the future.


Buffers
-------

All metadata is XFS is read and written using buffers as the lowest layer.
There are two ways to write a buffer back to disk: delwri and sync.
Delwri means the buffers gets added to a delayed write list, which a
background thread writes back periodically or when forced to.  Synchronous
writes means the buffer is written back immediately, and the callers waits
for completion synchronously.

Logging and the Active Item List (AIL)
--------------------------------------

The prime method of metadata writeback in XFS is by logging the changes
into the transaction log, and writing back the changes to the original
location in the background.  The prime data structure to drive the
asynchronous write back is the Active Item List or AIL.  The AIL contains
a list of all changes in the log that need to be written back, ordered
by on the time they were committed to the log using the Log Sequence
Number (LSN).  The AIL is periodically pushed out to try to move the
log tail LSN forward.  In addition periodically the sync worker attempts
to push out all items in the AIL.

Non-transaction metadata updates
--------------------------------

XFS still has a few updates where update metadata non-transactional.

The prime cause for non-transaction metadata updates are timestamps in the
inode, and inode size updates from extending writes.  These are handled
by marking the inode dirty in the VFS and XFS inodes, and either relying
on transactional updates to piggy-back these updates, or on the VFS
periodic writeback thread to call into the ->write_inode method in
XFS to write these changes back.  ->write_inode either starts delwri
buffer writeback on the inode, or starts a new transaction to log
the inode core containing these changes.

The dquot structures may be scheduled for delwri writeback after a
quota check during an unclean mount.

Extended attribute payloads that are stored outside the main attribute
btree are written back synchronously using buffers.

New allocation group headers written during a filesystem resizing are
written synchronously using buffers.

The superblock is written synchronously using buffers during umount
and sync operations.

Log recovery writes back various pieces of metadata synchronously
or using delwri buffers.


Other flushing methods
----------------------

For historical reasons we still have a few places that flush XFS metadata
using others methods than logging and the AIL or explicit synchronous
or delwri writes.

Filesystem freezing loops over all inodes in the system to flush out
inodes marked dirty directly using xfs_iflush.

The quotacheck code marks dquots dirty, just to flush them at the end of
the quotacheck operation.

The periodic and explicit sync code walks through all dqouts and writes
back all dirty dquots directly.


Future directions
-----------------

We should get rid of both the reliance of the VFS writeback tracking, and
XFS-internal non-AIL metadata flushing.

To get rid of the VFS writeback we'll just need to log all time stamps and size
updates explicitly when they happens.  This could be done today, but the
overhead for frequent transactions in that area is deemed to high, especially
with delayed logging enabled.  We plan to deprecate the non-delaylog mode
by Linux 3.3, and introduce a new fast-path for inode core updates that
will allow to use direct logging for this updates without introducing
large overhead.

The explicit inode flushing using xfs_sync_attr looks like an attempt to
make sure we do not have any inodes in the AIL when freezing a filesystem.
A better replacement would be a call into the AIL code that allows to
completely empty the AIL before a freeze.

The explicit quota flushing needs a bit more work.  First quota check needs
to be converted to queue up inodes to the delwri list immediately when
updating the dquot for each inode.  Second the code in xfs_qm_scall_setqlim
that attached a dquot to the transaction, but marks it dirty manually instead
of through the transaction interface needs a detailed audit.  After this
we should be able to get rid of all explicit xfs_qm_sync calls.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
