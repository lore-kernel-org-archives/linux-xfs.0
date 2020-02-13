Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806A3C2BA83
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 08:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52E9421734
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 08:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgBMIdv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 03:33:51 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9733 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbgBMIdu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Feb 2020 03:33:50 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B46EC3569906EF4565EF;
        Thu, 13 Feb 2020 16:33:48 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Thu, 13 Feb 2020
 16:33:39 +0800
Subject: Re: Questions about XFS abnormal img mount test
To:     Dave Chinner <david@fromorbit.com>
CC:     "Darrick J. Wong" <darrick.wong@oracle.com>, <sandeen@redhat.com>,
        <linux-xfs@vger.kernel.org>, <renxudong1@huawei.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>
References: <ea7db6e3-8a3a-a66d-710c-4854c4e5126c@huawei.com>
 <20200211011538.GC10776@dread.disaster.area>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <852729bc-729a-3ec5-bd85-f2b445ab07e3@huawei.com>
Date:   Thu, 13 Feb 2020 16:33:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20200211011538.GC10776@dread.disaster.area>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2020/2/11 9:15, Dave Chinner wrote:
> On Mon, Feb 10, 2020 at 11:02:08AM +0800, zhengbin (A) wrote:
>> ### question
>> We recently used fuzz(hydra) to test 4.19 stable XFS and automatically generate tmp.img (XFS v5 format, but some metadata is wrong)
> So you create impossible situations in the on-disk format, then
> recalculate the CRC to make appear valid to the filesystem?
>
>> Test as follows:
>> mount tmp.img tmpdir
>> cp file tmpdir
>> sync  --> stuck
>>
>> ### cause analysis
>> This is because tmp.img (only 1 AG) has some problems. Using xfs_repair detect information as follows:
> Please use at least 2 AGs for your fuzzer images. There's no point
> in testing single AG filesystems because:
> 	a) they are not supported
Maybe we can add a check in mount? If there is only 1 AG, refuse to mount?
> 	b) there is no redundant information in the filesysetm to
> 	   be able to detect a vast range of potential corruptions.
>
>> agf_freeblks 0, counted 3224 in ag 0
>> agf_longest 536874136, counted 3224 in ag 0 
>> sb_fdblocks 613, counted 3228
> So the AGF verifier is missing these checks:
>
> a) agf_longest < agf_freeblks
> b) agf_freeblks < sb_dblocks / sb_agcount
> c) agf_freeblks < sb_fdblocks

b is not ok,

ie: disk is 10G, mkfs.xfs -d agsize=3G, so there will be 4 AG, while the last AG is 1G.

sb_dblocks is 10G, while the first AG's  agf_freeblks is 3G > 10G/4=2.5G

>
> and probably some other things as well. Can you please add these
> checks to xfs_agf_verify() (and any other obvious bounds tests that
> are missing) and submit the patch for inclusion?
I will send a patch
> Cheers,
>
> Dave.

