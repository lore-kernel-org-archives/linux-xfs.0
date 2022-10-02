Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B18C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiJBSYX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJBSYW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:24:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E4225295
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:24:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD2D9B80D7E
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFA9C433D6;
        Sun,  2 Oct 2022 18:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735058;
        bh=d/vTjAuabvZMW1h6fFpOAZmbCjxnjiMKDmDBFSX2eK4=;
        h=Subject:From:To:Cc:Date:From;
        b=qfE7EyKwvE9YXFpI5fC3FF425RGPUOdmhUyMwZ+6jmpHnkwhnykCAKjVjmhFif9nt
         VY4rWhhm6LBd3AUEuF+MUkjmNonHMK8ukISmBnwcPSI0VjbJ1SpoROrWamE3G9spBH
         2Gl+v+8QIS0qx0gXt9uQSpQsSWRlaPzVxAfgiT3IL5/+yDfs7uOneIQ8sp3ydDJFJm
         +TYk0MCTpx1T8R7xlQfm32SX6CQSqIg/aXymcJGEGtij1AJfm2rTdN8yJE7sj4/Nzt
         sPgE4ow4aC005toac4XxRsDrNJX8wukVh82UaOFbCmw1mzTwbdSepK8lyqF+43zPfR
         /HZ9D3B1fCoGg==
Subject: [PATCHSET v23.1 0/3] xfs: detect incorrect gaps in inode btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:19 -0700
Message-ID: <166473481949.1084372.14443532201653453226.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_ialloc.c |   82 ++++++++----
 fs/xfs/libxfs/xfs_ialloc.h |    5 -
 fs/xfs/scrub/ialloc.c      |  292 +++++++++++++++++++++++++++++++++++---------
 3 files changed, 281 insertions(+), 98 deletions(-)

