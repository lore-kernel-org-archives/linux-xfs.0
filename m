Return-Path: <SRS0=Wl19=BE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E47C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F5142065F
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jpiNaZs/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgGYAIv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 20:08:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36410 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbgGYAIu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 20:08:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ONqmhd171088
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nZ2sEBgbUi1P8Mnyuha9DsK44+52EL/l9tv1RtyhxM4=;
 b=jpiNaZs/gLCSeSgKRcFphJgyjYFGcCOR0THBxb93f+bPyQhyT0Lv3HVG8UIVSkK4lKkt
 TULeuW1OxVoSEZEXbK3XO7lW8RmKGTZIpPSGYHzjGWiPVUobXmz48jwOpO5cCi/1h0oJ
 BoizaB7CjJ9+A3zMA0Vjq7r17QIzJ9uZuHmuVmxU/JFuZ6U//+Pqjc+B9SEUtAcbJemb
 0yXNOVSLPM9zURiy/WRHIR+tMxfsiDTz+OYZGIkIbH4IqwoJaUYelymrxwj8jHov54fN
 t++GjMaLnztQ+taZN3Bb68jopVXvrdsQyc1tA2xodqrdvm1yHopjp0OpHGAgVtqYISOC sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32brgs1pcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P02wRF188212
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32g9uu06ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:48 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06P08lLK019559
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:47 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 17:08:47 -0700
Subject: Re: [PATCH v11 21/25] xfs: Simplify xfs_attr_node_addname
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-22-allison.henderson@oracle.com>
 <20200721234103.GL3151642@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <7157b896-5bd5-0785-b401-37018352554f@oracle.com>
Date:   Fri, 24 Jul 2020 17:08:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721234103.GL3151642@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/21/20 4:41 PM, Darrick J. Wong wrote:
> On Mon, Jul 20, 2020 at 05:16:02PM -0700, Allison Collins wrote:
>> Invert the rename logic in xfs_attr_node_addname to simplify the
>> delayed attr logic later.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Looks ok, diff is dumb :(
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Yeah, a lot of times a graphical viewer makes this much easier to look 
at.  Thanks for the review!

Allison
> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 125 +++++++++++++++++++++++------------------------
>>   1 file changed, 61 insertions(+), 64 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index ca1e851..e618b09 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1030,80 +1030,77 @@ xfs_attr_node_addname(
>>   			return error;
>>   	}
>>   
>> -	/*
>> -	 * If this is an atomic rename operation, we must "flip" the
>> -	 * incomplete flags on the "new" and "old" attribute/value pairs
>> -	 * so that one disappears and one appears atomically.  Then we
>> -	 * must remove the "old" attribute/value pair.
>> -	 */
>> -	if (args->op_flags & XFS_DA_OP_RENAME) {
>> -		/*
>> -		 * In a separate transaction, set the incomplete flag on the
>> -		 * "old" attr and clear the incomplete flag on the "new" attr.
>> -		 */
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			goto out;
>> +	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>>   		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series
>> +		 * Added a "remote" value, just clear the incomplete flag.
>>   		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -		if (error)
>> -			goto out;
>> +		if (args->rmtblkno > 0)
>> +			error = xfs_attr3_leaf_clearflag(args);
>> +		retval = error;
>> +		goto out;
>> +	}
>>   
>> -		/*
>> -		 * Dismantle the "old" attribute/value pair by removing
>> -		 * a "remote" value (if it exists).
>> -		 */
>> -		xfs_attr_restore_rmt_blk(args);
>> +	/*
>> +	 * If this is an atomic rename operation, we must "flip" the incomplete
>> +	 * flags on the "new" and "old" attribute/value pairs so that one
>> +	 * disappears and one appears atomically.  Then we must remove the "old"
>> +	 * attribute/value pair.
>> +	 *
>> +	 * In a separate transaction, set the incomplete flag on the "old" attr
>> +	 * and clear the incomplete flag on the "new" attr.
>> +	 */
>> +	error = xfs_attr3_leaf_flipflags(args);
>> +	if (error)
>> +		goto out;
>> +	/*
>> +	 * Commit the flag value change and start the next trans in series
>> +	 */
>> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +	if (error)
>> +		goto out;
>>   
>> -		if (args->rmtblkno) {
>> -			error = xfs_attr_rmtval_invalidate(args);
>> -			if (error)
>> -				return error;
>> +	/*
>> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> +	 * (if it exists).
>> +	 */
>> +	xfs_attr_restore_rmt_blk(args);
>>   
>> -			error = xfs_attr_rmtval_remove(args);
>> -			if (error)
>> -				return error;
>> -		}
>> +	if (args->rmtblkno) {
>> +		error = xfs_attr_rmtval_invalidate(args);
>> +		if (error)
>> +			return error;
>>   
>> -		/*
>> -		 * Re-find the "old" attribute entry after any split ops.
>> -		 * The INCOMPLETE flag means that we will find the "old"
>> -		 * attr, not the "new" one.
>> -		 */
>> -		args->attr_filter |= XFS_ATTR_INCOMPLETE;
>> -		state = xfs_da_state_alloc();
>> -		state->args = args;
>> -		state->mp = mp;
>> -		state->inleaf = 0;
>> -		error = xfs_da3_node_lookup_int(state, &retval);
>> +		error = xfs_attr_rmtval_remove(args);
>>   		if (error)
>> -			goto out;
>> +			return error;
>> +	}
>>   
>> -		/*
>> -		 * Remove the name and update the hashvals in the tree.
>> -		 */
>> -		blk = &state->path.blk[ state->path.active-1 ];
>> -		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> -		error = xfs_attr3_leaf_remove(blk->bp, args);
>> -		xfs_da3_fixhashpath(state, &state->path);
>> +	/*
>> +	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>> +	 * flag means that we will find the "old" attr, not the "new" one.
>> +	 */
>> +	args->attr_filter |= XFS_ATTR_INCOMPLETE;
>> +	state = xfs_da_state_alloc();
>> +	state->args = args;
>> +	state->mp = mp;
>> +	state->inleaf = 0;
>> +	error = xfs_da3_node_lookup_int(state, &retval);
>> +	if (error)
>> +		goto out;
>>   
>> -		/*
>> -		 * Check to see if the tree needs to be collapsed.
>> -		 */
>> -		if (retval && (state->path.active > 1)) {
>> -			error = xfs_da3_join(state);
>> -			if (error)
>> -				goto out;
>> -		}
>> +	/*
>> +	 * Remove the name and update the hashvals in the tree.
>> +	 */
>> +	blk = &state->path.blk[state->path.active-1];
>> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> +	error = xfs_attr3_leaf_remove(blk->bp, args);
>> +	xfs_da3_fixhashpath(state, &state->path);
>>   
>> -	} else if (args->rmtblkno > 0) {
>> -		/*
>> -		 * Added a "remote" value, just clear the incomplete flag.
>> -		 */
>> -		error = xfs_attr3_leaf_clearflag(args);
>> +	/*
>> +	 * Check to see if the tree needs to be collapsed.
>> +	 */
>> +	if (retval && (state->path.active > 1)) {
>> +		error = xfs_da3_join(state);
>>   		if (error)
>>   			goto out;
>>   	}
>> -- 
>> 2.7.4
>>
