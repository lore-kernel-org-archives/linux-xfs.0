Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7061C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Feb 2021 07:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 861E164E56
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Feb 2021 07:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhB1Hum (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Feb 2021 02:50:42 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:57601 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229820AbhB1Hum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Feb 2021 02:50:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0UPnZxJ2_1614498575;
Received: from 30.39.186.82(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UPnZxJ2_1614498575)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 28 Feb 2021 15:49:35 +0800
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: code questions about xfs log implementation
Message-ID: <a732a6ff-4d66-91e5-cd9a-43d156d83362@linux.alibaba.com>
Date:   Sun, 28 Feb 2021 15:46:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

hi,

I'm studying xfs delayed logging codes, and currently have some questions about log
reservation, can anyone help to answer below questions, thanks in advance!

1, what's the difference between xlog's l_reserve_head and l_write_head?
Seems that l_reserve_head already can been used to do log space reservation, from
codes, I really don't get when to use l_reserve_head or l_write_head, so what different
cases are they used for?

2, what's the exact definition about permanent transaction reservation?
In xfs_trans_resv_calc(), I see many kinds of transactions have XFS_TRANS_PERM_LOG_RES
enabled, so non-permanent transaction does not need to do log reservation
at the begin?

3, struct xfs_trans_res's tr_logcount(/* number of log operations per log ticket */)
For exmaple, tr_write.tr_logcount is XFS_WRITE_LOG_COUNT_REFLINK(8), does that mean
to complete a write operation, we'll need 8 log operations, such as file block mapping
update intent will be counted one?

4, what's the exact definition about xfs rolling transactions?
Is that because we use WAL log ing xfs, so for example, if we free a file extent,
we at least create an extent free intent in one transaction, and when this transaction
is committed to disk, then do the real xfs b+ tree modifications, finally once
we completed the b+ tree modifications, we log an extent free done intent in one
new transactino? so we'll need to reserve all the needed log space an the begin,
and the whole process needs multiple transactions, so it's named rolling transactions?

5, finally are there any documents that describe the initial xfs log design before
current delayed logging design?
Documentation/filesystems/xfs-delayed-logging-design.rst is a very good document, but
seems that it assumes that readers has been familiar with initial xfs log design.


Regards,
Xiaoguang Wang
