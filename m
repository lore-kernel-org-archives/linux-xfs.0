Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB48C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjEZCBr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbjEZCBk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:01:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8220F19C
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11E0861298
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D9DC433D2;
        Fri, 26 May 2023 02:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066495;
        bh=1D+FEQ2U+O+LLvDuFoSPd/A8xq/9HSNxX7zL/xkGIPE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Dp/Z82qP/OGfZTx3UfsuUfiKAsIAGMAeaymXjHYxaTNQwVgNyY1ln+zVj///j2+s3
         sVE0z8n9+8GOGouj1RKf5QJchB7n+q7UjWMvJnG2Tk4XecP2H51331q/yuMsopG6jo
         Szo9BTAGhaGtbGpSIbNDuoNFTyiHSWRmXrKihp29IMjc8qQfCZdeEZcyEkymx5uIzt
         ksr42gti8hkyThm0WkIIVOwJiX8pdbY9tGGsgeQ+x2dh+s3npxB5747C+QF4vMIS3N
         +Cc8Ta8NpRzfYTbnP4iWAPi3a66Q6mihtUDWQ8sIPB9rM3hpwqORckzOTqWA/Q/cty
         9EXdVNI6rhrfA==
Date:   Thu, 25 May 2023 19:01:35 -0700
Subject: [PATCHSET v12.0 00/10] xfsprogs: name-value xattr lookups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000710.GG11642@frogsfrogsfrogs>
References: <20230526000710.GG11642@frogsfrogsfrogs>
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

--D

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
 libxfs/xfs_log_format.h |   29 +++++++++-
 logprint/log_redo.c     |  138 ++++++++++++++++++++++++++++++++++++++---------
 logprint/logprint.h     |    6 +-
 8 files changed, 239 insertions(+), 59 deletions(-)

