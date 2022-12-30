Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9676C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbiL3XNt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiL3XNs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:13:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B53DE81
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:13:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 537D961C32
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE566C433D2;
        Fri, 30 Dec 2022 23:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442026;
        bh=n3E27CvzH8V8pQ8AUVyaX6Z5mL0g50pTiKRHSe+U2Lk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KoavXyLsqoX8QG9e+pq1uptZx8/Y5LKbnju9rqKWe97IG4Kf1w8AqfSWmvbo61vX/
         iUQG65/Raa9xdRGUgahzYqk++ruZTftBv6IqOEb7CjMW2qZekYwAo1AjZ7UkPnqgjh
         nINOU52VCpyYgVVNowMPgzdbGy42iM9jwmVS/9vLJE2e5L3CU9zxgoKv+bZ8aMUfQS
         Oy+C5JMFTRBMqjr4Ah8rFOuMroSJTat+yZvwR34Iu2GZCoMcyiMOxusvZvtYonQPzY
         5BDTD/bfmSVQWUeIOc8FEe5+4Q2noAm+HmDe45u7x5qVUeszwGx2RO2H7i/Lcpza4W
         cUj9IXTzVcRkQ==
Subject: [PATCHSET v24.0 0/5] xfs_scrub: use scrub_item to track check
 progress
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:21 -0800
Message-ID: <167243870099.716382.3489355808439125232.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Now that we've introduced tickets to track the status of repairs to a
specific principal XFS object (fs, ag, file), use them to track the
scrub state of those same objects.  Ultimately, we want to make it easy
to introduce vectorized repair, where we send a batch of repair requests
to the kernel instead of making millions of ioctl calls.  For now,
however, we'll settle for easier bookkeepping.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-object-tracking
---
 scrub/phase1.c        |    3 
 scrub/phase2.c        |   12 +-
 scrub/phase3.c        |   39 ++----
 scrub/phase4.c        |   16 +-
 scrub/phase5.c        |    5 -
 scrub/phase7.c        |    5 +
 scrub/repair.c        |   71 +++++------
 scrub/scrub.c         |  321 ++++++++++++++++++++++---------------------------
 scrub/scrub.h         |   40 ++++--
 scrub/scrub_private.h |   14 ++
 10 files changed, 258 insertions(+), 268 deletions(-)

