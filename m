Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4EEC001DB
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 02:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjHHClC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 22:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjHHClB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 22:41:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4E41BE7
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 19:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83D43620A1
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 02:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3214C433C7
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 02:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691462430;
        bh=J9IXgE1CO/JvZQ69m+OiZ5hKDRUGn5npSi26fpE/M1k=;
        h=Date:From:To:Subject:From;
        b=sZQt2NH3Nz4mt07jhRcPRrX7YL+oj7DuwLpcdz+EQZbQHL4SwybkxUPLH4cPFvqOG
         DspWIsdLiWnV9+45hN34jbUUwuFi7yqLSVGmTcL/wgPz6nSsIOimjYrS0bLfep7UHY
         MzpLUEcg5Bc47pooeRnmXkDt8+roSujCn/yxPLUxsAmvGOIU4b3OrJyMwTs3SnY7pW
         l12/lT56Te0zLcWP6o66RHfUHgdm5Dh/KiB50RjGMdR7bQzFWUiQbA8e/FWI3/NGPY
         eXwssgQXDAc84wkorhIfAsmB91QQ4OYMB9q9SireT16qRaokEkNdPFp1ueU0ffQdii
         tdHkesmMy7bmw==
Date:   Mon, 7 Aug 2023 19:40:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix dqiterate thinko
Message-ID: <20230808024030.GP11352@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For some unknown reason, when I converted the incore dquot objects to
store the dquot id in host endian order, I removed the increment here.
This causes the scan to stop after retrieving the root dquot, which
severely limits the usefulness of the quota scrubber.  Fix the lost
increment, though it won't fix the problem that the quota iterator code
filters out zeroed dquot records.

Fixes: c51df7334167e ("xfs: stop using q_core.d_id in the quota code")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 17c64b7b91d02..9e6dc5972ec68 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1458,7 +1458,7 @@ xfs_qm_dqiterate(
 			return error;
 
 		error = iter_fn(dq, type, priv);
-		id = dq->q_id;
+		id = dq->q_id + 1;
 		xfs_qm_dqput(dq);
 	} while (error == 0 && id != 0);
 
