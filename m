Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D893C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjBPVzc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBPVzb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:55:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8715C1B56F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:55:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12F11B829C5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B184EC433EF;
        Thu, 16 Feb 2023 21:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676584390;
        bh=bFU+IBKoOyXU/gXF6xo2HK3PjRQAbaztWiJc5eRm4vo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ohaMR/jE7oChuAlsg53ZFRallfnwoh/Kpi+1rqNkMFzKTtV/bbi5v2OVI/nEvs7X+
         1ZDBpOxPH9Msb0Bj4vVCF7nAbWO0/pPI/pNm8U4DWu8+UzXjP4fLwWtLQe8B8r/L8m
         DP8wtrzWvqBcNvY7s0bMpN4PTrckuSFQHj0q98UCu/ij15/VPB06pkyH48Mei+mpRV
         JEPEErk9qlihxGniovqklc7BQfGnThIgwcbNrPJyc+PvNXh3Snxi+d/S9hjgvSeoH2
         F6sNDMgmYpxTNn5Qud0I3sQnINJoZC/fmbeeUYotXY8/UTiR55gEuDfa1CB2h4clr1
         4QU4BLrV/7cRQ==
Subject: [PATCH 4/5] xfs_io: fix bmap command not detecting realtime files
 with xattrs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        daan.j.demeyer@gmail.com
Date:   Thu, 16 Feb 2023 13:53:10 -0800
Message-ID: <167658439020.3590000.194008272775624083.stgit@magnolia>
In-Reply-To: <167658436759.3590000.3700844510708970684.stgit@magnolia>
References: <167658436759.3590000.3700844510708970684.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix the bmap command so that it will detect a realtime file if any of
the other file flags (e.g. xattrs) are set.  Observed via xfs/556.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/io/bmap.c b/io/bmap.c
index 27383ca6037..722a389baaa 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -118,7 +118,7 @@ bmap_f(
 			return 0;
 		}
 
-		if (fsx.fsx_xflags == FS_XFLAG_REALTIME) {
+		if (fsx.fsx_xflags & FS_XFLAG_REALTIME) {
 			/*
 			 * ag info not applicable to rt, continue
 			 * without ag output.

