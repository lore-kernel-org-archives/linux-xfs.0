Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEBCC3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 23:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5444821920
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 23:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OrNrc540"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394349AbfISXvV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 19:51:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36856 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394340AbfISXvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 19:51:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JNmwJ4113261;
        Thu, 19 Sep 2019 23:51:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Wwm8045w5EsR3dGX1dUmzZ/UGNxc1IuRmbuK4l2AcBQ=;
 b=OrNrc540JCGH0E3oYklswTVjZ6eo2gZmNAyay6GAki+XPZv+xCBNrbeGCeQAoFr/PH1Q
 iOfzBBCIKZAu76bboJU1ELDJwz5KB0XArWOeBqVZXyyT2iNe1G5QWPoipA4mT+CrbtQn
 tmVWYB/QHxCeVLOeozBzEC1nPjRF0NCqlbtm8DHPgGFCKVwSnp8bpQkhitbY0JP/ePf1
 l+0Lao+Ho32Ee3VH+/8yAazMTz1UHdxZLgxLUMiyAZkDQjtYYWLHBcCrwqrlFWohZU7h
 5pVYMi1M19qgejEoUt1hgzwjecxeG0Y6VoeBf4rEKtSwHrqGrpOQb4qOMI5eNdu92rhm fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v3vb4q249-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 23:51:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JNhvtT091141;
        Thu, 19 Sep 2019 23:51:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v3vb6xmpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 23:51:05 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8JNp3Nt000399;
        Thu, 19 Sep 2019 23:51:04 GMT
Received: from [192.168.1.9] (/67.1.21.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 16:51:03 -0700
Subject: Re: [PATCH v3 04/19] xfs: Add xfs_has_attr and subroutines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-5-allison.henderson@oracle.com>
 <20190919174744.GH35460@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <de154abf-b2a9-af27-6f1b-e67f19860e62@oracle.com>
Date:   Thu, 19 Sep 2019 16:51:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919174744.GH35460@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9385 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909190203
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9385 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909190204
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/19/19 10:47 AM, Brian Foster wrote:
> On Thu, Sep 05, 2019 at 03:18:22PM -0700, Allison Collins wrote:
>> From: Allison Henderson <allison.henderson@oracle.com>
>>
>> This patch adds a new functions to check for the existence of
>> an attribute.  Subroutines are also added to handle the cases
>> of leaf blocks, nodes or shortform.  Common code that appears
>> in existing attr add and remove functions have been factored
>> out to help reduce the appearence of duplicated code.  We will
>> need these routines later for delayed attributes since delayed
>> operations cannot return error codes.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Extra s-o-b tag?
Oops, I thought I had caught all the old names.  Will clean out :-)

> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 150 +++++++++++++++++++++++++++---------------
>>   fs/xfs/libxfs/xfs_attr.h      |   1 +
>>   fs/xfs/libxfs/xfs_attr_leaf.c |  92 +++++++++++++++++---------
>>   fs/xfs/libxfs/xfs_attr_leaf.h |   2 +
>>   4 files changed, 161 insertions(+), 84 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 50e099f..a297857 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -46,6 +46,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>> +STATIC int xfs_leaf_has_attr(struct xfs_da_args *args, struct xfs_buf **bp);
>>   
> 
> The fact that this is not named xfs_attr_leaf_*() kind of stands out
> here, particularly since the node variant uses the xfs_attr_* prefix.
> Hm? (Same goes for xfs_shortform_has_attr() I suppose..).
Sure, I can flip the prefixes around to look a little more consistent
> 
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
>> @@ -309,6 +312,32 @@ xfs_attr_set_args(
>>   }
>>   
>>   /*
>> + * Return EEXIST if attr is found, or ENOATTR if not
>> + */
>> +int
>> +xfs_has_attr(
>> +	struct xfs_da_args      *args)
>> +{
>> +	struct xfs_inode        *dp = args->dp;
>> +	struct xfs_buf		*bp;
>> +	int                     error;
>> +
>> +	if (!xfs_inode_hasattr(dp)) {
>> +		error = -ENOATTR;
>> +	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>> +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> +		error = xfs_shortform_has_attr(args, NULL, NULL);
>> +	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> +		error = xfs_leaf_has_attr(args, &bp);
>> +		xfs_trans_brelse(args->trans, bp);
>> +	} else {
>> +		error = xfs_attr_node_hasname(args, NULL);
>> +	}
>> +
>> +	return error;
>> +}
>> +
> 
> FWIW, I think it's preferable to include new functions like this with
> the first user. I'm a bit curious about the use of error codes here as
> opposed to returning a boolean. I could see being able to handle
> unexpected errors as a good reason for doing that, but taking a quick
> look ahead, it appears neither caller of xfs_has_attr() does so. ;)
> 
> (To be clear, I think keeping the function as is and fixing up the
> eventual callers to handle unexpected errors is probably the right thing
> to do.).

The new top level function actually doesnt get used until patch 18, but 
I guess I try to keep the patch sizes small to make them easier for 
people to review.  Basically we use it to see if there is/isnt an 
attribute present, and then return the appropriate error code right 
away.  IE, trying to remove an attribute that isnt there immediately 
return EENOATTR rather than trying to start a delayed operation that 
isnt going to be successful.  The is because delayed operations are not 
supposed to return error codes.  If they do, they cause a shut down, 
which is not correct here.

Initially I think I had it returning booleans, but it means the top 
level function needs to do extra handling to translate the error codes, 
and I thought it looked messy.  So I decided to stick with the scheme 
that the rest of the code was using.

I skipped ahead about unexpected error codes and see what you mean, so I 
will add some extra handlers there.

> 
>> +/*
>>    * Remove the attribute specified in @args.
>>    */
>>   int
>> @@ -574,26 +603,17 @@ STATIC int
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
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
>> -	if (error)
>> -		return error;
>> -
> 
> It looks like we lose this unexpected error check here (i.e. suppose we
> got -ENOMEM or -EFSCORRUPTED or something that indicates we shouldn't
> continue). FWIW, this seems to repeat throughout this patch where we've
> invoked the new helpers..

Ok, I'll add in an explicit check for (retval != -ENOATTR && retval != 
-EEXIST)


> 
>> -	/*
>>   	 * Look up the given attribute in the leaf block.  Figure out if
>>   	 * the given flags produce an error or call for an atomic rename.
>>   	 */
>> -	retval = xfs_attr3_leaf_lookup_int(bp, args);
>> +	retval = xfs_leaf_has_attr(args, &bp);
>>   	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>>   		xfs_trans_brelse(args->trans, bp);
>>   		return retval;
>> @@ -745,6 +765,25 @@ xfs_attr_leaf_addname(
>>   }
>>   
>>   /*
>> + * Return EEXIST if attr is found, or ENOATTR if not
>> + */
>> +STATIC int
>> +xfs_leaf_has_attr(
>> +	struct xfs_da_args      *args,
>> +	struct xfs_buf		**bp)
>> +{
>> +	int                     error = 0;
>> +
>> +	args->blkno = 0;
> 
> This seems misplaced for a helper, but I could be missing context.  Why
> not just pass zero directly and leave the args->blkno assignment to the
> caller?
I guess just I kept these two lines together since that's was how they 
initially appeared before factoring them out, but it does look a bit 
off.  It should be ok leave the assignment to the caller.  I can push it 
back up.

> 
>> +	error = xfs_attr3_leaf_read(args->trans, args->dp,
>> +			args->blkno, XFS_DABUF_MAP_NOMAPPING, bp);
>> +	if (error)
>> +		return error;
>> +
>> +	return xfs_attr3_leaf_lookup_int(*bp, args);
>> +}
>> +
>> +/*
>>    * Remove a name from the leaf attribute list structure
>>    *
>>    * This leaf block cannot have a "remote" value, we only call this routine
>> @@ -764,12 +803,8 @@ xfs_attr_leaf_removename(
>>   	 * Remove the attribute.
>>   	 */
>>   	dp = args->dp;
>> -	args->blkno = 0;
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
>> -	if (error)
>> -		return error;
> 
> Lost error check.
> 
>>   
>> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>> +	error = xfs_leaf_has_attr(args, &bp);
>>   	if (error == -ENOATTR) {
>>   		xfs_trans_brelse(args->trans, bp);
>>   		return error;
>> @@ -808,12 +843,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>>   
>>   	trace_xfs_attr_leaf_get(args);
>>   
>> -	args->blkno = 0;
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
>> -	if (error)
>> -		return error;
>> -
> 
> ^ here too. Not sure if I caught them all, but you get the idea. ;)
Ok,I'll sweep through and find them :-)

> 
>> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>> +	error = xfs_leaf_has_attr(args, &bp);
>>   	if (error != -EEXIST)  {
>>   		xfs_trans_brelse(args->trans, bp);
>>   		return error;
>> @@ -823,6 +853,43 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>>   	return error;
>>   }
>>   
>> +/*
>> + * Return EEXIST if attr is found, or ENOATTR if not
>> + * statep: If not null is set to point at the found state.  Caller will
>> + * 	   be responsible for freeing the state in this case.
>> + */
>> +STATIC int
>> +xfs_attr_node_hasname(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	**statep)
>> +{
>> +	struct xfs_da_state	*state;
>> +	struct xfs_inode	*dp;
>> +	int			retval, error;
>> +
>> +	/*
>> +	 * Tie a string around our finger to remind us where we are.
>> +	 */
>> +	dp = args->dp;
>> +	state = xfs_da_state_alloc();
>> +	state->args = args;
>> +	state->mp = dp->i_mount;
>> +
> 
> No real need for the dp local variable here if it's just to reference
> ->i_mount. Also I know that comment isn't introduced by this patch, but
> any idea what it actually means? It doesn't make much sense to me at a
> glance. :P

Ok, will clean out assignment.  I'm actually not sure as to the comments 
origins either, I assumed it was in reference the the state?  I suppose 
state is used to keep track of a lot of things going on in the calling 
function.  But even in that context, I don't find the comment 
particularly descriptive.  Should I clean it out?

> 
>> +	/*
>> +	 * Search to see if name exists, and get back a pointer to it.
>> +	 */
>> +	error = xfs_da3_node_lookup_int(state, &retval);
>> +	if (error == 0)
>> +		error = retval;
>> +
>> +	if (statep != NULL)
>> +		*statep = state;
>> +	else
>> +		xfs_da_state_free(state);
>> +
>> +	return error;
>> +}
>> +
>>   /*========================================================================
>>    * External routines when attribute list size > geo->blksize
>>    *========================================================================*/
>> @@ -855,17 +922,14 @@ xfs_attr_node_addname(
>>   	dp = args->dp;
>>   	mp = dp->i_mount;
>>   restart:
>> -	state = xfs_da_state_alloc();
>> -	state->args = args;
>> -	state->mp = mp;
>> -
>>   	/*
>>   	 * Search to see if name already exists, and get back a pointer
>>   	 * to where it should go.
>>   	 */
>> -	error = xfs_da3_node_lookup_int(state, &retval);
>> -	if (error)
> 
> Error check again.
> 
>> +	error = xfs_attr_node_hasname(args, &state);
>> +	if (error == -EEXIST)
>>   		goto out;
>> +
>>   	blk = &state->path.blk[ state->path.active-1 ];
>>   	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>   	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>> @@ -1070,29 +1134,15 @@ xfs_attr_node_removename(
>>   {
>>   	struct xfs_da_state	*state;
>>   	struct xfs_da_state_blk	*blk;
>> -	struct xfs_inode	*dp;
>>   	struct xfs_buf		*bp;
>>   	int			retval, error, forkoff;
>> +	struct xfs_inode	*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>>   
>> -	/*
>> -	 * Tie a string around our finger to remind us where we are.
>> -	 */
>> -	dp = args->dp;
>> -	state = xfs_da_state_alloc();
>> -	state->args = args;
>> -	state->mp = dp->i_mount;
>> -
>> -	/*
>> -	 * Search to see if name exists, and get back a pointer to it.
>> -	 */
>> -	error = xfs_da3_node_lookup_int(state, &retval);
>> -	if (error || (retval != -EEXIST)) {
>> -		if (error == 0)
>> -			error = retval;
>> +	error = xfs_attr_node_hasname(args, &state);
>> +	if (error != -EEXIST)
>>   		goto out;
>> -	}
>>   
>>   	/*
>>   	 * If there is an out-of-line value, de-allocate the blocks.
>> @@ -1314,20 +1364,14 @@ xfs_attr_node_get(xfs_da_args_t *args)
>>   
>>   	trace_xfs_attr_node_get(args);
>>   
>> -	state = xfs_da_state_alloc();
>> -	state->args = args;
>> -	state->mp = args->dp->i_mount;
>> -
>>   	/*
>>   	 * Search to see if name exists, and get back a pointer to it.
>>   	 */
>> -	error = xfs_da3_node_lookup_int(state, &retval);
>> -	if (error) {
>> +	error = xfs_attr_node_hasname(args, &state);
>> +	if (error != -EEXIST) {
>>   		retval = error;
>>   		goto out_release;
>>   	}
>> -	if (retval != -EEXIST)
>> -		goto out_release;
>>   
>>   	/*
>>   	 * Get the value, local or "remote"
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index cedb4e2..fb56d81 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -150,6 +150,7 @@ int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
>>   		 unsigned char *value, int valuelen);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>>   int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name);
>> +int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>>   int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>   		  int flags, struct attrlist_cursor_kern *cursor);
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 07ce320..a501538 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -590,6 +590,53 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
>>   }
>>   
>>   /*
>> + * Return EEXIST if attr is found, or ENOATTR if not
>> + * args:  args containing attribute name and namelen
>> + * sfep:  If not null, pointer will be set to the last attr entry found
>> + * basep: If not null, pointer is set to the byte offset of the entry in the
>> + *	  list
>> + */
>> +int
>> +xfs_shortform_has_attr(
>> +	struct xfs_da_args	 *args,
>> +	struct xfs_attr_sf_entry **sfep,
>> +	int			 *basep)
>> +{
>> +	struct xfs_attr_shortform *sf;
>> +	struct xfs_attr_sf_entry *sfe;
>> +	int			base = sizeof(struct xfs_attr_sf_hdr);
>> +	int			size = 0;
>> +	int			end;
>> +	int			i;
>> +
>> +	base = sizeof(struct xfs_attr_sf_hdr);
>> +	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
>> +	sfe = &sf->list[0];
>> +	end = sf->hdr.count;
>> +	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
>> +			base += size, i++) {
>> +		size = XFS_ATTR_SF_ENTSIZE(sfe);
>> +		if (sfe->namelen != args->name.len)
>> +			continue;
>> +		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
>> +			continue;
>> +		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
>> +			continue;
>> +		break;
>> +	}
>> +
>> +	if (sfep != NULL)
>> +		*sfep = sfe;
>> +
>> +	if (basep != NULL)
>> +		*basep = base;
>> +
>> +	if (i == end)
>> +		return -ENOATTR;
>> +	return -EEXIST;
> 
> This function seems like it could just return a bool. Eh, I suppose it's
> better to be consistent with the other variants if those ones can return
> unrelated errors.
Ok, I prefer the consistency as well.

> 
>> +}
>> +
>> +/*
>>    * Add a name/value pair to the shortform attribute list.
>>    * Overflow from the inode has already been checked for.
>>    */
>> @@ -598,7 +645,7 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>>   {
>>   	xfs_attr_shortform_t *sf;
>>   	xfs_attr_sf_entry_t *sfe;
>> -	int i, offset, size;
>> +	int offset, size, error;
>>   	xfs_mount_t *mp;
>>   	xfs_inode_t *dp;
> 
> Nit: might be good to clean up the typedefs here since you do it in the
> remove function as well.
Sure, will do.

> 
>>   	struct xfs_ifork *ifp;
>> @@ -612,18 +659,10 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>>   	ifp = dp->i_afp;
>>   	ASSERT(ifp->if_flags & XFS_IFINLINE);
>>   	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
>> -	sfe = &sf->list[0];
>> -	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
>> +	error = xfs_shortform_has_attr(args, &sfe, NULL);
>>   #ifdef DEBUG
>> -		if (sfe->namelen != args->name.len)
>> -			continue;
>> -		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
>> -			continue;
>> -		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
>> -			continue;
>> -		ASSERT(0);
>> +	ASSERT(error != -EEXIST);
>>   #endif
> 
> Hmm, interesting. So basically this code walks to the end of the list
> for the purpose of placement of the new attr and the debug code simply
> asserts that we don't find an existing attr. The only thing that
> concerns me is that nothing about xfs_shortform_has_attr() indicates
> that the output values are important when the lookup fails. The comment
> only explains what the values are when a lookup succeeds. Could we
> update the comment to elaborate on this use case to prevent somebody
> from unknowingly breaking it down the road?
> 
> Also, there's no need for the #ifdef DEBUG any more with just the assert
> check in that block.

Sure, I will clearify the comments and pull out the DEBUG

> 
>> -	}
>>   
>>   	offset = (char *)sfe - (char *)sf;
>>   	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
>> @@ -668,33 +707,24 @@ xfs_attr_fork_remove(
>>   int
>>   xfs_attr_shortform_remove(xfs_da_args_t *args)
>>   {
>> -	xfs_attr_shortform_t *sf;
>> -	xfs_attr_sf_entry_t *sfe;
>> -	int base, size=0, end, totsize, i;
>> -	xfs_mount_t *mp;
>> -	xfs_inode_t *dp;
>> +	struct xfs_attr_shortform	*sf;
>> +	struct xfs_attr_sf_entry	*sfe;
>> +	int				base, size = 0, end, totsize;
>> +	struct xfs_mount		*mp;
>> +	struct xfs_inode		*dp;
>> +	int				error;
>>   
>>   	trace_xfs_attr_sf_remove(args);
>>   
>>   	dp = args->dp;
>>   	mp = dp->i_mount;
>> -	base = sizeof(xfs_attr_sf_hdr_t);
>>   	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
>> -	sfe = &sf->list[0];
>>   	end = sf->hdr.count;
> 
> This value of end is unused (end is immediately reassigned further down
> in the function).
> 
> Brian

Ok, I will pick that out. Thank you for the thorough reviews!

Allison

> 
>> -	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
>> -					base += size, i++) {
>> -		size = XFS_ATTR_SF_ENTSIZE(sfe);
>> -		if (sfe->namelen != args->name.len)
>> -			continue;
>> -		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
>> -			continue;
>> -		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
>> -			continue;
>> -		break;
>> -	}
>> -	if (i == end)
>> -		return -ENOATTR;
>> +
>> +	error = xfs_shortform_has_attr(args, &sfe, &base);
>> +	if (error == -ENOATTR)
>> +		return error;
>> +	size = XFS_ATTR_SF_ENTSIZE(sfe);
>>   
>>   	/*
>>   	 * Fix up the attribute fork data, covering the hole
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
>> index 536a290..58e9327 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
>> @@ -42,6 +42,8 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>>   int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>>   			struct xfs_buf **leaf_bp);
>>   int	xfs_attr_shortform_remove(struct xfs_da_args *args);
>> +int	xfs_shortform_has_attr(struct xfs_da_args *args,
>> +			       struct xfs_attr_sf_entry **sfep, int *basep);
>>   int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>>   int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>>   xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
>> -- 
>> 2.7.4
>>
