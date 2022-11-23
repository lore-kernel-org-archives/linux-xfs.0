Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF69EC47088
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 17:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239254AbiKWRJ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 12:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239151AbiKWRJn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 12:09:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1931148
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 09:09:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1444CB821C3
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 17:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD5BC433C1;
        Wed, 23 Nov 2022 17:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669223379;
        bh=UnYzZ0ec4Vjv7i5xCeQMX6VqdQ0wjQ+8KkO8tCwc8Yc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AtPEwJEn7BO3UZegO/X52tq0FY0gTIQ3cHBxwRRdMQUocT70Tv7c7YGIDxMB0BOzd
         II3U5jF8YaLN3ZO+nCJkwGVVaxjxzv9ghJZeLq5Kqa7yuIo5aPR+1Hmfm3YaCH0GCw
         5rTDvwlQbtyp20eLgOfj5hIxh5dxQHvBM58yh0qJe6084qQyfOp+ybpTmf3Qu683nr
         UvgrjnA5FwJQ+k4WU0/5lmRkWLxaWDY9764HRJ5g/6f883LK5GO6AYa2z4aU3RkRNi
         LPh/OxJRlOxiH9Vykb4sKZbHy+2WmrpsZV9j0kscnpSBqEpULz2TnISXsLgVOFsone
         qPx0XNgW336vw==
Subject: [PATCH 8/9] xfs_{db,repair}: fix XFS_REFC_COW_START usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 23 Nov 2022 09:09:39 -0800
Message-ID: <166922337929.1572664.8324902697406402249.stgit@magnolia>
In-Reply-To: <166922333463.1572664.2330601679911464739.stgit@magnolia>
References: <166922333463.1572664.2330601679911464739.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is really a bit field stashed in the upper bit of the rc_startblock
field, so change its usage patterns to use masking instead of integer
addition and subtraction.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c    |    4 ++--
 repair/scan.c |   22 ++++++++++++++++------
 2 files changed, 18 insertions(+), 8 deletions(-)


diff --git a/db/check.c b/db/check.c
index 680edf1f9ed..bb27ce58053 100644
--- a/db/check.c
+++ b/db/check.c
@@ -4848,8 +4848,8 @@ scanfunc_refcnt(
 				char		*msg;
 
 				agbno = be32_to_cpu(rp[i].rc_startblock);
-				if (agbno >= XFS_REFC_COWFLAG) {
-					agbno -= XFS_REFC_COWFLAG;
+				if (agbno & XFS_REFC_COWFLAG) {
+					agbno &= ~XFS_REFC_COWFLAG;
 					msg = _(
 		"leftover CoW extent (%u/%u) len %u\n");
 				} else {
diff --git a/repair/scan.c b/repair/scan.c
index 859a6e69374..7b72013153d 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1367,6 +1367,7 @@ _("%s btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		pag = libxfs_perag_get(mp, agno);
 
 		for (i = 0; i < numrecs; i++) {
+			enum xfs_refc_domain	domain;
 			xfs_agblock_t		b, agb, end;
 			xfs_extlen_t		len;
 			xfs_nlink_t		nr;
@@ -1374,16 +1375,23 @@ _("%s btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			b = agb = be32_to_cpu(rp[i].rc_startblock);
 			len = be32_to_cpu(rp[i].rc_blockcount);
 			nr = be32_to_cpu(rp[i].rc_refcount);
-			if (b >= XFS_REFC_COWFLAG && nr != 1)
+
+			if (b & XFS_REFC_COWFLAG) {
+				domain = XFS_REFC_DOMAIN_COW;
+				agb &= ~XFS_REFC_COWFLAG;
+			} else {
+				domain = XFS_REFC_DOMAIN_SHARED;
+			}
+
+			if (domain == XFS_REFC_DOMAIN_COW && nr != 1)
 				do_warn(
 _("leftover CoW extent has incorrect refcount in record %u of %s btree block %u/%u\n"),
 					i, name, agno, bno);
 			if (nr == 1) {
-				if (agb < XFS_REFC_COWFLAG)
+				if (domain != XFS_REFC_DOMAIN_COW)
 					do_warn(
 _("leftover CoW extent has invalid startblock in record %u of %s btree block %u/%u\n"),
 						i, name, agno, bno);
-				agb -= XFS_REFC_COWFLAG;
 			}
 			end = agb + len;
 
@@ -1438,15 +1446,17 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 			}
 
 			/* Is this record mergeable with the last one? */
-			if (refc_priv->last_rec.rc_startblock +
-			    refc_priv->last_rec.rc_blockcount == b &&
+			if (refc_priv->last_rec.rc_domain == domain &&
+			    refc_priv->last_rec.rc_startblock +
+			    refc_priv->last_rec.rc_blockcount == agb &&
 			    refc_priv->last_rec.rc_refcount == nr) {
 				do_warn(
 	_("record %d in block (%u/%u) of %s tree should be merged with previous record\n"),
 					i, agno, bno, name);
 				refc_priv->last_rec.rc_blockcount += len;
 			} else {
-				refc_priv->last_rec.rc_startblock = b;
+				refc_priv->last_rec.rc_domain = domain;
+				refc_priv->last_rec.rc_startblock = agb;
 				refc_priv->last_rec.rc_blockcount = len;
 				refc_priv->last_rec.rc_refcount = nr;
 			}

