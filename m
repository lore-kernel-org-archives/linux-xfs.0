Return-Path: <SRS0=GEJR=V5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F457C433FF
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Aug 2019 01:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBCD5206A2
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Aug 2019 01:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbfHABhN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Jul 2019 21:37:13 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:43990 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728014AbfHABhN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 21:37:13 -0400
X-IronPort-AV: E=Sophos;i="5.64,332,1559491200"; 
   d="scan'208";a="72632467"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 01 Aug 2019 09:37:11 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 330514CDD99E;
        Thu,  1 Aug 2019 09:37:07 +0800 (CST)
Received: from [10.167.225.140] (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Thu, 1 Aug 2019 09:37:15 +0800
Subject: Re: [RFC PATCH 0/7] xfs: add reflink & dedupe support for fsdax.
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
CC:     <linux-xfs@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
        <darrick.wong@oracle.com>, <linux-kernel@vger.kernel.org>,
        <gujx@cn.fujitsu.com>, <david@fromorbit.com>,
        <qi.fuli@fujitsu.com>, <caoj.fnst@cn.fujitsu.com>
References: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
 <20190731203324.7vjwlejmwpghpvqi@fiona>
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <800ff77a-7cd1-5fa1-fcf7-e41264a3f189@cn.fujitsu.com>
Date:   Thu, 1 Aug 2019 09:37:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190731203324.7vjwlejmwpghpvqi@fiona>
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: 330514CDD99E.AAB55
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
Message-ID: <20190801013704.CiAb-8Vbc_UHo6TcwdPGuKoPIr3IqD9VnSvCRboJe8o@z>



On 8/1/19 4:33 AM, Goldwyn Rodrigues wrote:
> On 19:49 31/07, Shiyang Ruan wrote:
>> This patchset aims to take care of this issue to make reflink and dedupe
>> work correctly in XFS.
>>
>> It is based on Goldwyn's patchsets: "v4 Btrfs dax support" and "Btrfs
>> iomap".  I picked up some patches related and made a few fix to make it
>> basically works fine.
>>
>> For dax framework:
>>    1. adapt to the latest change in iomap.
>>
>> For XFS:
>>    1. report the source address and set IOMAP_COW type for those write
>>       operations that need COW.
>>    2. update extent list at the end.
>>    3. add file contents comparison function based on dax framework.
>>    4. use xfs_break_layouts() to support dax.
> 
> Shiyang,
> 
> I think you used the older patches which does not contain the iomap changes
> which would call iomap_begin() with two iomaps. I have it in the btrfs-iomap

Oh, Sorry for my carelessness.  This patchset is built on your "Btrfs 
iomap".  I didn't point it out in cover letter.

> branch and plan to update it today. It is built on v5.3-rcX, so it should
> contain the changes which moves the iomap code to the different directory.
> I will build the dax patches on top of that.
> However, we are making a big dependency chain here 
Don't worry.  It's fine for me.  I'll follow your updates.

> 

-- 
Thanks,
Shiyang Ruan.


