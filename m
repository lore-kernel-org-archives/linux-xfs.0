Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A036EC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjBPVFT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjBPVFT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:05:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E010505D3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:05:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1815EB826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DBEC433D2;
        Thu, 16 Feb 2023 21:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581515;
        bh=V3qfY/0jz7ZA+ArWQMcJJ5mQocu4dVWeZwdjE0/qRac=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ifks/CDY2Vk2iaEX1amG96iC827vhFzV/7Y7Vh2jZBXeSttPYXM1+TGlzlGzT1tRU
         U2ddno0qu7QaTawiwzGfAXgxSW+rc/cJpgdeedJmUrGQNVYgdwm40agn3oGsZ2GnSq
         LwotZ3Gam93sjNHpexLNNfBqETChtq7WurPOElG1RcOS6O2oQXCuvrc2CEJs8RCzeF
         qFeNhfX7zugXThefrryF2Tf+tKiVLAa40CNtF9fehXxfHCG3dYaHcJaojJgiB2kTGH
         11IZNojDz5rf/TXMw/HYpoNLnYVg7oijsIaaQAhSABiqGkMObvtxwgvjIeE2mzn+li
         GVp4kx8BD9s8w==
Date:   Thu, 16 Feb 2023 13:05:15 -0800
Subject: [PATCH 08/10] libfrog: trim trailing slashes when printing pptr paths
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880363.3477097.15991358215180868688.stgit@magnolia>
In-Reply-To: <167657880257.3477097.11495108667073036392.stgit@magnolia>
References: <167657880257.3477097.11495108667073036392.stgit@magnolia>
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
index 25d835a3..694c0839 100644
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
index 8d9e62a2..61fd1fb9 100644
--- a/libfrog/pptrs.c
+++ b/libfrog/pptrs.c
@@ -268,10 +268,15 @@ handle_to_path_walk(
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

