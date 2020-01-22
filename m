Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE59C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 05:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E40121569
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 05:23:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BUkpopGE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgAVFXL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 00:23:11 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35594 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgAVFXL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jan 2020 00:23:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M5IMQu075548
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 05:23:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=0+TMihsb33xvZhBhKBShvqWlpbuRtjVGLThFeFbwO2U=;
 b=BUkpopGEbW77kLTlcx8Apa3su/xm+qSCVNANUdYlESChxqXFHmYBRztocTOzZb3eUs3x
 abTNAU34kE76GfaS7X0A2R8NB0vP5Up+nX733uWp0e76XV1MkBrfffQ7ipwTq9yEsaoF
 i/FW3Q0wmlR62/HOyDPELpZDs3VjmK2Fl2Pb0L7ucWCABH0kt0DSXLz4YP0EJiIQ1G5N
 J7tW8+bK1vsb5OyHYp9r03E09KGDN5fUyfWZ407DdoSHeJc6AtP6v4FxOen9+RP1tkev
 v+wZDWYQgVd9KnlTOo2RyWt9i2BniuooFww1f4UBA5F6a8QV0q3OVO7+C9IRBezu1zi9 mQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnr97ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 05:23:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M5Itc2104616
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 05:23:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xnpejhhpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 05:23:08 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00M5N7Cm020142
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 05:23:07 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 21:23:07 -0800
Subject: Re: [PATCH v6 13/16] xfs: Add helper function xfs_attr_rmtval_unmap
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-14-allison.henderson@oracle.com>
 <20200121232408.GM8247@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <04af001b-2189-05e5-60ca-10d6b91291f8@oracle.com>
Date:   Tue, 21 Jan 2020 22:23:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200121232408.GM8247@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001220046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001220046
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/21/20 4:24 PM, Darrick J. Wong wrote:
> On Sat, Jan 18, 2020 at 03:50:32PM -0700, Allison Collins wrote:
>> This function is similar to xfs_attr_rmtval_remove, but adapted to
>> return. EAGAIN for new transactions. We will use this later when we
> 
> "..to return -EAGAIN"?
yees, I noticed that after I sent it... will fix :-)
> 
>> introduce delayed attributes
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 27 +++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>>   2 files changed, 28 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 9b4fa2a..f2ee0b8 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -684,3 +684,30 @@ xfs_attr_rmtval_remove(
>>   	}
>>   	return 0;
>>   }
>> +
>> +/*
>> + * Unmap value blocks for this attr.  This is similar to
>> + * xfs_attr_rmtval_remove, but adapted to to return EAGAIN for new transactions
note to self: fix too many to's

> 
> Do you have to scan for and invalidate any incore buffers for the remote
> value?  Or will that be performed by another step?  Hard to tell because
> this function doesn't have any callers.
Yes, that happens in xfs_attr_rmtval_invalidate.  Right after we mark 
incomplete, and before we fall into the bunmapi loop I mentioned in the 
last patch.  Basically this function becomes the inside of that loop.


> 
>> + */
>> +int
>> +xfs_attr_rmtval_unmap(
>> +	struct xfs_da_args	*args)
>> +{
>> +	int	error, done;
>> +
>> +	/*
>> +	 * Unmap value blocks for this attr.  This is similar to
>> +	 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
>> +	 * for new transactions
>> +	 */
>> +	error = xfs_bunmapi(args->trans, args->dp,
>> +		    args->rmtblkno, args->rmtblkcnt,
>> +		    XFS_BMAPI_ATTRFORK, 1, &done);
>> +	if (error)
>> +		return error;
>> +
>> +	if (!done)
>> +		return -EAGAIN;
> 
> return done ? 0 : -EAGAIN; ?
I believe Christoph asked for the return 0;  I am not particular about 
it as long a people are in agreement.  If people feel strongly one way 
or another please chime in.

Allison
> 
> --D
> 


>> +
>> +	return 0;
>> +}
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 85f2593..7ab3770 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -12,4 +12,5 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>> +int xfs_attr_rmtval_unmap(struct xfs_da_args *args);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> -- 
>> 2.7.4
>>
