Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E51C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 01:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJLBpM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiJLBpL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 21:45:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7295740BFC;
        Tue, 11 Oct 2022 18:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D368261345;
        Wed, 12 Oct 2022 01:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B40DC433C1;
        Wed, 12 Oct 2022 01:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665539108;
        bh=YuVEu9wrvZi7LQYdQ788lsyub+PAi9ho5j4PI9SXSJU=;
        h=Subject:From:To:Cc:Date:From;
        b=HB0m/ydoxF5G4lpdInPU2QzbrAtBCdRa+Rhmhrr48GcHbshaIF84Z5dK/gviPzKJl
         GRZvHZl5qk/QDhpCHOqXcncA00A34YJxkryLIx2vaJl6XOgF5yuond6P6a7OxAU/eZ
         TkGLT3CbGfASOCRg+oudy4gb7Q3MQMHdUx0n/CUSmxU/Q0qwYN4bSupsIMMvwxmYCN
         3Mc/79Apso8HZDIcB33vAzvFsGAyzKaFdLmhh4sz2UB1CBMP0GEkbT+aBIr65B2NR9
         DzgsnzsTF9TCyTuNuM2UuRtKQ6rusRmfRkxFZBFl+tsuTgndnPhOaXDxoi8csMdugw
         01F4V+7C20wcA==
Subject: [PATCHSET v2 0/2] fstests: improve coredump capture and storage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Oct 2022 18:45:07 -0700
Message-ID: <166553910766.422356.8069826206437666467.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While I was debugging some core dumps resulting from xfs_repair fuzz
testing, I noticed that fstests was no longer putting core dumps into
the test results directory.  The root cause of this turned out to be
that systemd enables kernel.core_uses_pid, which changes the core
pattern from "core" to "core.$pid".  This is a good change since we can
now capture *all* the coredumps produced by a test, but bad in that the
check script doesn't know about this.

Therefore, fix check to detect multiple corefiles and preserve them, and
compress coredumps if desired.

v2: let the user specify which program they want to use to compress the
    coredumps

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=compress-core-dumps
---
 README    |    4 ++++
 check     |   26 ++++++++++++++++++++++----
 common/rc |   20 ++++++++++++++++++++
 3 files changed, 46 insertions(+), 4 deletions(-)

