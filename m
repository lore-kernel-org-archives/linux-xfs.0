Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537A1C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbiLaBb5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbiLaBb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:31:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93F0DEB7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:31:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83631B81DD0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349D8C433D2;
        Sat, 31 Dec 2022 01:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450313;
        bh=mDLx1acuzkQ7LnkS9OCmISCHVJ8P8KiYkElI2JHKUEk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PhxmPoh4G0wNsSncVCeNsn3mynDxwlnmt4qudKhibJ5YS2/nSuH//dYGZ+HBi7b5m
         K2ust3Oz0vTV56i4YRMwL9mLOvnqLdWBSlFvhCA4fQ/q+1819+UqdccfIImaD1xNWI
         urUP+bDh/CFplaOvi+QxjYoovFIAe6438ZQfllk9LsTDTKsI0FnF/lfifeF/f3Aod/
         bkTu261BBUB5ViXWATFNeodjVbwJbhQLGPX5O5QlBwqimX7H95p7ulsH2ast4JX8uZ
         OOjeipb+TJnNWzEJe2B2azLYUMCLjLCI3PO2856SeSLJ+Y7rbRvDQh3qqD1r/S2Zy1
         Oyx5KbA5wB3uw==
Subject: [PATCH 17/22] xfs: encode the rtsummary in big endian format
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:55 -0800
Message-ID: <167243867511.712847.4394753972902151622.stgit@magnolia>
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

Currently, the ondisk realtime summary file counters are accessed in
units of 32-bit words.  There's no endian translation of the contents of
this file, which means that the Bad Things Happen(tm) if you go from
(say) x86 to powerpc.  Since we have a new feature flag, let's take the
opportunity to enforce an endianness on the file.  Encode the summary
information in big endian format, like most of the rest of the
filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h   |    4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.c |    8 +++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 47b2e31e2560..7e76bedda688 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -748,10 +748,12 @@ union xfs_rtword_ondisk {
 
 /*
  * Realtime summary counts are accessed by the word, which is currently
- * stored in host-endian format.
+ * stored in host-endian format.  Starting with the realtime groups feature,
+ * the words are stored in be32 ondisk.
  */
 union xfs_suminfo_ondisk {
 	__u32		raw;
+	__be32		rtg;
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 3d5b14cc0f3a..ccefbfc70f8b 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -562,6 +562,9 @@ xfs_suminfo_get(
 	struct xfs_mount	*mp,
 	union xfs_suminfo_ondisk *infoptr)
 {
+	if (xfs_has_rtgroups(mp))
+		return be32_to_cpu(infoptr->rtg);
+
 	return infoptr->raw;
 }
 
@@ -571,7 +574,10 @@ xfs_suminfo_add(
 	union xfs_suminfo_ondisk *infoptr,
 	int			delta)
 {
-	infoptr->raw += delta;
+	if (xfs_has_rtgroups(mp))
+		be32_add_cpu(&infoptr->rtg, delta);
+	else
+		infoptr->raw += delta;
 }
 
 /*

