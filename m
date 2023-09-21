Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1153EE7D0A8
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 20:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjIUU1b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbjIUU1M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 16:27:12 -0400
Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE17186
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 10:48:52 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="112433584"
X-IronPort-AV: E=Sophos;i="6.03,164,1694703600"; 
   d="scan'208";a="112433584"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 17:33:08 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
        by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 0DCC9CA1E6
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 17:33:07 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
        by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 42BA3D88B5
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 17:33:06 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
        by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id D11DA20076851
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 17:33:05 +0900 (JST)
Received: from [192.168.50.5] (unknown [10.167.234.230])
        by edo.cn.fujitsu.com (Postfix) with ESMTP id 32D3F1A0085;
        Thu, 21 Sep 2023 16:33:05 +0800 (CST)
Message-ID: <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
Date:   Thu, 21 Sep 2023 16:33:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
To:     linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev
Cc:     djwong@kernel.org, chandan.babu@oracle.com,
        dan.j.williams@intel.com
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
In-Reply-To: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27888.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27888.006
X-TMASE-Result: 10-0.031700-10.000000
X-TMASE-MatchedRID: hwtUKlde9zGPvrMjLFD6eDjNGpWCIvfT1KDIlODIu+X6t7zbE1rC9wYE
        LASKZobWBNyCmIook0cJKoJfwgWhzbVQ6XPWwtdyEXjPIvKd74BMkOX0UoduuRz8TwDJiHPoNiL
        P5F13qP7nzlXMYw4XMCAtDqHg/4Qmv79FIUygvZzZs3HUcS/scCq2rl3dzGQ1kFmoecv+RE241u
        Vp06SlZKbkJdESNECViXnp3Tl79ABmzTBoPxkj6zqLTpHlB2+SPoq0wVsiK7kDcHQCp5ROP+AlX
        X4WyiQqZr2cb5iz368JCuHHcDs8RyWtwY45TPtNPQO/EEw5sBQadJO6FnuPXQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Any comments?


--
Thanks,
Ruan.


在 2023/9/15 14:38, Shiyang Ruan 写道:
> FSDAX and reflink can work together now, let's drop this warning.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>   fs/xfs/xfs_super.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 1f77014c6e1a..faee773fa026 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -371,7 +371,6 @@ xfs_setup_dax_always(
>   		return -EINVAL;
>   	}
>   
> -	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>   	return 0;
>   
>   disable_dax:
