Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1942C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46936224F9
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgLDBqm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 20:46:42 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:46043 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLDBql (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 20:46:41 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0UHSKhDt_1607046358;
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UHSKhDt_1607046358)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Dec 2020 09:45:58 +0800
Subject: Re: [PATCH] xfs: remove unneeded return value check for
 xfs_rmapbt_init_cursor()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <1606984438-13997-1-git-send-email-joseph.qi@linux.alibaba.com>
 <20201203182544.GB106272@magnolia>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <372d35a8-254e-a770-7a88-279944e09365@linux.alibaba.com>
Date:   Fri, 4 Dec 2020 09:45:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201203182544.GB106272@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/4/20 2:25 AM, Darrick J. Wong wrote:
> On Thu, Dec 03, 2020 at 04:33:58PM +0800, Joseph Qi wrote:
>> Since xfs_rmapbt_init_cursor() can always return a valid cursor, the
>> NULL check in caller is unneeded.
>> This also keeps the behavior consistent with other callers.
>>
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>>  fs/xfs/libxfs/xfs_rmap.c | 9 ---------
>>  fs/xfs/scrub/bmap.c      | 5 -----
>>  fs/xfs/scrub/common.c    | 2 --
>>  3 files changed, 16 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
>> index 2668ebe..10e0cf99 100644
>> --- a/fs/xfs/libxfs/xfs_rmap.c
>> +++ b/fs/xfs/libxfs/xfs_rmap.c
>> @@ -2404,10 +2404,6 @@ struct xfs_rmap_query_range_info {
>>  			return -EFSCORRUPTED;
>>  
>>  		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
>> -		if (!rcur) {
>> -			error = -ENOMEM;
>> -			goto out_cur;
>> -		}
>>  	}
>>  	*pcur = rcur;
>>  
>> @@ -2446,11 +2442,6 @@ struct xfs_rmap_query_range_info {
>>  		error = -EFSCORRUPTED;
>>  	}
>>  	return error;
>> -
>> -out_cur:
>> -	xfs_trans_brelse(tp, agbp);
>> -
>> -	return error;
>>  }
>>  
>>  /*
>> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
>> index fed56d2..dd165c0 100644
>> --- a/fs/xfs/scrub/bmap.c
>> +++ b/fs/xfs/scrub/bmap.c
>> @@ -563,10 +563,6 @@ struct xchk_bmap_check_rmap_info {
>>  		return error;
>>  
>>  	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, agno);
>> -	if (!cur) {
>> -		error = -ENOMEM;
>> -		goto out_agf;
>> -	}
>>  
>>  	sbcri.sc = sc;
>>  	sbcri.whichfork = whichfork;
>> @@ -575,7 +571,6 @@ struct xchk_bmap_check_rmap_info {
>>  		error = 0;
>>  
>>  	xfs_btree_del_cursor(cur, error);
>> -out_agf:
>>  	xfs_trans_brelse(sc->tp, agf);
>>  	return error;
>>  }
>> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
>> index 1887605..6757dc7 100644
>> --- a/fs/xfs/scrub/common.c
>> +++ b/fs/xfs/scrub/common.c
>> @@ -502,8 +502,6 @@ struct xchk_rmap_ownedby_info {
>>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_RMAP)) {
>>  		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
>>  				agno);
>> -		if (!sa->rmap_cur)
>> -			goto err;
> 
> Would you mind cleaning out the other btree cursor allocation
> warts under fs/xfs/scrub/ ?
> 

Sure, I'll do this and send v2.

Thanks,
Joseph
