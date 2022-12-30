Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E42C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiL3XFK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiL3XFJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:05:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BAEE1CFC6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:05:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDE5C61A32
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28324C433EF;
        Fri, 30 Dec 2022 23:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441508;
        bh=HGyrroGrJI7aUgo3ZK+JTmifZ/fQ1imNbUDDsNyaMgU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eezDVN7rxxEmR/kHTemGn6rda9g7hJJAp2FaDtrEFvz0+zbNX65iMtL3BVbohp8Gj
         gwUPorn11rBSZe5U0Lor06KY78NBj86u8+tTgxXHKM+HJc8oU4rbpHb+pxNf+V5qwQ
         W6mJAP59yUPD4u3DSfgQF4y61McgONP7iJWDBn69/9EQcQ7YSi+7QAfAY1Z9/Pm8Kw
         kY+8o26WRWNNNBUfd19MitIbNPKQ2xQ92UVbiyTA9+bu+evGKFTTP+T9vu3VMG+7/J
         rx5a1nFW74mdTgvpRgsuLOlRelAcRG9yMX8HuAgpEqq7HAjyggcXUPpvJ/V/DTS2yN
         ALZKALTXAH3Ug==
Subject: [PATCHSET v24.0 0/3] xfs: bmap log intent cleanups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:41 -0800
Message-ID: <167243842121.698982.2011083519163197266.stgit@magnolia>
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

