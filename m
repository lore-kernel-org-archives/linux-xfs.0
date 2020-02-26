Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2DFAC4BA06
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 02:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DE9921744
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 02:18:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eK2VbXlD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgBZCSx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 21:18:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51570 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbgBZCSx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 21:18:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q2DOdO028009;
        Wed, 26 Feb 2020 02:18:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CUvYyQUVmppzgQ4Od1Lo8eXTCIhOPd+HjerzcpPugzE=;
 b=eK2VbXlD1Eht8neu5HLeTAMnIgJ8q+Hd2dOK/bKe6vOrBQJKqEwycVB9g1rWFgWuPjbQ
 hr1T57BwbM/yp03SQ2Q1gUVgOuKfS72vu2xI+SBoqdmDPNrjiawnKPN80oYKkNckegnq
 LaBfJ4+Kj9l6oyrhvzJB7UxqPbWld/NbCP2QPHQfHKYxuxculw55cY2UxqdZkTe/DrO1
 k8vHgYYwLze/LEmWpTVKHB+XzipUyEKctkM3vvMvRVwZ5mpsLtV589LouxyjbdY157Ok
 4cJ92yCbprgr9NrR3ewWH82e9a9BRRjez5yMk/9jhII0pdu1qgMzGuLQREs5xJd0Z5H3 Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ydcsn8jw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 02:18:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q2EoRj020537;
        Wed, 26 Feb 2020 02:18:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ydcs2p57a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 02:18:49 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01Q2ImcA022352;
        Wed, 26 Feb 2020 02:18:48 GMT
Received: from [192.168.1.9] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 18:18:48 -0800
Subject: Re: [PATCH v7 03/19] xfs: Add xfs_has_attr and subroutines
To:     Chandan Rajendra <chandan@linux.ibm.com>, linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-4-allison.henderson@oracle.com>
 <121751246.BNr9PkcSxa@localhost.localdomain>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <79008624-4d96-cf92-7764-7bd96941e123@oracle.com>
Date:   Tue, 25 Feb 2020 19:18:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <121751246.BNr9PkcSxa@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/20 2:49 AM, Chandan Rajendra wrote:
> On Sunday, February 23, 2020 7:35 AM Allison Collins wrote:
>> From: Allison Henderson <allison.henderson@oracle.com>
>>
>> This patch adds a new functions to check for the existence of an attribute.
>> Subroutines are also added to handle the cases of leaf blocks, nodes or shortform.
>> Common code that appears in existing attr add and remove functions have been
>> factored out to help reduce the appearance of duplicated code.  We will need these
>> routines later for delayed attributes since delayed operations cannot return error
>> codes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 171 ++++++++++++++++++++++++++++--------------
>>   fs/xfs/libxfs/xfs_attr.h      |   1 +
>>   fs/xfs/libxfs/xfs_attr_leaf.c | 111 +++++++++++++++++----------
>>   fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
>>   4 files changed, 188 insertions(+), 98 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 9acdb23..2255060 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -46,6 +46,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>   
>>   /*
>>    * Internal routines when attribute list is more than one block.
>> @@ -53,6 +54,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>> +				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>>   
>> @@ -310,6 +313,37 @@ xfs_attr_set_args(
>>   }
>>   
>>   /*
>> + * Return EEXIST if attr is found, or ENOATTR if not
>> + */
>> +int
>> +xfs_has_attr(
>> +	struct xfs_da_args      *args)
>> +{
>> +	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_buf		*bp = NULL;
>> +	int			error;
>> +
>> +	if (!xfs_inode_hasattr(dp))
>> +		return -ENOATTR;
>> +
>> +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>> +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> +		return xfs_attr_sf_findname(args, NULL, NULL);
>> +	}
>> +
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> +		error = xfs_attr_leaf_hasname(args, &bp);
>> +
>> +		if (bp)
>> +			xfs_trans_brelse(args->trans, bp);
>> +
>> +		return error;
>> +	}
>> +
>> +	return xfs_attr_node_hasname(args, NULL);
>> +}
>> +
>> +/*
>>    * Remove the attribute specified in @args.
>>    */
>>   int
>> @@ -583,26 +617,20 @@ STATIC int
>>   xfs_attr_leaf_addname(
>>   	struct xfs_da_args	*args)
>>   {
>> -	struct xfs_inode	*dp;
>>   	struct xfs_buf		*bp;
>>   	int			retval, error, forkoff;
>> +	struct xfs_inode	*dp = args->dp;
>>   
>>   	trace_xfs_attr_leaf_addname(args);
>>   
>>   	/*
>> -	 * Read the (only) block in the attribute list in.
>> -	 */
>> -	dp = args->dp;
>> -	args->blkno = 0;
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>>   	 * Look up the given attribute in the leaf block.  Figure out if
>>   	 * the given flags produce an error or call for an atomic rename.
>>   	 */
>> -	retval = xfs_attr3_leaf_lookup_int(bp, args);
>> +	retval = xfs_attr_leaf_hasname(args, &bp);
>> +	if (retval != -ENOATTR && retval != -EEXIST)
>> +		return retval;
>> +
>>   	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>>   		xfs_trans_brelse(args->trans, bp);
>>   		return retval;
>> @@ -754,6 +782,27 @@ xfs_attr_leaf_addname(
>>   }
>>   
>>   /*
>> + * Return EEXIST if attr is found, or ENOATTR if not
>> + */
>> +STATIC int
>> +xfs_attr_leaf_hasname(
>> +	struct xfs_da_args      *args,
>> +	struct xfs_buf		**bp)
>> +{
>> +	int                     error = 0;
>> +
>> +	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, bp);
>> +	if (error)
>> +		return error;
>> +
>> +	error = xfs_attr3_leaf_lookup_int(*bp, args);
>> +	if (error != -ENOATTR && error != -EEXIST)
>> +		xfs_trans_brelse(args->trans, *bp);
>> +
>> +	return error;
>> +}
>> +
>> +/*
>>    * Remove a name from the leaf attribute list structure
>>    *
>>    * This leaf block cannot have a "remote" value, we only call this routine
>> @@ -773,12 +822,11 @@ xfs_attr_leaf_removename(
>>   	 * Remove the attribute.
>>   	 */
>>   	dp = args->dp;
>> -	args->blkno = 0;
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
>> -	if (error)
>> +
>> +	error = xfs_attr_leaf_hasname(args, &bp);
>> +	if (error != -ENOATTR && error != -EEXIST)
>>   		return error;
>>   
>> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>>   	if (error == -ENOATTR) {
>>   		xfs_trans_brelse(args->trans, bp);
>>   		return error;
>> @@ -817,12 +865,10 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>>   
>>   	trace_xfs_attr_leaf_get(args);
>>   
>> -	args->blkno = 0;
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
>> -	if (error)
>> +	error = xfs_attr_leaf_hasname(args, &bp);
>> +	if (error != -ENOATTR && error != -EEXIST)
>>   		return error;
>>   
>> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>>   	if (error != -EEXIST)  {
>>   		xfs_trans_brelse(args->trans, bp);
>>   		return error;
>> @@ -832,6 +878,41 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>>   	return error;
>>   }
>>   
>> +/*
>> + * Return EEXIST if attr is found, or ENOATTR if not
>> + * statep: If not null is set to point at the found state.  Caller will
>> + *         be responsible for freeing the state in this case.
>> + */
>> +STATIC int
>> +xfs_attr_node_hasname(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	**statep)
>> +{
>> +	struct xfs_da_state	*state;
>> +	int			retval, error;
>> +
>> +	state = xfs_da_state_alloc();
>> +	state->args = args;
>> +	state->mp = args->dp->i_mount;
>> +
>> +	if (statep != NULL)
>> +		*statep = NULL;
>> +
>> +	/*
>> +	 * Search to see if name exists, and get back a pointer to it.
>> +	 */
>> +	error = xfs_da3_node_lookup_int(state, &retval);
>> +	if (error == 0) {
>> +		if (statep != NULL)
>> +			*statep = state;
>> +		return retval;
>> +	}
> 
> If 'statep' were NULL, then this would leak the memory pointed to by 'state'
> right?
> 
Another reviewer caught this too.  Will update!  :-)

Thanks!
Allison
