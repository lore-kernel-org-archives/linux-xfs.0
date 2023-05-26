Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F494C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjEZCAf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjEZCAe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:00:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0478118D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:00:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D40B6179C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F279CC433D2;
        Fri, 26 May 2023 02:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066433;
        bh=ip+gv8hhZctsjyyXp62PzwD3+JQsu3k/R3V1Hy3Up7Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=kZhjkIadfgLKiwy1U7dtUjmyYA1xUawHRTSJlavXz8oJWIF2Xx+RTvB/7CTsbafSd
         XsmCK7yRjereoEDcil/ck5mvda4UaYMN8dl6eEy5/E7w8ZTqs6G6gSTBa2CxqJQCxG
         ZNP4/fg4bERKzkiLI1iMGjVj6U+GLi68eOQsUI/YbxTTHEvBQOudUTzCz2c+sHGrvc
         alXrMTv9/BxQnpQ3bUgKaeuB7d0Rp9Ee+CBeWvQavgw9Ps6gVce5wMXiuIP8DZLNCQ
         VNPHPII1gwam5MkCHYVA8v2T2IzpLgV8BB5vHnO+FCxHnnEGW5FMY8p7hRZOaas62x
         hDbUGZJy9hshw==
Date:   Thu, 25 May 2023 19:00:32 -0700
Subject: [PATCHSET v12.0 00/12] xfs: name-value xattr lookups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072168.3743652.12378764451724622618.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_attr.c       |   57 +++++--
 fs/xfs/libxfs/xfs_attr.h       |    9 +
 fs/xfs/libxfs/xfs_attr_leaf.c  |   45 ++++-
 fs/xfs/libxfs/xfs_da_btree.h   |   10 +
 fs/xfs/libxfs/xfs_log_format.h |   29 +++
 fs/xfs/xfs_attr_item.c         |  347 ++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_attr_item.h         |    2 
 fs/xfs/xfs_xattr.c             |    5 +
 8 files changed, 425 insertions(+), 79 deletions(-)

