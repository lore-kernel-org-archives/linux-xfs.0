Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30ECEC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 May 2022 20:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352820AbiEMUeR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 May 2022 16:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384537AbiEMUeM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 May 2022 16:34:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0BA1155
        for <linux-xfs@vger.kernel.org>; Fri, 13 May 2022 13:34:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0857B831C2
        for <linux-xfs@vger.kernel.org>; Fri, 13 May 2022 20:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D244C34113;
        Fri, 13 May 2022 20:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652474039;
        bh=Lmsp89AUfP46FXvs6Oo47YNcCmAxebv0NZqkgsGLdx8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nq/XE1yGxt8M3/HuNsslbQd8DgyaURx7ruRAV+OsIu+7gA4dDllKRjGrQPRW8yUtC
         Q5exu2ohLE4zgfMjcr9uZW6pcoHuGuo/d5gF0CNperPexSuLybXoTZQdD6qz8SF9uy
         fEHstOe3pIn4s5YT0V6gfZgpXX4GREvaqBnJfKhyslbajag1ZirkYHAGcuZsUxjZ2B
         IZTKzRELCcmYSbUYTeDnf11nOI27nd7GWwotI6wnfkn0L9uRxqom1qUCSQK0br5c1V
         LVkGn6QEVCuPpd0o5REKTU+gMpjxuxS9YhRo70/umvdZ3YdEkYUMzTaRDVntoIa5JR
         cvS87u0EsPC6g==
Subject: [PATCH 1/4] xfs_repair: fix sizing of the incore rt space usage map
 calculation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Fri, 13 May 2022 13:33:59 -0700
Message-ID: <165247403922.275439.1751140257416635238.stgit@magnolia>
In-Reply-To: <165247403337.275439.13973873324817048674.stgit@magnolia>
References: <165247403337.275439.13973873324817048674.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If someone creates a realtime volume exactly *one* extent in length, the
sizing calculation for the incore rt space usage bitmap will be zero
because the integer division here rounds down.  Use howmany() to round
up.  Note that there can't be that many single-extent rt volumes since
repair will corrupt them into zero-extent rt volumes, and we haven't
gotten any reports.

Found by running xfs/530 after fixing xfs_repair to check the rt bitmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/incore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/incore.c b/repair/incore.c
index 4ffe18ab..10a8c2a8 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -209,7 +209,7 @@ init_rt_bmap(
 	if (mp->m_sb.sb_rextents == 0)
 		return;
 
-	rt_bmap_size = roundup(mp->m_sb.sb_rextents / (NBBY / XR_BB),
+	rt_bmap_size = roundup(howmany(mp->m_sb.sb_rextents, (NBBY / XR_BB)),
 			       sizeof(uint64_t));
 
 	rt_bmap = memalign(sizeof(uint64_t), rt_bmap_size);

