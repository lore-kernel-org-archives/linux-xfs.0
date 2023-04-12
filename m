Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00377C77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjDLDrM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjDLDrK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:47:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3114206
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:47:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E78B62D90
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A90CC433EF;
        Wed, 12 Apr 2023 03:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271229;
        bh=Rio046g+lSIcm1a9pUS7+55+NKay54qdNwjGOCO8wy0=;
        h=Date:Subject:From:To:Cc:From;
        b=ePB0SJ+zGuQcjDcMBfV6MgKSgpwfzYzC9eNbSITGNdTD8tgp1lUHXE/TJa9U8i3P2
         sD81dUDP8CCjfHZpzBANX6jcwAgTqgd/WcUmOex8lfK9BiLNmYgQRGM+3ANlYlufGv
         gmiDGlAzpr4UCBCICnubhDUIuVMGEfLUfmFTbWND7FaqJ088a9fjCtNXt5VWdu9jj9
         z2kEKhl07D9mo30e4Lbu1rrauKrDrwnHrf28I70cPCl4JXt73cYa0WpjajHZw1v/fM
         uMNxS+9q0OID+Aiwsqwzy86nesv7+DEezqW0AOxK73A47oK9gMYZ+hRd+OXtmPdi8x
         jBeF7bQBxrasg==
Date:   Tue, 11 Apr 2023 20:47:08 -0700
Subject: [GIT PULL 9/22] xfs: enhance btree key scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127094565.417736.2463509060702882791.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 38384569a2a8a721623d80c5ae3bcf80614ab792:

xfs: detect unwritten bit set in rmapbt node block keys (2023-04-11 19:00:07 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-btree-key-enhancements-6.4_2023-04-11

for you to fetch changes up to 2bea8df0a52b05bc0dddd54e950ae37c83533b03:

xfs: always scrub record/key order of interior records (2023-04-11 19:00:09 -0700)

----------------------------------------------------------------
xfs: enhance btree key scrubbing [v24.5]

This series fixes the scrub btree block checker to ensure that the keys
in the parent block accurately represent the block, and check the
ordering of all interior key records.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: check btree keys reflect the child block
xfs: always scrub record/key order of interior records

fs/xfs/scrub/btree.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++------
fs/xfs/scrub/btree.h |  8 ++++++-
2 files changed, 63 insertions(+), 8 deletions(-)

