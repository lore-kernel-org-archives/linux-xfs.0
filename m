Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FDCC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbiLaCid (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiLaCiG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:38:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2B22DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:38:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A68561CBF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA892C433D2;
        Sat, 31 Dec 2022 02:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454285;
        bh=SINQRA3kHr1SgQG2ErBULF2vhqum+u7HDbCMXWZi2tY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C+A+nu/9yVeb6OI/j+wWb0ci9Zc+oTkZys+pVe3GIYMSUuJcTI4m+bcm+8TkhxcBA
         tPLCwS2Ko1eaAwcocI77svuQPCaQoPnNn2sNzd89+z2o5ft6/hONklic+D0PzQnJ9X
         yNal3v9PrvcVo37ZaQjy9ydWiUspF4nLhbejncc8zUQylniNC3nviMoMJqpbUuwvgl
         HXZnr8ItpqarL2sBDmqaqwQrLbtCpsdgKp0Bi9/yRm0TsL13ECZpf0PKji1A/Zpor8
         CyaB0ztzrNCwEIJ9XL2LBuemO603aAWPomjfHvV3fM9AsH1Z1g/x7/3+cRODoogno2
         R+4c3Zn2yqY9Q==
Subject: [PATCH 31/45] xfs_db: report rtgroups via version command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:47 -0800
Message-ID: <167243878771.731133.5565215367768506.stgit@magnolia>
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

Report the rtgroups feature in the version command output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index 36d4c317dba..52c5edc065a 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -852,6 +852,8 @@ version_string(
 		strcat(s, ",NREXT64");
 	if (xfs_has_metadir(mp))
 		strcat(s, ",METADIR");
+	if (xfs_has_rtgroups(mp))
+		strcat(s, ",RTGROUPS");
 	return s;
 }
 

