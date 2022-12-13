Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7737CC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 19:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbiLMTjq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiLMTjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:39:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799D62098D
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 11:39:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1783F616F0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 19:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BC3C433EF;
        Tue, 13 Dec 2022 19:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670960383;
        bh=qmRG7PIMPfYUHLnV82WLXMzn07fOq0LM/4v+7MfFZOE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WwPHAtVnyeA/kHw3BdyXa6Nd5sUhSTZaUthJ+qdxubYXmGHpMPM8+VHKYrHJyeAVt
         VfoPA0b5k07T7oJMAukVYOkxjUIoFyQvw79D0iI14DDNeFP0rl+RaHSHoEFAY1U4Il
         h03fE5y8RqiO0lp7Z3Q0oGvYGL7UP13E8jgwrzuV2dpKk/OhQaQl8FcZxoMP3P3rux
         ITwaTIP5MZ8QwpIoJr22duSWFVK0YOqa9gNoe66QsahXYiGLIy0cBH36ZzovLyw8up
         iTBBPxncmdn2GJWPb1qK5unyR3LGbBSZRxQXvfZm+oAG3aRC8uCCDNH5cDDyOj7jc6
         4NPyTEb8qC46Q==
Subject: [PATCH 1/2] xfs_io: don't display stripe alignment flags for realtime
 files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 13 Dec 2022 11:39:43 -0800
Message-ID: <167096038305.1739636.16423852960443997377.stgit@magnolia>
In-Reply-To: <167096037742.1739636.10785934352963408920.stgit@magnolia>
References: <167096037742.1739636.10785934352963408920.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The stripe unit/width optimizations only occur on the data device, which
means that it makes no sense to report non-stripe-aligned realtime
extents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/fsmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/io/fsmap.c b/io/fsmap.c
index 9dd19cc04a9..7db51847e2b 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -197,7 +197,7 @@ dump_map_verbose(
 		    p->fmr_flags & FMR_OF_ATTR_FORK ||
 		    p->fmr_flags & FMR_OF_SHARED)
 			flg = 1;
-		if (sunit &&
+		if (sunit && p->fmr_device == xfs_data_dev &&
 		    (p->fmr_physical  % sunit != 0 ||
 		     ((p->fmr_physical + p->fmr_length) % sunit) != 0 ||
 		     p->fmr_physical % swidth != 0 ||
@@ -273,7 +273,7 @@ dump_map_verbose(
 		 * If striping enabled, determine if extent starts/ends
 		 * on a stripe unit boundary.
 		 */
-		if (sunit) {
+		if (sunit && p->fmr_device == xfs_data_dev) {
 			if (p->fmr_physical  % sunit != 0)
 				flg |= FLG_BSU;
 			if (((p->fmr_physical +

