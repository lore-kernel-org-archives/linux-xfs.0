Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FD5C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjBPVyX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjBPVyW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:54:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC677199C1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:54:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DBABB829C1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF02EC433EF;
        Thu, 16 Feb 2023 21:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676584373;
        bh=a37Dj5RdtMGYRK2mNzeB8TS5yGaDkFpNxQ4UhsVZ1ME=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C1FSfbYLGS7lyjisbaOwE5PjUct4ji+Y1K2R+AGWPB8eoZhJ1mqQCX2ldDI+3yNtP
         vsbl+sWGap83Nez+lHd2zadASopnZ6SgzOfxxK4nj44otMXDSEiAYl2x8FOlUhvxe5
         HX+2vKk4KH+mijIPzNFctvXfQOIZV4zEKtLLCcE+xF4H76m/DTJN908ekq7I/JoUhj
         rUh/6zsMSejydjKlfoWPqrs61+0ER0SngFeNccea9kiBCwJ6xim78L8i0BGu+BN/CP
         72ZFWeP7cbZIq3XYuQg8adRsu60ANqe8p71EIBZH5SnNFbeVdqeSV31SXGAEBo2KZq
         zrxt4RwCwSSVw==
Subject: [PATCH 1/5] xfs_spaceman: fix broken -g behavior in freesp command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Date:   Thu, 16 Feb 2023 13:52:53 -0800
Message-ID: <167658437328.3590000.18137446679798085024.stgit@magnolia>
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

Don't zero out the histogram bucket count when turning on group summary
mode -- this will screw up the data structures and it's pointless.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 spaceman/freesp.c |    1 -
 1 file changed, 1 deletion(-)


diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index 423568a4248..70dcdb5c923 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -284,7 +284,6 @@ init(
 			speced = 1;
 			break;
 		case 'g':
-			histcount = 0;
 			gflag++;
 			break;
 		case 'h':

