Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B52C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjDFTPq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjDFTPq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:15:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE2AC1
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27E696365E
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FAAC433EF;
        Thu,  6 Apr 2023 19:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808544;
        bh=F6R2PmF3QzFZNvajYraEE4gIFsIlBSFyzb49Sz5nKnI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=bhP2adgFyCQnHt4noJ6PEK2pg50pbSlxM3U4nTrFoPzcFecB/rZOLErVJW8ZfV1qf
         MZWxtMMYxMLVVt3RspRqy4ApZnlVCYQJ+qlLMXHM7R6/Shy/VeOplx4BHClIFCH/G0
         GAugNZEDhZk9C67ZCsq1+KcrmS5xNUXWO8Hu+/STVa5bnNEn+lu47bzx8LqquEuTtD
         DVrY9A9Us8yOtSbWp7p9WwluJZj7ZsiP1nqTQzo/04I3YcKdVbVWPkv/N8QcwdzaSH
         ZxRg5YPCknT/HXqOzqr3fKlw27l62fLBL9gc/PbgBIH3NfY63f8HZPrKlni3GiP4Ty
         4jV3sLuFiFsBQ==
Date:   Thu, 06 Apr 2023 12:15:44 -0700
Subject: [PATCHSET v11 00/10] xfs: name-value xattr lookups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827114.616519.13224581752144055912.stgit@frogsfrogsfrogs>
In-Reply-To: <20230406181038.GA360889@frogsfrogsfrogs>
References: <20230406181038.GA360889@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Directory parent pointers are stored as namespaced extended attributes
of a file.  Because parent pointers can consume up to 267 bytes of
space and xattr names are 255 bytes at most, we cannot use the usual
attr name lookup functions to find a parent pointer.  This is solvable
by introducing a new lookup mode that checks both the name and the
value of the xattr.

Therefore, introduce this new lookup mode.  Because all parent pointer
updates are logged, we must extend the xattr logging code to capture the
VLOOKUP variants, and restore them when recovering logged operations.
These new log formats are protected by the sb_incompat PARENT flag, so
they do not need a separate log_incompat feature flag.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-attr-nvlookups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-attr-nvlookups
---
 db/attrset.c            |    4 +
 libxfs/xfs_attr.c       |   57 ++++++++++++++-----
 libxfs/xfs_attr.h       |    9 ++-
 libxfs/xfs_attr_leaf.c  |   45 +++++++++++++--
 libxfs/xfs_da_btree.h   |   10 +++
 libxfs/xfs_log_format.h |   30 +++++++++-
 logprint/log_redo.c     |  138 ++++++++++++++++++++++++++++++++++++++---------
 logprint/logprint.h     |    6 +-
 8 files changed, 239 insertions(+), 60 deletions(-)

