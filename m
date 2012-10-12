Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9C5iVmn072386 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 00:44:31 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TSJJez9qx8DspGwg for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 22:46:03 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TMY2x-0003Z8-HP
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:44:31 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TMY2x-00055Z-By
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:44:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/23] xfs: metadata verifiers V2
Date: Fri, 12 Oct 2012 16:44:06 +1100
Message-Id: <1350020669-19504-1-git-send-email-david@fromorbit.com>
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

Second version of the buffer verifier series. The initial read
verifier infrastructure patch set and overview is described here:

http://oss.sgi.com/archives/xfs/2012-10/msg00146.html

This version of the patch set introduces write verifiers and fixes
lots of bugs in the read verifiers.  The write verifiers also
pointed out a bug in the allocation btree block/freelist handling
where we are writing back freed buffers that are still on the AGF
freelist (and hence failing verification).

I haven't yet folded the recent review comments into the series - I
figured that I'd finish testing this version of the code before I
broke it again, so apart from bug fixes the read veridier part of
the series is identical to the original series.

Still to implement are:

- log recovery read/write verifiers
- uncached buffer write verifiers
- potentially separate some of the write verify patches; maybe the
  directory/attr modifications shoul dbein a separate patch as they
  are somewhat more complicated than just adding a callback to a
  buffer once it has been read/built.

These will be implemented for version 3 along with all the review
comments from the first version that have come in....

This version passes xfstests without regressions, works on 500TB
filesystems, complete various stress tests and benchmark runs, etc,
so is much more robust than the first version.

Cheers,

Dave.

--

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
