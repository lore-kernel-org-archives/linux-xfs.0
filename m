Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA99C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbiLaCd3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236147AbiLaCd2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:33:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE0826D9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:33:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28F0DB81DED
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E6AC433EF;
        Sat, 31 Dec 2022 02:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454004;
        bh=imQubqf5SzMIgHdaO6aurOCUQ48rVrg+xQI1QA8Lkx8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BFwme/sDNtit5GiHzLDCGJCM3wqKYBtetVacrhdRzojLdZ5+mOo4BKOmHDumIyejn
         aeDtkQpO3eWFL80g+eowNwtbP9i9PbKFjPHCBH9ALUSZe6UvnaxFAeR4+a0SwkeowQ
         YQmCwz4/I2zLF93SqaqrGn0wqITO19uJgb76WyFE613jPFgqoY3W94ztEdLBimUY8I
         ENtbDD+lknSJoWU039h2o3tcEQwoKgitbeR0VrCfv6kUVmRHjHav4IzFve5dXzljFc
         3Ne9tZ2x2+qa5RhrZhTKVZRZbpl+2xJBiP5Q0Q5lt8iQ46znhTAVPu6SnLnspl2fqy
         9kzuO+qs4xqZA==
Subject: [PATCH 13/45] xfs: encode the rtbitmap in little endian format
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:45 -0800
Message-ID: <167243878535.731133.10030127003706643947.stgit@magnolia>
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

Currently, the ondisk realtime bitmap file is accessed in units of
32-bit words.  There's no endian translation of the contents of this
file, which means that the Bad Things Happen(tm) if you go from (say)
x86 to powerpc.  Since we have a new feature flag, let's take the
opportunity to enforce an endianness on the file.

The natural format of a bitmap is (IMHO) little endian, because the byte
offsets of the bitmap data should always increase in step with the
information being indexed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h   |    4 +++-
 libxfs/xfs_rtbitmap.c |    8 +++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 4096d3f069a..c7752aaa447 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -738,10 +738,12 @@ struct xfs_agfl {
 
 /*
  * Realtime bitmap information is accessed by the word, which is currently
- * stored in host-endian format.
+ * stored in host-endian format.  Starting with the realtime groups feature,
+ * the words are stored in le32 ondisk.
  */
 union xfs_rtword_ondisk {
 	__u32		raw;
+	__le32		rtg;
 };
 
 /*
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 2e286a22196..db80f740151 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -173,6 +173,9 @@ xfs_rtbitmap_getword(
 	struct xfs_mount	*mp,
 	union xfs_rtword_ondisk	*wordptr)
 {
+	if (xfs_has_rtgroups(mp))
+		return le32_to_cpu(wordptr->rtg);
+
 	return wordptr->raw;
 }
 
@@ -183,7 +186,10 @@ xfs_rtbitmap_setword(
 	union xfs_rtword_ondisk	*wordptr,
 	xfs_rtword_t		incore)
 {
-	wordptr->raw = incore;
+	if (xfs_has_rtgroups(mp))
+		wordptr->rtg = cpu_to_le32(incore);
+	else
+		wordptr->raw = incore;
 }
 
 /*

