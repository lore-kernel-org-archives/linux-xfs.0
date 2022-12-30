Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42794C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbiLaC1p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiLaC1o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:27:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B4D1C921
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:27:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F45E61CC6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B30C433EF;
        Sat, 31 Dec 2022 02:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453662;
        bh=0V1mRCQ+Bkkeq+VSeGRgrm1lRnbR85uvxH1EhYSQawc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O3tqzLCOwCzR4SUCoQJQgHe8ZHRVY7WufzEBbE8DM1+M+2OSHTk/cJ6dg2lZpCVTt
         HmDCCqbf03Y521cUHj1GSzP+/jHC29NULvliTv/cOSVX5TkGF+e6TgSFRCO+XTgsWk
         0Df1jxGFRDzA3XVuiueWcpL2MmYgzz6eeCSjrp5JX/vhejFigG9oPKB1X0VvDDwsOj
         vgJi09eYac0t27o4Uo+9rMuZkCjXXCpbJW2ABn7Zq5yurqWEiINz3C//yFcsF/yYTb
         OTeilvCPzi4RMEcXxzjKLvC7D0uI3YhByBd5dk7+qHLBPTt3nZEgo93SGX/OI3rkgs
         GJADjfIh36DLQ==
Subject: [PATCH 4/8] xfs_db: access realtime file blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:36 -0800
Message-ID: <167243877664.728317.4712975169277704547.stgit@magnolia>
In-Reply-To: <167243877610.728317.12510123562097453242.stgit@magnolia>
References: <167243877610.728317.12510123562097453242.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have the ability to point the io cursor at the realtime
device, let's make it so that the "dblock" command can walk the contents
of realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c |   17 +++++++++++++++--
 db/faddr.c |    4 +++-
 2 files changed, 18 insertions(+), 3 deletions(-)


diff --git a/db/block.c b/db/block.c
index d064fbed5aa..ae8744685b0 100644
--- a/db/block.c
+++ b/db/block.c
@@ -195,6 +195,13 @@ dblock_help(void)
 ));
 }
 
+static inline bool
+is_rtfile(
+	struct xfs_dinode	*dip)
+{
+	return dip->di_flags & cpu_to_be16(XFS_DIFLAG_REALTIME);
+}
+
 static int
 dblock_f(
 	int		argc,
@@ -234,8 +241,14 @@ dblock_f(
 	ASSERT(typtab[type].typnm == type);
 	if (nex > 1)
 		make_bbmap(&bbmap, nex, bmp);
-	set_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
-		nb * blkbb, DB_RING_ADD, nex > 1 ? &bbmap : NULL);
+	if (is_rtfile(iocur_top->data))
+		set_rt_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
+				nb * blkbb, DB_RING_ADD,
+				nex > 1 ? &bbmap : NULL);
+	else
+		set_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
+				nb * blkbb, DB_RING_ADD,
+				nex > 1 ? &bbmap : NULL);
 	free(bmp);
 	return 0;
 }
diff --git a/db/faddr.c b/db/faddr.c
index ec4aae68bb5..fd65b86b5e9 100644
--- a/db/faddr.c
+++ b/db/faddr.c
@@ -323,7 +323,9 @@ fa_drtbno(
 		dbprintf(_("null block number, cannot set new addr\n"));
 		return;
 	}
-	/* need set_cur to understand rt subvolume */
+
+	set_rt_cur(&typtab[next], (int64_t)XFS_FSB_TO_BB(mp, bno), blkbb,
+			DB_RING_ADD, NULL);
 }
 
 /*ARGSUSED*/

