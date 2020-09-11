Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC22C433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 11:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A71FF21D91
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 11:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgIKLRK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Sep 2020 07:17:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38045 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgIKLQg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Sep 2020 07:16:36 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kGh2g-0007mi-2D; Fri, 11 Sep 2020 11:16:34 +0000
From:   Colin Ian King <colin.king@canonical.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: re: xfs: support inode btree blockcounts in online repair
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <7c612801-682a-0115-2b37-5d21b933960d@canonical.com>
Date:   Fri, 11 Sep 2020 12:16:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Static analysis with Coverity has detected an issue with the following
commit:

commit 30deae31eab501f568aadea45cfb3258b9e522f5
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Wed Aug 26 10:48:50 2020 -0700

    xfs: support inode btree blockcounts in online repair

the analysis is as follows:

830                cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp,
sc->sa.agno,
831                                XFS_BTNUM_FINO);

const: At condition error, the value of error must be equal to 0.
dead_error_condition: The condition error cannot be true.

 832                if (error)

CID: Logically dead code (DEADCODE)dead_error_line: Execution cannot
reach this statement: goto err;.

 833                        goto err;

While it is tempting to change the if (error) check to if (cur), the
exit error path uses the errnoeous cur as follows:

 842 err:
 843       xfs_btree_del_cursor(cur, error);
 844       return error;

so the error exit path needs some sorting out too.
