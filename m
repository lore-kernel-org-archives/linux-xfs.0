Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D8DEB64DA
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 01:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjFPBhk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 21:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFPBhi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 21:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E496294A
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 18:37:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07EBB61B41
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 01:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52ACDC433C8;
        Fri, 16 Jun 2023 01:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686879456;
        bh=CVOhAlTPIXQOBDzV2MpCLskBQLd4LoZojxSnZ3uCys8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=B7C7tF7h/zi8D0B81tXojVK3IQ8CvbXQ8fKOfWcjuxxMuTkg3Ngrx/55iOCkqWdsj
         Y1Ww2oo6KlkW+Avdoop0M9VJp4x8vPW4r6KzM7TRcofj335Xo0UCjma96lbZQ8tgNA
         P8aG3cZ6dIkykvrvHgELvMfz62fhsqD4AJDFuv8Krb8mAwG4Gk1kNfD4iBjrukDkS2
         +50y6ix9N2Yc/eFhYEXW1UYl0MJTtvC456LJDj6v8F+vZNKzC4qPmLuFfeo/I4+2I3
         1GmAHclZ/BWLyQpQVXGe7/HFQ5S8irMQ2pAK7tG08g0bIvqlj7F/mPI7J6SsYQqBez
         YFuycApA307nw==
Subject: [PATCH 7/8] xfs: validity check agbnos on the AGFL
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Thu, 15 Jun 2023 18:37:35 -0700
Message-ID: <168687945573.831530.7630900598292491670.stgit@frogsfrogsfrogs>
In-Reply-To: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
References: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 3148ebf2c0782340946732bfaf3073d23ac833fa

If the agfl or the indexing in the AGF has been corrupted, getting a
block form the AGFL could return an invalid block number. If this
happens, bad things happen. Check the agbno we pull off the AGFL
and return -EFSCORRUPTED if we find somethign bad.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_alloc.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 229b22e6..40a36efa 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2776,6 +2776,9 @@ xfs_alloc_get_freelist(
 	 */
 	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
 	bno = be32_to_cpu(agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
+	if (XFS_IS_CORRUPT(tp->t_mountp, !xfs_verify_agbno(pag, bno)))
+		return -EFSCORRUPTED;
+
 	be32_add_cpu(&agf->agf_flfirst, 1);
 	xfs_trans_brelse(tp, agflbp);
 	if (be32_to_cpu(agf->agf_flfirst) == xfs_agfl_size(mp))

