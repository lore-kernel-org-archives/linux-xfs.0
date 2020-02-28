Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C00E4C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 18:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 992C1246AE
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 18:16:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X+7Uckoh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgB1SQG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 13:16:06 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34462 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgB1SQG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 13:16:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SHtRnJ105738;
        Fri, 28 Feb 2020 18:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=p+cWPpL6RheBOjI3yJNt7PGgTfKkSm8Y1yzrsAnmkIs=;
 b=X+7UckohsV1+cFnfLvZ2L7Pcz11JpzFR7dE5sUYIpcn0h/ypBnfOVH+2QRqCNWqCdJUJ
 gqjnaNSrs2/ttFX0PhELLxyPkYnXKericPzKIGUUWsr/boZh5XhFZEZqGVJ1Be3cRYcm
 KfJNGs3AV16rEAcwOoois2KU2lWVdhyFhAG/EOY6KyVfiIkrTnvYHSq07IqDNx5flTPR
 1S42vjgDT860YYl/HY3JkFpgHts8lk46yovy6QASxMar8d4eMsnuVHza7+E5Q42j9UPn
 ubKdjh0BRW3pVzmyFGoJpypOY+SB4dXDsrPP1cTLP3Gd8WWnZO9yQt93yMMDKwueBFuR 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ydcsnvmjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 18:16:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SHqEgi195316;
        Fri, 28 Feb 2020 18:14:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ydj4rdckq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 18:14:03 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SIE2Ma016299;
        Fri, 28 Feb 2020 18:14:03 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 10:14:02 -0800
Subject: Re: [PATCH v7 08/19] xfs: Refactor xfs_attr_try_sf_addname
To:     Chandan Rajendra <chandan@linux.ibm.com>, linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-9-allison.henderson@oracle.com>
 <1889824.mfX55q8Ynv@localhost.localdomain>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <7ed6e2fc-7593-468b-03a8-30944eb31949@oracle.com>
Date:   Fri, 28 Feb 2020 11:14:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1889824.mfX55q8Ynv@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/28/20 12:42 AM, Chandan Rajendra wrote:
> On Sunday, February 23, 2020 7:36 AM Allison Collins wrote:
>> To help pre-simplify xfs_attr_set_args, we need to hoist transacation handling up,
>> while modularizing the adjacent code down into helpers. In this patch, hoist the
>> commit in xfs_attr_try_sf_addname up into the calling function, and also pull the
>> attr list creation down.
>>
> 
> I don't see any logical errors.
> 
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Alrighty, thank you!

Allison

> 
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 30 +++++++++++++++---------------
>>   1 file changed, 15 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index b2f0780..71298b9 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -227,8 +227,13 @@ xfs_attr_try_sf_addname(
>>   	struct xfs_da_args	*args)
>>   {
>>   
>> -	struct xfs_mount	*mp = dp->i_mount;
>> -	int			error, error2;
>> +	int			error;
>> +
>> +	/*
>> +	 * Build initial attribute list (if required).
>> +	 */
>> +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
>> +		xfs_attr_shortform_create(args);
>>   
>>   	error = xfs_attr_shortform_addname(args);
>>   	if (error == -ENOSPC)
>> @@ -241,12 +246,10 @@ xfs_attr_try_sf_addname(
>>   	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
>>   		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
>>   
>> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
>> +	if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
>>   		xfs_trans_set_sync(args->trans);
>>   
>> -	error2 = xfs_trans_commit(args->trans);
>> -	args->trans = NULL;
>> -	return error ? error : error2;
>> +	return error;
>>   }
>>   
>>   /*
>> @@ -258,7 +261,7 @@ xfs_attr_set_args(
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error;
>> +	int			error, error2 = 0;
>>   
>>   	/*
>>   	 * If the attribute list is non-existent or a shortform list,
>> @@ -269,17 +272,14 @@ xfs_attr_set_args(
>>   	     dp->i_d.di_anextents == 0)) {
>>   
>>   		/*
>> -		 * Build initial attribute list (if required).
>> -		 */
>> -		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
>> -			xfs_attr_shortform_create(args);
>> -
>> -		/*
>>   		 * Try to add the attr to the attribute list in the inode.
>>   		 */
>>   		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC)
>> -			return error;
>> +		if (error != -ENOSPC) {
>> +			error2 = xfs_trans_commit(args->trans);
>> +			args->trans = NULL;
>> +			return error ? error : error2;
>> +		}
>>   
>>   		/*
>>   		 * It won't fit in the shortform, transform to a leaf block.
>>
> 
> 
