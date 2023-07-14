Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060F7EB64DA
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 06:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbjGNG0N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 02:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbjGNG0M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 02:26:12 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277AE2D57
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 23:26:11 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R2M1X75LJzBJYck
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 14:26:08 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689315968; x=1691907969; bh=T7C+qFpO5Z8k8C75zGGSrKXrnqN
        ynYdVGK4rmU6bAQ8=; b=i4gaxRtqQ0yvTR90x40wBAV1mHe1uR+FuqQHM661cZq
        YVFFNHZFhrBzC9MTIHaKd2CjM7LYbYf4rhEkFYY9WYHNxTcv6JV7b2koeP1U6DAT
        YNB5BhOams0tOcxbR04b6eWiU7Qxiy1ul94GFit6FDK3EorcxmDPrx36hIbFGj0Y
        1npaJ+pO1DUdNnWtlNBhL4AHu/wQBT8VVGjm+ncHIVSEQpFLGfQU5TCoiL9Qm6Jk
        yPrRu2hp9cUvEBd1Md+7ki8+jS+yuJOe8wG3GoJlWLxjzbdMAghD04thKHs9qRw9
        MAY6S+t1NeIdGXhozUBgOfG8ZHKpdCltk8wWP861QtA==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gdQWP5xAAoFQ for <linux-xfs@vger.kernel.org>;
        Fri, 14 Jul 2023 14:26:08 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R2M1X5VqJzBJFS7;
        Fri, 14 Jul 2023 14:26:08 +0800 (CST)
MIME-Version: 1.0
Date:   Fri, 14 Jul 2023 14:26:08 +0800
From:   liubin001@208suo.com
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xfs:Comparisons should place the constant on the right side
 of the test The if statement uses an assignment statement as a condition, 
 which is confusing.
In-Reply-To: <tencent_31C29C1E7BD35451F49750644121169CB608@qq.com>
References: <tencent_31C29C1E7BD35451F49750644121169CB608@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <e48842634c7d7ee1123d1887e7a04377@208suo.com>
X-Sender: liubin001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs:The if statement uses an assignment statement as a condition, which 
is confusing.
Signed-off-by: Liu Bin <liubin001@208suo.com>
---
  fs/xfs/xfs_trans_dquot.c | 7 +++++--
  1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index aa00cf67ad72..b429e95e425a 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -361,7 +361,8 @@ xfs_trans_apply_dquot_deltas(
               * The array of dquots is filled
               * sequentially, not sparsely.
               */
-            if ((dqp = qtrx->qt_dquot) == NULL)
+            dqp = qtrx->qt_dquot;
+            if (dqp == NULL)
                  break;

              ASSERT(XFS_DQ_IS_LOCKED(dqp));
@@ -492,8 +493,10 @@ xfs_trans_unreserve_and_mod_dquots(
              /*
               * We assume that the array of dquots is filled
               * sequentially, not sparsely.
+             *
               */
-            if ((dqp = qtrx->qt_dquot) == NULL)
+            dqp = qtrx->qt_dquot
+            if (dqp == NULL)
                  break;
              /*
               * Unreserve the original reservation. We don't care
