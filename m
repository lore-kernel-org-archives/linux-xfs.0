Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E35C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DD9C22D58
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbhARWMP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:12:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbhARWMO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:12:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D81422CB1;
        Mon, 18 Jan 2021 22:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007894;
        bh=H/5ADvI7VUmiyBpaPwYuztTFYCoZN6mLFlcfL1jNNEo=;
        h=Subject:From:To:Cc:Date:From;
        b=OOSDQwLSI6GEoeUXzVqtk0N5TceGrUJ9vFz2PSfk5BWJ8d17Pxi8HHJKCNOvGNfXS
         WwbrVaOyoghJwdu4Pvz3JQVOmvSJGNe9gGFKQ8eAjWbeWcw3PBNFCwH7owKvXpVns3
         D2MBZsI8hgpUAytfF5o08ShIdRTJav97xwruRU5ReovrYrsy+VMb3ulzSFid1HNCLx
         ZuM2oad2lgcmc1arkUcN84rZwW3l0PJ6XUgjgEenwdaOLtc14RL6pRq2yNYRdkPrmH
         aTWYj8VnXfTAO1hZvjJsaAsWJtvpjwhPSFk4Fj6iApZpv0Nil3lKXTTV/RaTrXimRI
         cL3Gc8cGeEStw==
Subject: [PATCHSET 0/4] xfs: minor cleanups of the quota functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:11:33 -0800
Message-ID: <161100789347.88678.17195697099723545426.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series reworks some of the internal quota APIs and cleans up some
of the function calls so that we have a clean(er) place to start the
space reclamation patchset.  There should be no behavioral changes in
this series.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=quota-function-cleanups-5.12
---
 fs/xfs/libxfs/xfs_bmap.c |    9 +++------
 fs/xfs/xfs_bmap_util.c   |    4 ++--
 fs/xfs/xfs_inode.c       |    8 ++++----
 fs/xfs/xfs_quota.h       |   40 +++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_reflink.c     |    3 +--
 fs/xfs/xfs_symlink.c     |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   21 +++++++++++++++++++++
 7 files changed, 68 insertions(+), 21 deletions(-)

