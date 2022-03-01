Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F39C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 02:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiCACwC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 21:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiCACwB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 21:52:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95354615E
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 18:51:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95C3DB80E5D
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356E9C340EE
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646103079;
        bh=RRoWr/L5CBxICLmVn478rNUqHuQSHBXbRJyMIXqgiZU=;
        h=Date:From:To:Subject:From;
        b=sfqa7Ib8FxC1DQ6p3Hz+h6IDNIgNywri8ozUMNmyoO6So0LZTX2PJfD3wcMrjSr24
         LKYtfbAr5/S0TVqpCHRlIG6RNWl7CYd97/WsVdpq4q/DOBE7S8Ow/UXS7S/BUjD4tq
         A8Lyo7K1gXSGNnWsvLjJDpmWvW3zeviHON4ThzuRDUZu6Qhv8EkKT/fO4wklNwBfs+
         9QjFseYsuQuVSpmeHIMeJ/4nURFYmKByZVCp0H0K7QIsuiOfjE+ybIAC2jAYNIzJDw
         3B9ISq/rADedpphM5I5CqGnpidOtKt8KlPf72EwRfEPi2koSI1XFZfr8ACxmGgYzrY
         ClvhQfYYkeaMA==
Date:   Mon, 28 Feb 2022 18:51:18 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: reserve quota for directory expansion when hardlinking
 files
Message-ID: <20220301025118.GG117732@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The XFS implementation of the linkat call does not reserve quota for the
potential directory expansion.  This means that we don't reject the
expansion with EDQUOT when we're at or near a hard limit, which means
that one can use linkat() to exceed quota.  Fix this by adding a quota
reservation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 04bf467b1090..6e556c9069e8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1249,6 +1249,10 @@ xfs_link(
 	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
 
+	error = xfs_trans_reserve_quota_nblks(tp, tdp, resblks, 0, false);
+	if (error)
+		goto error_return;
+
 	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
 	if (error)
