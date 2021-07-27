Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE0BC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 19:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59A3D60F41
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 19:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhG0TQM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 15:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhG0TQM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 15:16:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2D6760525;
        Tue, 27 Jul 2021 19:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627413371;
        bh=fhA1dLAieqgOhKOMrQribz5kfgFQnGiqIVUKL/4CGjQ=;
        h=Date:From:To:Cc:Subject:From;
        b=M4tGvnC8nDmTWheBpCUzOTr6qGYN8jnk//ppmtJeH47rd5kH3dAkbtWnNyeT4M7y+
         R/DU/LQR5kRS5PK4ratGo25Xve3Imqxh1S2XRSbXaEs5HunMGjbxrNMZKRlXoNpbLB
         k3wnDWaZ9lPOsd2GWfBn1StmWLvQMEfh+2oCjp9hWcefn8Ed6oo4H4PX7QIpzUnXNq
         vaD7ny0joCLoINKLPjCGDuk8gcC1mvZtq41Vj5JonU6mHkJs72jdUWcRFk7+gwDDH/
         BHV43gszIe8o+7nq/eF8kDxhBHCV4f9MVSpupqlcoeGJXfHNe7PoTVhPg8/Li60SlA
         jGPa55uCcT83Q==
Date:   Tue, 27 Jul 2021 12:16:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_repair: invalidate dirhash entry when junking dirent
Message-ID: <20210727191611.GI559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
---
 repair/phase6.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/repair/phase6.c b/repair/phase6.c
index 29259b38..84092269 100644
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
@@ -2009,6 +2024,7 @@ longform_dir2_entry_check_data(
 				if (entry_junked(
 	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block"), fname,
 						inum, ip->i_ino)) {
+					dir_hash_junkit(hashtab, addr);
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
 				}
@@ -2036,6 +2052,7 @@ longform_dir2_entry_check_data(
 				if (entry_junked(
 	_("entry \"%s\" in dir %" PRIu64 " is not the first entry"),
 						fname, inum, ip->i_ino)) {
+					dir_hash_junkit(hashtab, addr);
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
 				}
@@ -2124,6 +2141,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 				orphanage_ino = 0;
 			nbad++;
 			if (!no_modify)  {
+				dir_hash_junkit(hashtab, addr);
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 				if (verbose)
