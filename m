Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14D9C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiJBS2x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJBS2w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:28:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895233C14A
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:28:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 269CD60EFD
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867C5C433D6;
        Sun,  2 Oct 2022 18:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735330;
        bh=2r8RzCXwg7940uv6Ay3siyLNgL51/fij53Fqzj6SR+c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZJB84KWZGg+A0iD6HJMymTmNHcvvOY5TsI+3nZiPptpc1Z4mri0/y1TNLYPs1VGx0
         tdWX1JmfIclLhBYOooNxWb4LlfkjaOZJRhSTDW7EVUtMN3P20YMQAtf6Rh0qtGLjFA
         baXbT98ZSsQIrpQXMnJE6cOC9m+jWmTU0q2S5LmxZ2oZe5EEgK35XDmIDRBYo3L+RD
         QmLB4BM67uPdaCC6biE8+Ta30Sp3yD3XynsR41ivrJqtPdanZO+NUd0t83844ApwcH
         V4l2yucMI3ouSNJjaTkVunrTIFraDOxZ5J9WTSHw0pZJMjX25JTB8nsHf9YM5yvrbH
         39uRmrOIVFUgA==
Subject: [PATCH 2/4] xfs: fix return code when fatal signal encountered during
 dquot scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:55 -0700
Message-ID: <166473479539.1083393.2779029008005184154.stgit@magnolia>
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

If the scrub process is sent a fatal signal while we're checking dquots,
the predicate for this will set the error code to -EINTR.  Don't then
squash that into -ECANCELED, because the wrong errno turns up in the
trace output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/quota.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 21b4c9006859..0b643ff32b22 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -84,7 +84,7 @@ xchk_quota_item(
 	int			error = 0;
 
 	if (xchk_should_terminate(sc, &error))
-		return -ECANCELED;
+		return error;
 
 	/*
 	 * Except for the root dquot, the actual dquot we got must either have

