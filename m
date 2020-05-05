Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66A3C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 00:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FD3D206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 00:27:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B8Ywukrx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgEEA1Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 20:27:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48156 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgEEA1Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 20:27:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0450IIQ4186433
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 00:27:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nPrEov4OSKa3j6VRdEP/V3GucwaPnk41FpX6QZCFunk=;
 b=B8YwukrxHcWPSU5jZZxO6W+9bB2ojr/aqMj6dnzrUk1mAx3QWwCbweQEuo734x2SnfyH
 xNJ4/qGlvXQE1+SXJRNj8c+xyVeo23eWsCdMZAlvkGVcjsypG28WxmukWeXatqYju3Bx
 gzaTUb1QTToNi25Xk66oL2xWjiidU8olJvJ/zqP2VKB+TatBT5mpR7zUjbG2a+f9vHlH
 TFwwi8jVcaipX0bgF4UClnSxRvna+DlPcWwKR/UftuCJ/qJtB53K2jivFgOblKdSvXSF
 vQibkJwhjJ9iSWrM8hYWyafworoJPbdx3R9vzjzTznc9dJ5/lwxmdHRPFPoWkdAFMBch Jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30s1gn1t0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 00:27:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0450Ghbf064823
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 00:27:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30sjdrs670-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 00:27:22 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0450RL3i030971
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 00:27:21 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 17:27:20 -0700
Subject: Re: [PATCH v9 24/24] xfs: Rename __xfs_attr_rmtval_remove
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-25-allison.henderson@oracle.com>
 <20200504193410.GJ5703@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <c9d4f37f-cb30-8b9b-021a-6a6f62713861@oracle.com>
Date:   Mon, 4 May 2020 17:27:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504193410.GJ5703@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 12:34 PM, Darrick J. Wong wrote:
> On Thu, Apr 30, 2020 at 03:50:16PM -0700, Allison Collins wrote:
>> Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
>> to xfs_attr_rmtval_remove
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
Thanks!
Allison

> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 7 +++----
>>   fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
>>   fs/xfs/libxfs/xfs_attr_remote.h | 3 +--
>>   3 files changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 0751231..d76a970 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -874,7 +874,7 @@ xfs_attr_leaf_addname(
>>   		return error;
>>   das_rm_lblk:
>>   	if (args->rmtblkno) {
>> -		error = __xfs_attr_rmtval_remove(dac);
>> +		error = xfs_attr_rmtval_remove(dac);
>>   
>>   		if (error == -EAGAIN) {
>>   			dac->dela_state = XFS_DAS_RM_LBLK;
>> @@ -1244,8 +1244,7 @@ xfs_attr_node_addname(
>>   
>>   das_rm_nblk:
>>   	if (args->rmtblkno) {
>> -		error = __xfs_attr_rmtval_remove(dac);
>> -
>> +		error = xfs_attr_rmtval_remove(dac);
>>   		if (error == -EAGAIN) {
>>   			dac->dela_state = XFS_DAS_RM_NBLK;
>>   			return -EAGAIN;
>> @@ -1409,7 +1408,7 @@ xfs_attr_node_removename_rmt (
>>   	/*
>>   	 * May return -EAGAIN to request that the caller recall this function
>>   	 */
>> -	error = __xfs_attr_rmtval_remove(dac);
>> +	error = xfs_attr_rmtval_remove(dac);
>>   	if (error)
>>   		return error;
>>   
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 7a342f1..21c7aa9 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -740,7 +740,7 @@ xfs_attr_rmtval_invalidate(
>>    * transaction and recall the function
>>    */
>>   int
>> -__xfs_attr_rmtval_remove(
>> +xfs_attr_rmtval_remove(
>>   	struct xfs_delattr_context	*dac)
>>   {
>>   	struct xfs_da_args		*args = dac->da_args;
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 51a1c91..09fda56 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -10,11 +10,10 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>>   
>>   int xfs_attr_rmtval_get(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set(struct xfs_da_args *args);
>> -int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>   		xfs_buf_flags_t incore_flags);
>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>> -int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>> +int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>>   int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
>> -- 
>> 2.7.4
>>
