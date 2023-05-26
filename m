Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50602C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjEZA75 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjEZA74 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:59:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9333312E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:59:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2949F649F2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904CDC433EF;
        Fri, 26 May 2023 00:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062794;
        bh=uOylBCT+emyqMjizhEQuwaC0v35Fk4l5SbQmuNu33uM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=dGVqmXgZKT/2vE8GvSGi+IVR5CFu+lNA+DlPCE1ozBGvKMGW+s/5yBrySTEW1tJTW
         r9gom/nnIllk+jM3u1FGzMA9yYMnoQtfD+13cBvd8riYA3S4ozUAbm5U2hjjAPvLWn
         lHLzRy8+eZG63eA1mfxLLpr6/TWJ5w4S8WkdBxmCiMwRyEmuiO0JiDUgWPxDUh9fNg
         Wlz00H+4lL26QvkRi6J438yljiH1a/PgH9HwTnrDVKBeDZmhpbthEEg3ujtewxO2ge
         H0sf5qKfmc8vJ/eLF64o+CTAANKV5Pd9PyuXiLY1CUUQnrMjMl1pZEFl1Ved4QJr0C
         G4oS9V2lwRYLA==
Date:   Thu, 25 May 2023 17:59:54 -0700
Subject: [PATCH 4/5] xfs: create a predicate to determine if two xfs_names are
 the same
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506060329.3731332.1081224335543290466.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060263.3731332.723936389513300302.stgit@frogsfrogsfrogs>
References: <168506060263.3731332.723936389513300302.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a simple predicate to determine if two xfs_names are the same
objects or have the exact same name.  The comparison is always case
sensitive.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.h |    9 +++++++++
 fs/xfs/scrub/dir.c       |    4 ++--
 2 files changed, 11 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 7d7cd8d808e4..ac3c264402dd 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -24,6 +24,15 @@ struct xfs_dir3_icleaf_hdr;
 extern const struct xfs_name	xfs_name_dotdot;
 extern const struct xfs_name	xfs_name_dot;
 
+static inline bool
+xfs_dir2_samename(
+	const struct xfs_name	*n1,
+	const struct xfs_name	*n2)
+{
+	return n1 == n2 || (n1->len == n2->len &&
+			    !memcmp(n1->name, n2->name, n1->len));
+}
+
 /*
  * Convert inode mode to directory entry filetype
  */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index acae43d20f38..a849c5d2be78 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -91,11 +91,11 @@ xchk_dir_actor(
 		return -ECANCELED;
 	}
 
-	if (!strncmp(".", name->name, name->len)) {
+	if (xfs_dir2_samename(name, &xfs_name_dot)) {
 		/* If this is "." then check that the inum matches the dir. */
 		if (ino != dp->i_ino)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
-	} else if (!strncmp("..", name->name, name->len)) {
+	} else if (xfs_dir2_samename(name, &xfs_name_dotdot)) {
 		/*
 		 * If this is ".." in the root inode, check that the inum
 		 * matches this dir.

