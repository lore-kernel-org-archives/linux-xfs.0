Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56017ECAAA1
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 23:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJ3Xla (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 19:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3Xl3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:41:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057259FEA
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:41:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 914A360F84
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2956C433D6;
        Sun, 30 Oct 2022 23:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173288;
        bh=YZ3FDKQWpWriVeBJM60RQcLeX0662Rt39tLSPs4qe7g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ggjmwbsWdbundW8xdrX+sLrtfrise75V6gosxYw8a5UrC6/KKjB4Rtg5XfKp4qcRJ
         eYVfklcBO+nWFkyUtEORBj59dkXbFkOg+uE0fYd/rN/qe5W56olj15EvrVu/cVHvnh
         t8V98uZ4cedQLuc64O93ovo7u4qfQ1crKGAXmMxzFgTborioFtzvXF6m2NQu/cdkoB
         qkL88rajSKsflQZpFzahRcR5eo7Kk+tpTXL29egO0zrx8lzMbfdhaR90A77Hx7PYO+
         lV55+QjSVa6VezRrksj1Go9UmldYzLhT828mZktfRUkWLa3LhvGerg0BlO6dmoJws1
         QOFWmo485pxuA==
Subject: [PATCH 01/13] xfs: make sure aglen never goes negative in
 xfs_refcount_adjust_extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 30 Oct 2022 16:41:27 -0700
Message-ID: <166717328748.417886.7017052520923983451.stgit@magnolia>
In-Reply-To: <166717328145.417886.10627661186183843873.stgit@magnolia>
References: <166717328145.417886.10627661186183843873.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Prior to calling xfs_refcount_adjust_extents, we trimmed agbno/aglen
such that the end of the range would not be in the middle of a refcount
record.  If this is no longer the case, something is seriously wrong
with the btree.  Bail out with a corruption error.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 64b910caafaa..831353ba96dc 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -986,15 +986,29 @@ xfs_refcount_adjust_extents(
 			(*agbno) += tmp.rc_blockcount;
 			(*aglen) -= tmp.rc_blockcount;
 
+			/* Stop if there's nothing left to modify */
+			if (*aglen == 0 || !xfs_refcount_still_have_space(cur))
+				break;
+
+			/* Move the cursor to the start of ext. */
 			error = xfs_refcount_lookup_ge(cur, *agbno,
 					&found_rec);
 			if (error)
 				goto out_error;
 		}
 
-		/* Stop if there's nothing left to modify */
-		if (*aglen == 0 || !xfs_refcount_still_have_space(cur))
-			break;
+		/*
+		 * A previous step trimmed agbno/aglen such that the end of the
+		 * range would not be in the middle of the record.  If this is
+		 * no longer the case, something is seriously wrong with the
+		 * btree.  Make sure we never feed the synthesized record into
+		 * the processing loop below.
+		 */
+		if (XFS_IS_CORRUPT(cur->bc_mp, ext.rc_blockcount == 0) ||
+		    XFS_IS_CORRUPT(cur->bc_mp, ext.rc_blockcount > *aglen)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 
 		/*
 		 * Adjust the reference count and either update the tree

