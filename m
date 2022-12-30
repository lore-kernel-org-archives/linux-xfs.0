Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CEBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiLaDBn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbiLaDBm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:01:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9409915F27
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:01:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3219461D06
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9961AC433D2;
        Sat, 31 Dec 2022 03:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455701;
        bh=r8fwNUhf8cW+aWVU1uhsxxFotriQDPowUe0G6rTAJLI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PWwIKXYjmLrrq0WrjYvqc5Vk1jPiAYMKnTza5HZ86sn4sU7xTE8lJO8+j4+mGnsU2
         xyywQPZA3Ypueh49UQuB2DZoZTrMzrLgFDXhho1kssFzNLSFmxA0rUzu6gLtG+HF5t
         ymGVGkHXuC3sueO3o5MxctD/PV9Zpa5qNxtQHTV3VB2tN+j6lCEP+Ri6zHw184Ggz+
         oHjJ/aOBatAPNyh5BBWg7tl67yrzzDmL63X2o9gU1qNm89BklQlM9/Hfnt5DFNZZRO
         4AviROM8a4Jiite73cH7F9LI3vNpiUHuty4ghx2ip2YS8W3DZz+rvvJ1vq87wibNoc
         rF3JMQc0dZXsw==
Subject: [PATCH 29/41] xfs_spaceman: report health of the realtime refcount
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:11 -0800
Message-ID: <167243881154.734096.18174238218932229927.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Report the health of the realtime reference count btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 spaceman/health.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/spaceman/health.c b/spaceman/health.c
index 950610d9770..6114be5704c 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -44,6 +44,11 @@ static bool has_rtrmapbt(const struct xfs_fsop_geom *g)
 	return g->rtblocks > 0 && (g->flags & XFS_FSOP_GEOM_FLAGS_RMAPBT);
 }
 
+static bool has_rtreflink(const struct xfs_fsop_geom *g)
+{
+	return g->rtblocks > 0 && (g->flags & XFS_FSOP_GEOM_FLAGS_REFLINK);
+}
+
 struct flag_map {
 	unsigned int		mask;
 	bool			(*has_fn)(const struct xfs_fsop_geom *g);
@@ -153,6 +158,11 @@ static const struct flag_map rtgroup_flags[] = {
 		.descr = "realtime reverse mappings btree",
 		.has_fn = has_rtrmapbt,
 	},
+	{
+		.mask = XFS_RTGROUP_GEOM_SICK_REFCNTBT,
+		.descr = "realtime reference count btree",
+		.has_fn = has_rtreflink,
+	},
 	{0},
 };
 

