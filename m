Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E77C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 04:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 378E921835
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 04:29:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D/zMQnN0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgAVE3V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 23:29:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41362 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgAVE3V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 23:29:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M4OA5L025704
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 04:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MY7tI30z2cbt3s48uEprgmx/gUj0jzqc1NfXRrqepd4=;
 b=D/zMQnN0ye2YBkZlAdrw6NNcxNVk1niVZA5poGmKPKpwVh7eJSeS3UgFNx3l/6CEYyzY
 kyJ622+LFTO4D/rGUpfzaP3LrGzjvQkw/ZURRRhnN1zwVK41VHuhSFhRH9Ll0YcpFjBa
 0pF+Y69yo6lj49lqqHOSggD+91NtBBFLOAG8I6XPK9zpZaizkuPUeJSFGd/l4IPCG2PA
 8zJm8PbAV+oZpH9YkL4D6D76UW7INKYzZuDjVIz+0iFZ1tnwyRrF8eD3zrt9jIBjJEPd
 LsuaNAM/eW9Pc4AzyH7vqIKjA2P9VeMStCA3BGYVSr9wXfPs3l0RcLBWsXMoAbOYr/PK pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksyq97jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 04:29:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M4SadK096289
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 04:29:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xnsj62mca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 04:29:19 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00M4TIrJ029415
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 04:29:18 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 20:29:17 -0800
Subject: Re: [PATCH v6 11/16] xfs: Check for -ENOATTR or -EEXIST
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-12-allison.henderson@oracle.com>
 <20200121231530.GK8247@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <68dcf7a7-9e10-2d64-9c5c-d520d2372c2b@oracle.com>
Date:   Tue, 21 Jan 2020 21:29:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200121231530.GK8247@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001220038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001220037
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/21/20 4:15 PM, Darrick J. Wong wrote:
> On Sat, Jan 18, 2020 at 03:50:30PM -0700, Allison Collins wrote:
>> Delayed operations cannot return error codes.  So we must check for
>> these conditions first before starting set or remove operations
> 
> Answering my own question from earlier -- I see here you actually /are/
> checking the attr existence w.r.t. ATTR_{CREATE,REPLACE} right after we
> allocate a transaction and ILOCK the inode, so
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Alrighty, thank you!

> 
> Though I am wondering if you could discard the predicates from the
> second patch in favor of doing a normal lookup of the attr with a zero
> valuelen to determine if there's already an attribute?
I think I likely answered this in the response to that patch.  Because 
it's used as part of the remove procedures, we still need it.  We could 
make a simpler version just for this application I suppose, but it seems 
like it'd just be extra code since we still need the former.

Thank you for the reviews!
Allison

> 
> --D
> 
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index a2673fe..e9d22c1 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -457,6 +457,14 @@ xfs_attr_set(
>>   		goto out_trans_cancel;
>>   
>>   	xfs_trans_ijoin(args.trans, dp, 0);
>> +
>> +	error = xfs_has_attr(&args);
>> +	if (error == -EEXIST && (name->type & ATTR_CREATE))
>> +		goto out_trans_cancel;
>> +
>> +	if (error == -ENOATTR && (name->type & ATTR_REPLACE))
>> +		goto out_trans_cancel;
>> +
>>   	error = xfs_attr_set_args(&args);
>>   	if (error)
>>   		goto out_trans_cancel;
>> @@ -545,6 +553,10 @@ xfs_attr_remove(
>>   	 */
>>   	xfs_trans_ijoin(args.trans, dp, 0);
>>   
>> +	error = xfs_has_attr(&args);
>> +	if (error != -EEXIST)
>> +		goto out;
>> +
>>   	error = xfs_attr_remove_args(&args);
>>   	if (error)
>>   		goto out;
>> -- 
>> 2.7.4
>>
