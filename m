Return-Path: <SRS0=hYYw=2P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0E0C2D0C8
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Dec 2019 20:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4D992072A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Dec 2019 20:49:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ei/J2A9Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfLYUtg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Dec 2019 15:49:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41932 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfLYUtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Dec 2019 15:49:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBPKnRM5179989;
        Wed, 25 Dec 2019 20:49:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=DHDpZTzMtfxh4wWBaeR/hKPB6KroS1+24cnALusc+Ec=;
 b=ei/J2A9QugKfM2CSF9IILvaNDLMonby8Nqn2zd91X9XbSk0sO14OhKEGuCvNUtLznyza
 JVEpH9BRjNR+b0BbuRFeDPVUlj+IHH89p7oLDA9TP2liIz0xIUlMtmSVgjNVltsMirzX
 csNcNQkr+wjHkCsf1FnvxNL33BLXVIydJ/SXx9UqLe++g1Vz31hgn0+fq9A5q4MzK1ys
 zhvegukmIV/ExCTzC7YMftZ66QtVf8qqV56HNZD9YLbRGZxXs2Z5mE8SiNp5HXIlt6d6
 tW0X3XrTR5QmUYxcEK8W5CZ26ol1kC5X9CBu7lEXjjKxn5Q18SEwbS5WgtFize3Nfh19 9Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x1bbq007p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Dec 2019 20:49:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBPKmSFe102123;
        Wed, 25 Dec 2019 20:49:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x37tfctey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Dec 2019 20:49:27 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBPKnMAO023598;
        Wed, 25 Dec 2019 20:49:22 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Dec 2019 12:49:22 -0800
Subject: Re: [PATCH v5 06/14] xfs: Factor up trans handling in
 xfs_attr3_leaf_flipflags
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-7-allison.henderson@oracle.com>
 <20191224121601.GC18379@infradead.org>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <6be62029-986b-e8eb-0745-ffb4a379c2f5@oracle.com>
Date:   Wed, 25 Dec 2019 13:49:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191224121601.GC18379@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912250182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912250182
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/24/19 5:16 AM, Christoph Hellwig wrote:
> What does "factor up" mean?  Basically this moves the
> xfs_trans_roll_inode from xfs_attr3_leaf_flipflags to the callers,
> so I'd expect the subject to mention that.
Yes, that is what I meant for it to mean.  I guess I've been on a few 
other projects that used that terminology, so I didn't think much of it, 
and this is the first time someone has indicated confusion over it.  I 
can certainly change the verbiage if people prefer.  How about "Move 
up"?  "Pull up"?

> 
>> +		/*
>> +		 * Commit the flag value change and start the next trans in
>> +		 * series.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> 
> Do we really still need these comments?
I guess I brought it with the corresponding code because I wasn't sure 
if people would miss it or not.  It does seem to be explaining why we're 
doing a roll right now.  We may need to wait for after the holiday break 
for more people to chime in.

> 
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index ef96971..4fffa84 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -2972,10 +2972,5 @@ xfs_attr3_leaf_flipflags(
>>   			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
>>   	}
>>   
>> -	/*
>> -	 * Commit the flag value change and start the next trans in series.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -
>>   	return error;
> 
> This can become a
> 
> 	return 0;
> 
> now.
> 
Sure, will change.  Thanks!

Allison
