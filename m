Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E8EC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiKICGC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKICGB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:06:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E885860E88
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:06:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 705316187F
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBFCC433D6;
        Wed,  9 Nov 2022 02:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959559;
        bh=dfdgpTDWgLucjj3sFy6zjfMm8FODrAHQ0xekjesk/6o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=H0ByaixnbUGGlhIa5YBvGAM/jLp6XYAEwRbHhhh3wWeLm7LvgcxS3gw4GuLcg3m6z
         pg2UG54u6rzJ6/K1RrA3sxXRlOsn17BPBjJGXo9w+H8NeaBjoGhbFdMrzEn2V03h7Z
         xpYss0U+9+DIqaBmQwx4d+Gk5xP9WiwrazQPZ4bIXThiYw5zSWydsLhuLceKioXegG
         nCj4/l0RQgei+pkO2QjfElAeMouPcWBinJsZLSh9Jy0/tRwy3lsEmBvvYC9peJ19Ry
         Lg78qDRX9jTeBZF02rAxTFdioKw4K1GmwS773REequfwPsdAsp7KNH3eGnjOw6b2ks
         rSmUKCr0DL5Gg==
Subject: [PATCH 03/24] xfs: trim the mapp array accordingly in
 xfs_da_grow_inode_int
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Shida Zhang <zhangshida@kylinos.cn>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:05:59 -0800
Message-ID: <166795955941.3761583.17493578275711914726.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Shida Zhang <zhangshida@kylinos.cn>

Source kernel commit: 44159659df8ca381b84261e11058b2176fa03ba0

Take a look at the for-loop in xfs_da_grow_inode_int:
======
for(){
nmap = min(XFS_BMAP_MAX_NMAP, count);
...
error = xfs_bmapi_write(...,&mapp[mapi], &nmap);//(..., $1, $2)
...
mapi += nmap;
}
=====
where $1 stands for the start address of the array,
while $2 is used to indicate the size of the array.

The array $1 will advance by $nmap in each iteration after
the allocation of extents.
But the size $2 still remains unchanged, which is determined by
min(XFS_BMAP_MAX_NMAP, count).

It seems that it has forgotten to trim the mapp array after each
iteration, so change it.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_da_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 9dc22f2ff1..a068a01643 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2188,8 +2188,8 @@ xfs_da_grow_inode_int(
 		 */
 		mapp = kmem_alloc(sizeof(*mapp) * count, 0);
 		for (b = *bno, mapi = 0; b < *bno + count; ) {
-			nmap = min(XFS_BMAP_MAX_NMAP, count);
 			c = (int)(*bno + count - b);
+			nmap = min(XFS_BMAP_MAX_NMAP, c);
 			error = xfs_bmapi_write(tp, dp, b, c,
 					xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
 					args->total, &mapp[mapi], &nmap);

