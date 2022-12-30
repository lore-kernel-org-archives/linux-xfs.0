Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61088C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbiLaCj4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbiLaCjz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:39:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8182DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:39:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE7FC61CCF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D31C433D2;
        Sat, 31 Dec 2022 02:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454394;
        bh=O39Y4n7rhLCTqAdJSyUNYIm0gcM4UcYgZ0SWiCppngI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=H+Tdu2i3+glfF9PXwamUY9DIpSDPPsNiw0eckUPou9Y+KeVl+5psawTwcjfSHJTQI
         PmtKgnxR9Y8bXspQJlbdlKVVdqen9oiyiOLb/sFg2EDBENIRUzCp7FbcoFB1BbOKSq
         wDcbg5c9WeizDBAhax7/q6LICs4chpoPIlTDQa6wYbgd6R4WjLSfSOIb/IJyB2isdy
         4aYkwpiQlpX1/UKkereQWunRWOXA/QgAu1uk7Xl5ZrLbN9QFDiamuaBy8aChdyYq45
         LvRTnAP9Y1dmzXslt1p1QvzyFLgdddAIrlQ1B0OYHCl7K6wPW81r+d7lq4o+p5aUZW
         qpC4aUnso8PUg==
Subject: [PATCH 38/45] xfs_io: display rt group in verbose bmap output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:48 -0800
Message-ID: <167243878860.731133.14232316103222149536.stgit@magnolia>
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

Display the rt group number in the bmap -v output, just like we do for
regular data files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/bmap.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)


diff --git a/io/bmap.c b/io/bmap.c
index 27383ca6037..a78e0c65440 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -264,9 +264,16 @@ bmap_f(
 
 		foff_w = boff_w = aoff_w = MINRANGE_WIDTH;
 		tot_w = MINTOT_WIDTH;
-		if (is_rt)
-			sunit = swidth = bbperag = 0;
-		else {
+		if (is_rt) {
+			if (fsgeo.rgcount == 0) {
+				bbperag = 0;
+			} else {
+				bbperag = (off64_t)fsgeo.rgblocks *
+					  (off64_t)fsgeo.blocksize / BBSIZE;
+			}
+			sunit = 0;
+			swidth = 0;
+		} else {
 			bbperag = (off64_t)fsgeo.agblocks *
 				  (off64_t)fsgeo.blocksize / BBSIZE;
 			sunit = (fsgeo.sunit * fsgeo.blocksize) / BBSIZE;
@@ -295,7 +302,7 @@ bmap_f(
 					(long long)(map[i + 1].bmv_block +
 						map[i + 1].bmv_length - 1LL));
 				boff_w = max(boff_w, strlen(bbuf));
-				if (!is_rt) {
+				if (bbperag > 0) {
 					agno = map[i + 1].bmv_block / bbperag;
 					agoff = map[i + 1].bmv_block -
 							(agno * bbperag);
@@ -312,13 +319,20 @@ bmap_f(
 					numlen(map[i+1].bmv_length, 10));
 			}
 		}
-		agno_w = is_rt ? 0 : max(MINAG_WIDTH, numlen(fsgeo.agcount, 10));
+		if (is_rt) {
+			if (fsgeo.rgcount > 0)
+				agno_w = max(MINAG_WIDTH, numlen(fsgeo.rgcount, 10));
+			else
+				agno_w = 0;
+		} else {
+			agno_w = max(MINAG_WIDTH, numlen(fsgeo.agcount, 10));
+		}
 		printf("%4s: %-*s %-*s %*s %-*s %*s%s\n",
 			_("EXT"),
 			foff_w, _("FILE-OFFSET"),
 			boff_w, is_rt ? _("RT-BLOCK-RANGE") : _("BLOCK-RANGE"),
-			agno_w, is_rt ? "" : _("AG"),
-			aoff_w, is_rt ? "" : _("AG-OFFSET"),
+			agno_w, is_rt ? (fsgeo.rgcount ? _("RG") : "") : _("AG"),
+			aoff_w, is_rt ? (fsgeo.rgcount ? _("RG-OFFSET") : "") : _("AG-OFFSET"),
 			tot_w, _("TOTAL"),
 			flg ? _(" FLAGS") : "");
 		for (i = 0; i < egcnt; i++) {
@@ -377,7 +391,7 @@ bmap_f(
 						map[i + 1].bmv_length - 1LL));
 				printf("%4d: %-*s %-*s", i, foff_w, rbuf,
 					boff_w, bbuf);
-				if (!is_rt) {
+				if (bbperag > 0) {
 					agno = map[i + 1].bmv_block / bbperag;
 					agoff = map[i + 1].bmv_block -
 							(agno * bbperag);

