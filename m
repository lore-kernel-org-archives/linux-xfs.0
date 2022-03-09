Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B63C4167D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 19:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237749AbiCITX1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237714AbiCITXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 14:23:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66DA93188
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 11:22:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43AD4618A8
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 19:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC37C340E8;
        Wed,  9 Mar 2022 19:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646853741;
        bh=tND0ISLvSiMp3vLO6lTwh0fMpliW1+T61K08Hhr+3cU=;
        h=Subject:From:To:Cc:Date:From;
        b=Jw+VQE9HvlyqmzHCS2XQhJjbH888txjuvUK8h/o+p7VNp8n4DVIHC05MLFh+GUxcX
         m6bZRK461KifeN2aeCiou79MMzEHdR/C4Ihu8xaBc3vEasKtXy8RYdugT56T+SB7ds
         ARvNtlft3pjakE6oXMqdw/quadhq7xsUyHRBkAABBSfOHFge5Eryl6Sv88M1eifByT
         HqGGVrA+YBoV6+9OJtYQRZtGlhXiaTr8FdU3KsW2bZn9UKWNqd9eAAoXOe4R0Xfd7K
         ZfBQc3kWN5B2EXlKkVfSt8hsVEWWuBj5x3mRcSnnd0SvYojQjXOelStjbvcE9hgYBA
         J+BxEuFx3rvMg==
Subject: [PATCHSET v2 0/2] xfs: make quota reservations for directory changes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 09 Mar 2022 11:22:21 -0800
Message-ID: <164685374120.495923.2523387358442198692.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

A couple of weeks ago, I was triaging an unexpected quota counter
failure report coming from xfs_repair after the online repair code
rebuilt a directory.  It turned out that the XFS implementation of
linkat does not reserve any quota, which means that a directory
expansion can increase the quota block count beyond the hard limit.
Similar problems exist in the unlink, rmdir, and rename code, so we'll
fix those problems at the same time.

Note: this series does not try to fix a similar bug in the swapext code,
because estimating the necessary quota reservation is very very tricky.
I wrote all that estimation code as the first part of the atomic extent
exchange patchset, so I'll leave that there.

v2: fix unlink and rename, since Dave suggested it

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=quota-reservations-5.18
---
 fs/xfs/xfs_inode.c |   67 +++++++++++++++++++++++++++--------------
 fs/xfs/xfs_trans.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h |    3 ++
 3 files changed, 133 insertions(+), 23 deletions(-)

