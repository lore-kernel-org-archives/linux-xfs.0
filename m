Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EC1C3A5A2
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 22:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 556ED2080F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 22:50:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TYqtzdCA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406551AbfITWuj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 18:50:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39260 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406254AbfITWuj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 18:50:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8KMmvSm064288;
        Fri, 20 Sep 2019 22:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kPAJjZ2AxrjadxJz1T0fWckn7N1cjTFE3tnzCyBXKdo=;
 b=TYqtzdCAmLK5zftvoUYE6Wm0Gbk8BBe6fsq3JidmB3avKMhoUsuWZ4XOXiYIJlh2W9VE
 yIBtrZyji5n6cDsluQ+JcEN+DR8n/QvI0h8+x4Tz0sTrhhcg6PIktEy/x6VFeAPOcCU3
 gslHPV2iftRmEasdFh+ymMjNXiWfik5qLaMPmBWKF3z/jGmMpw6R3wn+tzA9rSROT0G+
 wd7iWcpyddkvgu0eI/OuytbCx9SZkBHEWe9jtcZirV7R6fb7jUsOjgijxdhmTYe1KgTg
 7nWeGZsbaYtRCdsqkedZbyE7u2P79Drk6KUwri/fFnH+1HNATqpQjYhTOr6ffzieI07j FQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v3vb551uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 22:50:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8KMn0jh112300;
        Fri, 20 Sep 2019 22:50:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v4xea125x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 22:50:27 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8KMoQpb020610;
        Fri, 20 Sep 2019 22:50:26 GMT
Received: from [192.168.1.9] (/67.1.21.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Sep 2019 22:50:26 +0000
Subject: Re: [PATCH v3 11/19] xfs: Factor out xfs_attr_rmtval_invalidate
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-12-allison.henderson@oracle.com>
 <20190920135121.GI40150@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <84f63a08-65b3-235d-42ff-0b9dc83d79f6@oracle.com>
Date:   Fri, 20 Sep 2019 15:50:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920135121.GI40150@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909200189
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909200189
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/20/19 6:51 AM, Brian Foster wrote:
> On Thu, Sep 05, 2019 at 03:18:29PM -0700, Allison Collins wrote:
>> Because new delayed attribute routines cannot roll
>> transactions, we carve off the parts of
>> xfs_attr_rmtval_remove that we can use.  This will help to
>> reduce repetitive code later when we introduce delayed
>> attributes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 29 +++++++++++++++++++++--------
>>   fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>>   2 files changed, 22 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 080a284..1b13795 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> ...
>> @@ -645,7 +638,27 @@ xfs_attr_rmtval_remove(
>>   		lblkno += map.br_blockcount;
>>   		blkcnt -= map.br_blockcount;
>>   	}
>> +	return 0;
>> +}
>>   
>> +/*
>> + * Remove the value associated with an attribute by deleting the
>> + * out-of-line buffer that it is stored on.
>> + */
>> +int
>> +xfs_attr_rmtval_remove(
>> +	struct xfs_da_args      *args)
>> +{
>> +	xfs_dablk_t		lblkno;
>> +	int			blkcnt;
>> +	int			error = 0;
>> +	int			done = 0;
> 
> Nit: with done initialized here, you can remove the done = 0 further
> down in the function. That aside:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Ok, I will pick out that little bit.  Thank you for the reviews!

Allison

> 
>> +
>> +	trace_xfs_attr_rmtval_remove(args);
>> +
>> +	error = xfs_attr_rmtval_invalidate(args);
>> +	if (error)
>> +		return error;
>>   	/*
>>   	 * Keep de-allocating extents until the remote-value region is gone.
>>   	 */
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index cd7670d..b6fd35a 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -11,6 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>>   int xfs_attr_rmtval_get(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>> +int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>>   int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> -- 
>> 2.7.4
>>
