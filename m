Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72311C17441
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 23:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EDF6215EA
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 23:13:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N1RqVuBd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfKHXNY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 18:13:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46938 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKHXNY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 18:13:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8N957N052066
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 23:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=5cynv8FGcUHT3zc0nw4SBGHSAjT38Faj6SMr6gi0kzQ=;
 b=N1RqVuBdSRvzqg/9wpNi/yLXn+Nx3Te38+sHp+DIVhu1loODNXMkmbui585C3RabHepO
 Gz9mkzmzH1PGFuJTzspYPrHvDcgloBEVeyAXo6F34fHFjklShc2vOhPKRmk4slenJqK3
 I6v6PELhPonXwzCe0DP0n5RooEvj7kyNur/W8hcM1+0/u/hfV5TQifDwi87J5Ae2XR20
 dUwa8xhkJSZt1ec7j2qVl0rYziO+MLHGis4BhqH/qaRwshFeAuV56WklkWi9gB7xu7sc
 Za+1+sTC0COj4y5dznt2xywB1ieNgLX/kmACuu3+MyMZ+eHhE2k3JF8nnTKF1urWnhOo Tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w5hgv81uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 23:13:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8N800K043499
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 23:13:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2w5hh3tuub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 23:13:22 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8NDLFe024776
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 23:13:21 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 15:13:21 -0800
Subject: Re: [PATCH v4 09/17] xfs: Factor up commit from
 xfs_attr_try_sf_addname
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-10-allison.henderson@oracle.com>
 <20191108210439.GA6219@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <fed8fd63-a0bd-4275-4440-6e3f978a3a69@oracle.com>
Date:   Fri, 8 Nov 2019 16:13:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108210439.GA6219@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080223
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080223
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/8/19 2:04 PM, Darrick J. Wong wrote:
> On Wed, Nov 06, 2019 at 06:27:53PM -0700, Allison Collins wrote:
>> New delayed attribute routines cannot handle transactions,
>> so factor this up to the calling function.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 23 ++++++++++++-----------
>>   1 file changed, 12 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index dda2eba..e0a38a2 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -227,8 +227,7 @@ xfs_attr_try_sf_addname(
>>   	struct xfs_da_args	*args)
>>   {
>>   
>> -	struct xfs_mount	*mp = dp->i_mount;
>> -	int			error, error2;
>> +	int			error;
>>   
>>   	error = xfs_attr_shortform_addname(args);
>>   	if (error == -ENOSPC)
>> @@ -241,12 +240,7 @@ xfs_attr_try_sf_addname(
>>   	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
>>   		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
> 
> What if you moved this part (the conditional ichgtime) into
> xfs_attr_shortform_addname?  Then this function can just go away.
Sure, I may do that in a separate patch though just to make it easier to 
review.

> 
>>   
>> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
>> -		xfs_trans_set_sync(args->trans);
>> -
>> -	error2 = xfs_trans_commit(args->trans);
>> -	args->trans = NULL;
>> -	return error ? error : error2;
>> +	return error;
>>   }
>>   
>>   /*
>> @@ -258,7 +252,7 @@ xfs_attr_set_args(
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error;
>> +	int			error, error2 = 0;;
>>   
>>   	/*
>>   	 * If the attribute list is non-existent or a shortform list,
>> @@ -278,8 +272,15 @@ xfs_attr_set_args(
>>   		 * Try to add the attr to the attribute list in the inode.
>>   		 */
>>   		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC)
>> -			return error;
>> +		if (error != -ENOSPC) {
>> +			if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
>> +				xfs_trans_set_sync(args->trans);
>> +
>> +			error2 = xfs_trans_commit(args->trans);
>> +			args->trans = NULL;
>> +			return error ? error : error2;
> 
> Can error be something other than 0 or EEXIST?  If so, does it make
> sense to commit even in those cases?  (Have I asked this before...?)
Yeah, this came up once before:
https://patchwork.kernel.org/patch/11087647/

So I simplified it, but then I think people were more comfortable with a 
straight refactor with no function change:
https://patchwork.kernel.org/patch/11134023/

So I put it back. :-)

  It
> looks odd to me that we'd commit the transaction even if something
> handed back EFSCORRUPTED.
> 
> Hm, it's a local attr fork so I guess the only possible error is ENOSPC?
> If that's true then please add a comment/ASSERT to that effect.

Ok, how about a comment.  Something like
/* Should only be 0, EEXIST or ENOSPC */

Sound good?
Allison

> 
> --D
> 
>> +		}
>> +
>>   
>>   		/*
>>   		 * It won't fit in the shortform, transform to a leaf block.
>> -- 
>> 2.7.4
>>
