Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF83AC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiL3W0b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiL3W0a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:26:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719F3A1A1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:26:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3209FB81B91
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB83C433EF;
        Fri, 30 Dec 2022 22:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439186;
        bh=jLoawwwJptZcc3GUxJvfbxXauLu4heS6dpZxYCTN+HY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g5e1YkD6y/gZiX0QVzCZBPsKwaUPkQCb+muByJGYUE/USNHfoQsOBMV2KGggUPJ5/
         i2074ZwO+y1st8BB7mEeUS8OxXSkCudwRtSm6EebdYts7r4FokPjWOF6uPwpaq0GQf
         FDNpqKtNVFpq4CstRPKwtViRq/WGHrwmXcnMrsRThmTyqAXX7Ll/zzLlLEJva1KTPP
         QJrjouKKp0HYZ6fy35gN7EUeLwaBACtqwE7VPz8Z5OcLUfL9wjbtzwcLGxZJ6LlVhj
         0+c1lykiE+e2KqrqbSCBD/1MPR4mdxiAqxes9fKWLOA76DM6F+Sw34R6TkpjiSJfHo
         pfbDG3ruFYkgA==
Subject: [PATCHSET v24.0 0/4] xfs: detect incorrect gaps in inode btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:28 -0800
Message-ID: <167243828888.684591.12405031427937736396.stgit@magnolia>
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

This series continues the corrections for a couple of problems I found
in the inode btree scrubber.  The first problem is that we don't
directly check the inobt records have a direct correspondence with the
finobt records, and vice versa.  The second problem occurs on
filesystems with sparse inode chunks -- the cross-referencing we do
detects sparseness, but it doesn't actually check the consistency
between the inobt hole records and the rmap data.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-detect-inobt-gaps

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-detect-inobt-gaps
---
 fs/xfs/libxfs/xfs_ialloc.c |   84 ++++++++------
 fs/xfs/libxfs/xfs_ialloc.h |    5 -
 fs/xfs/scrub/ialloc.c      |  268 ++++++++++++++++++++++++++++++++++++--------
 3 files changed, 269 insertions(+), 88 deletions(-)

