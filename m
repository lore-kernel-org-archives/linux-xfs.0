Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771A9C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 07:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28532619B7
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 07:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCWHM4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 03:12:56 -0400
Received: from m12-13.163.com ([220.181.12.13]:40231 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhCWHMu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 03:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=jDmKw
        smfdPUeQ2eaIc38URUQN8I2zqkw5DhJ8pout80=; b=CWweHAMtsF9OqweZ9NsWE
        3Os3XUGOUgZkaqdVJu9F5DY7r9RVS4wZA+03QTeow+gJI/c+hqIUIRfDMenh/1Rw
        eAMhGnGnMhlvVB+btMv+LGSPaQUGUmov5z0LmLU1vY4bqcGABFT6PeqsS1tJbbCq
        Wc/+ufJ9h1R24qPLvjt+FM=
Received: from localhost.localdomain (unknown [36.112.33.106])
        by smtp9 (Coremail) with SMTP id DcCowAAH_QHYiVlgKAVKCg--.1929S4;
        Tue, 23 Mar 2021 14:26:03 +0800 (CST)
From:   Zhen Zhao <zp_8483@163.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Zhen Zhao <zp_8483@163.com>
Subject: [PATCH v1] xfs: return err code if xfs_buf_associate_memory fail
Date:   Tue, 23 Mar 2021 02:24:56 -0400
Message-Id: <20210323062456.67938-1-zp_8483@163.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowAAH_QHYiVlgKAVKCg--.1929S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF4DWF48AFy7Gr4fGFW8Xrb_yoW3CrX_Ga
        12kwn7Kw1kAryxta1UJr9aq3Wagrsakrn7Xr4fKa4ayr18AFnrJF4DJ3Z5Xr4UCr9xtFn5
        AwsYqryFvFW7CjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUn3l1DUUUUU==
X-Originating-IP: [36.112.33.106]
X-CM-SenderInfo: h2sbmkiyt6il2tof0z/1tbiJRte4WAJkTxzkQAAsn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In kernel 3.10, when there is no memory left in the
system, fs_buf_associate_memory can fail, catch the
error and return.

Signed-off-by: Zhen Zhao <zp_8483@163.com>
---
 fs/xfs/xfs_log.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2e5581bc..32a41bf5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1916,8 +1916,11 @@ xlog_sync(
 	if (split) {
 		bp = iclog->ic_log->l_xbuf;
 		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
-		xfs_buf_associate_memory(bp,
+		error = xfs_buf_associate_memory(bp,
 				(char *)&iclog->ic_header + count, split);
+		if (error)
+			return error;
+
 		bp->b_fspriv = iclog;
 		bp->b_flags &= ~XBF_FLUSH;
 		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
-- 
2.27.0


