Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994FAC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 20:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62A2322D5A
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 20:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbhAEUS1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 15:18:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43772 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbhAEUS0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 15:18:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105KEvq0145035
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 20:17:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WVVytGvwcUVT6Z2ZzrJBe3LEupuOeQgxEDIrHsnod1M=;
 b=hezDneJ7yKaUjUqUFBXwbGhDg2NG15SrF2YgEWwLPDJkT0TDCqn4TNFwyhtyNxpiTHJN
 7/7ChBpLy/gX15LhvcItTt4otFUpM1rLUJq6DZUw26/co/X+jPdghIDIlpnnrp4LwETw
 1er9VBiQvlpyUeWuEDFCgu3VEre5mo3zS6RNyLu9WTLpq75NdnYHLOw1yo4QlmXgXibr
 IYZ/ok8G6YFGe8gkxldMvqgNILafdJ+4jb5Z2zSNhBEbBh08QEtfNG6SiqGyK1yNSGF5
 SFRe/Z7nxqmsRRYBf7aEwo88DcHjWqGa2dadl3T9oFhzPX3NLHP/wydQLkLYOqhbabjO 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35tgsktk2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jan 2021 20:17:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105K6PXm063737
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 20:15:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35v4rbtsb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jan 2021 20:15:45 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 105KFiok003807
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 20:15:44 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 12:15:43 -0800
Subject: Re: [PATCH v14 08/15] xfs: Handle krealloc errors in
 xlog_recover_add_to_cont_trans
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-9-allison.henderson@oracle.com>
 <20210105053807.GU6918@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <edad6d0c-b57a-9bb3-6694-c9272909192f@oracle.com>
Date:   Tue, 5 Jan 2021 13:15:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210105053807.GU6918@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050117
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/4/21 10:38 PM, Darrick J. Wong wrote:
> On Fri, Dec 18, 2020 at 12:29:10AM -0700, Allison Henderson wrote:
>> Because xattrs can be over a page in size, we need to handle possible
>> krealloc errors to avoid warnings
> 
> Which warnings?

Sorry, I should have included it here.  The warning is:
[  +0.000016] WARNING: CPU: 1 PID: 20255 at mm/page_alloc.c:3446 
get_page_from_freelist+0x100b/0x1690

and if we look at that line number we have this snippet:
         /*
          * We most definitely don't want callers attempting to
          * allocate greater than order-1 page units with __GFP_NOFAIL.
          */
         WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/xfs_log_recover.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index 97f3130..295a5c6 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -2061,7 +2061,10 @@ xlog_recover_add_to_cont_trans(
>>   	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
>>   	old_len = item->ri_buf[item->ri_cnt-1].i_len;
>>   
>> -	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
>> +	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL);
> 
> Does the removal of NOFAIL increase the likelihood that log recovery
> will fail instead of looping around looking for more memory?

I suppose it would?  But better to return the error code than proceed 
with a NULL pointer.  I would think it would be quickly proceeded with 
questions of what else is causing memory pressure to build though.

> 
> Hm, what /are/ we doing here, anyway?  I guess someone logged a gigantic
> xattri item, which gets split across multiple log records, and now we're
> trying to staple all that back together?  And perhaps the xattri item is
> larger than a ... page(?) which causes dmesg warnings when combined with
> NOFAIL?

Effectively yes, this is coming from one of the new test cases I came up 
with to test the replay.  It progressively sets larger and larger attrs 
and pulls the error tag to see that it replays correctly.  Up to 64k 
which I think is where ATTR_MAX_VALUELEN is.  I figured since we are 
opening up a means of logging as much, its something that we should be 
testing. :-)

Allison
> 
> --D
> 
>> +	if (ptr == NULL)
>> +		return -ENOMEM;
>> +
>>   	memcpy(&ptr[old_len], dp, len);
>>   	item->ri_buf[item->ri_cnt-1].i_len += len;
>>   	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
>> -- 
>> 2.7.4
>>
