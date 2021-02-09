Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29466C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D824364EB1
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhBIESH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:18:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:48466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhBIEPp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:15:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20CCE64E70;
        Tue,  9 Feb 2021 04:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843899;
        bh=JiqHVRVE/L/BZD4KLgEejOLuwi+sNl71aTUiUZHR8+0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JGaHKCYG/lFDmN2LCsDCmRt5vK606lKUJUN5l0L0bbXwxTgbhq4M5l7f08Jpo4AVr
         QyBe4fcmdKxMEDJMkJStOkHLh9lAfNkj7zysLkirUnWGsUdEl2G7lRAUAfUr+TOA0Z
         RZIJ+D5c71HT1el4SVzcwAyG3RUsokbQKVz+uLIStOUy7HNFu702eNh0gvLL5R8hmm
         sOvO1kRigi0knKdrIx5srL0WDg35Bn7hle1Ra2yqly/5hspGBY8R+rz9EKn4B+ssiC
         g6jGm/qiS0boK8l6Eql1LAdgYZ29DrLmq5z8aycM69747LHf9gbJdbyp+SU65xSjc1
         fz8FP88+S4xDw==
Subject: [PATCH 4/6] xfs_scrub: handle concurrent directory updates during
 name scan
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        Chaitanya.Kulkarni@wdc.com
Date:   Mon, 08 Feb 2021 20:11:38 -0800
Message-ID: <161284389874.3058224.15020913005905277309.stgit@magnolia>
In-Reply-To: <161284387610.3058224.6236053293202575597.stgit@magnolia>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
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
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
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

