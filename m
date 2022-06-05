Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A797CC433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jun 2022 16:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343766AbiFEQfq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jun 2022 12:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346126AbiFEQfp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jun 2022 12:35:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9004CD4C
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 09:35:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88AD861137
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 16:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AC6C385A5;
        Sun,  5 Jun 2022 16:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654446943;
        bh=IyTWy6A7Bj2DdE354AJHltvcs/E7263O0ihqKZS9NNg=;
        h=Date:From:To:Cc:Subject:From;
        b=ZOWaEdRXlbiUaV/MHDo5yXqTYVNvpMCXGsDIfavYUgaElA8YeiGo0PGIJriciCZz9
         LPJVrhVYeMSs9rIL9KfhL93QZfSkDxaV4vMOoV0Odv+97VOiRQdPDq++obMOX4I9iW
         0EySET142GvGbF84+Chzv/2DUlop1voaB2b3UeC8j9P95xoZP2MSDx/UesekPoNlGQ
         FREyijWXIfsmkaN0pLA9Shr3t6KpzjJk+89sbn0ASrblflAZUojzIlmY2aX74FYtNP
         2pnOz2XqdDrnkRuO1OYNFNcs92YIx4dhlJIeZUBY4MSzQWFZ7EsziHPUxdW1hcMGdd
         wHT1SrKcrZccw==
Date:   Sun, 5 Jun 2022 09:35:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: preserve DIFLAG2_NREXT64 when setting other inode
 attributes
Message-ID: <YpzbX/5sgRIcN2LC@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It is vitally important that we preserve the state of the NREXT64 inode
flag when we're changing the other flags2 fields.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5a364a7d58fd..0d67ff8a8961 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1096,7 +1096,8 @@ xfs_flags2diflags2(
 {
 	uint64_t		di_flags2 =
 		(ip->i_diflags2 & (XFS_DIFLAG2_REFLINK |
-				   XFS_DIFLAG2_BIGTIME));
+				   XFS_DIFLAG2_BIGTIME |
+				   XFS_DIFLAG2_NREXT64));
 
 	if (xflags & FS_XFLAG_DAX)
 		di_flags2 |= XFS_DIFLAG2_DAX;
