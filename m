Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C555C7EE2F
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 22:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239867AbjFFW30 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239864AbjFFW3Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 18:29:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DEE1726;
        Tue,  6 Jun 2023 15:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E993A62CD2;
        Tue,  6 Jun 2023 22:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5CEC433EF;
        Tue,  6 Jun 2023 22:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686090563;
        bh=T1YCPP30Do6ni3yxMsNs+eZ4kHHbIoJQGPWWHjcTVkM=;
        h=Subject:From:To:Cc:Date:From;
        b=C0SdDjpFQ1BkqDV/soXReb6nNnOEml8VdUQfedHpS8NHE8ca7uGRpj4hUF8Lv4O5I
         fD7Yj8hEurMA4qgYcjHE6XWul4K4cU/tF/i4Y5P1GX/EqAjFZ0xl/6vqUB0zinQVq9
         gaTKAvuzbPnnBS4OvXJ5Aj657vyHrGLMaO5+d/Ze3GnRN6d1tXw/3DIg1iq6Swsqpj
         G/OZY5G392GmuSxnsxXd/x/HWL8yUcs/DKu8W2Ax5ZWuvt7aBGTb4AwRLB3F0q6+2g
         LwrhY0lnbyljHjiJ45Piaw0xcDqLuGG1c0Qyrc+DqF4W/6o/J3ND+1E4FPbGhd9OpQ
         XYWEL3w+cQf6w==
Subject: [PATCHSET 0/3] fstests: reduce scrub time in testing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jun 2023 15:29:22 -0700
Message-ID: <168609056295.2592490.1272515528324889317.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

For fuzz testing of the filesystem repair tools, there's no point in
having _check_xfs_filesystem rebuild the filesystem metadata with
xfs_repair or xfs_scrub after it's already been testing both.  This can
reduce the runtime of those tests considerably.

Do the same for xfs/503 since we're only concerned with testing that
metadump and mdrestore work properly.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-test-speedups
---
 common/fuzzy  |    7 ++++++-
 common/rc     |    2 +-
 common/xfs    |   31 ++++++++++++++++++++++---------
 tests/xfs/503 |    2 ++
 4 files changed, 31 insertions(+), 11 deletions(-)

