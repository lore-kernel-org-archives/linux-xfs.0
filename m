Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC04FC19F2A
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 04:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiHCEVY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 00:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiHCEVY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 00:21:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78343357CD;
        Tue,  2 Aug 2022 21:21:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C94AB82188;
        Wed,  3 Aug 2022 04:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5E0C433D6;
        Wed,  3 Aug 2022 04:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659500480;
        bh=j6U10ShCo3GcN0MgV872rvBoLw1B4nGHxnaQGqUaFec=;
        h=Subject:From:To:Cc:Date:From;
        b=XU+MDNxLMsdeLTwIYHpMkVNOHQX5KmFSbDxH/9kc6YUqwDf/5KETffUeclSfPX2LX
         UC79fmbQdGbMeVD6mSmG1lxuPXI7uf/XjVlJOeovC/S05ZslGeoUNYA5be+FVqlJKF
         oZmM46awcRuDBQ/TulzzivivhzhQ+mESeR85fm6mmkId12A7kSGeGAgY1USI+sNRrk
         ufQZFW9IB/BNChKfBvlzmKynTizrCNc2/g1vdqDF58Rzqy6piEnwROn69mmi0APd7R
         UACfoNCnRyFxXA2SsYjq2NLI9x5NjPD8CUtXyrLd4BoFT6S930c3WOGGM3tODoIWMN
         t3XA4W0ZoPzYw==
Subject: [PATCHSET 0/3] fstests: random fixes for v2022.07.31
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Aug 2022 21:21:20 -0700
Message-ID: <165950048029.198815.11843926234080013062.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual batch of odd fixes for fstests.  Fix a golden output
error in the new xfs/533 test, and recycle the same "scratch fs with
not the usual scratch device" fixes.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 tests/xfs/291     |    6 +-----
 tests/xfs/432     |    3 ++-
 tests/xfs/533.out |    2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)

