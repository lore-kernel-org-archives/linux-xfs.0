Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9P6WkV5102327 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 01:32:46 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0vdFbgM0JbB7Qpoc for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 23:34:31 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TRH1F-00009b-W8
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:18 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TRH1F-00053M-Rj
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/25, V3] xfs: metadata buffer verifiers
Date: Thu, 25 Oct 2012 17:33:49 +1100
Message-Id: <1351146854-19343-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

Third version of the buffer verifier series. The read verifier
infrastructure is described here:

http://oss.sgi.com/archives/xfs/2012-10/msg00146.html

This version converts to a buffer operations structure rather than
specific write/iodone callback installations and adds log recovery
write verifiers. There are also several bugs fixed and review
comments address.

This series is essentially now functionally complete, so there is
nothing really left to add to this except for addressing review
comments and bug fixing. Comments welcome. ;)

FYI, I do have more changes lined up for the 3.8 window, but I will
be posting them as separate patches on top of this series and not as
part of it.

Cheers,

Dave.

--

Changes in version 3:
- update agfl verfier commit to mention debug checks are being done
  unconditionally now.
- fixed agfl verifier null point crash when invalid block numbers
  are found
- ifdef'd out agfl verifier checks as they are not reliable because
  mkfs does not initialise the full AGFL to known values.
- fixed quiet mount flag handling for superblock verification.
- directorry -> directory
- convert to struct buf_ops method of attaching verifiers to the
  buffer. This provides a much cleaner abstraction and simpler
  future expansion of operations on the buffer. It removes a great
  deal of code that is repeated through all the verifiers, too, by
  separating them from buffer IO completion processing.
- add initial support for log write verifiers

  Log write verifiers are, in general, identical to the existing
  verifiers. There are only a small number of modifications
  necessary, mainly due to log recovery occurring before certain
  in-memory structures are initialised (e.g. the struct xfs_perag).
  Write verifiers that need different checks during recovery do so
  via detection of the XLOG_ACTIVE_RECOVERY flag on the log.

  Log recovery does not do read verification of the buffers at this
  point in time, mainly due to the fact we don't know what the
  contents of the buffer is before we read it - the buffer logging
  is generic and content unaware. However, almost all metadata has
  magic numbers in it, so after the changes have been replayed into
  the buffer we can snoop the magic number out of the buffer and
  attach the appropriate verifier before it is written back. Hence
  we should catch gross corruptions introduced by recovery errors.

Changes in Version 2:

- fixed use of xfs_dir2_db_t instead of xfs_dablk_t in directory and
  attr read functions (found when testing xfstests --large-fs on a
  500TB fs and attribute block numbers went beyond 32 bits). This
  mistake was copy-n-pasted several times.
- fixed use of "int map_type" instead of "xfs_daddr_t mappedbno" in
  directory and attr read functions.
- fixed incorrect logic in xfs_dir2_block_verify where a failed
  block check would not clear the block_ok flag correctly
- invalidate allocbt->freelist buffers so they don't get written
  after being freed and while still on the freelist
- added initial suppor for write verifiers.

  Write verifiers are similar to read verifiers, the are simply
  called just prior to issuing the IO on the buffer. The buffer is
  locked at this point, so we are guaranteed an unchanging buffer
  to work from.

  The initial write verifiers are simply the same as the read
  verifiers, except they don't have the ioend processing in them. A
  failure of the write verifier will cause the filesystem to shut
  down as writing invalid metadata to disk is a bad thing. The write
  verifier for the alloc btree blocks was what discovered the
  writing of freed allocbt blocks to disk from the free list.

  Eventually, the metadata CRC will be calculated in the write
  verifier after validating that the buffer contents are valid.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
