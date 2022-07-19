Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5A3C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 21:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239975AbiGSVhM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239758AbiGSVhL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:37:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E9E474E4;
        Tue, 19 Jul 2022 14:37:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57AC1B81C77;
        Tue, 19 Jul 2022 21:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15193C341C6;
        Tue, 19 Jul 2022 21:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658266628;
        bh=F2FcEaijUWAZeQXC0Q8C04EmUa0BhjbK4luFJpSNwHo=;
        h=Subject:From:To:Cc:Date:From;
        b=hXm3YW1y5lUTCsE3sExFXe+w8/C8KTLrArllhjQBNF9iV2y4c6+NxVBLwELMDL6Yf
         hclficFkL3Q5BWAygkFMBDJBarRd5EzJ3psJ8IVYHO9LzOQSPBH+Hu41K7p1AviqfZ
         RYix3JG8CWaZNGEVzDlzgYMdEDHvuO8Sz4hJhYYhE2SMJCj9730xuRizmclfMdImts
         rWibq6uCvwYbBaHIN0UQ8cbModXDD0zy0cY7XS5GEz4db8tEM8BUyxo9qpB1HT4iUd
         v4XO0YnFHAz9goJyFOdDq93rW5sw3YKVtnpd79yZy4abk7CM0F9W6foT7Fz0IY4sOR
         sCPn/nYV9eXTQ==
Subject: [PATCHSET 0/1] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 19 Jul 2022 14:37:07 -0700
Message-ID: <165826662758.3249425.5439317033584646383.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual batch of odd fixes for fstests.

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
 tests/generic/275 |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

