Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A2DC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 23:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE3562495A
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 23:01:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FLIy/tqi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgEDXBw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 19:01:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46458 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbgEDXBw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 19:01:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044Mwoi0070274
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:01:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=oQTZEgWzFEs8SlQB9QVHQKgSmZROW35xr52Bzn6OM3U=;
 b=FLIy/tqi3KqCOoOPMoB4hsWSlMGCV86XNy9KkjK9UsIX/ULqAsgklAckAj924/DmVuK/
 HjzMQBrUvoMNgnOGKcIZ5STPIzHk8kq4EaiySgR2Qh/PZje28qRyriVwynIGNO7TnjgN
 cJnMg4dvhYhb/s/DhWDq9pgWVZCKR+uuM+SG6Qej5X0UYzaD7tlie285xUBMXcRfBzH2
 0i5cbb+mXiZVqbwzbng3Doq2yGtSWz8K/BhZ1t5M5o4OAPa8qUqpVwyHkkuLng91TkG/
 vy/ufytYu2RkAylu0W4a+EFGadtvjWNPBigT25Zms4PtodD8Ubl8TphKJ8JRDi6mZxR5 wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30s1gn1k82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:01:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044MwVAr146771
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:01:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30sjjx4eqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:01:50 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044N1nrZ024508
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:01:49 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 16:01:49 -0700
Subject: Re: [PATCH v9 16/24] xfs: Add remote block helper functions
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-17-allison.henderson@oracle.com>
 <20200504185555.GC5703@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <05a86a13-cea0-63bb-06c1-0aa48dfd2cd2@oracle.com>
Date:   Mon, 4 May 2020 16:01:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504185555.GC5703@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040178
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 11:55 AM, Darrick J. Wong wrote:
> On Thu, Apr 30, 2020 at 03:50:08PM -0700, Allison Collins wrote:
>> This patch adds two new helper functions xfs_attr_store_rmt_blk and
>> xfs_attr_restore_rmt_blk. These two helpers assist to remove redundant
>> code associated with storing and retrieving remote blocks during the
>> attr set operations.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Hmm.  This is an ok-enough refactoring of the same idiom repeated over
> and over, but ...ugh, there has got to be a less weird way of pushing
> and popping state like this.
> 
> Unfortunately, the only thing I can think of would be to pass a "which
> attr state?" argument to all the attr functions, and that might just
> make things worse, particularly since we already have da state that gets
> passed around everywhere, and afaict there's on a few users of this.
> 
Hmm, ok, I'll give it some thought.  I just spotted it as a sort of 
clean up while trying to organize things.

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Alrighty, thank you!

Allison
> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 50 +++++++++++++++++++++++++++++-------------------
>>   1 file changed, 30 insertions(+), 20 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index df77a3c..feae122 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -563,6 +563,30 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>>    * External routines when attribute list is one block
>>    *========================================================================*/
>>   
>> +/* Store info about a remote block */
>> +STATIC void
>> +xfs_attr_save_rmt_blk(
>> +	struct xfs_da_args	*args)
>> +{
>> +	args->blkno2 = args->blkno;
>> +	args->index2 = args->index;
>> +	args->rmtblkno2 = args->rmtblkno;
>> +	args->rmtblkcnt2 = args->rmtblkcnt;
>> +	args->rmtvaluelen2 = args->rmtvaluelen;
>> +}
>> +
>> +/* Set stored info about a remote block */
>> +STATIC void
>> +xfs_attr_restore_rmt_blk(
>> +	struct xfs_da_args	*args)
>> +{
>> +	args->blkno = args->blkno2;
>> +	args->index = args->index2;
>> +	args->rmtblkno = args->rmtblkno2;
>> +	args->rmtblkcnt = args->rmtblkcnt2;
>> +	args->rmtvaluelen = args->rmtvaluelen2;
>> +}
>> +
>>   /*
>>    * Tries to add an attribute to an inode in leaf form
>>    *
>> @@ -597,11 +621,7 @@ xfs_attr_leaf_try_add(
>>   
>>   		/* save the attribute state for later removal*/
>>   		args->op_flags |= XFS_DA_OP_RENAME;	/* an atomic rename */
>> -		args->blkno2 = args->blkno;		/* set 2nd entry info*/
>> -		args->index2 = args->index;
>> -		args->rmtblkno2 = args->rmtblkno;
>> -		args->rmtblkcnt2 = args->rmtblkcnt;
>> -		args->rmtvaluelen2 = args->rmtvaluelen;
>> +		xfs_attr_save_rmt_blk(args);
>>   
>>   		/*
>>   		 * clear the remote attr state now that it is saved so that the
>> @@ -700,11 +720,8 @@ xfs_attr_leaf_addname(
>>   		 * Dismantle the "old" attribute/value pair by removing
>>   		 * a "remote" value (if it exists).
>>   		 */
>> -		args->index = args->index2;
>> -		args->blkno = args->blkno2;
>> -		args->rmtblkno = args->rmtblkno2;
>> -		args->rmtblkcnt = args->rmtblkcnt2;
>> -		args->rmtvaluelen = args->rmtvaluelen2;
>> +		xfs_attr_restore_rmt_blk(args);
>> +
>>   		if (args->rmtblkno) {
>>   			error = xfs_attr_rmtval_invalidate(args);
>>   			if (error)
>> @@ -929,11 +946,7 @@ xfs_attr_node_addname(
>>   
>>   		/* save the attribute state for later removal*/
>>   		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
>> -		args->blkno2 = args->blkno;		/* set 2nd entry info*/
>> -		args->index2 = args->index;
>> -		args->rmtblkno2 = args->rmtblkno;
>> -		args->rmtblkcnt2 = args->rmtblkcnt;
>> -		args->rmtvaluelen2 = args->rmtvaluelen;
>> +		xfs_attr_save_rmt_blk(args);
>>   
>>   		/*
>>   		 * clear the remote attr state now that it is saved so that the
>> @@ -1045,11 +1058,8 @@ xfs_attr_node_addname(
>>   		 * Dismantle the "old" attribute/value pair by removing
>>   		 * a "remote" value (if it exists).
>>   		 */
>> -		args->index = args->index2;
>> -		args->blkno = args->blkno2;
>> -		args->rmtblkno = args->rmtblkno2;
>> -		args->rmtblkcnt = args->rmtblkcnt2;
>> -		args->rmtvaluelen = args->rmtvaluelen2;
>> +		xfs_attr_restore_rmt_blk(args);
>> +
>>   		if (args->rmtblkno) {
>>   			error = xfs_attr_rmtval_invalidate(args);
>>   			if (error)
>> -- 
>> 2.7.4
>>
