Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21D7C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 21:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B798561106
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 21:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhGNV2K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 17:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235617AbhGNV2K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 17:28:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DEA261106;
        Wed, 14 Jul 2021 21:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626297918;
        bh=KknpwZsO7nhk7R6X5Pg/nwYL2OAcopwfFnnvUgyu2As=;
        h=Subject:From:To:Cc:Date:From;
        b=Cp4763Pq4D6b1neSlPyxVpgMcByfB0PgjSeujGJjoiBlIgpdDY/OmGNcGlUH/1cXY
         yQLBw41oCO5K2XR8SLFwU0NshuobxeY7WaNJH6Oie/CYSJQjU00tqCWB9DCdvqt3Aq
         TSby6lh7KtKZT4hPwiV4IjE7LDFteOsAS+PyVFmr0/QLof76nFLNrGpktDGpBpRgu0
         K7YYXHLEhbet+vtuHRLoLNwnhCf3nM/WyzSxqlKiB+pVdPh8iZe2+Hs6zieb0F9H0e
         78krHt9X7zLb8BHldhhmKer2q2a8fSXKY/YOn6Nn868oafn8oyDL0Vw7hPv+0zI+ay
         AuJXh0mcW1Dew==
Subject: [PATCHSET v2 0/2] xfs: small fixes to realtime growfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 14 Jul 2021 14:25:17 -0700
Message-ID: <162629791767.487242.2747879614157558075.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While auditing the GROWFSRT ioctl, I noticed that there are a few things
missing in the argument validation code that could lead to invalid fs
geometry.  Fix the validation and overflow errors.

v2: tweak some of the checks, straighten out the int overflow cleanup

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=growfsrt-fixes
---
 fs/xfs/xfs_rtalloc.c |   49 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

