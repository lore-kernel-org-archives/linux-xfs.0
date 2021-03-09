Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6005CC43381
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D2ED652B3
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhCIElN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:41:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:32990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhCIEkm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:40:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EF70652AB;
        Tue,  9 Mar 2021 04:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264842;
        bh=TC8sqN/K3xRmSr3J0c+aaYt48aeySfMJX7cOvq0X+1Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YROBj0y2SKlsZIwGac97uHH9r9Vay6ZqJc9x4dEztoblu0UW96SptEUo8if50L7l4
         1RdnRVXG1fN32d2JfQ8TpPa5V7u602mMq5cjAldFlCGsi9xzB9OZ7F5yuzd5aESSi3
         o/8/aSQafwXoSUwicEJldclZjPGzeX2vFInUhmd/li9zuZhc+Ybc/LtqF6yFV7fQCy
         azMWPJwV1Ht6+Lgm+5lHA+H2QXoYlxyxNwxGE4ssV5tZsG8Mma6dHth7rF5aHRgB9z
         L9RoSrI3QWcEo8Ktt+RjSOCGLI1c/qN/IMo+F/ZDBURvi+tawIe/6wpN+XRcH8cy/y
         bK3tNggyLZYcQ==
Subject: [PATCH 07/10] xfs/122: fix test for xfs_attr_shortform_t conversion
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:40:42 -0800
Message-ID: <161526484222.1214319.7083379928394196240.stgit@magnolia>
In-Reply-To: <161526480371.1214319.3263690953532787783.stgit@magnolia>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The typedef xfs_attr_shortform_t was converted to a struct in 5.10.
Update this test to pass.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/122     |    1 -
 tests/xfs/122.out |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/122 b/tests/xfs/122
index a4248031..322e1d81 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -72,7 +72,6 @@ for hdr in /usr/include/xfs/xfs*.h; do
 done
 
 # missing:
-# xfs_attr_shortform_t
 # xfs_trans_header_t
 
 cat >$tmp.ignore <<EOF
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 45c42e59..cfe09c6d 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -62,6 +62,7 @@ sizeof(struct xfs_agfl) = 36
 sizeof(struct xfs_attr3_leaf_hdr) = 80
 sizeof(struct xfs_attr3_leafblock) = 88
 sizeof(struct xfs_attr3_rmt_hdr) = 56
+sizeof(struct xfs_attr_shortform) = 8
 sizeof(struct xfs_btree_block) = 72
 sizeof(struct xfs_btree_block_lhdr) = 64
 sizeof(struct xfs_btree_block_shdr) = 48

