Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F01C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5BB9229F0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbhAPB0S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 20:26:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbhAPB0R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 20:26:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 077E123A40;
        Sat, 16 Jan 2021 01:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760337;
        bh=d5bBPyyb8IShxoxeIcQ3CZvkjLDkiUnuWwihoE3AUnU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WDhtdOAeL32LZRpbUfHr+tGCKoT4sD12SFTPSpL+9fEV3qlXlGK+S4iaTGzqq5EvT
         m5TXZbFbtfYY/3T5Exqh/x5hlVAoFfN5tVi7qvsZbr3icKTOVfA9UHFpTy8HeuR96v
         7sGfqYC9j+Ll3e/a/pxW9NoiCwJ/TVl+CS+B8y0KxrbK+90XLAr/G3Im+kb8GLA4QZ
         a7+pLHtlLyZX9iKgNYyqGlmILpZ3TWfCPcfr/1dSM5MaAPrxT/n1NA9SVFBa4BoUNf
         9Fk6Ggpf760d2zmT1AnfOyj2kTtH6NxhTJ2+gPhryZsUBmI650sZjKB/PqIkCCYTT1
         fa7XYlTpKIdkg==
Subject: [PATCH 4/4] xfs_scrub: handle concurrent directory updates during
 name scan
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 15 Jan 2021 17:25:36 -0800
Message-ID: <161076033640.3386689.11320451390779411930.stgit@magnolia>
In-Reply-To: <161076031261.3386689.3320804567045193864.stgit@magnolia>
References: <161076031261.3386689.3320804567045193864.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The name scanner in xfs_scrub cannot lock a namespace (dirent or xattr)
and the kernel does not provide a stable cursor interface, which means
that we can see the same byte sequence multiple times during a scan.
This isn't a confusing name error since the kernel enforces uniqueness
on the byte sequence, so all we need to do here is update the old entry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index de3217c2..cb0880c1 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -68,7 +68,7 @@ struct name_entry {
 
 	xfs_ino_t		ino;
 
-	/* Raw UTF8 name */
+	/* Raw dirent name */
 	size_t			namelen;
 	char			name[0];
 };
@@ -627,6 +627,20 @@ unicrash_add(
 	uc->buckets[bucket] = new_entry;
 
 	while (entry != NULL) {
+		/*
+		 * If we see the same byte sequence then someone's modifying
+		 * the namespace while we're scanning it.  Update the existing
+		 * entry's inode mapping and erase the new entry from existence.
+		 */
+		if (new_entry->namelen == entry->namelen &&
+		    !memcmp(new_entry->name, entry->name, entry->namelen)) {
+			entry->ino = new_entry->ino;
+			uc->buckets[bucket] = new_entry->next;
+			name_entry_free(new_entry);
+			*badflags = 0;
+			return;
+		}
+
 		/* Same normalization? */
 		if (new_entry->normstrlen == entry->normstrlen &&
 		    !u_strcmp(new_entry->normstr, entry->normstr) &&

