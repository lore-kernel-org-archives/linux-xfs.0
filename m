Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0F7C001E0
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Aug 2023 15:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbjHJP2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Aug 2023 11:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbjHJP2o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2023 11:28:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5330110F3
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 08:28:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5CFB65305
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 15:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F76C433C8;
        Thu, 10 Aug 2023 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691681323;
        bh=86AeCKXSO4dJMZMi514vr3NoacCQ0uor9GQUDt0C8HA=;
        h=Date:From:To:Cc:Subject:From;
        b=Jr28mVaU9gLP1SgwIsBGMQsn2/LVrUpSrInw8wp+Prq22DSBW6u1RxqEd1hHvpOq+
         rcbLdNHWOJrCAf7s95/H9qi4RoJG5OiXezodTP8jGZKo0MLiQMnjL2XhDWtAcPTGgP
         vPEDBYE+rBb8TjCMykqhCmTsLrItp9/xlIi6PwULP04Z7xzqEVM6dxvVBfmDm6KIba
         LgjJM/74dtt+Poc/6JXa+bZgtRdebC/Gql/kybvYoine772s0zjpeG8iuiLDfNM6Xi
         KV4ZUPvPBARR4dfXGSrFGGk67kFRoVJl5bTTGgzUeIn8XKZg/oWRAoGdllORvDIbpp
         meHfAe9Zn03EQ==
Date:   Thu, 10 Aug 2023 08:28:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@oracle.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 2/9] xfs: fix online repair block reaping
Message-ID: <169168055657.1060601.852644481898844259.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Please pull this branch with changes for xfs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit d6532904a10290b94d2375ff438313e0fb9fc9f8:

MAINTAINERS: add Chandan Babu as XFS release manager (2023-08-10 07:47:54 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-reap-fixes-6.6_2023-08-10

for you to fetch changes up to 014ad53732d2bac34d21a251f3622a4da516e21b:

xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair (2023-08-10 07:48:04 -0700)

----------------------------------------------------------------
xfs: fix online repair block reaping [v26.1]

These patches fix a few problems that I noticed in the code that deals
with old btree blocks after a successful repair.

First, I observed that it is possible for repair to incorrectly
invalidate and delete old btree blocks if they were crosslinked.  The
solution here is to consult the reverse mappings for each block in the
extent -- singly owned blocks are invalidated and freed, whereas for
crosslinked blocks, we merely drop the incorrect reverse mapping.

A largeish change in this patchset is moving the reaping code to a
separate file, because the code are mostly interrelated static
functions.  For now this also drops the ability to reap file blocks,
which will return when we add the bmbt repair functions.

Second, we convert the reap function to use EFIs so that we can commit
to freeing as many blocks in as few transactions as we dare.  We would
like to free as many old blocks as we can in the same transaction that
commits the new structure to the ondisk filesystem to minimize the
number of blocks that leak if the system crashes before the repair fully
completes.

The third change made in this series is to avoid tripping buffer cache
assertions if we're merely scanning the buffer cache for buffers to
invalidate, and find a non-stale buffer of the wrong length.  This is
primarily cosmetic, but makes my life easier.

The fourth change restructures the reaping code to try to process as many
blocks in one go as possible, to reduce logging traffic.

The last change switches the reaping mechanism to use per-AG bitmaps
defined in a previous patchset.  This should reduce type confusion when
reading the source code.

This has been running on the djcloud for years with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (9):
xfs: cull repair code that will never get used
xfs: move the post-repair block reaping code to a separate file
xfs: only invalidate blocks if we're going to free them
xfs: only allow reaping of per-AG blocks in xrep_reap_extents
xfs: use deferred frees to reap old btree blocks
xfs: rearrange xrep_reap_block to make future code flow easier
xfs: allow scanning ranges of the buffer cache for live buffers
xfs: reap large AG metadata extents when possible
xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair

fs/xfs/Makefile                |   1 +
fs/xfs/scrub/agheader_repair.c |  75 +++----
fs/xfs/scrub/bitmap.c          |  78 +------
fs/xfs/scrub/bitmap.h          |  10 +-
fs/xfs/scrub/reap.c            | 498 +++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/reap.h            |  12 +
fs/xfs/scrub/repair.c          | 366 +++++-------------------------
fs/xfs/scrub/repair.h          |  18 +-
fs/xfs/scrub/trace.h           |  72 +++---
fs/xfs/xfs_buf.c               |   9 +-
fs/xfs/xfs_buf.h               |  13 ++
11 files changed, 673 insertions(+), 479 deletions(-)
create mode 100644 fs/xfs/scrub/reap.c
create mode 100644 fs/xfs/scrub/reap.h
