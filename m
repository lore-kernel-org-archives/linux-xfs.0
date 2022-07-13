Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FF7CCA47F
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 01:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiGMBJ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 21:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiGMBJ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 21:09:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A59C9128
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 18:09:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1272E618CD
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 01:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65ABBC3411E;
        Wed, 13 Jul 2022 01:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657674594;
        bh=nbBf7JjaeNH12QruEGFcXfHUA8yI8IFv1NKFHvB9GTc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AATGEaOOBLEhNk4yi88hSAZB+yBWWJSJr3tzKm9k8hqX/T8PixpfOOBgRhus1k43X
         3+CiORTZPq9mJFfNJ4fskW1KD58iwlpQjxcqoaUy/SqXaWXyI2ViwW4iLPndRbuBnZ
         iDKiIGT6gQeOZrW8B8WqR7ezqtgoj9HZbPAVNCl8SOt8uR9jmMvyfoRb2qYF3bp2f2
         plSY8QpS0GCwbVj43y+KUGI23NwUJq9XX/npQLWJzwywn+CZNY1ZFGsNXCkFfdVlxC
         /kYiu2PSobF7DNceG+mlL/A/WecYSlzKgKUcPbvjMXINJQ5WFrRA6RZ5eqkn3lrOY5
         o888FFfoyvI0A==
Subject: [PATCH 3/4] mkfs: complain about impossible log size constraints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 12 Jul 2022 18:09:53 -0700
Message-ID: <165767459394.891854.2338822152912053034.stgit@magnolia>
In-Reply-To: <165767457703.891854.2108521135190969641.stgit@magnolia>
References: <165767457703.891854.2108521135190969641.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfs/042 trips over an impossible fs geometry when nrext64 is enabled.
The minimum log size calculation comes out to 4287 blocks, but the mkfs
parameters specify an AG size of 4096 blocks.  This eventually causes
mkfs to complain that the autoselected log size doesn't meet the minimum
size, but we could be a little more explicit in pointing out that the
two size constraints make for an impossible geometry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index db322b3a..61ac1a4a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3401,6 +3401,13 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 	 * an AG.
 	 */
 	max_logblocks = libxfs_alloc_ag_max_usable(mp) - 1;
+	if (max_logblocks < min_logblocks) {
+		fprintf(stderr,
+_("max log size %d smaller than min log size %d\n"),
+				max_logblocks,
+				min_logblocks);
+		usage();
+	}
 
 	/* internal log - if no size specified, calculate automatically */
 	if (!cfg->logblocks) {

