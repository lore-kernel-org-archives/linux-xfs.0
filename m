Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A70947CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 23:02:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E494830405F
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 21:02:05 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id sy1Ml978ZFOZaui9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 21:02:01 -0700 (PDT)
Subject: [RFC DONOTMERGE v8 0/3] fallocate for block devices
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 12 Apr 2016 21:01:21 -0700
Message-ID: <20160413040121.10562.98998.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: darrick.wong@oracle.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org

Hi,

This is a redesign of the patch series that fixes various interface
problems with the existing "zero out this part of a block device"
code.  BLKZEROOUT2 is gone.

The first patch is still a fix to the existing BLKZEROOUT ioctl to
invalidate the page cache if the zeroing command to the underlying
device succeeds.

The second patch changes the internal block device functions to reject
attempts to discard or zeroout that are not aligned to the logical
block size.  Previously, we only checked that the start/len parameters
were 512-byte aligned, which caused kernel BUG_ONs for unaligned IOs
to 4k-LBA devices.

The third patch creates an fallocate handler for block devices, wires
up the FALLOC_FL_PUNCH_HOLE flag to zeroing-discard, and connects
FALLOC_FL_ZERO_RANGE to write-same so that we can have a consistent
fallocate interface between files and block devices.  It also allows
the combination of PUNCH_HOLE and NO_HIDE_STALE to invoke non-zeroing
discard.

The point of this patchset is not to go upstream, but is to be a
starting point for a discussion at LSF.  Don't merge this!  Foremost
in my mind is whether or not we require the offset/len parameters to
be aligned to logical block size or minimum_io_size; what error code
to return for unaligned values; and whether or not we should allow
byte ranges and zero blocks with the page cache (like file fallocate
does now).  It'll also be a jumping off point for Brian Foster and
Mike Snitzer's patches to allow bdev clients to ask that space be
allocated to a range, and to plumb that out to userspace.

Test cases for the new block device fallocate have been submitted to
the xfstests list as generic/70[5-7], though the latest versions of
those test cases will be attached to this patchset for convenience.

Comments and questions are, as always, welcome.  Patches are against
4.6-rc3.

v7: Strengthen parameter checking and fix various code issues pointed
out by Linus and Christoph.
v8: More code rearranging, rebase to 4.6-rc3, and dig into alignment
issues.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
