Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A605C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiJBS3Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJBS3P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:29:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3F93BC69
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:29:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD7E0B80D86
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBD0C433D6;
        Sun,  2 Oct 2022 18:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735351;
        bh=rWscwKe9O9wWhic5H7sbCAmsRx6CIzNUizl4pLbEMvI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Pa3+pAXne1NEU4SSPZqXRF5qfExINxR4pemUTiQ8YtgqlZqFUdt5RWVuUP16DElbn
         XipN90w80x357grdeleBiEmfN40wIvbW+25ESfdz+izZlNajd/rJAVAqntToWF67Js
         U9GoGtjY2YFgXnRyCTU/DWl4rRXAf2ywcBMJDtNqn2vUk5OFwe3lmkM4oWIJDZ4HA4
         IAGB6NLeYaJ+TB4u/gTExPWaqkZwRMsi+NJZu00THZ/IH/xZag+pD/Zc1VzwoHOj8y
         hh9qsfyqxcSyiPuM2k50iCvOx4xRm7CNk5DriXa3QfPgt+xm49p8lGNPyx7rc9lpbh
         UP2HZVQw4jS+A==
Subject: [PATCH 4/4] xfs: don't return -EFSCORRUPTED from repair when
 resources cannot be grabbed
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:55 -0700
Message-ID: <166473479567.1083393.7668585289114718845.stgit@magnolia>
In-Reply-To: <166473479505.1083393.7049311366138032768.stgit@magnolia>
References: <166473479505.1083393.7049311366138032768.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we tried to repair something but the repair failed with -EDEADLOCK or
-EAGAIN, that means that the repair function couldn't grab some resource
it needed and wants us to try again.  If we try again (with TRY_HARDER)
but still can't do it, exit back to userspace, since xfs_scrub_metadata
requires xrep_attempt to return -EAGAIN.

This makes the return value diagnostics look less weird, and fixes a
wart that remains from very early in the repair implementation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f6c4cb013346..34fc0dc5f200 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -69,9 +69,9 @@ xrep_attempt(
 		/*
 		 * We tried harder but still couldn't grab all the resources
 		 * we needed to fix it.  The corruption has not been fixed,
-		 * so report back to userspace.
+		 * so exit to userspace.
 		 */
-		return -EFSCORRUPTED;
+		return 0;
 	case -EAGAIN:
 		/* Repair functions should return EDEADLOCK, not EAGAIN. */
 		ASSERT(0);

