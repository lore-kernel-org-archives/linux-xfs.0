Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D5D3EE3F08
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 17:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjILRk7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbjILRk7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 13:40:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EDC10C9
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 10:40:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AE0C433C8;
        Tue, 12 Sep 2023 17:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694540454;
        bh=DbGDAER0Z7tzuCrxKHF327iajSlJYhWeWoCdONPgLDA=;
        h=Date:Subject:From:To:Cc:From;
        b=ZZnA0TVVuJRymw/bZepgtEgFHhhBmwza0cFh49Yqia0a3cdiUsoptz1NjmNgV4TWw
         X9x1HLTjM63MD2yrGqjLQOxcZy5nZQk6KBjlcbPFDyo8qaPpIXDzF9T+wMr3eHBchu
         NEzq75Ry8TligUwjJH3SAdC4j9Dd8n092MUnLgGDUYochNY6qaEJquaQocmCI7lhjE
         1ZEhpDofOlA8Onkov5o6GD3pFXZeM3U4r4Bfy4avL7tLgAe4wwn5jMpNV03rnRw/j9
         mdOmCMuOq+PT3ZHj5Pi9XOVNIERfDKWs9om0Wn3wsBpM7DPwLAaeZm9xZrlP7JsyNw
         h/a/DHpMt2jng==
Date:   Tue, 12 Sep 2023 10:40:54 -0700
Subject: [GIT PULL 8/8] xfs: fix out of bounds memory access in scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com,
        harshit.m.mogalapalli@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <169454023821.3411463.7740303846093140144.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Please pull this branch with changes.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 34389616a963480b20ea7f997533380ae3946fba:

xfs: require a relatively recent V5 filesystem for LARP mode (2023-09-12 10:31:08 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-scrub-6.6_2023-09-12

for you to fetch changes up to e03192820002feb064cc4fd0df9b8f0a94675c7d:

xfs: only call xchk_stats_merge after validating scrub inputs (2023-09-12 10:31:08 -0700)

----------------------------------------------------------------
xfs: fix out of bounds memory access in scrub
This is a quick fix for a few internal syzbot reports concerning an
invalid memory access in the scrub code.

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs: only call xchk_stats_merge after validating scrub inputs

fs/xfs/scrub/scrub.c | 4 ++--
fs/xfs/scrub/stats.c | 5 ++++-
2 files changed, 6 insertions(+), 3 deletions(-)

