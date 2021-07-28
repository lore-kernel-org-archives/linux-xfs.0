Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F33EC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 334FD6103C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhG1VQ3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhG1VQ2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:16:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5806A6103B;
        Wed, 28 Jul 2021 21:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506986;
        bh=3Q3wOtnNcC2GtPlLxznGFZeUSxPuL0sdWlbcFkV4EHc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qAX4z3v9kvsLbcZS9rg9vbsMdZ1QKdIpcMSiZTyeT9XX4GcRuDtZAKIxr9HrGykKa
         cmxhJJroPXzaU/H/QjDCfZAaA2VvC4S5FTboUJYriong4lyVSMEYeEwzkv01FYXSfa
         XQ36EPDJg/kp4UVg1FDxS3zyiV2Xk0ggJ0uWx9wlm3Jf+iYluK9waIWIkKimzwmipI
         0FsjHuwGK3EWoYujZRioNQ2AggQD23HsdU6QUl/fJq1bjiF56CRivLgIOCHR9waAwo
         1BVwj936rWoTlsvpelXje7BrPn8eCD7zXTa+yeoUb8iMT3VFPYR9B95AszlyOGury9
         YTuscPEnHmkmw==
Subject: [PATCH 1/2] xfs_repair: invalidate dirhash entry when junking dirent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 28 Jul 2021 14:16:26 -0700
Message-ID: <162750698605.45897.4760370429656466555.stgit@magnolia>
In-Reply-To: <162750698055.45897.6106668678411666392.stgit@magnolia>
References: <162750698055.45897.6106668678411666392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In longform_dir2_entry_check_data, we add the directory entries we find
to the incore dirent hash table after we've validated the name but
before we're totally done checking the entry.  This sequence is
necessary to detect all duplicated names in the directory.

Unfortunately, if we later decide to junk the ondisk dirent, we neglect
to mark the dirhash entry, so if the directory gets rebuilt, it will get
rebuilt with the entry that we rejected.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase6.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index 0929dcdf..696a6427 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -237,6 +237,21 @@ dir_hash_add(
 	return !dup;
 }
 
+/* Mark an existing directory hashtable entry as junk. */
+static void
+dir_hash_junkit(
+	struct dir_hash_tab	*hashtab,
+	xfs_dir2_dataptr_t	addr)
+{
+	struct dir_hash_ent	*p;
+
+	p = radix_tree_lookup(&hashtab->byaddr, addr);
+	assert(p != NULL);
+
+	p->junkit = 1;
+	p->namebuf[0] = '/';
+}
+
 static int
 dir_hash_check(
 	struct dir_hash_tab	*hashtab,
@@ -1729,6 +1744,7 @@ longform_dir2_entry_check_data(
 				if (entry_junked(
 	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block"), fname,
 						inum, ip->i_ino)) {
+					dir_hash_junkit(hashtab, addr);
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
 				}
@@ -1756,6 +1772,7 @@ longform_dir2_entry_check_data(
 				if (entry_junked(
 	_("entry \"%s\" in dir %" PRIu64 " is not the first entry"),
 						fname, inum, ip->i_ino)) {
+					dir_hash_junkit(hashtab, addr);
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
 				}
@@ -1844,6 +1861,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 				orphanage_ino = 0;
 			nbad++;
 			if (!no_modify)  {
+				dir_hash_junkit(hashtab, addr);
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 				if (verbose)

