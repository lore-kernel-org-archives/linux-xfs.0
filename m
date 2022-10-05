Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78920C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Oct 2022 17:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiJERKU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Oct 2022 13:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiJERKO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2022 13:10:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7731219C08;
        Wed,  5 Oct 2022 10:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 140DCB81D79;
        Wed,  5 Oct 2022 17:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47F2C433B5;
        Wed,  5 Oct 2022 17:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664989810;
        bh=py4CKtrvySMjzGcD1cbyTThoL3ImbRIASdFiDFboOv4=;
        h=Date:From:To:Cc:Subject:From;
        b=XMY/v41N2AAwjSreHZtrjI2OkFrLsqh9NDVLNn2vtGavWWd5f00v5A186GZieun7T
         lDkA9goTJmCNxHMDN25FwRjiXVYitqbvIqIkxRQS1QPXh8K+OVsHsSxG942W4+e/ob
         mbW2PPIlH8AuRHBQNcG1m9/irLxDIXgroND4BfmZbU8Mcd3hk5SzINDzq3+ojXDfm3
         vqvnjJOFz/MvYtMXMgnHMjv2WswOyk2tbmMGxAuCiubgR1WCQSXRTE93qlOWY1BIcz
         6X/38sUWuaoNeowR0ov5VNLcqJcc8qBqfgKqBNmolwZU3483ALHQRBFYiU7RDwQitR
         mAgnglLs9WX7w==
Date:   Wed, 5 Oct 2022 10:10:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] iomap: new code for 6.1
Message-ID: <Yz26clbuE/nMjyNU@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with new code for iomap for 6.1.  It's pretty
quiet this time around -- a UAF bugfix and a new tracepoint so we can
watch file writeback.  Dave Chinner will be sending the XFS pull request
for 6.1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit f76349cf41451c5c42a99f18a9163377e4b364ff:

  Linux 6.0-rc7 (2022-09-25 14:01:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-6.1-merge-1

for you to fetch changes up to adc9c2e5a723052de4f5bd7e3d6add050ba400e1:

  iomap: add a tracepoint for mappings returned by map_blocks (2022-10-02 11:42:19 -0700)

----------------------------------------------------------------
New code for 6.1:

 - Fix a UAF bug when recording writeback mapping errors.
 - Add a tracepoint so that we can monitor writeback mappings.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
      iomap: iomap: fix memory corruption when recording errors during writeback
      iomap: add a tracepoint for mappings returned by map_blocks

 fs/iomap/buffered-io.c | 3 ++-
 fs/iomap/trace.h       | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)
