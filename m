Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83E4C05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 03:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjBIDRm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 22:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbjBIDRl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 22:17:41 -0500
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42D525FD4
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 19:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=S+Rs1
        MbQ/ZNAOrwD1O0pUrEbsUROivvmoT3Xq361E30=; b=kcX8X7ujJXKEs0Yf36W+n
        gdEm/QHbENSdu9Uiz7pOt8NPPtJs+pxu0ErS1Gf8ZxemMaXiNIJ69XGWaxMo8x+I
        /vTwLdpcPZfXP0OOowlG/NNLCcRGcT1QfX9cxU+0csv7UFC95ttkXgUXhc58oJhj
        zLU1It5N6Bg35GEsH+zDXs=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by zwqz-smtp-mta-g2-1 (Coremail) with SMTP id _____wBnkFaxZeRjKzblAg--.47897S2;
        Thu, 09 Feb 2023 11:17:11 +0800 (CST)
From:   Xiaole He <hexiaole1994@126.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, dchinner@redhat.com, chandan.babu@oracle.com,
        huhai@kylinos.cn, zhangshida@kylinos.cn,
        Xiaole He <hexiaole1994@126.com>,
        Xiaole He <hexiaole@kylinos.cn>
Subject: [PATCH v1 1/2] xfs: fix typo from filesystes to filesystems
Date:   Thu,  9 Feb 2023 11:16:36 +0800
Message-Id: <20230209031637.19026-1-hexiaole1994@126.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wBnkFaxZeRjKzblAg--.47897S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWfWF4DGFWxtr18tFWkJFb_yoW3JFg_Ca
        nrtrs7Z34qyryfZ3ZxJan8Kr109a1fGr9rGa4fCFW3tw4UGa4kX39xJrsIyF13GrWfCr4r
        Ja9rWrWak34v9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRZBMNPUUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5kh0xt5rohimizu6ij2wof0z/1tbikA8RBlpEC6SapQACsE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Xiaole He <hexiaole@kylinos.cn>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f8ff81c3de76..7ebef43e3c1f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -41,7 +41,7 @@ STATIC int xfs_alloc_ag_vextent_near(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 
 /*
- * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of slots in
+ * Size of the AGFL.  For CRC-enabled filesystems we steal a couple of slots in
  * the beginning of the block for a proper header with the location information
  * and CRC.
  */
-- 
2.27.0

