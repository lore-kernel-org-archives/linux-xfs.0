Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B905BC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbiL3W1t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235585AbiL3W1q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:27:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8821C90C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:27:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CFFE61C15
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA07C433EF;
        Fri, 30 Dec 2022 22:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439264;
        bh=HZp8shcD/e2jnJ8w0Ebn9K1EVlIPq7+GwIx0oBK/Li8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gUo+mTuXkhFwzZMC02VQJyOK/oH8eQ9mMl8kqzVao4YZkbtybxkySEOlETLPeTz6c
         85zLBZkVnDFq8Sqn88/lK/Caqwl2a93uT72UMXfaKhbJ9r4CCdAipZMHP3rvNceI5i
         m0sdh/S0/gTVcQUB8osRdiY84m4RF3kjOGGV9QrjAHV96p7kcZkzb14AKjWB+qg7E/
         cXwIRzUxFxSomPvcSBb0FWh5w44r8aMT2LFe6hUHIRCxZCPUCi7h7yZqJJLzUv8p2t
         EqJssfhEDNBuukhXhfWDV9UYWBYjMsi4yrVMRQUTQdOXzECkrmxGBbU2JjetU7U5CC
         sRTSulRCcWdaQ==
Subject: [PATCHSET v24.0 00/11] xfs: clean up memory management in xattr scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:46 -0800
Message-ID: <167243830598.687022.17067931640967897645.stgit@magnolia>
In-Reply-To: <Y69UceeA2MEpjMJ8@magnolia>
References: <Y69UceeA2MEpjMJ8@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Currently, the extended attribute scrubber uses a single VLA to store
all the context information needed in various parts of the scrubber
code.  This includes xattr leaf block space usage bitmaps, and the value
buffer used to check the correctness of remote xattr value block
headers.  We try to minimize the insanity through the use of helper
functions, but this is a memory management nightmare.  Clean this up by
making the bitmap and value pointers explicit members of struct
xchk_xattr_buf.

Second, strengthen the xattr checking by teaching it to look for overlapping
data structures in the shortform attr data.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-fix-xattr-memory-mgmt
---
 fs/xfs/scrub/attr.c  |  298 +++++++++++++++++++++++++++++++++++---------------
 fs/xfs/scrub/attr.h  |   60 +---------
 fs/xfs/scrub/scrub.c |    3 +
 fs/xfs/scrub/scrub.h |   10 ++
 4 files changed, 231 insertions(+), 140 deletions(-)

