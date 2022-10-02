Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7989C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiJBS3F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJBS3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:29:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDF93BC69
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:29:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8954CE0A24
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F106C433D6;
        Sun,  2 Oct 2022 18:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735341;
        bh=SNJJyXa16c20+r8aBen3gt44QumV8R9/SRDIG+//sYg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KWTsEG6kQmQjUwVGKVednpN7rm1ElwXL33orwFvlQaL5CX8CjdTXAmroXE5GZPqz4
         TaIwXSriB+Vry1MtJE87hRgBas0CbZ635Zv4nqLgl+suk0ZuwZHkmXxQNY1WQOtBOY
         jRRLSs2M3EQhv4q6CnE2US6PrIg6CTZPK1gVG1eBSRLNGyVrAXvQkWkjUbBTtaprVM
         W+EFNmKPNsxl+75o88r6hnwJYVrT5n4K8tSlPq6xmsEExtNv6KYdNNLgOAJtszFv3C
         pzxSPoNujDEP+xthbMhrPfRR/9qMZkW2bLvXfxEPR8LX/uTSBOA4vbwZtVP2AB9vdB
         Du0J4JfPpjYHQ==
Subject: [PATCH 3/4] xfs: don't retry repairs harder when EAGAIN is returned
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:55 -0700
Message-ID: <166473479553.1083393.17251197615976928220.stgit@magnolia>
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

Repair functions will not return EAGAIN -- if they were not able to
obtain resources, they should return EDEADLOCK (like the rest of online
fsck) to signal that we need to grab all the resources and try again.
Hence we don't need to deal with this case except as a debugging
assertion.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 92c661b98892..f6c4cb013346 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -61,7 +61,6 @@ xrep_attempt(
 		sc->flags |= XREP_ALREADY_FIXED;
 		return -EAGAIN;
 	case -EDEADLOCK:
-	case -EAGAIN:
 		/* Tell the caller to try again having grabbed all the locks. */
 		if (!(sc->flags & XCHK_TRY_HARDER)) {
 			sc->flags |= XCHK_TRY_HARDER;
@@ -73,6 +72,10 @@ xrep_attempt(
 		 * so report back to userspace.
 		 */
 		return -EFSCORRUPTED;
+	case -EAGAIN:
+		/* Repair functions should return EDEADLOCK, not EAGAIN. */
+		ASSERT(0);
+		fallthrough;
 	default:
 		return error;
 	}

