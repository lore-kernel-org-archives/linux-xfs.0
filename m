Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9F3C04FE0
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 17:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjHDRLV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbjHDRLA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 13:11:00 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFB8469A
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 10:10:51 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-112-100.bstnma.fios.verizon.net [173.48.112.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 374HAUv0018433
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Aug 2023 13:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1691169032; bh=/2zJRyZjVdTFX93RUFfhWfBmOLfv1scRe50CT8jbvsY=;
        h=From:Subject:Date:Message-Id:MIME-Version;
        b=ZR4eu0Nn3GfNjmsoHWugzqeVCuOYfIU4UWJCDnbHjaTe+mmwOJ0PIzZh5ATyffmTd
         l7kOCT5Hv6I9HjZzYoh2IwEBYBjoX65wfObuQ6JnnlWlKuAErr/F7s4S+8IrO3rjfg
         vl5By9DYqXlRaiVzb94ofmYXoIq/t4EbvQHABqa0Qa98pBopxO+aLgqeGoJs1lhF4Z
         Ivls6cWpJer9Hb3C/Z8utzhBPeFf1SZm3ArTd+VBck83jY9AjLA/8xiO4LQqmxGDDp
         xXV4y6xmgr31oHtQAOnMGL5DSUGoGzZJtLg8ybYhttw9mFU2ItRuSsUEhvUbksEk4Q
         oIV51eDZ7WARg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 051A315C04F3; Fri,  4 Aug 2023 13:10:30 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, djwong@kernel.org, chandan.babu@oracle.com,
        leah.rumancik@gmail.com, Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH CANDIDATE v5.15 3/9] xfs: add missing cmap->br_state = XFS_EXT_NORM update
Date:   Fri,  4 Aug 2023 13:10:13 -0400
Message-Id: <20230804171019.1392900-3-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230804171019.1392900-1-tytso@mit.edu>
References: <20230802205747.GE358316@mit.edu>
 <20230804171019.1392900-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 1a39ae415c1be1e46f5b3f97d438c7c4adc22b63 upstream.

COW extents are already converted into written real extents after
xfs_reflink_convert_cow_locked(), therefore cmap->br_state should
reflect it.

Otherwise, there is another necessary unwritten convertion
triggered in xfs_dio_write_end_io() for direct I/O cases.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 36832e4bc803..628ce65d02bb 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -425,7 +425,10 @@ xfs_reflink_allocate_cow(
 	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
 		return 0;
 	trace_xfs_reflink_convert_cow(ip, cmap);
-	return xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
+	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
+	if (!error)
+		cmap->br_state = XFS_EXT_NORM;
+	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
-- 
2.31.0

