Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549C0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbiLaBCx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBCw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:02:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FBE1DDE4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:02:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C28FB81E34
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0EEC433D2;
        Sat, 31 Dec 2022 01:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448568;
        bh=sifmTy5r0HhXqcBz3uOaf7Q5Ew2StoxyjXR0P4bP+Xc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uC4Q09qFQr+HdZdRJc3puCNBwcNgnhCCtSGS1YUqFCzmRZnzNRJVuuGk8Dj/GUxKH
         TnAjLMvoLhKI4gk5j0SSzD1mqd4sSU9QHCYbskDM2vuIFXlaUcnzgmWoNkKZZe8bic
         PVrmQNNGHelnu2IhvbyCWQScrnsewWXRpSmdOUiMfbd2nOWxPwmRgcorj7u7JkYJSA
         yTxfg/tMU4y+5mnFW6OR7uWhQCnCfKrujMHK/YX51cM/tWTgu/tW/lMA4VjCqm7Ooy
         FZuonyqXh/4uIcIyUrhH+f5k4QE2IQ03vxrEg9veEuYDk5UQ1g7V4hJqPrCPb+Y4iW
         xqy0rXYIHRHiA==
Subject: [PATCHSET v1.0 0/3] libxfs: reflink with large realtime extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:16 -0800
Message-ID: <167243881598.735065.1487919004054265294.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Now that we've landed support for reflink on the realtime device for
cases where the rt extent size is the same as the fs block size, enhance
the reflink code further to support cases where the rt extent size is a
power-of-two multiple of the fs block size.  This enables us to do data
block sharing (for example) for much larger allocation units by dirtying
pagecache around shared extents and expanding writeback to write back
shared extents fully.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink-extsize

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink-extsize

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink-extsize
---
 libxfs/init.c          |    7 -------
 libxfs/xfs_bmap.c      |   22 ++++++++++++++++++++++
 libxfs/xfs_inode_buf.c |   20 ++++++--------------
 mkfs/xfs_mkfs.c        |   37 -------------------------------------
 4 files changed, 28 insertions(+), 58 deletions(-)

