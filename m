Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0F2C7EE2D
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 17:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjCCRLX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjCCRLW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 12:11:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A458A1C33E
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 09:11:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46D70B81907
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 17:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03EDC433EF;
        Fri,  3 Mar 2023 17:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677863478;
        bh=NvWpO+h/eXlqE+iGY/HgaJ5alEyWdW9h26PLoG8SOZ8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MMxBbOz8fQJC0yQppYf8mx0VFwV27WjF+wjMdO4hYS9BtjrK1SoSq2LlNGt/dFYAg
         jzSQt7wN4Mf0KtOC4gILgtXu6S8TfKoGOm9mUxSdCtdYTV4vY1bFCT20ty5nF4Hxhg
         yDnQH8rSxZnq74u67reZnnCvsh833VaaYcSAwUcYBpmvGYa1QuP2q0u9CDiOcqHlrI
         DQOGsel4P/HIHHlPq5fcoTsaQiTEr8mZyiAl4dM5nHyKad4LVftfWz3fzG57Icawxt
         o1e60h51zvz5YTlaVhlS83e4jZhtDmBv/0yTWQtz+TiKkRVGF+7vjhuUD/fmYaib0c
         ajIzPEkPdR7tw==
Subject: [PATCHSET v9r2d1.1 00/13] xfs: remove parent pointer hashing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Date:   Fri, 03 Mar 2023 09:11:18 -0800
Message-ID: <167786347827.1543331.2803518928321606576.stgit@magnolia>
In-Reply-To: <167657875861.3475422.10929602650869169128.stgit@magnolia>
References: <167657875861.3475422.10929602650869169128.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Dave Chinner pointed out (a bit too subtly) that hashing the dirent name
to try to squash it into the parent pointer xattr name is unnecessary
because we could simply make the xattr matching predicate compare names.
Do that instead and drop the hashing.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-vlookup

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-vlookup
---
 fs/xfs/Kconfig                 |    1 
 fs/xfs/libxfs/xfs_attr.c       |   39 +++--
 fs/xfs/libxfs/xfs_attr_leaf.c  |   41 +++++
 fs/xfs/libxfs/xfs_da_btree.h   |    6 +
 fs/xfs/libxfs/xfs_da_format.h  |   34 ++---
 fs/xfs/libxfs/xfs_log_format.h |   30 +++-
 fs/xfs/libxfs/xfs_parent.c     |  302 +++++++++++++---------------------------
 fs/xfs/libxfs/xfs_parent.h     |   16 --
 fs/xfs/libxfs/xfs_trans_resv.c |    1 
 fs/xfs/scrub/dir.c             |   38 +----
 fs/xfs/scrub/parent.c          |   61 +-------
 fs/xfs/scrub/parent_repair.c   |   34 +----
 fs/xfs/xfs_attr_item.c         |  217 ++++++++++++++++++++---------
 fs/xfs/xfs_attr_item.h         |    3 
 fs/xfs/xfs_linux.h             |    1 
 fs/xfs/xfs_mount.c             |   13 --
 fs/xfs/xfs_mount.h             |    3 
 fs/xfs/xfs_ondisk.h            |    3 
 fs/xfs/xfs_sha512.h            |   42 ------
 fs/xfs/xfs_super.c             |    3 
 fs/xfs/xfs_xattr.c             |    5 +
 21 files changed, 383 insertions(+), 510 deletions(-)
 delete mode 100644 fs/xfs/xfs_sha512.h

