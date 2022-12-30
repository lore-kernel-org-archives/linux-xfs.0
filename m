Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E372C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbiLaBDG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBDG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:03:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAD11DDE4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:03:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD5FA61D73
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33490C433EF;
        Sat, 31 Dec 2022 01:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448584;
        bh=4A5s6Gpvp65OOQI9NkaCPmTxnAoYReI2ismt/2hUbBI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OpMZLRem9AdCmydUfuzcfb/qOB1FWBBpb65B64jgFYqd1ndafqOSpLJysdMsbNw/J
         NP7q6Nc5b/TiJWJ9n0bH4mBhI3QLQql0nhf6axAkT75Nu3hts5+LK8Ee0FpxnBz454
         9k/hxhHJC/QLSSQfC0KCVuLX/oikK+lr+iQuaSCRFPfdto7VEMl3JiT85xtEdAzldd
         QceAENqhhl0M+/m/Pimo925fbQAuYd5NyKAJMCPNDRjbCmDPpVA6MlOUqmo1pS8bYG
         TqdgYWDAMa/A/9q2vv6d/x3IZ6rRfD770Q/W8LlTekyoDdINpC5WVp/MTULca1bT/E
         RC1upM8sMelmA==
Subject: [PATCHSET v1.0 0/1] libxfs: enable quota for realtime voluems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:19 -0800
Message-ID: <167243881927.735184.9698389452163804435.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

At some point, I realized that I've refactored enough of the quota code
in XFS that I should evaluate whether or not quota actually works on
realtime volumes.  It turns out that with two exceptions, it actually
does seem to work properly!  There are three broken pieces that I've
found so far: chown doesn't work, the quota accounting goes wrong when
the rt bitmap changes size, and the VFS quota ioctls don't report the
realtime warning counts or limits.  Hence this series fixes two things
in XFS and re-enables rt quota after a break of a couple decades.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-quotas
---
 include/xqm.h |    5 ++++-
 quota/state.c |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

