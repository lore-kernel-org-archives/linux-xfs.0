Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6A8C3F2CD
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 08:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC3212146E
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 08:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgCEI3C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 03:29:02 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:44252 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725844AbgCEI3C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Mar 2020 03:29:02 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CFA217F2327BCD73BA59;
        Thu,  5 Mar 2020 16:28:59 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Mar 2020
 16:28:56 +0800
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        <linux-xfs@vger.kernel.org>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Subject: Questions about CVE-2016-8660
Message-ID: <50013503-3b51-c1ac-dcc3-31266609b973@huawei.com>
Date:   Thu, 5 Mar 2020 16:28:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Recently I am studying CVE-2016-8660, in https://seclists.org/oss-sec/2016/q4/118,
it says that this bug is introduced by commit fc0561cefc04 ("xfs: optimise away log forces on timestamp updates for fdatasync").
And in https://patchwork.kernel.org/patch/9363339/#19693745, david correction has nothing to do with this commit,
and is a page lock order bug in the XFS seek hole/data implementation(demsg is in http://people.redhat.com/qcai/tmp/dmesg-sync,
Unfortunately, it is not accessible now, I do not understand why this is a page lock order bug).

Is this CVE solved? Can I see the demsg in other way? thanks.


