Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA779C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiJBS2n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiJBS2l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:28:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00DA3BC69
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:28:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C7EC60EFD
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC161C433C1;
        Sun,  2 Oct 2022 18:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735320;
        bh=GGD5ZPc54hxoJliGWzUhRXYx1XixpjDTNV9pdH7e374=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Is8P+fLLjn2kUhKsisAG69MvXo359lA/l5VrXPJQv+uC+g7r1m0Y47jQo5JbRtdGW
         cRmr0u22i4QhwDRW6O/O2e9Qd8RHov4OzUG0UBB5HGhdsHPGtaGybGjjJNidNXwQ8B
         szdYTksPzzV8nBu+LDMM8nS17DWJg8+BMUZEJnhcIxDYWF4RwA6fvQukBu7z4VzqOZ
         ChhA2kmEFnM0vOFgMoEYtPfxThFKR5B9fV/W/Da6zv9IbSK4+xR4wL9dFRG3kAegfZ
         iPB5QHW14i1OeLUSRZjlIdWiZ/IIMwHYnCargJqm3e6NxWvJRLZJA850HpKnzomqx+
         2JjKAk1737stw==
Subject: [PATCH 1/4] xfs: return EINTR when a fatal signal terminates scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:55 -0700
Message-ID: <166473479526.1083393.2162985380296325620.stgit@magnolia>
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

If the program calling online fsck is terminated with a fatal signal,
bail out to userspace by returning EINTR, not EAGAIN.  EAGAIN is used by
scrubbers to indicate that we should try again with more resources
locked, and not to indicate that the operation was cancelled.  The
miswiring is mostly harmless, but it shows up in the trace data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 454145db10e7..b73648d81d23 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -25,7 +25,7 @@ xchk_should_terminate(
 
 	if (fatal_signal_pending(current)) {
 		if (*error == 0)
-			*error = -EAGAIN;
+			*error = -EINTR;
 		return true;
 	}
 	return false;

