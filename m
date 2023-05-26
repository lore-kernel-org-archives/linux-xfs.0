Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0985EC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbjEZAuT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbjEZAuS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D401C12E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 704E6619B3
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D6DC433D2;
        Fri, 26 May 2023 00:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062216;
        bh=5jXpceOI7p8QU+X8F7d8i7Cu3PaTZvwnrbG4PbbYF/Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=umuaPAG3XdWM1UzN2vBbi46+x0UfAZO8434o9aEm2VvFXa/cWZIFaEtg9kzzierYR
         ghhRVMq5bxJATXctT+PCQUxrKpDk+e+OyXUXB2ou7svcJoemDLtgwA+z1HcgrFRHDz
         TU44zQSLuLJUWjtuQyNgWqyY9pTWz6ZTyR+/PERiI2CaXTsTMCh8ht84vKTDw2p9RB
         oSoCx4QPbLM+Rqn6zQ4DYv38B8ySoJ+orZ4wWuXmMaXjBbdm6POr9tUkNqOHiaYapx
         ScK3Xv0j6t6ii5aoN8GlIrOYFVpLw42o46QWw90EWF9rBVSJYU230j8l+l6ibpHOtg
         NruNAfQOYu9Lw==
Date:   Thu, 25 May 2023 17:50:16 -0700
Subject: [PATCH 2/2] xfs: allow the user to cancel repairs before we start
 writing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506057253.3730021.16355634028400743188.stgit@frogsfrogsfrogs>
In-Reply-To: <168506057223.3730021.15237048674614006148.stgit@frogsfrogsfrogs>
References: <168506057223.3730021.15237048674614006148.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/agheader_repair.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 7874ae8149ca..d54edd0d8538 100644
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

