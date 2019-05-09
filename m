Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbfEIRIQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 May 2019 13:08:16 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC87281F12
        for <linux-xfs@vger.kernel.org>; Thu,  9 May 2019 16:58:39 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98BF61001E69
        for <linux-xfs@vger.kernel.org>; Thu,  9 May 2019 16:58:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/6] xfs: rework extent allocation
Date: Thu,  9 May 2019 12:58:33 -0400
Message-Id: <20190509165839.44329-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is a first (non-rfc) pass at the XFS extent allocation rework. This
series aims to 1.) improve the near mode allocation algorithm to have
better breakdown characteristics by taking advantage of locality
optimized cntbt lookups instead of relying so heavily on bnobt scans and
2.) refactor the remaining allocation modes to reuse similar code and
reduce duplication.

Patches 1 and 2 are cleanups to the small allocation mode fallback
function.  Patch 3 reworks the near mode allocation algorithm as noted
above and introduces reusable infrastructure. Patches 4 and 5 rework the
exact and by-size allocation modes respectively. Patch 6 removes the
unused bits of the small allocation mode and refactors the remaining
code into an AGFL allocation helper.

With regard to regression testing, this series survives multiple fstests
runs with various geometries, such as defaults, abnormally high AG
counts, and nonstandard block sizes. This also survives several days of
iterative, concurrent stress loads of fsstress, fs_mark and growfiles
(xfstests/ltp/growfiles.c) to repeatedly run a filesystem out of space
without any explosions.

With regard to performance, I have a user provided metadump image with
heavy free space fragmentation that demonstrates pathological allocation
behavior. An fs_mark test against this filesystem image shows an
improvement from 30-100 files/second to 600-800 f/s. On newly created
filesystems, I ran a filebench workload of 16 file creator threads
creating a mix of small (4k-1mb), medium (10mb-100mb) and larger
(500mb-1g) files and issuing fsyncs which shows comparable performance
and post-test free space properties with and without the patchset.
Finally, I've also run some ad hoc tests with fs_mark and fio (fallocate
and aio engines doing random writes) and observe no notable regressions
with these patches.

I may continue to experiment with filebench but so far I've not seen
anything that shows significant regressions. Let me know if anybody
would like to see test output or configuration details or whatnot from
any of that, or would like me to run any additional tests, etc.

Thoughts, reviews, flames appreciated.

Brian

v1:
- Continued development (various fixes, refinements) on generic bits and
  near mode implementation.
- Added patches 4-6 to refactor exact, by-size and small allocation
  modes.
rfcv2: https://marc.info/?l=linux-xfs&m=155197946630582&w=2
- Dropped spurious initial refactoring.
- Added minlen functionality.
- Properly tied into near alloc path.
- General refactoring and cleanups.
rfcv1: https://marc.info/?l=linux-xfs&m=154479089914351&w=2

Brian Foster (6):
  xfs: refactor small allocation helper to skip cntbt attempt
  xfs: always update params on small allocation
  xfs: use locality optimized cntbt lookups for near mode allocations
  xfs: refactor exact extent allocation mode
  xfs: refactor by-size extent allocation mode
  xfs: replace small allocation logic with agfl only logic

 fs/xfs/libxfs/xfs_alloc.c | 1375 +++++++++++++++----------------------
 fs/xfs/xfs_trace.h        |   38 +-
 2 files changed, 595 insertions(+), 818 deletions(-)

-- 
2.17.2
