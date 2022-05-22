Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D2E7C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 22 May 2022 15:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiEVP1t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 11:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiEVP1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 11:27:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2FE38BF6
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 08:27:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06C3161003
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 15:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC76C385AA;
        Sun, 22 May 2022 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653233267;
        bh=K3UWEh4bdIKRtS1HvpMR295ULOTX2xuqs1OMRsQQT1A=;
        h=Subject:From:To:Cc:Date:From;
        b=s5WkbZFr3RlVRtYoSmzAvE2I/RrXTdQXDXYDAxxmN9rnz7/i4awQQQrbKkM49crGE
         PhsN5gvT4xC58/N42ivkcg05Jw7vL0bIF1xdRejDfcAqctvaUd71SyXlqbGu8sPiHJ
         VGgA0RRuT8BUtFv11LVHLC2A/pWSZO8EQC4l+RpzhEqx2xND6uGtHjqzs/CinQ1cdi
         8qpGl7ZzndA4S5kpxxV8klLsYJp4hL7hmfAy6fh4+w3etENoZ4ODIHIqkeGOLNksTp
         RXpQEHQ8V/0JzY6pm3wGAwdosXdAAh+kQ2V+wAeKIchnOam7VGyuI24/c7v07pR60a
         Y7YuA9smQxZtA==
Subject: [PATCHSET 0/4] xfs: last bit of LARP and other fixes for 5.19
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 22 May 2022 08:27:46 -0700
Message-ID: <165323326679.78754.13346434666230687214.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's one last round of fixes for UAF bugs and memory leaks that I
found while testing the logged xattr code.  The first patch is a bug for
a memory leak in quotacheck that has been popping up here and there for
the last 10 years, and the rest are previously seen patches rebased
against where I /think/ Dave's current internal testing tree is right
now, based on his request on IRC Friday night.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=larp-fixes-5.19
---
 fs/xfs/libxfs/xfs_attr.c  |    6 +
 fs/xfs/libxfs/xfs_attr.h  |   11 ++
 fs/xfs/libxfs/xfs_defer.c |   59 ++++++++--
 fs/xfs/xfs_attr_item.c    |  268 +++++++++++++++++++++++++--------------------
 fs/xfs/xfs_attr_item.h    |   13 ++
 fs/xfs/xfs_log.h          |    7 +
 fs/xfs/xfs_qm.c           |    9 +-
 7 files changed, 235 insertions(+), 138 deletions(-)

