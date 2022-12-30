Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0EBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbiLaCtT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236244AbiLaCtS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:49:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D712C19023
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:49:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3328CCE1AC2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7438FC433EF;
        Sat, 31 Dec 2022 02:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454954;
        bh=+B0UWOoOVV3TevJWnHenLJsjbEcMcRSrDnj+cFOZt4U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EW4lsTtsXHh7at2UK0DKMrkRCOPjO5IoH+364d6uEFjV8SUHcqADhGEYshQUCvf2h
         UiINkN8SSN6uadzW4lDnV/FZ3gzwdqmEbXOfdQn072LyFgLdtuINRVayIVsVS7/W/t
         wLw+Yj+9B8l7s5gCS0kBdH3V3C7JRdb+wsfy0s9ps7XaUHJDBlESU/i1wqlF22GkYz
         +fkB5Ukj/zr2W8tm87DgofsW+S09DTNE18eUNMC+XHA7rVDmZkLyTGO5JykHaDTfKt
         oCSYvp/nEfkLkOl8Y8aPf1ytSGmwouYr1By1zBdWRZjh1ChCVrtRN7+D9vCf9P0y1d
         qfg/bgEvfekqA==
Subject: [PATCH 26/41] xfs_spaceman: report health status of the realtime rmap
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:59 -0800
Message-ID: <167243879939.732820.2612658105013891280.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add reporting of the rt rmap btree health to spaceman.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 spaceman/health.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/spaceman/health.c b/spaceman/health.c
index 928d92abb8c..950610d9770 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -39,6 +39,11 @@ static bool has_reflink(const struct xfs_fsop_geom *g)
 	return g->flags & XFS_FSOP_GEOM_FLAGS_REFLINK;
 }
 
+static bool has_rtrmapbt(const struct xfs_fsop_geom *g)
+{
+	return g->rtblocks > 0 && (g->flags & XFS_FSOP_GEOM_FLAGS_RMAPBT);
+}
+
 struct flag_map {
 	unsigned int		mask;
 	bool			(*has_fn)(const struct xfs_fsop_geom *g);
@@ -143,6 +148,11 @@ static const struct flag_map rtgroup_flags[] = {
 		.mask = XFS_RTGROUP_GEOM_SICK_BITMAP,
 		.descr = "realtime bitmap",
 	},
+	{
+		.mask = XFS_RTGROUP_GEOM_SICK_RMAPBT,
+		.descr = "realtime reverse mappings btree",
+		.has_fn = has_rtrmapbt,
+	},
 	{0},
 };
 

