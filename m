Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C75C77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 22:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239852AbjFFW3G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbjFFW3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 18:29:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFB81717;
        Tue,  6 Jun 2023 15:29:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D487F63809;
        Tue,  6 Jun 2023 22:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D698C433EF;
        Tue,  6 Jun 2023 22:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686090543;
        bh=tECIZe4+f1/J1vjPwZ3NYyCKYfrd2/bOie7gPZLsrIU=;
        h=Subject:From:To:Cc:Date:From;
        b=KqzqfWnMfUsqYTdUB7q7rgjh3QszLph01Db3avgPeWOolDAZjBAODcxNVLMQW+o3O
         fFo/aJ7aYlT2HyLb3Td1t3GR3zxSYz0QDNOBFcZi0/sfXpcu85edSSxjhVtDZEO1na
         nHT0s72kTPn6tbRN8FATwwSHrRWtcgkh4kIZjPgLjGlXt+N6c5kRYc1dtVdQsYTyTN
         H1458uCDYC0TCpL+u+QEzcU22zHrlBMu+1cQpTJY+wni1sVHWcNaG/VPC5t7qPzy3N
         baXq3zqa1j8KQG/ryOTErWP3Sp8Sz3gp6Y2eiX8b42wZ6/cTI4+lwA4DCGhD77c/PJ
         as5tIkD7+jtbg==
Subject: [PATCHSET 0/3] fstests: random fixes for v2023.05.28
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jun 2023 15:29:02 -0700
Message-ID: <168609054262.2590724.13871035450315143622.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual odd fixes for fstests.

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
 tests/xfs/108 |   14 +++++++++++---
 tests/xfs/155 |    7 ++++---
 2 files changed, 15 insertions(+), 6 deletions(-)

