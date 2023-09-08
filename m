Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789D2EE57EB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Sep 2023 10:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbjIHKb2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Sep 2023 06:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243258AbjIHK1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2023 06:27:49 -0400
Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B984E212B
        for <linux-xfs@vger.kernel.org>; Fri,  8 Sep 2023 03:27:15 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="131309201"
X-IronPort-AV: E=Sophos;i="6.02,236,1688396400"; 
   d="scan'208";a="131309201"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 19:18:57 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
        by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id BFF18DDC61
        for <linux-xfs@vger.kernel.org>; Fri,  8 Sep 2023 19:18:54 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
        by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 00B05E4ACC
        for <linux-xfs@vger.kernel.org>; Fri,  8 Sep 2023 19:18:54 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
        by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 7E8EE20077814
        for <linux-xfs@vger.kernel.org>; Fri,  8 Sep 2023 19:18:53 +0900 (JST)
Received: from [192.168.50.5] (unknown [10.167.234.230])
        by edo.cn.fujitsu.com (Postfix) with ESMTP id 232B51A0090;
        Fri,  8 Sep 2023 18:18:53 +0800 (CST)
Message-ID: <26b057ea-c373-4df5-9d7e-cf56d78844a5@fujitsu.com>
Date:   Fri, 8 Sep 2023 18:18:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: correct calculation for blockcount
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
To:     linux-xfs@vger.kernel.org
References: <20230828072450.1510248-1-ruansy.fnst@fujitsu.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>
In-Reply-To: <20230828072450.1510248-1-ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27862.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27862.006
X-TMASE-Result: 10--2.959200-10.000000
X-TMASE-MatchedRID: AzgLcq71PUyPvrMjLFD6eHchRkqzj/bEC/ExpXrHizyfHrjLA9DhZvM+
        9Fw01I7G8MdX6WBaNTSaernOJKdgiC/7QU2czuUNA9lly13c/gEibYmzSbsTwrc6v3/B0U2Do8W
        MkQWv6iWhMIDkR/KfwLcClLxx8lxlavP8b9lJtWr6C0ePs7A07Rf2ukFm4ENt+iZuJRs5K6w6UX
        M7eVdcpqC6dgWkkORhyMI4lAHl0vU1M+z76c3UmQKXbLvjxK6sUfw9XGG3qZYQq1MEudpEcZFQP
        HTVUuQzcfbnqkGlKiFvaCBS6Jt0bSJI7BEzdHcpWYHCeX3u7h8=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ping~

在 2023/8/28 15:24, Shiyang Ruan 写道:
> The blockcount, which means length, should be "end + 1 - start".  So,
> add the missing "+1" here.
> 
> Fixes: 5cf32f63b0f4 ("xfs: fix the calculation for "end" and "length"")
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>   fs/xfs/xfs_notify_failure.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> index 4a9bbd3fe120..459fc8a39635 100644
> --- a/fs/xfs/xfs_notify_failure.c
> +++ b/fs/xfs/xfs_notify_failure.c
> @@ -151,7 +151,7 @@ xfs_dax_notify_ddev_failure(
>   		agend = min(be32_to_cpu(agf->agf_length),
>   				ri_high.rm_startblock);
>   		notify.startblock = ri_low.rm_startblock;
> -		notify.blockcount = agend - ri_low.rm_startblock;
> +		notify.blockcount = agend + 1 - ri_low.rm_startblock;
>   
>   		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
>   				xfs_dax_failure_fn, &notify);
