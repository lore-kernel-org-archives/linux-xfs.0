Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D889C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbiLaCh3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236255AbiLaChT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:37:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B3ABC9C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:37:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A9361CC2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6ADC433EF;
        Sat, 31 Dec 2022 02:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454238;
        bh=C440FqgCAnfJbdzyfvfQmcSNRj96M6QL7F7RJ9fqnn0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GotejuvkzXrWiVENpZJFnMboDdi0WjYgj+9d9Bus0kSDUz5npZGxJkiUnN3FynrFk
         endIT2Vda5izN/ZJJQNYHT133u6q+Rikx5/e05oEEh/thQRpGXNPUg/8tRGVLwqp9p
         iEPevOlGMT+sn3uOIhjjk05jzc6Af373nNdNQwUdINLtF4EvH/oPktkc0gG72w0S9O
         DcEwJymezs+XFiizIlYfE8kwENsCeJ6YLb+8EeHz4vr8NMsjyUSrUr234BBfzHfQQd
         Q6MJlyHdkgoxtdCeJkfrpt6BjPRddO3wAxMRlFwt12h97JY5U4knWbqpD4lZCGjmYb
         kK4Mn5Ryk7vNw==
Subject: [PATCH 28/45] xfs_db: listify the definition of dbm_t
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:47 -0800
Message-ID: <167243878730.731133.15573785425504120020.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert this enum definition to a list so that code adding elements to
the enum do not have to reflow the whole thing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)


diff --git a/db/check.c b/db/check.c
index f39d732d04d..4f4bff58e22 100644
--- a/db/check.c
+++ b/db/check.c
@@ -26,14 +26,36 @@ typedef enum {
 } qtype_t;
 
 typedef enum {
-	DBM_UNKNOWN,	DBM_AGF,	DBM_AGFL,	DBM_AGI,
-	DBM_ATTR,	DBM_BTBMAPA,	DBM_BTBMAPD,	DBM_BTBNO,
-	DBM_BTCNT,	DBM_BTINO,	DBM_DATA,	DBM_DIR,
-	DBM_FREE1,	DBM_FREE2,	DBM_FREELIST,	DBM_INODE,
-	DBM_LOG,	DBM_MISSING,	DBM_QUOTA,	DBM_RTBITMAP,
-	DBM_RTDATA,	DBM_RTFREE,	DBM_RTSUM,	DBM_SB,
-	DBM_SYMLINK,	DBM_BTFINO,	DBM_BTRMAP,	DBM_BTREFC,
-	DBM_RLDATA,	DBM_COWDATA,
+	DBM_UNKNOWN,
+	DBM_AGF,
+	DBM_AGFL,
+	DBM_AGI,
+	DBM_ATTR,
+	DBM_BTBMAPA,
+	DBM_BTBMAPD,
+	DBM_BTBNO,
+	DBM_BTCNT,
+	DBM_BTINO,
+	DBM_DATA,
+	DBM_DIR,
+	DBM_FREE1,
+	DBM_FREE2,
+	DBM_FREELIST,
+	DBM_INODE,
+	DBM_LOG,
+	DBM_MISSING,
+	DBM_QUOTA,
+	DBM_RTBITMAP,
+	DBM_RTDATA,
+	DBM_RTFREE,
+	DBM_RTSUM,
+	DBM_SB,
+	DBM_SYMLINK,
+	DBM_BTFINO,
+	DBM_BTRMAP,
+	DBM_BTREFC,
+	DBM_RLDATA,
+	DBM_COWDATA,
 	DBM_NDBM
 } dbm_t;
 

