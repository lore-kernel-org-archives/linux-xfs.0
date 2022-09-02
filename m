Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E666C38145
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Sep 2022 11:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbiIBLGR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Sep 2022 07:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiIBLGP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Sep 2022 07:06:15 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4FBA5C52
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 04:06:14 -0700 (PDT)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MJw3j0ny2z1N7l9;
        Fri,  2 Sep 2022 19:02:25 +0800 (CST)
Received: from huawei.com (10.175.124.27) by kwepemi500019.china.huawei.com
 (7.221.188.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 2 Sep
 2022 19:06:06 +0800
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     <david@fromorbit.com>
CC:     <chandan.babu@oracle.com>, <dchinner@redhat.com>,
        <djwong@kernel.org>, <guoxuenan@huawei.com>, <houtao1@huawei.com>,
        <jack.qiu@huawei.com>, <linux-xfs@vger.kernel.org>,
        <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: add fstest xfs/554 and patch v2
Date:   Fri, 2 Sep 2022 19:24:07 +0800
Message-ID: <20220902112407.3989875-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220829081244.GT3600936@dread.disaster.area>
References: <20220829081244.GT3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave & Darrick:

To reproduce this problem add xfs/554 [1].
And, I resend a patch v2 [2], considering the situation mentioned by Darrick,
Meanwhile, check the i_disk_size or get dir blocks at xfs_dir3_leaf_check_int
looks a little strange. So in my opinion, we can just add judgment in that
situation, avoiding UAF and return EFSCORRUPTED, xfs_repair will help us fix it.

[1] https://lore.kernel.org/all/20220902094046.3891252-1-guoxuenan@huawei.com/
[2] https://lore.kernel.org/all/20220831121639.3060527-1-guoxuenan@huawei.com/



thanks
Xueanan
