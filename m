Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7D1C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  1 May 2023 21:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjEAVYh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 May 2023 17:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjEAVYg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 May 2023 17:24:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE48173C
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 14:24:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68B5E61F97
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 21:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4AAC433EF;
        Mon,  1 May 2023 21:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682976274;
        bh=MIVpH+igFd8WsYlG0BS22I3OLLcuNYMptFvxjlNzp/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LbA+AdyAIJkxbPVnkxrHYSOQ/n/g80pmxEykFAANOGUq7IYtQ5moXfcTmsmj7RP9C
         1dJf811Fprxi77WvGytq2mbf140C/RVIVJyGvFg/lUHmGWPBGoUfoE/2R9h3Wphooy
         t7U5s2bVyMEb2P53gmXO4rdb9rvVqiQ8qJESL98hTl+YbiuLx9V0CUaiYn7AKYwGWZ
         FGRTZ519pRchcfhuOYc19o4/lImj5oki9Z7StzSxpYtL9iOq4i3qN1Zd8CilHGNx11
         tYcQElYsrY9lSu3ZnmgJBTxWHPANC8EtBVyntaIbTq8M7RSEI6gQWwN10UowqSCOvP
         +y5oMUsRjML4A==
Date:   Mon, 1 May 2023 14:24:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        yebin10@huawei.com
Subject: [PATCH 5/4] xfs: fix negative array access in xfs_getbmap
Message-ID: <20230501212434.GM59213@frogsfrogsfrogs>
References: <168296561299.290030.5324305660599413777.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168296561299.290030.5324305660599413777.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit 8ee81ed581ff, Ye Bin complained about an ASSERT in the bmapx
code that trips if we encounter a delalloc extent after flushing the
pagecache to disk.  The ioctl code does not hold MMAPLOCK so it's
entirely possible that a racing write page fault can create a delalloc
extent after the file has been flushed.  The proposed solution was to
replace the assertion with an early return that avoids filling out the
bmap recordset with a delalloc entry if the caller didn't ask for it.

At the time, I recall thinking that the forward logic sounded ok, but
felt hesitant because I suspected that changing this code would cause
something /else/ to burst loose due to some other subtlety.

syzbot of course found that subtlety.  If all the extent mappings found
after the flush are delalloc mappings, we'll reach the end of the data
fork without ever incrementing bmv->bmv_entries.  This is new, since
before we'd have emitted the delalloc mappings even though the caller
didn't ask for them.  Once we reach the end, we'll try to set
BMV_OF_LAST on the -1st entry (because bmv_entries is zero) and go
corrupt something else in memory.  Yay.

I really dislike all these stupid patches that fiddle around with debug
code and break things that otherwise worked well enough.  Nobody was
complaining that calling XFS_IOC_BMAPX without BMV_IF_DELALLOC would
return BMV_OF_DELALLOC records, and now we've gone from "weird behavior
that nobody cared about" to "bad behavior that must be addressed
immediately".

Maybe I'll just ignore anything from Huawei from now on for my own sake.

Reported-by: syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-xfs/20230412024907.GP360889@frogsfrogsfrogs/
Fixes: 8ee81ed581ff ("xfs: fix BUG_ON in xfs_getbmap()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f032d3a4b727..fbb675563208 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -558,7 +558,9 @@ xfs_getbmap(
 		if (!xfs_iext_next_extent(ifp, &icur, &got)) {
 			xfs_fileoff_t	end = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
 
-			out[bmv->bmv_entries - 1].bmv_oflags |= BMV_OF_LAST;
+			if (bmv->bmv_entries > 0)
+				out[bmv->bmv_entries - 1].bmv_oflags |=
+								BMV_OF_LAST;
 
 			if (whichfork != XFS_ATTR_FORK && bno < end &&
 			    !xfs_getbmap_full(bmv)) {
