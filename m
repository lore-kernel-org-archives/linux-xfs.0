Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B96BC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 22:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237184AbiDKW4g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245197AbiDKW4e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 18:56:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D7264DF;
        Mon, 11 Apr 2022 15:54:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA2EE61787;
        Mon, 11 Apr 2022 22:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3806BC385A3;
        Mon, 11 Apr 2022 22:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649717657;
        bh=PIHtYZilQTNkR8hF1vI1jRXkzxmPiuKzDfgRmK5COzQ=;
        h=Subject:From:To:Cc:Date:From;
        b=JclAxqVJEdvnRgzH2k3+sljxpT/nkNW35mHXi2J6VF9eAAaRnhhiVNcJc2S6FT/pc
         6jaHafeyFEbg7pr+9KogkMNvLAuvVSiPtQREJQjEF04UPhtlqzqk3bNHI1hBhIN1oD
         rNbxuurIZlhQtq4/eG+IMmAUmLIr0+khEW6pu77wJzJHIwis6p5fl/vjit6CgaqD/p
         TwybxmEGjSzFT4hL1C9/BEm9V0Y3IDsh9ACvZHYYwHhBHG4Ozu/18iBGg/4yh4BcPH
         f+PP4TwmlfqTmh7DfPYElqFkbdyMb/OV6n8L5nnoDEKnwxY2yPZkifXe/RlKxbDTfj
         U3KrXDcDmwn7w==
Subject: [PATCHSET 0/2] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 11 Apr 2022 15:54:16 -0700
Message-ID: <164971765670.169895.10730350919455923432.stgit@magnolia>
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
 tests/xfs/187 |    2 +-
 tests/xfs/507 |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

