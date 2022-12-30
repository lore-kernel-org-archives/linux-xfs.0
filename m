Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B86C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbiLaAjA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaAi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:38:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE701E3EE;
        Fri, 30 Dec 2022 16:38:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69CA761CF1;
        Sat, 31 Dec 2022 00:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CB7C433D2;
        Sat, 31 Dec 2022 00:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447136;
        bh=8uUp+jz76PhiBHJsOCR1Uj3kMa5h+L0eJ60EOdh5F/4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Fw5RiQCXrh5bTx9XGlw2q9T1Lg/F1ea9pVZCD0Y+g/wncPGPAY3RPuf8ZxM0X8jkj
         4rWoQdijtiE2+B58mHKuExKrH9MK6mwnlPIwHHPvezOJ6X3CyE5BdSJmLaRPOfr8d3
         4Zn8bEwvhMaf7JseCB/YDWsEm+O7Mr4gUlm9W/3bG3dLp85MZ0YDLAyCBI6vztxsd+
         dl/dVE0L3ZGD3pQ6Ar/l6cxHDcc+vULAnjXa0yUqAuZgX/DFyqKj75ErI9JPKDs0HB
         Yq57nQaK+ZxMIbuDUyauqymWNVzKLAV6+7SFqS/yZ24i5sveywblY5IQJsJkbs+ibr
         nL/bSJ/PSLH3g==
Subject: [PATCH 1/5] xfs/357: switch fuzzing to agi 1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:06 -0800
Message-ID: <167243874627.722028.4085306307237352574.stgit@magnolia>
In-Reply-To: <167243874614.722028.11987534226186856347.stgit@magnolia>
References: <167243874614.722028.11987534226186856347.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since we now require a working AGI 0 to mount the system, fuzz AGI 1
instead.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/357 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/357 b/tests/xfs/357
index 8a2c920ef4..25af8624db 100755
--- a/tests/xfs/357
+++ b/tests/xfs/357
@@ -25,7 +25,7 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz AGI"
-_scratch_xfs_fuzz_metadata '' 'online' 'agi 0' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'online' 'agi 1' >> $seqres.full
 echo "Done fuzzing AGI"
 
 # success, all done

