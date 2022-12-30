Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB05C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbiLaCgd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbiLaCgd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:36:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4668BD6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:36:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FC8661CC2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DE4C433D2;
        Sat, 31 Dec 2022 02:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454191;
        bh=CoLZ5vSgNfPAE/ou3DKvCnnCtz9TbpzKqJPNH5W08Sg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GWSaMtaI5sZdVvA4zjD4ZbA3u0k8Rlc/09r/zyE/KW8kiOMy9NCsTXdpmY3vEajsh
         /ybTk53HrGRaF3G3tDZo34gNOObAXRnqLhKpXsIBU3lmaRRs1uiJhvrn8Dkyu12+hA
         mfVU7H6SCGJECtQbPmPo/qS2iT+waMJHblVLUvKYF5SbJdxRgszgWT0p+yhk3KoAmj
         iPhHgTHDboSFWPUPj9FHPYcVGjr2OppyEb2Jj3/+OpHxvYt47tpw3mV9QjxdRS/k+L
         aUQshZ0FNGBKtt7KoMc+61jI0sl9g8W+sIPxV6ksDQHdh9nt9YtF12O747u/jQ0g69
         wQnBUNxZPAypQ==
Subject: [PATCH 25/45] xfs_db: listify the definition of enum typnm
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:46 -0800
Message-ID: <167243878691.731133.3678549325865013969.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the enum definition into a list so that future patches adding
things to enum typnm don't have to reflow the entire thing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/type.h |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)


diff --git a/db/type.h b/db/type.h
index 411bfe90dbc..397dcf5464c 100644
--- a/db/type.h
+++ b/db/type.h
@@ -11,11 +11,30 @@ struct field;
 
 typedef enum typnm
 {
-	TYP_AGF, TYP_AGFL, TYP_AGI, TYP_ATTR, TYP_BMAPBTA,
-	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_RMAPBT, TYP_REFCBT, TYP_DATA,
-	TYP_DIR2, TYP_DQBLK, TYP_INOBT, TYP_INODATA, TYP_INODE,
-	TYP_LOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
-	TYP_TEXT, TYP_FINOBT, TYP_NONE
+	TYP_AGF,
+	TYP_AGFL,
+	TYP_AGI,
+	TYP_ATTR,
+	TYP_BMAPBTA,
+	TYP_BMAPBTD,
+	TYP_BNOBT,
+	TYP_CNTBT,
+	TYP_RMAPBT,
+	TYP_REFCBT,
+	TYP_DATA,
+	TYP_DIR2,
+	TYP_DQBLK,
+	TYP_INOBT,
+	TYP_INODATA,
+	TYP_INODE,
+	TYP_LOG,
+	TYP_RTBITMAP,
+	TYP_RTSUMMARY,
+	TYP_SB,
+	TYP_SYMLINK,
+	TYP_TEXT,
+	TYP_FINOBT,
+	TYP_NONE
 } typnm_t;
 
 #define DB_FUZZ  2

