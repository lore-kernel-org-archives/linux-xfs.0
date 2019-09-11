Return-Path: <SRS0=7YMi=XG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E477C5ACAE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Sep 2019 13:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D676920863
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Sep 2019 13:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbfIKNn1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Sep 2019 09:43:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36256 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727302AbfIKNn1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Sep 2019 09:43:27 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 32FE161D25;
        Wed, 11 Sep 2019 13:43:27 +0000 (UTC)
Received: from pegasus.maiolino.com (ovpn-204-18.brq.redhat.com [10.40.204.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E828C1001958;
        Wed, 11 Sep 2019 13:43:25 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     hch@lst.de, adilger@dilger.ca, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH 3/9] ecryptfs: drop direct calls to ->bmap
Date:   Wed, 11 Sep 2019 15:43:09 +0200
Message-Id: <20190911134315.27380-4-cmaiolino@redhat.com>
In-Reply-To: <20190911134315.27380-1-cmaiolino@redhat.com>
References: <20190911134315.27380-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 11 Sep 2019 13:43:27 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace direct ->bmap calls by bmap() method.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/ecryptfs/mmap.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index cffa0c1ec829..019572c6b39a 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -524,16 +524,12 @@ static int ecryptfs_write_end(struct file *file,
 
 static sector_t ecryptfs_bmap(struct address_space *mapping, sector_t block)
 {
-	int rc = 0;
-	struct inode *inode;
-	struct inode *lower_inode;
-
-	inode = (struct inode *)mapping->host;
-	lower_inode = ecryptfs_inode_to_lower(inode);
-	if (lower_inode->i_mapping->a_ops->bmap)
-		rc = lower_inode->i_mapping->a_ops->bmap(lower_inode->i_mapping,
-							 block);
-	return rc;
+	struct inode *lower_inode = ecryptfs_inode_to_lower(mapping->host);
+	int ret = bmap(lower_inode, &block);
+
+	if (ret)
+		return 0;
+	return block;
 }
 
 const struct address_space_operations ecryptfs_aops = {
-- 
2.20.1

