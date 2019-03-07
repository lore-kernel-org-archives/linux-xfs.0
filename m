Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbfCGRYZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Mar 2019 12:24:25 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 17ACE3092656
        for <linux-xfs@vger.kernel.org>; Thu,  7 Mar 2019 17:24:25 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB1D96090C
        for <linux-xfs@vger.kernel.org>; Thu,  7 Mar 2019 17:24:24 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFCv2 0/3] XFS near block allocation algorithm prototype
Date: Thu,  7 Mar 2019 12:24:21 -0500
Message-Id: <20190307172424.30316-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's an RFCv2 of the near block allocation algorithm rework. The
changes since the first rfc are primarily to clean out a bunch of
unnecessary refactoring, further improvements/cleanups to the code and
the addition of minlen support.

While I ran some basic performance tests against the initial version as
I was fleshing out the high level algorithm, this has mostly only seen
functional testing since then. Hence this is still RFC until I've had a
chance to do more thorough testing. The limited performance testing that
I have run consists of a simple single-writer fs_mark test against the
pre-fragmented metadump image provided by the user. A single threaded
fs_mark writes in the range of 30-100 files/sec (150k sized files) on a
baseline kernel and 550-800 files/sec with the updated allocator
algorithm. The latter range is about the same as the result for both
kernels against a newly created filesystem on the same system. More
testing is certainly required, but I'd like to solicit high level
design feedback before getting too far down the targeted testing path,
including any thoughts on specific performance tests that might be
worthwhile.

The background and motivation for this change is described in the patch
2 commit log as well as in the original thread referenced in the rfcv1
cover letter. The original idea was to replace the current allocator
with a single locality-enhanced cntbt lookup. This refines that idea to
something that combines the cntbt and bnobt searches in a manner that is
optimal for the size of the request (for example, a single fsb near
alloc is a trivial bnobt lookup) and repeats the cntbt lookup to provide
a bit more locality.

While this is written as new code, this is really based on the existing
allocation algorithm and rewritten in a way to facilitate reuse for the
other allocation modes. The longer term objective beyond improving worst
case near mode allocation behavior is to be able to reuse this code for
all of the near, exact and size allocation modes. The latter bits will
likely occur as follow on work.

Note that this series should technically only consist of two patches.
Patch 1 is a dependency fixup for the small allocation fallback. Patches
2 and 3 are artificially split into two to improve readability in patch
form. Patch 2 adds the new mechanism and patch 3 changes the near
allocation path to use it. Thoughts, reviews, flames appreciated.

Brian

rfcv2:
- Dropped spurious initial refactoring.
- Added minlen functionality.
- Properly tied into near alloc path.
- General refactoring and cleanups.
rfcv1: https://marc.info/?l=linux-xfs&m=154479089914351&w=2

Brian Foster (3):
  xfs: refactor small allocation helper to skip cntbt attempt
  xfs: introduce generic extent allocation infrastructure
  xfs: use generic extent alloc mechanism for near mode allocs

 fs/xfs/libxfs/xfs_alloc.c | 928 +++++++++++++++++++-------------------
 fs/xfs/xfs_trace.h        |  26 +-
 2 files changed, 493 insertions(+), 461 deletions(-)

-- 
2.17.2
