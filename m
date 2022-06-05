Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D7FC433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jun 2022 16:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351276AbiFEQkI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jun 2022 12:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348621AbiFEQkG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jun 2022 12:40:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD8B4DF56
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 09:40:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43B206111C
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 16:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE33C385A5;
        Sun,  5 Jun 2022 16:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654447203;
        bh=n9ofTU4pQHeVguD/JImnbRXMWFmxigSFdytFs1SO8mE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mO4mmfodO/ayKmB0vzGxh3Erk3GVIO23FdYG3fv3Kww+u5Cyum7YWvqsO9PDEOLwh
         TnhCr5jjBAWGbT0/aR+/Z97KeyaYFQbIyOmTiqJWg5+ssIaK3w26B994Nv38UzN8VP
         TvO04yYPWX7wfLmiNJumTab5b4Gcp3u4vWf85al/jLeyQpVFjoOjiPboSYPpfC61Ey
         RuHPg3RukkyUMmqIcElzYd/1B5Oueq8hjQMFp5zY2w8PYSpYoIUsONq9Y5w61J7msv
         KaPBXNY4U5dMfKwHGK4XubuAbDXRDcTjeCg94sWbu+8D09rPM9wSHJtIV8UdRIkEP9
         IOkX55piqqf3g==
Date:   Sun, 5 Jun 2022 09:40:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: fix variable state usage control knob
Message-ID: <YpzcY0ockNGsv5PR@magnolia>
References: <YpzbrQdA9voYKRCE@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YpzbrQdA9voYKRCE@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The variable @args is fed to a tracepoint, and that's the only place
it's used.  This is fine for the kernel, but for userspace, tracepoints
are #define'd out of existence, which results in this warning on gcc
11.2:

xfs_attr.c: In function ‘xfs_attr_node_try_addname’:
xfs_attr.c:1440:42: warning: unused variable ‘args’ [-Wunused-variable]
 1440 |         struct xfs_da_args              *args = attr->xattri_da_args;
      |                                          ^~~~

Clean this up.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 836ab1b8ed7b..acbd7dbd2281 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1439,12 +1439,11 @@ static int
 xfs_attr_node_try_addname(
 	struct xfs_attr_intent		*attr)
 {
-	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = attr->xattri_da_state;
 	struct xfs_da_state_blk		*blk;
 	int				error;
 
-	trace_xfs_attr_node_addname(args);
+	trace_xfs_attr_node_addname(state->args);
 
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
