Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B393FC6196
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1EE3214DA
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:42:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KWyzSVQD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732519AbfKHVm5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:42:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37250 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732101AbfKHVm5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 16:42:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8LYPTK195805
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:42:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=0H2zn/+vkvgBBUll5tfDWDuDultefdd2G7Gpool7+HQ=;
 b=KWyzSVQDe3Evu/XybAVw6baJeY9aaThFxZYD3rcbg8jgkzSI0ZsbjycCg5wwuvovQa+Q
 9vl6Xnz9JWpD6QetFcBag8ydpzxUIGQGvr+zHAEurIjNp4t5Tg0fbgoK9znT9/TL8/B2
 Nt3cIe1RvrteEW/kZO9obRmQbFCF+5sNBXIhgMRDKqIPitcJ46otokHqtuEJ4M1G2zK4
 ZHVFvCxG+PjrGoGCvMwstHj9i7lDaSS2kxA3QyvD3gzHHMvJvlzYvPIf3u4zj7W9ZpI5
 7mFkR9p/ncsQGSpuVznhzsDO3pon1JpNJOqj7PuGzsFPhj+b/S7AZ81sTbK0wDrVJSdQ tQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w17tus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:42:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8Lgn9u061887
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:42:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w5bmqef0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:42:54 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8LgrWQ007645
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:42:53 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 13:42:53 -0800
Subject: Re: [PATCH v4 15/17] xfs: Check for -ENOATTR or -EEXIST
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-16-allison.henderson@oracle.com>
 <20191108212833.GF6219@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <59ef241e-b7c3-bc9e-7786-073972b7af35@oracle.com>
Date:   Fri, 8 Nov 2019 14:42:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108212833.GF6219@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/8/19 2:28 PM, Darrick J. Wong wrote:
> On Wed, Nov 06, 2019 at 06:27:59PM -0700, Allison Collins wrote:
>> Delayed operations cannot return error codes.  So we must check for
>> these conditions first before starting set or remove operations
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 25 +++++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 5dcb19f..626d4a98 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -458,6 +458,27 @@ xfs_attr_set(
>>   		goto out_trans_cancel;
>>   
>>   	xfs_trans_ijoin(args.trans, dp, 0);
>> +
>> +	error = xfs_has_attr(&args);
>> +	if (error == -EEXIST) {
>> +		if (name->type & ATTR_CREATE)
>> +			goto out_trans_cancel;
>> +		else
>> +			name->type |= ATTR_REPLACE;
>> +	}
>> +
>> +	if (error == -ENOATTR && (name->type & ATTR_REPLACE))
>> +		goto out_trans_cancel;
>> +
>> +	if (name->type & ATTR_REPLACE) {
>> +		name->type &= ~ATTR_REPLACE;
>> +		error = xfs_attr_remove_args(&args);
>> +		if (error)
>> +			goto out_trans_cancel;
>> +
>> +		name->type |= ATTR_CREATE;
> 
> I thought _set_args already handled the remove part of replacing an
> attr?  
No, IIRC in one of the other reviews we decided to break the rename into 
a set and then a remove.  That way the error handling moves up here 
instead of trying to deal with it in the middle of the delayed operation

And I thought that it did this with an atomic rename?  Won't this
> break the atomicity of attr replacement?
Hmm, think this worked for delayed operations, but not anymore since 
we're going back to supporting both delayed and inline in one code path. 
  I think what this means is that the flip flag has to get moved in 
here, right?  We flip on the incomplete flag before the remove and then 
set it when the rename is done?

> 
> --D
> 
>> +	}
>> +
>>   	error = xfs_attr_set_args(&args);
>>   	if (error)
>>   		goto out_trans_cancel;
>> @@ -543,6 +564,10 @@ xfs_attr_remove(
>>   	 */
>>   	xfs_trans_ijoin(args.trans, dp, 0);
>>   
>> +	error = xfs_has_attr(&args);
>> +	if (error == -ENOATTR)
>> +		goto out;
>> +
>>   	error = xfs_attr_remove_args(&args);
>>   	if (error)
>>   		goto out;
>> -- 
>> 2.7.4
>>
