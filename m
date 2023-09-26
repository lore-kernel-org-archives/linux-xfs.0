Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A54AAE7F14B
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjI0ANG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbjI0ALF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:11:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B211A1F24
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:29:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473D3C433C7;
        Tue, 26 Sep 2023 23:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695770942;
        bh=XXRy0e300CAKX1SOyETG8VaZs5z6X5p75n8LgsJ97Ns=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ke1NZEnVDfm/PBMsGRhvLkWEzUv1ZS9bU2AwUWSOTIvmnC/yNQ2g3G2EJo6FHTvUy
         CSzAiRiSK5iQP5evM1Mcq+iEvbmJ7OgaI3HIdBp4OtiCF8X/rtfiXKi6GHqqRkgvFN
         b0dxKnX6CCbMn1bmOF0HGBcetKtgieKap93ZZah1HVKMna6iOB6dXEHvRF3QtkYMWd
         vI2FNinZoR/GfjkWKQqK+WIA/p8BjuyVhUVqC9np9Bz7Y9yZg1jhbiUpPlQspY/9sG
         4ZcSAa5/IPeHL6JZeFFW5Sk1oTdzwTldFkHKbDGjEMuhu1aiJ3PNYgvwZmdHVaok+T
         fq49OXU6ferOA==
Date:   Tue, 26 Sep 2023 16:29:01 -0700
Subject: [PATCHSET v27.0 0/1] xfs: prevent livelocks in xchk_iget
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577058799.3312834.4066903607681044261.stgit@frogsfrogsfrogs>
In-Reply-To: <20230926231410.GF11439@frogsfrogsfrogs>
References: <20230926231410.GF11439@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Prevent scrub from live locking in xchk_iget if there's a cycle in the
inobt by allocating an empty transaction.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-livelock-prevention
---
 fs/xfs/scrub/common.c |    6 ++++--
 fs/xfs/scrub/common.h |   19 +++++++++++++++++++
 fs/xfs/scrub/inode.c  |    4 ++--
 3 files changed, 25 insertions(+), 4 deletions(-)

