Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD58CC433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D6C9611AB
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhDIOSs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 10:18:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48411 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbhDIOSs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Apr 2021 10:18:48 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lUrxy-0004mK-8f; Fri, 09 Apr 2021 14:18:34 +0000
From:   Colin King <colin.king@canonical.com>
To:     "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: fix return of uninitialized value in variable error
Date:   Fri,  9 Apr 2021 15:18:34 +0100
Message-Id: <20210409141834.667163-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A previous commit removed a call to xfs_attr3_leaf_read that
assigned an error return code to variable error. We now have
a few early error return paths to label 'out' that return
error if error is set; however error now is uninitialized
so potentially garbage is being returned.  Fix this by setting
error to zero to restore the original behaviour where error
was zero at the label 'restart'.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/xfs/libxfs/xfs_attr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 472b3039eabb..902e5f7e6642 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -928,6 +928,7 @@ xfs_attr_node_addname(
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
+	error = 0;
 	retval = xfs_attr_node_hasname(args, &state);
 	if (retval != -ENOATTR && retval != -EEXIST)
 		goto out;
-- 
2.30.2

