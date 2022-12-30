Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BD7C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbiLaAop (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235923AbiLaAon (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:44:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D751EAC9;
        Fri, 30 Dec 2022 16:44:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39311B81E79;
        Sat, 31 Dec 2022 00:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25B6C433D2;
        Sat, 31 Dec 2022 00:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447479;
        bh=lMyQa2uCBpJA0FdLpONrAsSONhKH7rdyHnsWrlcBaaI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JAK60yl6fBbE9hG8Wi18aH21bQbimHUd1u/3ww11jgpOUFGCPmNNgLBhqABhiyY88
         M9eSKK9RgHmkGXuPfjVyr2SBmcgOitF1+In/roqFXpszzkJobdqvM8nJunmcO+3O6f
         knamz21EQ2vqWSFV99KdZzAjguDq87IkdtoRNPhGJkABhr1LLvO9iXU2FbONFkzJT3
         F6yi5P5feqbGlTxFP/T1Wn72yKQvIoECRevM/+TEExnhdjWcdhbMZXxD4huwk4UBYM
         stDA5ZneKwNaz/MRm4OH9MhKGIObo6sS3R+ymnvcP9rIBdnwy900tW7QYsO/N414HW
         yJc/IFMA0m2Fg==
Subject: [PATCH 02/24] fuzzy: disable timstamp fuzzing by default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:39 -0800
Message-ID: <167243877933.730387.11688188649202773886.stgit@magnolia>
In-Reply-To: <167243877899.730387.9276624623424433346.stgit@magnolia>
References: <167243877899.730387.9276624623424433346.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't fuzz timestamps since all bit patterns are valid and XFS itself
does not perform any validation on them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index cd6e2a0e08..2798c257a0 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -73,6 +73,14 @@ __filter_xfs_db_keys() {
 	    -e '/pad/d'
 }
 
+# Filter out metadata fields that are completely controlled by userspace
+# or are arbitrary bit sequences.  In other words, fields where the filesystem
+# does no validation.
+__filter_unvalidated_xfs_db_fields() {
+	sed -e '/\.sec/d' \
+	    -e '/\.nsec/d'
+}
+
 # Filter the xfs_db print command's field debug information
 # into field name and type.
 __filter_xfs_db_print_fields() {
@@ -91,7 +99,7 @@ __filter_xfs_db_print_fields() {
 		else
 			echo "${fuzzkey}"
 		fi
-	done | grep -E "${filter}"
+	done | grep -E "${filter}" | __filter_unvalidated_xfs_db_fields
 }
 
 # Navigate to some part of the filesystem and print the field info.

