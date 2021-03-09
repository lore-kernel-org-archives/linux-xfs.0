Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EB3C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CEFD6523B
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCIEkL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230086AbhCIEj5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:39:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4DA16528A;
        Tue,  9 Mar 2021 04:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264796;
        bh=T354c2EA65RqnKeDW9v247sVjiiasEsbCc+5mdqtSZo=;
        h=Subject:From:To:Cc:Date:From;
        b=CoJozbYFffNWpiufRw8WOq3gX7n5ApRFzJzBx8JCUaE+1FIWKpzvRR+Y9ZeEL42i4
         5UvDPHkrKX6Vl6aCAtTJ5u3ndtecwWnFKqYefH07fF2sj1Hs66xfKNkvaTreUCThYY
         jAhEs9pSR7WFrplkg6CzqXg2wjcpH5KTt3bX6Oh4I967S6vHkCCmq+bEHk9n+lKqIX
         2rjyiXWxCMRr7kxaQjKgzuGQsNhAyI2rBDmlG+19utzlcsjuZYECpnLOBLzOzuvKCq
         sZzuzyL4caiaFEyW4Y8HTiH7wpWu4aurlF5rXNy3XNowbMzGOgNklE7rlQYR/kLgjp
         klzTT/2WnuQxw==
Subject: [PATCHSET 0/1] fstests: functional testing for xfs realtime extent
 size
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:39:56 -0800
Message-ID: <161526479659.1213159.2118025896747855436.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The single patch in this series introduces functional testing for xfs
filesystems when the realtime volume is enabled and the realtime extent
size is greater than a single block.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=rtextsize
---
 tests/xfs/763     |  181 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/763.out |   91 +++++++++++++++++++++++++++
 tests/xfs/group   |    1 
 3 files changed, 273 insertions(+)
 create mode 100755 tests/xfs/763
 create mode 100644 tests/xfs/763.out

