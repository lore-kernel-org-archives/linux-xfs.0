Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D507C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Apr 2022 23:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243579AbiDPAAa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Apr 2022 20:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbiDPAA3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Apr 2022 20:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322CD95A1A
        for <linux-xfs@vger.kernel.org>; Fri, 15 Apr 2022 16:58:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC4C460E33
        for <linux-xfs@vger.kernel.org>; Fri, 15 Apr 2022 23:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3877BC385A4;
        Fri, 15 Apr 2022 23:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650067079;
        bh=QTM7U56FxNNX5SP6cf0JmKgInBvEo90G9IZwPdueMYg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dGEFIiJT8YTGvBxQC+C8sRTiW4d4FldLeIu87zD98Jc9Dq2wzhqmyfB5hmzBuLmuB
         QTZFtDixIdtYH3Pge/omfJIryDKgDvlA+m2tMwP9hP7Aj3jLYcgCyTLtA7JK7cVBtC
         aYK7ip4KrtjBUrkBEttKtUM/Ys8+d2HJ+0xx1BbwbZERTdBRXdPCYfRq1jNXLmB0OY
         TY6pFdh0T5PwICEVXH2abF+NOdPFbIcK4OGpwq9drvFGtquVaZFjSmX4lHy6nYRXIT
         QOQ1V+dAvGeSvP9OdMve4TUAxXrDZ2qN9/lNfnROQUrEPpU8V9F0Z18Js9TmkR4yw5
         fmv0fEF5/E+4Q==
Date:   Fri, 15 Apr 2022 16:57:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [PATCH 6/4] mkfs: round log size down if rounding log start up
 causes overflow
Message-ID: <20220415235758.GE17025@magnolia>
References: <164996213753.226891.14458233911347178679.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164996213753.226891.14458233911347178679.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If rounding the log start up to the next stripe unit would cause the log
to overrun the end of the AG, round the log size down by a stripe unit.
We already ensured that logblocks was small enough to fit inside the AG,
so the minor adjustment should suffice.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b932acaa..cfa38f17 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3219,9 +3219,19 @@ align_internal_log(
 	int			max_logblocks)
 {
 	/* round up log start if necessary */
-	if ((cfg->logstart % sunit) != 0)
+	if ((cfg->logstart % sunit) != 0) {
 		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
 
+		/*
+		 * If rounding up logstart to a stripe boundary moves the end
+		 * of the log past the end of the AG, reduce logblocks to get
+		 * it back under EOAG.
+		 */
+		if (!libxfs_verify_fsbext(mp, cfg->logstart, cfg->logblocks) &&
+		    cfg->logblocks > sunit)
+			cfg->logblocks -= sunit;
+	}
+
 	/* If our log start overlaps the next AG's metadata, fail. */
 	if (!libxfs_verify_fsbno(mp, cfg->logstart)) {
 		fprintf(stderr,
