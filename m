Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9021ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 17:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbiJ0ROO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237094AbiJ0ROM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 13:14:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2545C196082
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 10:14:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C038FB826D7
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 17:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7352FC433C1;
        Thu, 27 Oct 2022 17:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890849;
        bh=YA/5v5GovSR1Qju3y8j+MMma1scWPLs6kt2nHYJnzN4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rAP6ltJmL7yFQkJMoUY6BzgmDP7V/lBlRaKGMQ7Ar1MQGXdcYg7HSFQ4KWwpKjmcN
         ER5ItHC3Gerl26dgSxqwmIB9bXlZelKmlQw/BHVwhbwnSeBSTGfKQ3DKi8+h+Dw1J0
         PAaxzDWiQ2dC+rCXZYNa+UUHfOFumUm9OX5ihv8SuxuD1NTeRXCK1zMt84tTtW8mhT
         GGzj7OFTzTXqnEdlYibiwU8FHRAPK/Od7iQtzX7jBrhADu5sSKstopon8RpPNa3IZA
         W1PEyPBUoMq5EegVzO/XOjlLvq5Br+bOKSNTMP8qI23k2j8Njqa1a5QMbienHYPvGx
         vEkIixc7tpCOA==
Subject: [PATCH 01/12] xfs: make sure aglen never goes negative in
 xfs_refcount_adjust_extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Oct 2022 10:14:09 -0700
Message-ID: <166689084901.3788582.2985638032925462213.stgit@magnolia>
In-Reply-To: <166689084304.3788582.15155501738043912776.stgit@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
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

