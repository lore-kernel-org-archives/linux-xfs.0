Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E53C2D0EC
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 22:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F57420730
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 22:19:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="prNHOziC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgDGWTw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 18:19:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41966 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgDGWTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 18:19:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037MDv57030389;
        Tue, 7 Apr 2020 22:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1Urzoc+eoo5ZboQ5sEWmb3A2aFYTHkQU2tAow4nv32Q=;
 b=prNHOziC2JgjvD5trXykILGu5Hwoi//dTgkHqpj12Hn8nI9e8g/4n+OX0FkfoBLHkFay
 eTW5ubYIDMOakpj6Ze6MGzh9qQv3h+WdeXulB+5/7idIDjoZVe7VhdATXQljVxk3UdNt
 NcfO1iE7aKNCOaB59ox5xLlvkqb6nRgoIJjLjWz0Br/+P6NWfA+ihoI9ijTSQMp5+fp7
 Fg28H6Fw0FdriU76kH82YD39QKXqqc/GfwMdi/NU8wVEQtbRuxKJUk7B9Ry07YQMyRei
 Kt7TWJeowr6Wuz2NfD4dw83XyA2Z1gcSY5cmfTh9oDqBOtTs95NyI6uA8j+Sup73fc7d nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3091m384dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 22:19:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037MDS7r023517;
        Tue, 7 Apr 2020 22:19:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3091m1k675-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 22:19:48 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 037MJkbF032016;
        Tue, 7 Apr 2020 22:19:47 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 15:19:46 -0700
Subject: Re: [PATCH v8 10/20] xfs: Add helper function
 __xfs_attr_rmtval_remove
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-11-allison.henderson@oracle.com>
 <20200407141644.GA28936@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <09e59197-3de5-d977-3563-d6a142f8eac0@oracle.com>
Date:   Tue, 7 Apr 2020 15:19:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200407141644.GA28936@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/7/20 7:16 AM, Brian Foster wrote:
> On Fri, Apr 03, 2020 at 03:12:19PM -0700, Allison Collins wrote:
>> This function is similar to xfs_attr_rmtval_remove, but adapted to
>> return EAGAIN for new transactions. We will use this later when we
>> introduce delayed attributes.  This function will eventually replace
>> xfs_attr_rmtval_remove
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 25 +++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>>   2 files changed, 26 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 4d51969..fd4be9d 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -711,3 +711,28 @@ xfs_attr_rmtval_remove(
>>   	}
>>   	return 0;
>>   }
>> +
>> +/*
>> + * Remove the value associated with an attribute by deleting the out-of-line
>> + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>> + * transaction and recall the function
>> + */
>> +int
>> +__xfs_attr_rmtval_remove(
>> +	struct xfs_da_args	*args)
>> +{
>> +	int	error, done;
>> +
>> +	/*
>> +	 * Unmap value blocks for this attr.
>> +	 */
>> +	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
>> +			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
>> +	if (error)
>> +		return error;
>> +
>> +	if (!done)
>> +		return -EAGAIN;
>> +
>> +	return 0;
>> +}
> 
> We should let xfs_attr_rmtval_remove() call this function and do the
> roll based on -EAGAIN, then eliminate the higher level function later if
> it becomes unused.
> 
> Brian
Sure, that should work.  Will update.  Thanks!

Allison

> 
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index eff5f95..ee3337b 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>   		xfs_buf_flags_t incore_flags);
>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>> +int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> -- 
>> 2.7.4
>>
> 
