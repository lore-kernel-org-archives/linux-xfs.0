Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80087C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjDLDss (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDLDso (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:48:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D548E10C0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:48:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70A5A62B68
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1ABC433EF;
        Wed, 12 Apr 2023 03:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271322;
        bh=k0SgcYTg9L7NAEBJjQxuVztTF//Bx4yEJtdfdd4AvE4=;
        h=Date:Subject:From:To:Cc:From;
        b=duFs0MOenSxM4a1IvhmkMC82P2vjxHvGBdjzl3BFM/DYIb3Q6PHhNfzCxT5P315JW
         obZuKT94KWJ3QRFfWFpfkqwy6EuGF2Vy3HXaSt2r/W9f4T426PrIsnM9QKH5Ry4/TL
         9gsUs9upr5ehPAVOlU6SxfahrtXDMyMkM8UFQiRSiIbxel9bfjDtAK3uAT8k1Gguz+
         rUC2Nixmg/Q7b/K2t6cCsyX92KbPklnKLil64i8IQR+ykDwQkx3LzLX2MPoGYSJebH
         hG/+3r+HFHnwNaMbkvl4dxV4PPXMtdulkeAxfwIwFrHj5g787wieCLRHWTLlMxTE33
         3iUNfKU0GLp9w==
Date:   Tue, 11 Apr 2023 20:48:42 -0700
Subject: [GIT PULL 15/22] xfs: fix iget usage in directory scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168127095149.417736.13949355066335699103.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 6bb9209ceebb07fd07cec25af04eed1809c654de:

xfs: always check the existence of a dirent's child inode (2023-04-11 19:00:18 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-dir-iget-fixes-6.4_2023-04-11

for you to fetch changes up to 6bb9209ceebb07fd07cec25af04eed1809c654de:

xfs: always check the existence of a dirent's child inode (2023-04-11 19:00:18 -0700)

----------------------------------------------------------------
xfs: fix iget usage in directory scrub [v24.5]

In this series, we fix some problems with how the directory scrubber
grabs child inodes.  First, we want to reduce EDEADLOCK returns by
replacing fixed-iteration loops with interruptible trylock loops.
Second, we add UNTRUSTED to the child iget call so that we can detect a
dirent that points to an unallocated inode.  Third, we fix a bug where
we weren't checking the inode pointed to by dotdot entries at all.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------

