Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3FAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbiLaC3F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiLaC3D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:29:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2595D1C921
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:29:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C327EB81E6D
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868A0C433D2;
        Sat, 31 Dec 2022 02:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453740;
        bh=MvTTqZihwbHiEUTypuNXwMvBlapOLO0upWwetK3wHU0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vJ87fvXe5I9cUMinQPKPfUYh6SIdDQGR84g8TUo2sy7/Qu+BAQGcM9Bi+BTO+volD
         UYmm3sTAjAR5AwwLhzdL8cHb+fWI2e2VHUnwJFEZ84vCYNUm1RyhRuLbsYhscU1ww8
         xbrX3Q/rg9ebg4dgN9swgW0cYwVAuyPjp0BS8iII6h82GcwC97cnN71dhZpmixuZEX
         gKNOuZ5M4aY4FZYF/XvRnaRiRN6HZf52eggyA9EoxGqZ33qrXKpMIQluqJoB702dGV
         lfwmwFLNyOn5lz+3mDzZR309kvbLI14OOvs+NEbr12IpdWoY9z+PMD4C0JQYseL/ay
         v3s2ICSdTpouw==
Subject: [PATCH 1/5] xfs_db: allow selecting logdev blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:39 -0800
Message-ID: <167243877995.730695.10725248450234022103.stgit@magnolia>
In-Reply-To: <167243877981.730695.7761889719607533776.stgit@magnolia>
References: <167243877981.730695.7761889719607533776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make it so that xfs_db can examine blocks on an external log device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/io.c |   18 ++++++++++++++++++
 db/io.h |    2 ++
 2 files changed, 20 insertions(+)


diff --git a/db/io.c b/db/io.c
index 00eb5e98dc2..8e3b32d9551 100644
--- a/db/io.c
+++ b/db/io.c
@@ -660,6 +660,24 @@ set_rt_cur(
 	return 0;
 }
 
+int
+set_log_cur(
+	const typ_t	*type,
+	xfs_daddr_t	blknum,
+	int		len,
+	int		ring_flag,
+	bbmap_t		*bbmap)
+{
+	if (!mp->m_logdev_targp->bt_bdev ||
+	    mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
+		printf(_("external log device not loaded, use -l.\n"));
+		return ENODEV;
+	}
+
+	__set_cur(mp->m_logdev_targp, type, blknum, len, ring_flag, bbmap);
+	return 0;
+}
+
 void
 set_iocur_type(
 	const typ_t	*type)
diff --git a/db/io.h b/db/io.h
index 1a37ee78c72..b3d8123d548 100644
--- a/db/io.h
+++ b/db/io.h
@@ -49,6 +49,8 @@ extern void	push_cur_and_set_type(void);
 extern void	write_cur(void);
 extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
 			int len, int ring_add, bbmap_t *bbmap);
+extern int	set_log_cur(const struct typ *type, xfs_daddr_t blknum,
+			int len, int ring_add, bbmap_t *bbmap);
 extern int	set_rt_cur(const struct typ *type, xfs_daddr_t blknum,
 			int len, int ring_add, bbmap_t *bbmap);
 extern void     ring_add(void);

