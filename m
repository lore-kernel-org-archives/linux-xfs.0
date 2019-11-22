Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11945C43215
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 06:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1A9220731
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 06:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574404133;
	bh=O8wyPceWayF533GAkTF/pAHkQtQKQAuf8TKGcWkyJoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=r2LEfJsv87qb4gct7x9dXeh2z2nOdk3n1WLw2kteBUqd8c2Z/bn4GVpYqfVB5T+u8
	 SO1KsYKercf1BdGsMc9kAK7/TORUImlTBdtNXla2FrCMgoZ8f4LdR6TFNzT0kOxZT7
	 4kKB7Cvc/PCl0yifcOTEypRei40icDfXPJC8IKRU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfKVG2o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 01:28:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbfKVFuH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAD882068F;
        Fri, 22 Nov 2019 05:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401806;
        bh=O8wyPceWayF533GAkTF/pAHkQtQKQAuf8TKGcWkyJoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wui7xc7b8H4Xmf2RtO2/lOcI19UqcrNRKrKQOgpJqT5hcVTrlnDhcF4haH7X28F7O
         y3zs63khc/TXnDmqB+bsEIjrmBZ9wbMv5ccMX83TmbNTJJiALJ6l/4MLOLs0Jv7CBZ
         J54YXy6WOXJc9dhAlswQJn9b/8Z/I1LY0daO5C2M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Bill O'Donnell <billodo@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 051/219] xfs: require both realtime inodes to mount
Date:   Fri, 22 Nov 2019 00:46:23 -0500
Message-Id: <20191122054911.1750-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 64bafd2f1e484e27071e7584642005d56516cb77 ]

Since mkfs always formats the filesystem with the realtime bitmap and
summary inodes immediately after the root directory, we should expect
that both of them are present and loadable, even if there isn't a
realtime volume attached.  There's no reason to skip this if rbmino ==
NULLFSINO; in fact, this causes an immediate crash if the there /is/ a
realtime volume and someone writes to it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 926ed314ffba1..484eb0adcefb2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1198,13 +1198,11 @@ xfs_rtmount_inodes(
 	xfs_sb_t	*sbp;
 
 	sbp = &mp->m_sb;
-	if (sbp->sb_rbmino == NULLFSINO)
-		return 0;
 	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
 	if (error)
 		return error;
 	ASSERT(mp->m_rbmip != NULL);
-	ASSERT(sbp->sb_rsumino != NULLFSINO);
+
 	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
 	if (error) {
 		xfs_irele(mp->m_rbmip);
-- 
2.20.1

