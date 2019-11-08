Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E30FA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 19:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BD162087E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 19:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fCKl5giP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732575AbfKHTvg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 14:51:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38978 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732515AbfKHTvg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 14:51:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8JmxS0129413
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:51:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=xtn1YyIsE9QjuKza3ylP2NXWvZtswiaNWdNzfWHtL+M=;
 b=fCKl5giPihzT8dAqbYwv+gXGRdfQj76Nvok1ulVLINVpLkKYNfq9Hhs8JC/Kd8G3pQYc
 IB0kkzK5mzVs4hggdzYozYxJ1ypCMnkioTh9fNN1LECx82u/XYsXf43uGXvpQmsdFOd1
 2FNeb4Ba3JgkgJ6qA4ySfpz0TPxWm/gG0pVQ5grYWjyzOeMXrcTLYleVIsmoBOp1cRHU
 nHXsmZame24BTBlJ6yX56XQqQn682/fAB9yNqeax8dfbcKSAADfDKUo7SX3IycpdmwkY
 8w0hYe+e/vcPbmEcLBu8NeYeTFsUjxOYCaH/PVT2NZmMNqBVSr1n2v78c6XddHGTP4HN hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w1fds3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 19:51:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8Jn0pX119610
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:51:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w5cxk9e6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 19:51:32 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8JpVeq032192
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:51:31 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 11:51:30 -0800
Subject: Re: [PATCH v4 05/17] xfs: Add xfs_has_attr and subroutines
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-6-allison.henderson@oracle.com>
 <20191108193246.GW6219@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <76a69ddf-283a-8cbb-ee53-59e737328e9b@oracle.com>
Date:   Fri, 8 Nov 2019 12:51:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108193246.GW6219@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/8/19 12:32 PM, Darrick J. Wong wrote:
> On Wed, Nov 06, 2019 at 06:27:49PM -0700, Allison Collins wrote:
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
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 154 +++++++++++++++++++++++++++---------------
>>   fs/xfs/libxfs/xfs_attr.h      |   1 +
>>   fs/xfs/libxfs/xfs_attr_leaf.c | 107 ++++++++++++++++++-----------
>>   fs/xfs/libxfs/xfs_attr_leaf.h |   2 +
>>   4 files changed, 171 insertions(+), 93 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 5cb83a8..c8a3273 100644
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
>> @@ -310,6 +313,34 @@ xfs_attr_set_args(
>>   }
>>   
>>   /*
>> + * Return EEXIST if attr is found, or ENOATTR if not
>> + */
>> +int
>> +xfs_has_attr(
>> +	struct xfs_da_args      *args)
> 
> I was really hoping for a "replace ENOATTR/EEXIST with a boolean"
> cleanup at the end of this series, though as a straight hoisting and
> refactoring, this patch is ok for leaving the existing error code
> overloading. :)
> 
>> +{
>> +	struct xfs_inode        *dp = args->dp;
>> +	struct xfs_buf		*bp;
>> +	int                     error;
>> +
>> +	if (!xfs_inode_hasattr(dp)) {
>> +		error = -ENOATTR;
>> +	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>> +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> +		error = xfs_attr_shortform_hasname(args, NULL, NULL);
>> +	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> +		error = xfs_attr_leaf_hasname(args, &bp);
>> +		if (error != -ENOATTR && error != -EEXIST)
>> +			goto out;
>> +		xfs_trans_brelse(args->trans, bp);
>> +	} else {
>> +		error = xfs_attr_node_hasname(args, NULL);
>> +	}
>> +out:
>> +	return error;
>> +}
>> +
>> +/*
>>    * Remove the attribute specified in @args.
>>    */
>>   int
>> @@ -580,27 +611,20 @@ STATIC int
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
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> -				    XFS_DABUF_MAP_NOMAPPING, &bp);
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
>> @@ -752,6 +776,24 @@ xfs_attr_leaf_addname(
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
>> +	error = xfs_attr3_leaf_read(args->trans, args->dp, 0,
>> +				    XFS_DABUF_MAP_NOMAPPING, bp);
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
>> @@ -771,13 +813,11 @@ xfs_attr_leaf_removename(
>>   	 * Remove the attribute.
>>   	 */
>>   	dp = args->dp;
>> -	args->blkno = 0;
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> -				    XFS_DABUF_MAP_NOMAPPING, &bp);
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
>> @@ -816,13 +856,10 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>>   
>>   	trace_xfs_attr_leaf_get(args);
>>   
>> -	args->blkno = 0;
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> -				    XFS_DABUF_MAP_NOMAPPING, &bp);
>> -	if (error)
>> +	error = xfs_attr_leaf_hasname(args, &bp);
>> +	if (error != -ENOATTR && error != -EEXIST)
>>   		return error;
>>   
>> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>>   	if (error != -EEXIST)  {
>>   		xfs_trans_brelse(args->trans, bp);
>>   		return error;
>> @@ -832,6 +869,38 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
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
>> +	int			retval, error;
>> +
>> +	state = xfs_da_state_alloc();
>> +	state->args = args;
>> +	state->mp = args->dp->i_mount;
>> +
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
>> @@ -864,20 +933,17 @@ xfs_attr_node_addname(
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
>> +	retval = xfs_attr_node_hasname(args, &state);
>> +	if (retval != -ENOATTR)
>>   		goto out;
>> +
>>   	blk = &state->path.blk[ state->path.active-1 ];
>>   	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> -	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>> +	if (args->name.type & ATTR_REPLACE) {
>>   		goto out;
>>   	} else if (retval == -EEXIST) {
>>   		if (args->name.type & ATTR_CREATE)
>> @@ -1079,29 +1145,15 @@ xfs_attr_node_removename(
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
>> @@ -1324,20 +1376,14 @@ xfs_attr_node_get(xfs_da_args_t *args)
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
>> index 44dd07a..3b5dad4 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -150,6 +150,7 @@ int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
>>   		 unsigned char *value, int valuelen, int flags);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>>   int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
>> +int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>>   int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>   		  int flags, struct attrlist_cursor_kern *cursor);
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 93c3496..d06cfd6 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -655,18 +655,67 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
>>   }
>>   
>>   /*
>> + * Return -EEXIST if attr is found, or -ENOATTR if not
>> + * args:  args containing attribute name and namelen
>> + * sfep:  If not null, pointer will be set to the last attr entry found on
>> +	  -EEXIST.  On -ENOATTR pointer is left at the last entry in the list
>> + * basep: If not null, pointer is set to the byte offset of the entry in the
>> + *	  list on -EEXIST.  On -ENOATTR, pointer is left at the byte offset of
>> + *	  the last entry in the list
>> + */
>> +int
>> +xfs_attr_shortform_hasname(
>> +	struct xfs_da_args	 *args,
>> +	struct xfs_attr_sf_entry **sfep,
>> +	int			 *basep)
> 
> Byte offsets can't be negative, so this should be unsigned int.
> 
> Seeing as we also return the location of the sf entry and byte offset,
> maybe this ought to be called xfs_attr_sf_findname ?

Sure, will fix.

> 
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
>> +}
>> +
>> +/*
>>    * Add a name/value pair to the shortform attribute list.
>>    * Overflow from the inode has already been checked for.
>>    */
>>   void
>>   xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>>   {
>> -	xfs_attr_shortform_t *sf;
>> -	xfs_attr_sf_entry_t *sfe;
>> -	int i, offset, size;
>> -	xfs_mount_t *mp;
>> -	xfs_inode_t *dp;
>> -	struct xfs_ifork *ifp;
>> +	struct xfs_attr_shortform	*sf;
>> +	struct xfs_attr_sf_entry	*sfe;
>> +	int				offset, size, error;
>> +	struct xfs_mount		*mp;
>> +	struct xfs_inode		*dp;
>> +	struct xfs_ifork		*ifp;
>>   
>>   	trace_xfs_attr_sf_add(args);
>>   
>> @@ -677,18 +726,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>>   	ifp = dp->i_afp;
>>   	ASSERT(ifp->if_flags & XFS_IFINLINE);
>>   	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
>> -	sfe = &sf->list[0];
>> -	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
>> -#ifdef DEBUG
>> -		if (sfe->namelen != args->name.len)
>> -			continue;
>> -		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
>> -			continue;
>> -		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
>> -			continue;
>> -		ASSERT(0);
>> -#endif
>> -	}
>> +	error = xfs_attr_shortform_hasname(args, &sfe, NULL);
>> +	ASSERT(error != -EEXIST);
> 
> If this assertion triggers, the fs is corrupt and we need to log
> something and bail out.  5.5 for-next will soon have a new
> XFS_IS_CORRUPT macro that takes care of this, so you can do:
> 
> 	error = xfs_attr_shortform_hasname(args, &sfe, NULL);
> 	if (XFS_IS_CORRUPT(mp, error != -EEXIST))
> 		return -EFSCORRUPTED;
> 
> --D
Ok, I will keep an eye out for that then.  Thanks!
Allison

> 
> 
>>   
>>   	offset = (char *)sfe - (char *)sf;
>>   	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
>> @@ -733,33 +772,23 @@ xfs_attr_fork_remove(
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
>> -	end = sf->hdr.count;
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
>> +	error = xfs_attr_shortform_hasname(args, &sfe, &base);
>> +	if (error != -EEXIST)
>> +		return error;
>> +	size = XFS_ATTR_SF_ENTSIZE(sfe);
>>   
>>   	/*
>>   	 * Fix up the attribute fork data, covering the hole
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
>> index 017480e..e108b37 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
>> @@ -42,6 +42,8 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>>   int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>>   			struct xfs_buf **leaf_bp);
>>   int	xfs_attr_shortform_remove(struct xfs_da_args *args);
>> +int	xfs_attr_shortform_hasname(struct xfs_da_args *args,
>> +			       struct xfs_attr_sf_entry **sfep, int *basep);
>>   int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>>   int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>>   xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
>> -- 
>> 2.7.4
>>
