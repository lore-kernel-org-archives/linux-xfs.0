Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AB8C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 17:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381094AbiDTRcZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 13:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381104AbiDTRcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 13:32:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668C847058
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 10:29:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5E1BFCE1F59
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 17:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948FEC385A1;
        Wed, 20 Apr 2022 17:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650475768;
        bh=nHL7r0DRh78hPHTBd8gH/IrK1+lOcqTH8Vmu1y2QUcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t7vbu1pmVrYShKDY7dnKRPebzIdx71YNgkaZC0k9k8KLJq5ebOrivs1H08PEduRZG
         Z4EOrUTSqhbgZUb2g1uq0HKLXUmosIrirZTP2hfVVEJrzPWCIUr3TNjWr9Xy53Mp6z
         kJlxM00th8VSzV5Fs1CPA37ByLo6qrN8JQpvUS9Aq0q6/D0hG2YCEbI+iwbx0cXGBQ
         ESD4PMB5YLhIv/dTFj9KwGzjLsyiWrkGNwG/rpkBhd6E8gPDxLqtTKq0SZBUoYvkQU
         gA0TYd+mUo9QNRwAWPy8geb3fWTFb62AWdaf5deKasKF8ww9Q6QqTqVTSSb73ztGT3
         Ui7lkfMBmoUxg==
Date:   Wed, 20 Apr 2022 10:29:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [PATCH v1.1 6/4] mkfs: round log size down if rounding log start up
 causes overflow
Message-ID: <20220420172928.GS17025@magnolia>
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

This can be reproduced with:
mkfs.xfs -dsu=44k,sw=1,size=300m,file,name=fsfile -m rmapbt=0
and:
mkfs.xfs -dsu=48k,sw=1,size=512m,file,name=fsfile -m rmapbt=0

Reported-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b932acaa..01d2e8ca 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3234,6 +3234,15 @@ _("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
 	/* round up/down the log size now */
 	align_log_size(cfg, sunit, max_logblocks);
 
+	/*
+	 * If the end of the log has been rounded up past the end of the AG,
+	 * reduce logblocks by a stripe unit to try to get it back under EOAG.
+	 */
+	if (!libxfs_verify_fsbext(mp, cfg->logstart, cfg->logblocks) &&
+	    cfg->logblocks > sunit) {
+		cfg->logblocks -= sunit;
+	}
+
 	/* check the aligned log still starts and ends in the same AG. */
 	if (!libxfs_verify_fsbext(mp, cfg->logstart, cfg->logblocks)) {
 		fprintf(stderr,
