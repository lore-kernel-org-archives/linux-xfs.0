Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C15C6379F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjARWp2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjARWpR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:17 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD16863E39
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:15 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so3156247pjq.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=++Cg3sGO8a2SDx6tdjz79G2MdDaeXXLkWhyYGYUl/Cc=;
        b=mMcH4sgWkfrqg73IJgiDAp907C2fbleDqrMuwz9dk6uQOc0RQ6JQCrQMXV2aGBNtgH
         rMkk1VEZWcFUHExzBmiZ0agETsMjnd8uEVFNpuW3flEDdAEJRiu/rnwR3ZCAI00ueEKx
         cnGIIJtIB14xsFfTufoQgOfZFgK74wv8IQ5UwjFRubgs5KybTz6faEgWTkdPopbdPkuo
         jmilmiaoqtHrpDTatIaRVbDkDHx8z9z6F6QlsD0fVIweF3prWaElSxTgD17c/hDuKJ5+
         7PywVmeI8YjPar33141ViRTdMkAbQEDstdR1IiH2jiP/IoNPGcc+Z6gOmfucTpnZeF1R
         kn2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++Cg3sGO8a2SDx6tdjz79G2MdDaeXXLkWhyYGYUl/Cc=;
        b=gaALgrwWJYRcjf/qbpO7OrHwYFenaztLi84dRk3joVbpzL1ygMKpb6UxkvbcPy2mXZ
         oDf0Na9/O+7RU8Gv9OmiqDouI8XBmnHEUL1/LOQKDNyJmufBYciz5tKmcOAPblT3ZIpe
         iF/9BzbdD0hmPuVzACy5NT5Hl9TGV5IPpMVbCB+J70dnU3MxRmawHZlSYg4h6mAnfs/y
         8XVmKgvvXNkT1xxSusE0U034y0XCIItxfFqkdCTB/y5DsTxA5xnZJiH/UEcl2fv9W5gI
         IYiDRbYEJKRBoReZQHpmeUqQn3trfb3hjHv3u5NEdeZO47zoJvZRItUwcrBZ3vix7w4p
         dBJA==
X-Gm-Message-State: AFqh2kqSabksae0+rB1Q9+3qha/KVemKjSh+isiZ6TGzy0rkTxS7Infy
        ZNwjZCGBhEbVQY1oTBA24EaKa1nfkTz8xavF
X-Google-Smtp-Source: AMrXdXvAohfKaZQsVMShyHQXHl1MF7TfY/lUtY6MelY5FceVRmHqdmi4CkMK2NAASN5orsw6EKAwsA==
X-Received: by 2002:a17:902:ccce:b0:194:91eb:5b84 with SMTP id z14-20020a170902ccce00b0019491eb5b84mr10534113ple.22.1674081915166;
        Wed, 18 Jan 2023 14:45:15 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090311c600b00186985198a4sm23742290plh.169.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB8-004iWc-Pz
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:10 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB8-008FCY-2V
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/42] xfs: per-ag centric allocation alogrithms
Date:   Thu, 19 Jan 2023 09:44:23 +1100
Message-Id: <20230118224505.1964941-1-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This series continues the work towards making shrinking a filesystem
possible.  We need to be able to stop operations from taking place
on AGs that need to be removed by a shrink, so before shrink can be
implemented we need to have the infrastructure in place to prevent
incursion into AGs that are going to be, or are in the process, of
being removed from active duty.

The focus of this is making operations that depend on access to AGs
use the perag to access and pin the AG in active use, thereby
creating a barrier we can use to delay shrink until all active uses
of an AG have been drained and new uses are prevented.

This series starts by fixing some existing issues that are exposed
by changes later in the series. They stand alone, so can be picked
up independently of the rest of this patchset.

The most complex of these fixes is cleaning up the mess that is the
AGF deadlock avoidance algorithm. This algorithm stores the first
block that is allocated in a transaction in tp->t_firstblock, then
uses this to try to limit future allocations within the transaction
to AGs at or higher than the filesystem block stored in
tp->t_firstblock. This depends on one of the initial bug fixes in
the series to move the deadlock avoidance checks to
xfs_alloc_vextent(), and then builds on it to relax the constraints
of the avoidance algorithm to only be active when a deadlock is
possible.

We also update the algorithm to record allocations from higher AGs
that are allocated from, because we when we need to lock more than
two AGs we still have to ensure lock order is correct. Therefore we
can't lock AGs in the order 1, 3, 2, even though tp->t_firstblock
indicates that we've allocated from AG 1 and so AG is valid to lock.
It's not valid, because we already hold AG 3 locked, and so
tp->t-first_block should actually point at AG 3, not AG 1 in this
situation.

It should now be obvious that the deadlock avoidance algorithm
should record AGs, not filesystem blocks. So the series then changes
the transaction to store the highest AG we've allocated in rather
than a filesystem block we allocated.  This makes it obvious what
the constraints are, and trivial to update as we lock and allocate
from various AGs.

With all the bug fixes out of the way, the series then starts
converting the code to use active references. Active reference
counts are used by high level code that needs to prevent the AG from
being taken out from under it by a shrink operation. The high level
code needs to be able to handle not getting an active reference
gracefully, and the shrink code will need to wait for active
references to drain before continuing.

Active references are implemented just as reference counts right now
- an active reference is taken at perag init during mount, and all
other active references are dependent on the active reference count
being greater than zero. This gives us an initial method of stopping
new active references without needing other infrastructure; just
drop the reference taken at filesystem mount time and when the
refcount then falls to zero no new references can be taken.

In future, this will need to take into account AG control state
(e.g. offline, no alloc, etc) as well as the reference count, but
right now we can implement a basic barrier for shrink with just
reference count manipulations. As such, patches to convert the perag
state to atomic opstate fields similar to the xfs_mount and xlog
opstate fields follow the initial active perag reference counting
patches.

The first target for active reference conversion is the
for_each_perag*() iterators. This captures a lot of high level code
that should skip offline AGs, and introduces the ability to
differentiate between a lookup that didn't have an online AG and the
end of the AG iteration range.

From there, the inode allocation AG selection is converted to active
references, and the perag is driven deeper into the inode allocation
and btree code to replace the xfs_mount. Most of the inode
allocation code operates on a single AG once it is selected, hence
it should pass the perag as the primary referenced object around for
allocation, not the xfs_mount. There is a bit of churn here, but it
emphasises that inode allocation is inherently an allocation group
based operation.

Next the bmap/alloc interface undergoes a major untangling,
reworking xfs_bmap_btalloc() into separate allocation operations for
different contexts and failure handling behaviours. This then allows
us to completely remove the xfs_alloc_vextent() layer via
restructuring the xfs_alloc_vextent/xfs_alloc_ag_vextent() into a
set of realtively simple helper function that describe the
allocation that they are doing. e.g.  xfs_alloc_vextent_exact_bno().

This allows the requirements for accessing AGs to be allocation
context dependent. The allocations that require operation on a
single AG generally can't tolerate failure after the allocation
method and AG has been decided on, and hence the caller needs to
manage the active references to ensure the allocation does not race
with shrink removing the selected AG for the duration of the
operation that requires access to that allocation group.

Other allocations iterate AGs and so the first AG is just a hint -
these do not need to pin a perag first as they can tolerate not
being able to access an AG by simply skipping over it. These require
new perag iteration functions that can start at arbitrary AGs and
wrap around at arbitrary AGs, hence a new set for
for_each_perag_wrap*() helpers to do this.

Next is the rework of the filestreams allocator. This doesn't change
any functionality, but gets rid of the unnecessary multi-pass
selection algorithm when the selected AG is not available. It
currently does a lookup pass which might iterate all AGs to select
an AG, then checks if the AG is acceptible and if not does a "new
AG" pass that is essentially identical to the lookup pass. Both of
these scans also do the same "longest extent in AG" check before
selecting an AG as is done after the AG is selected.

IOWs, the filestreams algorithm can be greatly simplified into a
single new AG selection pass if the there is no current association
or the currently associated AG doesn't have enough contiguous free
space for the allocation to proceed.  With this simplification of
the filestreams allocator, it's then trivial to convert it to use
for_each_perag_wrap() for the AG scan algorithm.

This series passes auto group fstests with rmapbt=1 on both 1kB and
4kB block size configurations without functional or performance
regressions. In some cases ENOSPC behaviour is improved, but fstests
does not capture those improvements as it only tests for regressions
in behaviour.

Version 2:
- AGI, AGF and AGFL access conversion patches removed due to being
  merged.
- AG geometry conversion patches removed due to being merged
- Rebase on 6.2-rc4
- fixed "firstblock" AGF deadlock avoidance algorithm
- lots of cleanups and bug fixes.

Version 1 [RFC]:
- https://lore.kernel.org/linux-xfs/20220611012659.3418072-1-david@fromorbit.com/

