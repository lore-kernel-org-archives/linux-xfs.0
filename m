Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1383DC43334
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 12:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237138AbiFFMdn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 08:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237137AbiFFMdm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 08:33:42 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61761000
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 05:33:41 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LGtCY6jJ5z1K9H8;
        Mon,  6 Jun 2022 20:31:53 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 6 Jun 2022 20:33:40 +0800
Received: from [10.174.176.102] (10.174.176.102) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 6 Jun 2022 20:33:39 +0800
Message-ID: <534c6d3c-4bd1-c07d-d927-3715eb8c19b2@huawei.com>
Date:   Mon, 6 Jun 2022 20:33:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: [PATCH 2/3] db: avoid to use NULL pointer
From:   zhanchengbin <zhanchengbin1@huawei.com>
To:     <sandeen@sandeen.net>, <djwong@kernel.org>
CC:     <liuzhiqiang26@huawei.com>, linfeilong <linfeilong@huawei.com>,
        <linux-xfs@vger.kernel.org>
References: <7f4abf2a-5ea5-e2ee-786e-88d871d29475@huawei.com>
In-Reply-To: <7f4abf2a-5ea5-e2ee-786e-88d871d29475@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.102]
X-ClientProxiedBy: dggpeml100019.china.huawei.com (7.185.36.175) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Changed malloc to xmalloc.

Signed-off-by: zhanchengbin <zhanchengbin1@huawei.com>
---
  db/block.c | 2 +-
  db/check.c | 4 ++--
  db/faddr.c | 6 +++---
  db/namei.c | 2 +-
  4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/db/block.c b/db/block.c
index f31f9544..349cf6ec 100644
--- a/db/block.c
+++ b/db/block.c
@@ -180,7 +180,7 @@ dblock_f(
  		return 0;
  	}
  	nex = nb = type == TYP_DIR2 ? mp->m_dir_geo->fsbcount : 1;
-	bmp = malloc(nb * sizeof(*bmp));
+	bmp = xmalloc(nb * sizeof(*bmp));
  	bmap(bno, nb, XFS_DATA_FORK, &nex, bmp);
  	if (nex == 0) {
  		dbprintf(_("file data block is unmapped\n"));
diff --git a/db/check.c b/db/check.c
index a9c6e632..cc3c7832 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1782,7 +1782,7 @@ dir_hash_add(
  	dirhash_t		*p;

  	i = DIR_HASH_FUNC(hash, addr);
-	p = malloc(sizeof(*p));
+	p = xmalloc(sizeof(*p));
  	p->next = dirhash[i];
  	dirhash[i] = p;
  	p->hashval = hash;
@@ -3094,7 +3094,7 @@ process_leaf_node_dir_v2(
  	v2 = verbose || id->ilist;
  	v = parent = 0;
  	dbno = NULLFILEOFF;
-	freetab = malloc(FREETAB_SIZE(dirsize / mp->m_dir_geo->blksize));
+	freetab = xmalloc(FREETAB_SIZE(dirsize / mp->m_dir_geo->blksize));
  	freetab->naents = (int)(dirsize / mp->m_dir_geo->blksize);
  	freetab->nents = 0;
  	for (i = 0; i < freetab->naents; i++)
diff --git a/db/faddr.c b/db/faddr.c
index 0127c5d1..cc21faaf 100644
--- a/db/faddr.c
+++ b/db/faddr.c
@@ -137,7 +137,7 @@ fa_cfileoffd(
  		return;
  	}
  	nex = nb = next == TYP_DIR2 ? mp->m_dir_geo->fsbcount : 1;
-	bmp = malloc(nb * sizeof(*bmp));
+	bmp = xmalloc(nb * sizeof(*bmp));
  	bmap(bno, nb, XFS_DATA_FORK, &nex, bmp);
  	if (nex == 0) {
  		dbprintf(_("file block is unmapped\n"));
@@ -221,7 +221,7 @@ fa_dfiloffd(
  		return;
  	}
  	nex = nb = next == TYP_DIR2 ? mp->m_dir_geo->fsbcount : 1;
-	bmp = malloc(nb * sizeof(*bmp));
+	bmp = xmalloc(nb * sizeof(*bmp));
  	bmap(bno, nb, XFS_DATA_FORK, &nex, bmp);
  	if (nex == 0) {
  		dbprintf(_("file block is unmapped\n"));
@@ -274,7 +274,7 @@ fa_dirblock(
  		return;
  	}
  	nex = mp->m_dir_geo->fsbcount;
-	bmp = malloc(nex * sizeof(*bmp));
+	bmp = xmalloc(nex * sizeof(*bmp));
  	bmap(bno, mp->m_dir_geo->fsbcount, XFS_DATA_FORK, &nex, bmp);
  	if (nex == 0) {
  		dbprintf(_("directory block is unmapped\n"));
diff --git a/db/namei.c b/db/namei.c
index e44667a9..d1a9904b 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -266,7 +266,7 @@ dir_emit(
  		 * copy the string to a buffer so that we can add the null
  		 * terminator.
  		 */
-		display_name = malloc(namelen + 1);
+		display_name = xmalloc(namelen + 1);
  		memcpy(display_name, name, namelen);
  		display_name[namelen] = 0;
  		xname.len = namelen;
-- 
2.27.0

