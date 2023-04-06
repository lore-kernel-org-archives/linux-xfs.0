Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A75EC7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240496AbjDFTN6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240337AbjDFTN5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:13:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8708EF2
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:13:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24B456365E
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801B7C4339E;
        Thu,  6 Apr 2023 19:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808435;
        bh=KjRXutpWEmyFUy74HDDoh0kBTL9s9B5Zdbh+mRSTy8g=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=FWwHkMkURTwp9JAxFver4LBVAZYrudIoTSnZUdcHyj9+GG8v4gPl+qa02yRw7iQwI
         5vXP+SHyE89Ep1T9861lcTI40UFEfDwVc30jv2EW8RYzLT2kVIjbJMg5CBXa3qPtAK
         fRH/aGZu7k1Vu8O7A1T24gD9tj6CMLOj2mgWzVKHTcj4LnYJswzvRyscni1jsnjPLg
         pNRci5pjj993lOSipqnjDkk3ljvpv4wjrHV0whoCQeOYoIFkdQVvmeWARL0LdaQ4l1
         8RZbrwf1ZqFDughjBbikxXoGg+Cas3x1nJNB2PwIJYR6+ynDlym0O1hTiMYO0XQtxk
         dfcs9jh/P3S9g==
Date:   Thu, 06 Apr 2023 12:13:55 -0700
Subject: [PATCHSET v11 00/12] xfs: name-value xattr lookups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080823794.613065.2971656278555515103.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_attr.c       |   57 +++++--
 fs/xfs/libxfs/xfs_attr.h       |    9 +
 fs/xfs/libxfs/xfs_attr_leaf.c  |   45 ++++-
 fs/xfs/libxfs/xfs_da_btree.h   |   10 +
 fs/xfs/libxfs/xfs_log_format.h |   30 +++
 fs/xfs/xfs_attr_item.c         |  347 ++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_attr_item.h         |    2 
 fs/xfs/xfs_xattr.c             |    5 +
 8 files changed, 425 insertions(+), 80 deletions(-)

