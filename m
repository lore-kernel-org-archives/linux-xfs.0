Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99075EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbjG0W3R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbjG0W3Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:29:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49592D63
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42BCC61EBC
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F34DC433C7;
        Thu, 27 Jul 2023 22:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496954;
        bh=lFIgCWK/IrnIdOVEYUYIhux5c03MjjvKOJqpfxVk9GI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=c9oVKu4DcTko7w616cUq6X0yzhvt1dTrV9CD8A2t1sYvezbf04DfJcWv1dbkdYEYc
         T6NG6F0zvzgE6hl2pu5VvwTfczJSJyNR+Ghy2UtRDWkPXd3NnGkrzJ9eJpgN3GifAJ
         97+7QYL6D+GKoh7h3aLQjylJu5nKlwfymhKqz5SyNnzLN4s9yaNVlv3jjhT3jrhw6U
         3tJhRtPFS/Q5G7XjjSnu2qauJRbTLB0nYsYYCJ5Muy9ouSuZGNR8gbPqh8uuKGUO7D
         MZqG0lDNDJqCp0GVlTX1zEHyj4uxsZGZsPEtocH+wRWJvMD17/+zfwZssyxKFD1BJZ
         yFpI2buajVOQA==
Date:   Thu, 27 Jul 2023 15:29:14 -0700
Subject: [PATCH 2/2] xfs: allow the user to cancel repairs before we start
 writing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049624694.921955.17547336213821473858.stgit@frogsfrogsfrogs>
In-Reply-To: <169049624664.921955.12084246901012682213.stgit@frogsfrogsfrogs>
References: <169049624664.921955.12084246901012682213.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

All online repair functions have the same structure: walk filesystem
metadata structures gathering enough data to rebuild the structure,
stage a new copy, and then commit the new copy.

The gathering steps do not write anything to disk, so they are peppered
with xchk_should_terminate calls to avoid softlockup warnings and to
provide an opportunity to abort the repair (by killing xfs_scrub).
However, it's not clear in the code base when is the last chance to
abort cleanly without having to undo a bunch of structure.

Therefore, add one more call to xchk_should_terminate (along with a
comment) providing the sysadmin with the ability to abort before it's
too late and to make it clear in the source code when it's no longer
convenient or safe to abort a repair.   As there are only four repair
functions right now, this patch exists more to establish a precedent for
subsequent additions than to deliver practical functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/agheader_repair.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 7874ae8149caa..d54edd0d8538d 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -50,6 +50,10 @@ xrep_superblock(
 	if (error)
 		return error;
 
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
 	/* Copy AG 0's superblock to this one. */
 	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
@@ -425,6 +429,10 @@ xrep_agf(
 	if (error)
 		return error;
 
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
 	/* Start rewriting the header and implant the btrees we found. */
 	xrep_agf_init_header(sc, agf_bp, &old_agf);
 	xrep_agf_set_roots(sc, agf, fab);
@@ -749,6 +757,10 @@ xrep_agfl(
 	if (error)
 		goto err;
 
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		goto err;
+
 	/*
 	 * Update AGF and AGFL.  We reset the global free block counter when
 	 * we adjust the AGF flcount (which can fail) so avoid updating any
@@ -996,6 +1008,10 @@ xrep_agi(
 	if (error)
 		return error;
 
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
 	/* Start rewriting the header and implant the btrees we found. */
 	xrep_agi_init_header(sc, agi_bp, &old_agi);
 	xrep_agi_set_roots(sc, agi, fab);

