Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AF2C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 03:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbiKQDJr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 22:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbiKQDJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 22:09:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BFD4876D
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 19:09:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C876CE1D52
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 03:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B72DC433D6;
        Thu, 17 Nov 2022 03:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668654582;
        bh=DNbeK2ZnI8arW1yRyr+BIoeq/XFdhUca/xtrDH//URY=;
        h=Date:From:To:Cc:Subject:From;
        b=h0bsdNbCzAfSSEta0QzYY7Ql1Tx2eMY57TY5m+yq1hrtanezKvVJCSomd8isWSKIH
         DWKaY05UstmY5gcuCeJN2N+Lgav79i4naGXH7xyaDzsqhG9KzpfwdZ3kDggaVcTdLQ
         iygg99rRAjBG2yqDpY44zq2ibxsCF9OykppW7CmQlByHBJb4sja5EpkaDCrcTpHrVt
         U8P53NlrwxZC4/PBRyeOo31LTWXXXCdEjYKZukvA6UKRV1gCZOFLoPLhiWHwc4BZPF
         JON1LKGub1bGG6lA7WgSDJp4evqLmpoHTMvJ0BR+o8KAu8q/NI0tdTopanTrDB+R7/
         G+gch1BWtHg3g==
Date:   Wed, 16 Nov 2022 19:09:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 2/7] xfs: clean up memory allocations in online fsck
Message-ID: <166865411034.2381691.6691985084316997644.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Please pull this branch with changes for xfs for 6.2-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit b255fab0f80cc65a334fcd90cd278673cddbc988:

xfs: make AGFL repair function avoid crosslinked blocks (2022-11-16 15:25:01 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-cleanup-malloc-6.2_2022-11-16

for you to fetch changes up to 306195f355bbdcc3eff6cffac05bcd93a5e419ed:

xfs: pivot online scrub away from kmem.[ch] (2022-11-16 15:25:02 -0800)

----------------------------------------------------------------
xfs: clean up memory allocations in online fsck

This series standardizes the GFP_ flags that we use for memory
allocation in online scrub, and convert the callers away from the old
kmem_alloc code that was ported from Irix.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: standardize GFP flags usage in online scrub
xfs: initialize the check_owner object fully
xfs: pivot online scrub away from kmem.[ch]

fs/xfs/scrub/agheader.c        |  2 +-
fs/xfs/scrub/agheader_repair.c |  2 +-
fs/xfs/scrub/attr.c            | 11 +++++------
fs/xfs/scrub/bitmap.c          | 11 ++++++-----
fs/xfs/scrub/btree.c           | 14 ++++++++------
fs/xfs/scrub/dabtree.c         |  4 ++--
fs/xfs/scrub/fscounters.c      |  2 +-
fs/xfs/scrub/refcount.c        | 12 ++++++------
fs/xfs/scrub/scrub.c           |  6 +++---
fs/xfs/scrub/scrub.h           |  9 +++++++++
fs/xfs/scrub/symlink.c         |  2 +-
11 files changed, 43 insertions(+), 32 deletions(-)
