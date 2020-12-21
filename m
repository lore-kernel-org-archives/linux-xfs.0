Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65818C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 23:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24F0D230FC
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 23:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgLUXs2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 18:48:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40286 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgLUXs1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Dec 2020 18:48:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BLNevdn017125;
        Mon, 21 Dec 2020 23:47:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KxERdEzLQuDjkzAJCuY6UXIh7RWT5ta66iJ3gd4aloo=;
 b=Xnsr6DAIopOrbxiSr8qgnTqseIpBXkUbybadBB8VU2xmotzqByujb5ooeRDZq6Vp9Z7O
 ChvbPMUNrDggefwvsRXEkyN3+gw2b2x0ZktH2y+x53WEN/IycywY29q+SGKl1ATaZq6M
 ro8sr4lGRD16lYMZlJnh7me2AYTBgjYotI8M949+CpCoO+3DZNw7RmffNyrJoYKKUnXe
 Ns+NbNvvOm3DlZoiamv/QoxjQ9FVFY2m0uqCdcWfRRZLeyoHxZmctYpz+jkAH1DVjvbs
 R0NdaHTUJclLRchqjga62f3CJJu5Ai308515P4wlYFETODucDuFgTmKJsWyxJuLUpteF jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35k0d895rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Dec 2020 23:47:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BLNfVEt172534;
        Mon, 21 Dec 2020 23:47:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35k0e7s4wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Dec 2020 23:47:44 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BLNlh1s019531;
        Mon, 21 Dec 2020 23:47:43 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Dec 2020 15:47:43 -0800
Subject: Re: [PATCH v14 02/15] xfs: Add xfs_attr_node_remove_cleanup
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-3-allison.henderson@oracle.com>
 <4861977.KByABTbv6y@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <bb09069c-d0a2-a768-5f07-239e2cbf9353@oracle.com>
Date:   Mon, 21 Dec 2020 16:47:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4861977.KByABTbv6y@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9842 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012210160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9842 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012210160
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/20/20 11:45 PM, Chandan Babu R wrote:
> On Fri, 18 Dec 2020 00:29:04 -0700, Allison Henderson wrote:
>> This patch pulls a new helper function xfs_attr_node_remove_cleanup out
>> of xfs_attr_node_remove_step.  This helps to modularize
>> xfs_attr_node_remove_step which will help make the delayed attribute
>> code easier to follow
> 
> The changes look good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, thank you!
Allison

> 
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
>>   1 file changed, 20 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 8b55a8d..e93d76a 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1220,6 +1220,25 @@ xfs_attr_node_remove_rmt(
>>   	return xfs_attr_refillstate(state);
>>   }
>>   
>> +STATIC int
>> +xfs_attr_node_remove_cleanup(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	*state)
>> +{
>> +	struct xfs_da_state_blk	*blk;
>> +	int			retval;
>> +
>> +	/*
>> +	 * Remove the name and update the hashvals in the tree.
>> +	 */
>> +	blk = &state->path.blk[state->path.active-1];
>> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> +	retval = xfs_attr3_leaf_remove(blk->bp, args);
>> +	xfs_da3_fixhashpath(state, &state->path);
>> +
>> +	return retval;
>> +}
>> +
>>   /*
>>    * Remove a name from a B-tree attribute list.
>>    *
>> @@ -1232,7 +1251,6 @@ xfs_attr_node_remove_step(
>>   	struct xfs_da_args	*args,
>>   	struct xfs_da_state	*state)
>>   {
>> -	struct xfs_da_state_blk	*blk;
>>   	int			retval, error;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>> @@ -1247,14 +1265,7 @@ xfs_attr_node_remove_step(
>>   		if (error)
>>   			return error;
>>   	}
>> -
>> -	/*
>> -	 * Remove the name and update the hashvals in the tree.
>> -	 */
>> -	blk = &state->path.blk[ state->path.active-1 ];
>> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> -	retval = xfs_attr3_leaf_remove(blk->bp, args);
>> -	xfs_da3_fixhashpath(state, &state->path);
>> +	retval = xfs_attr_node_remove_cleanup(args, state);
>>   
>>   	/*
>>   	 * Check to see if the tree needs to be collapsed.
>>
> 
> 
