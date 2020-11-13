Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 566DAC388F9
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 04:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F20C422243
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 04:00:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q60ylBh6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgKMEAc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 23:00:32 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37166 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgKMEAb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 23:00:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD3xfGk124937;
        Fri, 13 Nov 2020 04:00:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iV+095K32c3Cp1GjXWTmHXZOsCKwdB2Ala4PMIHdU6c=;
 b=q60ylBh6lZy9iQFVQxnchZ2R/DCbpkxpMXsR3/6iiJWCrjCnAliV+USrxBYVB5ho/VXN
 IMPll1rTmozus+SY5dU4JnznEIhWP/pqNTia1gFazAWwkBbzN4RcQBGQgUhu1U44qgAg
 QpbNgnQst/6vTQT5GGm3Y8Kr38DmDuE0Vg1hHvh+zexGeS0XZk8i4w8X1c0PHvYZcBcy
 c+ZW1h3OQyVtmJlPGk6is1xzzIdGrx8SG4bz78sT28TqiBNSibHA/CVaUdv3CX4tclJ7
 wqsaYQzoRJvGSBbkcrSBrEVkJIIIORZp9R9szm81sGjmNmGvH7qcU6+si1v3EtCzlgT3 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34p72exun8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Nov 2020 04:00:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD40IZ2188760;
        Fri, 13 Nov 2020 04:00:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34rtksw96j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 04:00:27 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AD40Q7K017888;
        Fri, 13 Nov 2020 04:00:26 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 20:00:24 -0800
Subject: Re: [PATCH v13 02/10] xfs: Add delay ready attr remove routines
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-3-allison.henderson@oracle.com>
 <20201110234331.GL9695@magnolia> <20201111002818.GJ7391@dread.disaster.area>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e004d3da-60bc-0985-ac42-8490d0317919@oracle.com>
Date:   Thu, 12 Nov 2020 21:00:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201111002818.GJ7391@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130021
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/10/20 5:28 PM, Dave Chinner wrote:
> On Tue, Nov 10, 2020 at 03:43:31PM -0800, Darrick J. Wong wrote:
>> On Thu, Oct 22, 2020 at 11:34:27PM -0700, Allison Henderson wrote:
>>> +/*
>>> + * Remove the attribute specified in @args.
>>> + *
>>> + * This function may return -EAGAIN to signal that the transaction needs to be
>>> + * rolled.  Callers should continue calling this function until they receive a
>>> + * return value other than -EAGAIN.
>>> + */
>>> +int
>>> +xfs_attr_remove_iter(
>>> +	struct xfs_delattr_context	*dac)
>>> +{
>>> +	struct xfs_da_args		*args = dac->da_args;
>>> +	struct xfs_inode		*dp = args->dp;
>>> +
>>> +	if (dac->dela_state == XFS_DAS_RM_SHRINK)
>>> +		goto node;
>>>   
>>
>> Might as well just make this part of the if statement dispatch:
>>
>> 	if (dac->dela_state == XFS_DAS_RM_SHRINK)
>> 		return xfs_attr_node_removename_iter(dac);
>> 	else if (!xfs_inode_hasattr(dp))
>> 		return -ENOATTR;
>>
>>>   	if (!xfs_inode_hasattr(dp)) {
>>> -		error = -ENOATTR;
>>> +		return -ENOATTR;
>>>   	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>>>   		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>>> -		error = xfs_attr_shortform_remove(args);
>>> +		return xfs_attr_shortform_remove(args);
>>>   	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>> -		error = xfs_attr_leaf_removename(args);
>>> -	} else {
>>> -		error = xfs_attr_node_removename(args);
>>> +		return xfs_attr_leaf_removename(args);
>>>   	}
>>> -
>>> -	return error;
>>> +node:
>>> +	return  xfs_attr_node_removename_iter(dac);
> 
> Just a nitpick on this anti-pattern: else is not necessary
> when the branch returns.
> 
> 	if (!xfs_inode_hasattr(dp))
> 		return -ENOATTR;
> 
> 	if (dac->dela_state == XFS_DAS_RM_SHRINK)
> 		return xfs_attr_node_removename_iter(dac);
> 
> 	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
> 		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> 		return xfs_attr_shortform_remove(args);
> 	}
> 
> 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> 		return xfs_attr_leaf_removename(args);
> 
> 	return xfs_attr_node_removename_iter(dac);
> 
> -Dave.
> 
Sure, I think its ok to clean out the elses sense they all return.  Thanks!

Allison

