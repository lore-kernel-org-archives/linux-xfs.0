Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1702BC6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjCPTam (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjCPTam (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:30:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA26DC0A1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E17A620F1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0054C433D2;
        Thu, 16 Mar 2023 19:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995035;
        bh=iCviZiQltjTcy+vt/iOvo/WHRVOCyTvk2x368hJOPLA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=lQMSWVbVQMPz4cpjZqnaR8qTjdYWMr5KkRJ9NRYPtY+p5x5jtASPhanUo0cAdkEoh
         EJRtWnZJ+xO9+/T+kAR+NlRQwLPQc7tnphlF3AHE22siLKicZIAde6bn83nKUlkC8Y
         e9m7ePm/edixMcg0vjx2biO6AliZoqB+SF5U+CFk7xsvbUqJ20ATHJHsImtmEFjUFZ
         z2NniN5j6/jzn66J2m3GbSx1OhyL0B6F9gv8vbo59QoWeltGbmXH5XI9vnu+jRk5Vt
         PXJoBkA0OSFalmQ8TzehlkVASJTPWo29/s8BJbHV8/baRO4K8EnMxg2+ZRBEIMTA0n
         q6FhqbIsRwRbQ==
Date:   Thu, 16 Mar 2023 12:30:35 -0700
Subject: [PATCH 7/7] libfrog: fix a buffer overrun in path_list_to_string
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416161.16628.955548688434298492.stgit@frogsfrogsfrogs>
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

Fix a buffer overrun when converting a path list to a string.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/paths.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/libfrog/paths.c b/libfrog/paths.c
index cc43b02c4..42e000295 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -694,13 +694,18 @@ path_list_to_string(
 	size_t			buflen)
 {
 	struct path_component	*pos;
+	char			*buf_end = buf + buflen;
 	ssize_t			bytes = 0;
 	int			ret;
 
 	list_for_each_entry(pos, &path->p_head, pc_list) {
+		if (buf >= buf_end)
+			return -1;
+
 		ret = snprintf(buf, buflen, "/%s", pos->pc_fname);
-		if (ret != 1 + strlen(pos->pc_fname))
+		if (ret < 0 || ret >= buflen)
 			return -1;
+
 		bytes += ret;
 		buf += ret;
 		buflen -= ret;

