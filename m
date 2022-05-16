Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114B9C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 03:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbiEPDe5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 23:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiEPDez (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 23:34:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40B91FCC4
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 20:34:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6201960EDC
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 03:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE2BC385AA;
        Mon, 16 May 2022 03:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652672093;
        bh=9a0bghvyB91TtoMoJJx+Rv2HsV3P4lMGCOOWBpbwEv4=;
        h=Date:From:To:Subject:From;
        b=Zx3Trlpq8wMdo0KDegxvQL432eLOgv79uuIxI1LK0iaX2pT0Pmf6PmW4uY7RyRLS6
         QoFKHd1jFQq4Y1U6J5GfaN3SyAKrF7Yb8TcCfDqbCP7mSFhRQ0zXXfUOSDUAvwVv4v
         Vwj4U1uXJapYvJr2u1LxWPOArKLQvGM1F/Rs57RiwG57zW0CGCdJIpv9wuo+uFFNtH
         OutrZmWEgK7CHB/oD/kot4VKGq0FXgouXk8m+sh6KDJzYewBByrJOanDaJlYtAV+MY
         U0pKbeAGppjto/RuM30WiV7uUVet9BJ+VEtz/Nkljs0N/o2cEiycno9X7XOjWXJL3J
         Y6YBZ0x/JvDQw==
Date:   Sun, 15 May 2022 20:34:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Subject: [RFC]RAP xfs: don't crash when relogging xattri item
Message-ID: <YoHGXehJko1sc/xr@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

XXX DO NOT APPLY

While running xfs/297 and generic/642, I noticed a crash in
xfs_attri_item_relog when it tries to copy the attr name to the new
xattri log item.  I think what happened here was that we called
->iop_commit on the old attri item (which nulls out the pointers) as
part of a log force at the same time that a chained attr operation was
ongoing.  The system was busy enough that at some later point, the defer
ops operation decided it was necessary to relog the attri log item, but
as we've detached the name buffer from the old attri log item, we can't
copy it to the new one, and kaboom.

I think speaks to a broader refcounting problem with LARP mode -- the
attr log item needs to be able to retain a reference to the name and
value buffers until the log items have completely cleared the log.  I
think it might be possible that the setxattr code can return to
userspace before the CIL actually formats and commits the log item,
leading to a UAF, but I don't really have the time to figure that one
out without external help.

Skipping the memcpy is /not/ the correct solution here -- that means
we'll relog the xattri with zeroed names and values, which breaks log
recovery.

Singed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index fb84f71388c4..47c3c44e375d 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -670,12 +670,24 @@ xfs_attri_item_relog(
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
-	memcpy(new_attrip->attri_name, old_attrip->attri_name,
-		new_attrip->attri_name_len);
+	if (old_attrip->attri_name) {
+		memcpy(new_attrip->attri_name, old_attrip->attri_name,
+				new_attrip->attri_name_len);
+	} else {
+		xfs_emerg(tp->t_mountp, "%s namelen 0x%x name NULL!", __func__, new_attrip->attri_name_len);
+		dump_stack();
+	}
 
-	if (new_attrip->attri_value_len > 0)
-		memcpy(new_attrip->attri_value, old_attrip->attri_value,
-		       new_attrip->attri_value_len);
+	if (new_attrip->attri_value_len > 0) {
+		if (old_attrip->attri_value) {
+			memcpy(new_attrip->attri_value,
+					old_attrip->attri_value,
+					new_attrip->attri_value_len);
+		} else {
+			xfs_emerg(tp->t_mountp, "%s valuelen 0x%x value NULL!", __func__, new_attrip->attri_value_len);
+			dump_stack();
+		}
+	}
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
 	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
