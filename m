Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF8FC3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 10:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BAEC21929
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 10:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388342AbfISKtJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 06:49:09 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13565 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387987AbfISKtI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 06:49:08 -0400
X-IronPort-AV: E=Sophos;i="5.64,523,1559491200"; 
   d="scan'208";a="75706467"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 19 Sep 2019 18:49:06 +0800
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id CAC394CE14E7;
        Thu, 19 Sep 2019 18:49:03 +0800 (CST)
Received: from [10.167.220.84] (10.167.220.84) by
 G08CNEXCHPEKD02.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 id 14.3.439.0; Thu, 19 Sep 2019 18:49:03 +0800
Subject: Re: question of xfs/148 and xfs/149
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     Zorro Lang <zlang@redhat.com>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
References: <4BF2FD5A942B1C4B828DDAF5635768C1041AB0E2@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20190917163933.GC736475@magnolia>
 <20190918025915.GK7239@dhcp-12-102.nay.redhat.com>
 <7b5d5797-afff-90bc-0131-38fd13eced34@cn.fujitsu.com>
 <20190918163711.GX2229799@magnolia>
From:   Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Message-ID: <638537d9-ce38-7285-c598-8637adbebd8f@cn.fujitsu.com>
Date:   Thu, 19 Sep 2019 18:49:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <20190918163711.GX2229799@magnolia>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.84]
X-yoursite-MailScanner-ID: CAC394CE14E7.AFE9C
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: xuyang2018.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



on 2019/09/19 0:37, Darrick J. Wong wrote:
>>   I am finding the reasion. It seems wipefs wipes important information and
>> $DSIZE option(using single agcount or dsize, it also fails ) can not format
>> disk completely. If we use other options, it can pass.
> How does mkfs fail, specifically?
> 
> Also, what's your storage configuration?  And lsblk -D output?

I only guess it from result. Even though, mkfs.xfs $DSIZE 
successfully($? is 0), but UUID mismatch in 030.full, so it may
format the first superblock failed.  This is just my guess.

 From your detailed explanation, I understand why it fails.

Thanks
Yang Xu


