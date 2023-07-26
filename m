Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BA1EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 01:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjGZBnV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jul 2023 21:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjGZBnU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2023 21:43:20 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE2F26A2
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2023 18:43:19 -0700 (PDT)
Received: from dggpemm500014.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4R9c5v178RztRnj;
        Wed, 26 Jul 2023 09:40:03 +0800 (CST)
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 09:43:16 +0800
Message-ID: <bbaaee4c-06a7-36ca-a754-cf3677424f78@huawei.com>
Date:   Wed, 26 Jul 2023 09:43:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To:     <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
        <linux-xfs@vger.kernel.org>
CC:     <louhongxiang@huawei.com>, <liuzhiqiang26@huawei.com>
From:   Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH]xfs_repair: fix the problem of repair failure caused by dirty
 flag being abnormally set on buffer
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We found an issue where repair failed in the fault injection.

$ xfs_repair test.img
...
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
Metadata CRC error detected at 0x55a30e420c7d, xfs_bmbt block 0x51d68/0x1000
        - agno = 3
Metadata CRC error detected at 0x55a30e420c7d, xfs_bmbt block 0x51d68/0x1000
btree block 0/41901 is suspect, error -74
bad magic # 0x58534c4d in inode 3306572 (data fork) bmbt block 41901
bad data fork in inode 3306572
cleared inode 3306572
...
Phase 7 - verify and correct link counts...
Metadata corruption detected at 0x55a30e420b58, xfs_bmbt block 0x51d68/0x1000
libxfs_bwrite: write verifier failed on xfs_bmbt bno 0x51d68/0x8
xfs_repair: Releasing dirty buffer to free list!
xfs_repair: Refusing to write a corrupt buffer to the data device!
xfs_repair: Lost a write to the data device!

fatal error -- File system metadata writeout failed, err=117.  Re-run xfs_repair.


$ xfs_db test.img
xfs_db> inode 3306572
xfs_db> p
core.magic = 0x494e
core.mode = 0100666		  // regular file
core.version = 3
core.format = 3 (btree)	
...
u3.bmbt.keys[1] = [startoff]
1:[6]
u3.bmbt.ptrs[1] = 41901	 // btree root
...

$ hexdump -C -n 4096 41901.img
00000000  58 53 4c 4d 00 00 00 00  00 00 01 e8 d6 f4 03 14  |XSLM............|
00000010  09 f3 a6 1b 0a 3c 45 5a  96 39 41 ac 09 2f 66 99  |.....<EZ.9A../f.|
00000020  00 00 00 00 00 05 1f fb  00 00 00 00 00 05 1d 68  |...............h|
...

The block data associated with inode 3306572 is abnormal, but check the CRC first
when reading. If the CRC check fails, badcrc will be set. Then the dirty flag
will be set on bp when badcrc is set. In the final stage of repair, the dirty bp
will be refreshed in batches. When refresh to the disk, the data in bp will be
verified. At this time, if the data verification fails, resulting in a repair
error.

After scan_bmapbt returns an error, the inode will be cleaned up. Then bp
doesn't need to set dirty flag, so that it won't trigger writeback verification
failure.

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/scan.c b/repair/scan.c
index 7b720131..b5458eb8 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -185,7 +185,7 @@ scan_lbtree(

 	ASSERT(dirty == 0 || (dirty && !no_modify));

-	if ((dirty || badcrc) && !no_modify) {
+	if (!err && (dirty || badcrc) && !no_modify) {
 		libxfs_buf_mark_dirty(bp);
 		libxfs_buf_relse(bp);
 	}
-- 
2.27.0

