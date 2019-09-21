Return-Path: <SRS0=b7mv=XQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2558C3A5A2
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 01:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67CEE20640
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 01:26:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CCvJOnO3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbfIUB0W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 21:26:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48328 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730608AbfIUB0W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 21:26:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L1Pq7n163901;
        Sat, 21 Sep 2019 01:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QnmbdVojwGrDpDUG6yIJxhnSzDRYbP4ppC/7DlILv9A=;
 b=CCvJOnO3RSklu1Dwjo3Z3YsAZDWlidolt7HLkTTlBokYszcTNPXgg5gcjxs3zTh9QRF5
 tFANOaQa7TSdqllMzafn+lTzf0lUquFG7EgK2/UA7jDvFcOX7mCt79Co49XtSyBPmcXC
 BlVmpLOQBiYx4Ml2diPhoPaK+6+kEaQThgtcb1LXBMJohN1+df5DHJLky1x0yxLtgi29
 hfR+0WB+6GFZwX/lrp7+z9JL8R2RnL/2CcAActH+vToWFdZOPo9QqMtzqJFhJaQyoA+d
 xM+m3ufPQ4sbt69318GgjZKPmio9r1pIwnhcXLLTPc+5nfkRUmzCpF9PAs3cf1+v505E Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v3vb5d6mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 01:26:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L1Od05157485;
        Sat, 21 Sep 2019 01:26:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v4xea7b7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 01:26:10 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8L1Q9O7026186;
        Sat, 21 Sep 2019 01:26:09 GMT
Received: from [192.168.1.9] (/67.1.21.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Sep 2019 18:25:04 -0700
Subject: Re: [PATCH v3 08/19] xfs: Factor up commit from
 xfs_attr_try_sf_addname
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-9-allison.henderson@oracle.com>
 <20190920135037.GF40150@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <1336049c-33fb-ee2d-53e6-28f27a576e82@oracle.com>
Date:   Fri, 20 Sep 2019 18:25:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920135037.GF40150@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909210014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909210014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/20/19 6:50 AM, Brian Foster wrote:
> On Thu, Sep 05, 2019 at 03:18:26PM -0700, Allison Collins wrote:
>> New delayed attribute routines cannot handle transactions,
>> so factor this up to the calling function.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 15 ++++++++-------
>>   1 file changed, 8 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index f27e2c6..318c543 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -227,7 +227,7 @@ xfs_attr_try_sf_addname(
>>   {
>>   
>>   	struct xfs_mount	*mp = dp->i_mount;
>> -	int			error, error2;
>> +	int			error;
>>   
>>   	error = xfs_attr_shortform_addname(args);
>>   	if (error == -ENOSPC)
>> @@ -243,9 +243,7 @@ xfs_attr_try_sf_addname(
>>   	if (mp->m_flags & XFS_MOUNT_WSYNC)
>>   		xfs_trans_set_sync(args->trans);
>>   
> 
> Perhaps the above check should stay along with the tx commit code..?
That makes sense, I will move it upwards
> 
>> -	error2 = xfs_trans_commit(args->trans);
>> -	args->trans = NULL;
>> -	return error ? error : error2;
>> +	return error;
>>   }
>>   
>>   /*
>> @@ -257,7 +255,7 @@ xfs_attr_set_args(
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error;
>> +	int			error, error2 = 0;;
>>   
>>   	/*
>>   	 * If the attribute list is non-existent or a shortform list,
>> @@ -277,8 +275,11 @@ xfs_attr_set_args(
>>   		 * Try to add the attr to the attribute list in the inode.
>>   		 */
>>   		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC)
>> -			return error;
>> +		if (!error) {
>> +			error2 = xfs_trans_commit(args->trans);
>> +			args->trans = NULL;
>> +			return error ? error : error2;
> 
> We've already checked that error == 0 here, so this can be simplified.
> Hmm.. that said, the original code looks like it commits the transaction
> on error != -ENOSPC, which means this slightly changes behavior when
> (error && error != -ENOSPC) is true. So perhaps it is the error check
> that should be fixed up and not the error2 logic..

Yes, I believe this got some attention in the last review.  While it is 
different logic now, I think we reasoned that committing on say -EIO or 
some other such unexpected error didn't make much sense either, so we 
cleaned it up a bit.  Though you're probably right about the 
simplification now with the change.  Is there a reason we would want to 
commit in the case of unexpected errors?

Allison

> 
> Brian
> 
>> +		}
>>   
>>   		/*
>>   		 * It won't fit in the shortform, transform to a leaf block.
>> -- 
>> 2.7.4
>>
