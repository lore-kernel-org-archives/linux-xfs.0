Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8301C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbjEZAdj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjEZAdj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:33:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0E3EE
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09AEE61B68
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AAEC433D2;
        Fri, 26 May 2023 00:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061217;
        bh=HGyrroGrJI7aUgo3ZK+JTmifZ/fQ1imNbUDDsNyaMgU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=EuQBSWUA2H1l+bdx8wPVsAs+orlPCLYNSmoGvc+BbbPuUER8LgQxvkecGI1KKLbh0
         inyzMXYzXOeNg6ilwR9SIbUGQ5b2ZrD9lkXiosN9HQpUW6oDhnYKAW9YXSuMS6zMoV
         8pfWu2Nv3qro5r/hpFvj7st7m8kWSZP8QvK2zidPVJxEBG9Z/hMo34MstgCRNGDOZ/
         W3mLGPWu8Uc6sK1ICNrvnFgFCb9KtFZMMQ3B3dvppKol9+ahW7qVnG/LuIUG2jq20l
         qTd+/lVSORkQK0dR8ND5kum891Hf1K59sQJpHtfpETaVUFavlTRcGnz05YUExd3/xP
         5cUZwSpCdEjXQ==
Date:   Thu, 25 May 2023 17:33:37 -0700
Subject: [PATCHSET v25.0 0/3] xfs: bmap log intent cleanups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506063487.3733930.3765429104183077810.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The next major target of online repair are metadata that are persisted
in blocks mapped by a file fork.  In other words, we want to repair
directories, extended attributes, symbolic links, and the realtime free
space information.  For file-based metadata, we assume that the space
metadata is correct, which enables repair to construct new versions of
the metadata in a temporary file.  We then need to swap the file fork
mappings of the two files atomically.  With this patchset, we begin
constructing such a facility based on the existing bmap log items and a
new extent swap log item.

This series cleans up a few parts of the file block mapping log intent
code before we start adding support for realtime bmap intents.  Most of
it involves cleaning up tracepoints so that more of the data extraction
logic ends up in the tracepoint code and not the tracepoint call site,
which should reduce overhead further when tracepoints are disabled.
There is also a change to pass bmap intents all the way back to the bmap
code instead of unboxing the intent values and re-boxing them after the
_finish_one function completes.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bmap-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bmap-intent-cleanups
---
 fs/xfs/libxfs/xfs_bmap.c |   19 +--
 fs/xfs/libxfs/xfs_bmap.h |    4 +
 fs/xfs/xfs_bmap_item.c   |   38 ++-----
 fs/xfs/xfs_trace.c       |    1 
 fs/xfs/xfs_trace.h       |  267 +++++++++++++++++++++++++++++-----------------
 5 files changed, 192 insertions(+), 137 deletions(-)

