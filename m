Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E47C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbiL3XK1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiL3XK0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:10:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60DC2DC7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:10:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D81DB81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CB4C433EF;
        Fri, 30 Dec 2022 23:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441823;
        bh=yxCB5F6MIJ2oBOyNzQzK8PbX3HCkmvltVOuWWEDwIN0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a6gAECDGfGySbE5f7WDpPe77fHK5RkrqTNKGJrdh224eSxMS+7rSI04RzeT8wl9cq
         ozRZBsb7ChB36P3fIU4HlPSEe/HDW8/Sje53aDvzkwSKFe8RK/5gL84OqmU8nbx3o5
         2hkDppKV1NfRsa3vhDtxriN4K3O3Ckdk7GAiayNS3FWmdXdkUn64zaJXX+OYO/V06n
         iUZF9vReg35pR0AuSxZI1Y9+8wJXuRDXkAV9a55GmM1i9Osr+Rg2zOpDF4COAvdIec
         Z60V8AhTJry3Ok8JCn9ueEXZlNfxrXIgFz7qLbkUNNEgqoAYRed+LnKOLRGgZmCOh9
         /9WwtWSeBRdOg==
Subject: [PATCHSET v24.0 0/3] libxfs: online repair of file link counts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:35 -0800
Message-ID: <167243865502.709394.13215707195694339795.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Now that we've created the infrastructure to perform live scans of every
file in the filesystem and the necessary hook infrastructure to observe
live updates, use it to scan directories to compute the correct link
counts for files in the filesystem, and reset those link counts.

This patchset creates a tailored readdir implementation for scrub
because the regular version has to cycle ILOCKs to copy information to
userspace.  We can't cycle the ILOCK during the nlink scan and we don't
need all the other VFS support code (maintaining a readdir cursor and
translating XFS structures to VFS structures and back) so it was easier
to duplicate the code.


If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-nlinks

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-nlinks

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-nlinks
---
 libfrog/scrub.c                     |    5 +
 libxfs/xfs_da_format.h              |   11 +++
 libxfs/xfs_dir2.c                   |    6 ++
 libxfs/xfs_dir2.h                   |    1 
 libxfs/xfs_fs.h                     |    4 +
 libxfs/xfs_health.h                 |    4 +
 man/man2/ioctl_xfs_scrub_metadata.2 |    4 +
 repair/phase6.c                     |    4 -
 scrub/phase5.c                      |  136 +++++++++++++++++++++++++++++++++--
 scrub/scrub.c                       |   18 ++---
 scrub/scrub.h                       |    1 
 spaceman/health.c                   |    4 +
 12 files changed, 175 insertions(+), 23 deletions(-)

