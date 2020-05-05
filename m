Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE177C47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 17:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFE76206CC
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 17:37:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OL8VUZk1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgEERhk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 13:37:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38452 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730242AbgEERhk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 13:37:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045HXeVA195833;
        Tue, 5 May 2020 17:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bxmjoH0I9z/4QCi8gaXeLI6QD84ihVqZzgMCYLdHKdk=;
 b=OL8VUZk1fIqWWlzthWOXR/+bFGgmcIsG+gKZbsSXvmsiPCGDnEzexqXuGWwMDJ3kFNGL
 wpmXWm3eJAB13DbZb8dsgELGuIZ1424CVgcY0bRg8YEXcAQ/quNnCdia8aVY1G+Q5DGf
 krkYK9Po+Z78yrEHiDIygH7lUeaZAnXFMR0/b++iLegyKPYEWkLl/jbQoUcJwK4sfN5X
 SVdqmY6xb17KqZbEZVuX1KPj2xKWuZTymtxYCZwEsc6ApYt9TElndiWIn0pMz93incaW
 V6fCOEc4e9AL9L8ITmHBnQx1tHExs0rxzozYYots54dAsgmxv6rYxf+IpqnCGsKOcVyS ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r678u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 17:37:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045HZXpv036962;
        Tue, 5 May 2020 17:35:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjnf7ed3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 17:35:34 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 045HZUlW024716;
        Tue, 5 May 2020 17:35:31 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 10:35:30 -0700
Subject: Re: [PATCH v9 10/24] xfs: Add helper function
 __xfs_attr_rmtval_remove
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-11-allison.henderson@oracle.com>
 <20200504132722.GA54625@bfoster>
 <d2effe05-04da-3c8d-5020-4fca83875051@oracle.com>
 <20200505120313.GB60048@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <e07597f1-13a3-258f-e155-55059ace52fa@oracle.com>
Date:   Tue, 5 May 2020 10:35:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200505120313.GB60048@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/5/20 5:03 AM, Brian Foster wrote:
> On Mon, May 04, 2020 at 02:36:39PM -0700, Allison Collins wrote:
>>
>>
>> On 5/4/20 6:27 AM, Brian Foster wrote:
>>> On Thu, Apr 30, 2020 at 03:50:02PM -0700, Allison Collins wrote:
>>>> This function is similar to xfs_attr_rmtval_remove, but adapted to
>>>> return EAGAIN for new transactions. We will use this later when we
>>>> introduce delayed attributes.  This function will eventually replace
>>>> xfs_attr_rmtval_remove
>>>>
>>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>>>> ---
>>>
>>> Looks like the commit log needs some rewording now that this is a
>>> refactor patch. With that fixed:
>> Ok, maybe just an extra line like "Refactor xfs_attr_rmtval_remove to add
>> helper function __xfs_attr_rmtval_remove" ?
>>
> 
> I'd update the first sentence to say something like that instead of how
> the function is similar to xfs_attr_rmtval_remove().
> 
> Brian

Ok then, will update.

Allison

> 
>>>
>>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Alrighty, thank you!
>>
>> Allison
>>
>>>
>>>>    fs/xfs/libxfs/xfs_attr_remote.c | 46 ++++++++++++++++++++++++++++++++---------
>>>>    fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>>>>    2 files changed, 37 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>>>> index 4d51969..02d1a44 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>>>> @@ -681,7 +681,7 @@ xfs_attr_rmtval_remove(
>>>>    	xfs_dablk_t		lblkno;
>>>>    	int			blkcnt;
>>>>    	int			error = 0;
>>>> -	int			done = 0;
>>>> +	int			retval = 0;
>>>>    	trace_xfs_attr_rmtval_remove(args);
>>>> @@ -693,14 +693,10 @@ xfs_attr_rmtval_remove(
>>>>    	 */
>>>>    	lblkno = args->rmtblkno;
>>>>    	blkcnt = args->rmtblkcnt;
>>>> -	while (!done) {
>>>> -		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
>>>> -				    XFS_BMAPI_ATTRFORK, 1, &done);
>>>> -		if (error)
>>>> -			return error;
>>>> -		error = xfs_defer_finish(&args->trans);
>>>> -		if (error)
>>>> -			return error;
>>>> +	do {
>>>> +		retval = __xfs_attr_rmtval_remove(args);
>>>> +		if (retval && retval != EAGAIN)
>>>> +			return retval;
>>>>    		/*
>>>>    		 * Close out trans and start the next one in the chain.
>>>> @@ -708,6 +704,36 @@ xfs_attr_rmtval_remove(
>>>>    		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>>    		if (error)
>>>>    			return error;
>>>> -	}
>>>> +	} while (retval == -EAGAIN);
>>>> +
>>>>    	return 0;
>>>>    }
>>>> +
>>>> +/*
>>>> + * Remove the value associated with an attribute by deleting the out-of-line
>>>> + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>>>> + * transaction and recall the function
>>>> + */
>>>> +int
>>>> +__xfs_attr_rmtval_remove(
>>>> +	struct xfs_da_args	*args)
>>>> +{
>>>> +	int			error, done;
>>>> +
>>>> +	/*
>>>> +	 * Unmap value blocks for this attr.
>>>> +	 */
>>>> +	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
>>>> +			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
>>>> +	if (error)
>>>> +		return error;
>>>> +
>>>> +	error = xfs_defer_finish(&args->trans);
>>>> +	if (error)
>>>> +		return error;
>>>> +
>>>> +	if (!done)
>>>> +		return -EAGAIN;
>>>> +
>>>> +	return error;
>>>> +}
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>>>> index eff5f95..ee3337b 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>>>> @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>>    int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>>>    		xfs_buf_flags_t incore_flags);
>>>>    int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>>>> +int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>>    #endif /* __XFS_ATTR_REMOTE_H__ */
>>>> -- 
>>>> 2.7.4
>>>>
>>>
>>
> 
