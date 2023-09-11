Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10645CA0EC7
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Sep 2023 21:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345540AbjIKVVM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbjIKKrU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2023 06:47:20 -0400
Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E43DE9
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 03:47:15 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="132995944"
X-IronPort-AV: E=Sophos;i="6.02,243,1688396400"; 
   d="scan'208";a="132995944"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 19:47:13 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
        by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id C2C35D3EAC
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 19:47:10 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
        by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 085E2D5E8E
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 19:47:10 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
        by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 8DE776C9DA
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 19:47:09 +0900 (JST)
Received: from [192.168.50.5] (unknown [10.167.234.230])
        by edo.cn.fujitsu.com (Postfix) with ESMTP id 3763C1A0085;
        Mon, 11 Sep 2023 18:47:09 +0800 (CST)
Message-ID: <d6ea0b52-2e1b-4e83-9e0a-126f9d266008@fujitsu.com>
Date:   Mon, 11 Sep 2023 18:47:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: correct calculation for blockcount
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20230828072450.1510248-1-ruansy.fnst@fujitsu.com>
 <26b057ea-c373-4df5-9d7e-cf56d78844a5@fujitsu.com>
 <20230908235521.GO28202@frogsfrogsfrogs>
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <20230908235521.GO28202@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27868.007
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27868.007
X-TMASE-Result: 10--10.050200-10.000000
X-TMASE-MatchedRID: AvuQOGDihJqPvrMjLFD6eHchRkqzj/bEC/ExpXrHizw0tugJQ9Wdw2nX
        UUBQ4UsQykxJ5WoyZKukulA7P59GuuBRuAss+FbmEXjPIvKd74BMkOX0UoduuR+hI5qKPMbWdcs
        jo3n3EUUhjxbeo5NwNPaR8eF8Hn3mMDQQSfAWi0Wz8d6zvo5NkDWRH7TlULWGZopoopCRD0SjxY
        yRBa/qJaEwgORH8p/AtwKUvHHyXGXdB/CxWTRRu25FeHtsUoHuYZJ6VZDFISCCEzRwY+5XY8lDL
        oHgP+xX5EANA1Y/Pc02RRIMOrvjaQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2023/9/9 7:55, Darrick J. Wong 写道:
> On Fri, Sep 08, 2023 at 06:18:52PM +0800, Shiyang Ruan wrote:
>> Ping~
>>
>> 在 2023/8/28 15:24, Shiyang Ruan 写道:
>>> The blockcount, which means length, should be "end + 1 - start".  So,
>>> add the missing "+1" here.
>>>
>>> Fixes: 5cf32f63b0f4 ("xfs: fix the calculation for "end" and "length"")
>>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>>> ---
>>>    fs/xfs/xfs_notify_failure.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
>>> index 4a9bbd3fe120..459fc8a39635 100644
>>> --- a/fs/xfs/xfs_notify_failure.c
>>> +++ b/fs/xfs/xfs_notify_failure.c
>>> @@ -151,7 +151,7 @@ xfs_dax_notify_ddev_failure(
>>>    		agend = min(be32_to_cpu(agf->agf_length),
>>>    				ri_high.rm_startblock);
> 
> I don't understand this.  ri_high.rm_startblock should be the last agbno
> for which we want rmapbt mappings.  If agf_length is 100, then don't we
> want to be clamping agend to 99, not 100?  Block 99 is the last block in
> an AG.
> 
> 	agend = min(be32_to_cpu(agf->agf_length) - 1,
> 		    ri_high.rm_startblock);

This is right.  Will fix this too.

> 
> If we do the above...
> 
>>>    		notify.startblock = ri_low.rm_startblock;
>>> -		notify.blockcount = agend - ri_low.rm_startblock;
>>> +		notify.blockcount = agend + 1 - ri_low.rm_startblock;
> 
> ...then this actually makes sense.
> 
>>>    		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
>>>    				xfs_dax_failure_fn, &notify);
> 
> Sorry I've been kinda slow to respond.

No problem :)


--
Thanks,
Ruan.

> 
> --D
