Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1714A7F58
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 00:09:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A348AC001
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 22:09:39 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	KFhsiygTpf8QbGBn for <xfs@oss.sgi.com>;
	Wed, 20 Aug 2014 22:09:37 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfs: direct IO invalidation and related fixes
Date: Thu, 21 Aug 2014 15:09:08 +1000
Message-Id: <1408597754-13526-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: clm@fb.com

Hi folks,

This patch set started when I was testing Chris Mason's direct IO
read invalidation fix (patch 2 of the series). I hit a problem
testing it on a 1k block size filesystem, and that opened a can of
bugs. Luckily, the can of bugs fell into the fire, and so the bug
hunt wasn't long and drawn out.

In the end, the class of bugs that was uncovered is prevented from
occurring by the first patch (hmmm, not sure the title is accurate
anymore) which then means it is safe to fix the invalidation bugs
in the direct Io code (Chris fixed read, I fixed write). With these
issues fixed, we can trim the range of invalidation to just that of
the direct IO in progress and that finally works without causing
random regressions.

This then left fsx tripping over issues with collapse range calls
that Brian had already found the cause of, so this series adds his
patch to change the inode logging and my temporary workaround of
flushing the entire file before running the collapse range
operation.

With these 6 patches, the troublesome fsx configuration from
generic/263 goes from assert failing on the 1192nd operation to
running for over 60 million operations before tripping over another
collapse range issue. This was repeated on multiple test machines,
with a ramdisk based test getting 61,350,000 million ops, a 2p VM
getting 63,700,000 ops and a 1p VM getting 65,450,000 million ops
before failing.

The series does result in generic/247 now occasionally tripping an
invalidation failure, but this is intentionally causing direct Io
writes and mmap writes to race and so this is an expected failure
when the code is working correctly. i.e. page faults cannot be
synchronised against any other IO operation.

Hence I think this patch series fixes the root cause of another long
standing bufferhead coherency issue that we'd otherwise covered up.
Please test and review - I want to send this patchset to Linux for
3.17-rc3 if possible...

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
