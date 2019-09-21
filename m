Return-Path: <SRS0=b7mv=XQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E76C49ED7
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 07:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1F8F20882
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 07:00:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dt1cOExq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbfIUHA0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Sep 2019 03:00:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58098 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729840AbfIUHAZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Sep 2019 03:00:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L6xAj4159430;
        Sat, 21 Sep 2019 07:00:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=0LLhAhXvrQKrszRZuIs8jl6FqZt6ZkRyfgyFxBht1KM=;
 b=dt1cOExqg8Y1Q0OBJkGU1gl+BYRsFYV4ivlrlMdMGQrT7WgmNyXR07f/ETuGNWgBUBE7
 p8kkkDuIMCz87svtLqPIC9Ca0plTzfCmb/G+hJz5u4PPSu7KzNSDYW0Sf78qYTQfcwB6
 6+U1aqWMSYBoEogtQGxo/SNPXne7J2FAGvHHVeMj8+hbR4BJRriw6nciVOOUx1TayQGp
 9qJIIU4qwXyQL7jTj7cfZRUwXKYrQCdXq5SAVIY2RGnj57YP/7FvN5xM1PMgijKBDUIC
 pVd16ND+MnkUxjhC/QunljkZw0MAo/DkiGavpEd6aTG52eCTXi5RiKGfKHD0e0Cp/gjS 2g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9t8amt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 07:00:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L6wnUQ070489;
        Sat, 21 Sep 2019 07:00:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v5bpc1wtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 07:00:08 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8L706FL000777;
        Sat, 21 Sep 2019 07:00:07 GMT
Received: from [192.168.1.9] (/67.1.21.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 21 Sep 2019 07:00:06 +0000
Subject: Re: [PATCH v3 07/19] xfs: Factor out xfs_attr_leaf_addname helper
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-8-allison.henderson@oracle.com>
 <20190920134959.GE40150@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <02e9ea9f-166e-6589-18b6-784f431fc311@oracle.com>
Date:   Sat, 21 Sep 2019 00:00:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920134959.GE40150@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909210077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909210077
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/20/19 6:49 AM, Brian Foster wrote:
> On Thu, Sep 05, 2019 at 03:18:25PM -0700, Allison Collins wrote:
>> Factor out new helper function xfs_attr_leaf_try_add.
>> Because new delayed attribute routines cannot roll
>> transactions, we carve off the parts of
>> xfs_attr_leaf_addname that we can use.  This will help
>> to reduce repetitive code later when we introduce
>> delayed attributes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++--------------
>>   1 file changed, 29 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 7a6dd37..f27e2c6 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -593,19 +593,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>>    * External routines when attribute list is one block
>>    *========================================================================*/
>>   
>> -/*
>> - * Add a name to the leaf attribute list structure
>> - *
>> - * This leaf block cannot have a "remote" value, we only call this routine
>> - * if bmap_one_block() says there is only one block (ie: no remote blks).
>> - */
>>   STATIC int
>> -xfs_attr_leaf_addname(
>> -	struct xfs_da_args	*args)
>> +xfs_attr_leaf_try_add(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_buf		*bp)
>>   {
>> -	struct xfs_buf		*bp;
>> -	int			retval, error, forkoff;
>> -	struct xfs_inode	*dp = args->dp;
>> +	int			retval, error;
> 
> It looks like we could pick either retval or error and use it
> consistently throughout the new function.
> 
>>   
>>   	trace_xfs_attr_leaf_addname(args);
>>   
> 
> I also wonder if this tracepoint should remain in the caller.

Alrihty, will clean out retval and move trace point

> 
>> @@ -650,13 +643,35 @@ xfs_attr_leaf_addname(
>>   	retval = xfs_attr3_leaf_add(bp, args);
>>   	if (retval == -ENOSPC) {
>>   		/*
>> -		 * Promote the attribute list to the Btree format, then
>> -		 * Commit that transaction so that the node_addname() call
>> -		 * can manage its own transactions.
>> +		 * Promote the attribute list to the Btree format.
>>   		 */
>>   		error = xfs_attr3_leaf_to_node(args);
>>   		if (error)
>>   			return error;
>> +	}
>> +	return retval;
>> +}
>> +
>> +
>> +/*
>> + * Add a name to the leaf attribute list structure
>> + *
>> + * This leaf block cannot have a "remote" value, we only call this routine
>> + * if bmap_one_block() says there is only one block (ie: no remote blks).
>> + */
>> +STATIC int
>> +xfs_attr_leaf_addname(struct xfs_da_args	*args)
>> +{
>> +	int			retval, error, forkoff;
>> +	struct xfs_buf		*bp = NULL;
>> +	struct xfs_inode	*dp = args->dp;
>> +
>> +	retval = xfs_attr_leaf_try_add(args, bp);
>> +	if (retval == -ENOSPC) {
>> +		/*
>> +		 * Commit that transaction so that the node_addname() call
>> +		 * can manage its own transactions.
>> +		 */
>>   		error = xfs_defer_finish(&args->trans);
>>   		if (error)
>>   			return error;
> 
> Hmm.. I find this bit of factoring a little strange. We do part of the
> -ENOSPC handling (leaf to node) in one place and another part
> (xfs_defer_finish()) in the caller. I'm assuming we intentionally don't
> finish dfops in the new helper because the delayed attr bits shouldn't
> do that, but I'm wondering whether the helper should just return -ENOSPC
> and the caller should be responsible for whatever needs to happen based
> on that in the associated context. Hm?
> 
> Brian

Yes, the idea is that the new helper function avoids anything with 
transactions.  We could factor up the ENOSPC handling into the caller, 
that may look cleaner.  I think there's really only one place it's called.

Thanks!
Allison

> 
>> -- 
>> 2.7.4
>>
