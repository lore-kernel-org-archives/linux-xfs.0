Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB5BC3F2D1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 17:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E803222B48
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 17:04:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="y3yzHckh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgCDREq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 12:04:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53742 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbgCDREq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 12:04:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 024GwIlC111226;
        Wed, 4 Mar 2020 17:04:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=K6Rny7oqdP8iisSJWk7CNPNrEQWVUQxu8fgX6oMg9j4=;
 b=y3yzHckhdqWZL8/AjCZ6HcfklYSU05YgSmeIBQRED8QtnzIsuo9vPXH0SMOZmFQd/V7e
 F9pl2MXGoXWO7+4v+RqfZML+zhm0wSwjwfK80gkmuKq+S9bD2fCIDCFk+yZtbEkhT5K4
 PUgWY8CpuH719h5whb2fjBEc6VvJy3RZULD05djg8SyhNjRPQRArHFt+mS+h2/91anFs
 YHqNKak/il5VyIA52Ob/ciN6A/Uic2/ARhw7dVbtxwuALh1/Gxe8/qWrgE0oS8GbgZ4N
 uTEMDLtcH42GCOIaVPCTpMzwZl6sFM6KDogyr+2/mLZAK36zJVaCzmUh0yUwVCzcI5Hx 2Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2yffcuqrh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 17:04:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 024GvAWs091179;
        Wed, 4 Mar 2020 17:04:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2yg1rrjgcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 17:04:42 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 024H4fF1015751;
        Wed, 4 Mar 2020 17:04:41 GMT
Received: from [192.168.1.223] (/67.1.126.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Mar 2020 09:04:40 -0800
Subject: Re: [PATCH v7 16/19] xfs: Simplify xfs_attr_set_iter
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-17-allison.henderson@oracle.com>
 <11418238.YRoMbP1DLo@localhost.localdomain>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <0faf1c56-87c4-8e0f-38fd-4dadec2de117@oracle.com>
Date:   Wed, 4 Mar 2020 10:04:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <11418238.YRoMbP1DLo@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/3/20 9:30 PM, Chandan Rajendra wrote:
> On Sunday, February 23, 2020 7:36 AM Allison Collins wrote:
>> Delayed attribute mechanics make frequent use of goto statements.  We can use this
>> to further simplify xfs_attr_set_iter.  Because states tend to fall between if
>> conditions, we can invert the if logic and jump to the goto. This helps to reduce
>> indentation and simplify things.
>>
> 
> I don't see any logical errors.
> 
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Alrighty, thanks for the reviews!  I got some feed back in other reviews 
to move the patches 13 and 14 to the end of the set.  Which means the 
patches ahead of them may change a bit in order to seat correctly.  For 
example, this patch will likely go back to being more like it's v6 version:

https://www.spinics.net/lists/linux-xfs/msg36072.html

Would you prefer I keep or drop your RVB's in this case?  Functionally 
they wont change much, but I understand that function is a lot of what 
your are analyzing too.  Let me know what you are comfortable with.  Thanks!

Allison

> 
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 71 ++++++++++++++++++++++++++++--------------------
>>   1 file changed, 42 insertions(+), 29 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 30a16fe..dd935ff 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -254,6 +254,19 @@ xfs_attr_try_sf_addname(
>>   }
>>   
>>   /*
>> + * Check to see if the attr should be upgraded from non-existent or shortform to
>> + * single-leaf-block attribute list.
>> + */
>> +static inline bool
>> +xfs_attr_fmt_needs_update(
>> +	struct xfs_inode    *dp)
>> +{
>> +	return dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> +	      (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> +	      dp->i_d.di_anextents == 0);
>> +}
>> +
>> +/*
>>    * Set the attribute specified in @args.
>>    */
>>   int
>> @@ -342,40 +355,40 @@ xfs_attr_set_iter(
>>   	}
>>   
>>   	/*
>> -	 * If the attribute list is non-existent or a shortform list,
>> -	 * upgrade it to a single-leaf-block attribute list.
>> +	 * If the attribute list is already in leaf format, jump straight to
>> +	 * leaf handling.  Otherwise, try to add the attribute to the shortform
>> +	 * list; if there's no room then convert the list to leaf format and try
>> +	 * again.
>>   	 */
>> -	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> -	     dp->i_d.di_anextents == 0)) {
>> +	if (!xfs_attr_fmt_needs_update(dp))
>> +		goto add_leaf;
>>   
>> -		/*
>> -		 * Try to add the attr to the attribute list in the inode.
>> -		 */
>> -		error = xfs_attr_try_sf_addname(dp, args);
>> +	/*
>> +	 * Try to add the attr to the attribute list in the inode.
>> +	 */
>> +	error = xfs_attr_try_sf_addname(dp, args);
>>   
>> -		/* Should only be 0, -EEXIST or ENOSPC */
>> -		if (error != -ENOSPC)
>> -			return error;
>> +	/* Should only be 0, -EEXIST or ENOSPC */
>> +	if (error != -ENOSPC)
>> +		return error;
>>   
>> -		/*
>> -		 * It won't fit in the shortform, transform to a leaf block.
>> -		 * GROT: another possible req'mt for a double-split btree op.
>> -		 */
>> -		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>> -		if (error)
>> -			return error;
>> +	/*
>> +	 * It won't fit in the shortform, transform to a leaf block.
>> +	 * GROT: another possible req'mt for a double-split btree op.
>> +	 */
>> +	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>> +	if (error)
>> +		return error;
>>   
>> -		/*
>> -		 * Prevent the leaf buffer from being unlocked so that a
>> -		 * concurrent AIL push cannot grab the half-baked leaf
>> -		 * buffer and run into problems with the write verifier.
>> -		 */
>> -		xfs_trans_bhold(args->trans, *leaf_bp);
>> -		args->dac.flags |= XFS_DAC_FINISH_TRANS;
>> -		args->dac.dela_state = XFS_DAS_ADD_LEAF;
>> -		return -EAGAIN;
>> -	}
>> +	/*
>> +	 * Prevent the leaf buffer from being unlocked so that a
>> +	 * concurrent AIL push cannot grab the half-baked leaf
>> +	 * buffer and run into problems with the write verifier.
>> +	 */
>> +	xfs_trans_bhold(args->trans, *leaf_bp);
>> +	args->dac.flags |= XFS_DAC_FINISH_TRANS;
>> +	args->dac.dela_state = XFS_DAS_ADD_LEAF;
>> +	return -EAGAIN;
>>   
>>   add_leaf:
>>   
>>
> 
> 
