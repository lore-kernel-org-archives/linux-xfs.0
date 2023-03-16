Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3F4C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjCPTa1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCPTa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:30:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A82685A55
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B9FCB82302
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D7AC4339C;
        Thu, 16 Mar 2023 19:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995020;
        bh=3GjQrUq7tVwIC8k/B8voSnlgNxrNNFjdDwApY/XUtb8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=onpbzE/8P4u2op9MP65PrPHA/GTujtJaEUpUD/pcUu7VCOrwRxQMYPf+AycpgMpVi
         y2jresOXdXp5ouFr39JABGC0Chvh9KJJUDPEwdabCCyBhwHo32aXEL3Rii/sjUg3Ch
         73APhEtzpNxLatc2oZ/VQqWshMD+Pex4Z/LrmpA5VpnNYJqAM3TaaFDvRznoqKGOOf
         y0ZAq++APF0VRXnXpwJbpIFl2mwfIOvArV02o7Y97bh19qWEdQoGPOdGcQfkONhdv4
         mYXBZYs6yXB/XsVMa+NCWSPRH+XFizgRoilVY+W8jSjaiG2q7LuHuHIHr8BMddQhrv
         50nV331quG2SQ==
Date:   Thu, 16 Mar 2023 12:30:19 -0700
Subject: [PATCH 6/7] libfrog: trim trailing slashes when printing pptr paths
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416148.16628.3062260277371930152.stgit@frogsfrogsfrogs>
In-Reply-To: <167899416068.16628.8907331389138892555.stgit@frogsfrogsfrogs>
References: <167899416068.16628.8907331389138892555.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Trim the trailing slashes in the mountpoint string when we're printing
parent pointer paths.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/parent.c     |    9 +++++++--
 libfrog/pptrs.c |    9 +++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)


diff --git a/io/parent.c b/io/parent.c
index 6c0d81c12..36522f262 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -97,6 +97,7 @@ path_print(
 	struct pptr_args	*args = arg;
 	char			buf[PATH_MAX];
 	size_t			len = PATH_MAX;
+	int			mntpt_len = strlen(mntpt);
 	int			ret;
 
 	if (args->filter_ino || args->filter_name) {
@@ -105,8 +106,12 @@ path_print(
 			return 0;
 	}
 
-	ret = snprintf(buf, len, "%s", mntpt);
-	if (ret != strlen(mntpt))
+	/* Trim trailing slashes from the mountpoint */
+	while (mntpt_len > 0 && mntpt[mntpt_len - 1] == '/')
+		mntpt_len--;
+
+	ret = snprintf(buf, len, "%.*s", mntpt_len, mntpt);
+	if (ret != mntpt_len)
 		return ENAMETOOLONG;
 
 	ret = path_list_to_string(path, buf + ret, len - ret);
diff --git a/libfrog/pptrs.c b/libfrog/pptrs.c
index b61a4e005..488682738 100644
--- a/libfrog/pptrs.c
+++ b/libfrog/pptrs.c
@@ -267,10 +267,15 @@ handle_to_path_walk(
 	void			*arg)
 {
 	struct path_walk_info	*pwi = arg;
+	int			mntpt_len = strlen(mntpt);
 	int			ret;
 
-	ret = snprintf(pwi->buf, pwi->len, "%s", mntpt);
-	if (ret != strlen(mntpt))
+	/* Trim trailing slashes from the mountpoint */
+	while (mntpt_len > 0 && mntpt[mntpt_len - 1] == '/')
+		mntpt_len--;
+
+	ret = snprintf(pwi->buf, pwi->len, "%.*s", mntpt_len, mntpt);
+	if (ret != mntpt_len)
 		return ENAMETOOLONG;
 
 	ret = path_list_to_string(path, pwi->buf + ret, pwi->len - ret);

