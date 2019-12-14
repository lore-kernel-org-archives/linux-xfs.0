Return-Path: <SRS0=IS9S=2E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBA1C43603
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 06:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7C7A2465E
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 06:59:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z5uZ6y3D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbfLNG7I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Dec 2019 01:59:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51392 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfLNG7I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Dec 2019 01:59:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE6x2jW071253;
        Sat, 14 Dec 2019 06:59:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=A/oy3kbwFBGFrpEmlIhHLSb703v1MMUt0qDkHyGTuQA=;
 b=Z5uZ6y3DjS31+E6nafMwuWl9RaZQsWrdO53bXxz0Yh7KgqKRaJo9Vq3UKSI6i5Jp5Rke
 r7EXMoSaWiUy8VX9jVyklPz7pGcjcrDZR/EJcIqbva5VbRGvgC1IfthgEjZC36v5Xs4g
 /q1jrNROe6ECwKGEvofV6m9lKKdDmrz4FVvnxSkZX9ernZ4HLhNfetOIGYm5spstFWkI
 094u7c83Dsrj4AJKK8IUMA95JS9bx/BC8ytwC8nC8TMcbkDa0jM+jZc7IAQRLAqd6fO5
 9v+zpyNu/YvpzHECmn3+1AUXCDU2T4rkMeZq74ugnglLG8PBHyS+/5K4HTIbxDMCii6Q Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wvrcqr8nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 06:59:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE6wXhL103903;
        Sat, 14 Dec 2019 06:59:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wvqju9bqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 06:59:01 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBE6x03R010053;
        Sat, 14 Dec 2019 06:59:00 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 22:58:59 -0800
Subject: Re: [PATCH v5 08/14] xfs: Factor up xfs_attr_try_sf_addname
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-9-allison.henderson@oracle.com>
 <20191213141549.GE43376@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <d06c3297-c5f8-9104-964c-1023441246d1@oracle.com>
Date:   Fri, 13 Dec 2019 23:58:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191213141549.GE43376@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912140050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912140050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/13/19 7:15 AM, Brian Foster wrote:
> On Wed, Dec 11, 2019 at 09:15:07PM -0700, Allison Collins wrote:
>> New delayed attribute routines cannot handle transactions. We
>> can factor up the commit, but there is little left in this
>> function other than some error handling and an ichgtime. So
>> hoist all of xfs_attr_try_sf_addname up at this time.  We will
>> remove all the commits in this set.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 54 ++++++++++++++++++++----------------------------
>>   1 file changed, 22 insertions(+), 32 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 36f6a43..9c78e0d 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -258,7 +230,7 @@ xfs_attr_set_args(
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error;
>> +	int			error, error2 = 0;;
> 
> Extra semicolon on the above line.
> 
>>   
>>   	/*
>>   	 * If the attribute list is non-existent or a shortform list,
>> @@ -277,9 +249,27 @@ xfs_attr_set_args(
>>   		/*
>>   		 * Try to add the attr to the attribute list in the inode.
>>   		 */
>> -		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC)
>> -			return error;
>> +
>> +		error = xfs_attr_shortform_addname(args);
>> +
>> +		/* Should only be 0, -EEXIST or ENOSPC */
>> +		if (error != -ENOSPC) {
>> +			/*
>> +			 * Commit the shortform mods, and we're done.
>> +			 * NOTE: this is also the error path (EEXIST, etc).
>> +			 */
>> +			if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
>> +				xfs_trans_ichgtime(args->trans, dp,
>> +						   XFS_ICHGTIME_CHG);
>> +
>> +			if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
>> +				xfs_trans_set_sync(args->trans);
>> +
>> +			error2 = xfs_trans_commit(args->trans);
>> +			args->trans = NULL;
>> +			return error ? error : error2;
>> +		}
>> +
> 
> And extra whitespace here. With those nits fixed:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
Ok, will do.  Thank you!

Allison

>>   
>>   		/*
>>   		 * It won't fit in the shortform, transform to a leaf block.
>> -- 
>> 2.7.4
>>
> 
