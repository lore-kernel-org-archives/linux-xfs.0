Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E12AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbiLaBbZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbiLaBbY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:31:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072BDDECF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:31:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 980C661C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054D1C433EF;
        Sat, 31 Dec 2022 01:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450282;
        bh=bkEFSfYcyQ5RYf4PND9D1QFDLzol4sRnwrFjLRpjkuk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ks+2qTlo9He0Aup94tM5eESuDtiGxLRatwFx4fy6z3tfNB04zRbJdIbgb8E8L4Ryk
         brlrBA8dkUjkehKqjT9UyYCjCDXw4oVveZ3xgtTpa9/0DyexHn7dmTh2lap8XjmYa6
         TSivm9jsFp4QRozJhGesqsYHVLIGAVQA5giqc061o1MsdK7qwAb73ViCY+46320Wdc
         qi51m/guDOg+mb7ZlpYs9KH1IxTFegdeiHar6M3HmVSiPXlnYKWfxBfBosgEcaAoRB
         cCNmQZfdFMg4/hG30fTx/susL883zZ77VysxPTAjzowDuhCPuuCsLC4lQi9S9e3saZ
         fFM8kQZeN8AUA==
Subject: [PATCH 15/22] xfs: encode the rtbitmap in little endian format
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:54 -0800
Message-ID: <167243867482.712847.6507400689250147833.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_format.h   |    4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.c |    8 +++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 4096d3f069a3..c7752aaa4478 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 05b0e4e92a0a..3e99afea78a6 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -177,6 +177,9 @@ xfs_rtbitmap_getword(
 	struct xfs_mount	*mp,
 	union xfs_rtword_ondisk	*wordptr)
 {
+	if (xfs_has_rtgroups(mp))
+		return le32_to_cpu(wordptr->rtg);
+
 	return wordptr->raw;
 }
 
@@ -187,7 +190,10 @@ xfs_rtbitmap_setword(
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

