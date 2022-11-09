Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1F7C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiKICGr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKICGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:06:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7922F68687
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:06:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 158C0617FF
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7327AC43140;
        Wed,  9 Nov 2022 02:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959604;
        bh=1JVi/5pDan09LUFMVms/79Xz9MxLevnSIYOnUMTAPVw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b8JFM+fhbxH8Jy4M5WTWEWJncutU70gQO/RJL71Z5bCRqP5MmxpQjDqwk7ciU4PMQ
         Bb2u0xwVe3IEOrEV3S91Vg9BRGsPe1XV+mDRxuvUcNtcm2sAO0joYKTkYBeBxjQY57
         /jxI/pJNQ9KfII7WjwXf0Xafn60AfFIaV6wStViJLGwOxUrtS3GzC11aSvKXPviCEU
         bQmIiFYlBUDfgco62F6MF2ywkW6ThRH3HZ0mJVO41WOuESquRXWesxa/C7FdgBzIYc
         zjYART5BEYsi5kGiRkWrY6RBbrepY8ZD/HQrBQNJ+2gSHQbEs8lUb31Sx0g6JPustS
         LzT3hH4QVwesw==
Subject: [PATCH 11/24] xfs: make sure aglen never goes negative in
 xfs_refcount_adjust_extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:06:44 -0800
Message-ID: <166795960400.3761583.7960144983090565358.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 3a3a253f66c5d3ab2712a9d4794b457195a503d7

Prior to calling xfs_refcount_adjust_extents, we trimmed agbno/aglen
such that the end of the range would not be in the middle of a refcount
record.  If this is no longer the case, something is seriously wrong
with the btree.  Bail out with a corruption error.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_refcount.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index bcd760fe12..146e833b0d 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -985,15 +985,29 @@ xfs_refcount_adjust_extents(
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

