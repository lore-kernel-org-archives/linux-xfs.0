Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1108CC2BA1A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 22:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9B3820768
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 22:09:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IqGBjwMj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgDFWJ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 18:09:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42634 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgDFWJ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 18:09:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036M9oUG174927;
        Mon, 6 Apr 2020 22:09:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wD/jFT5GcQNjC98gMCruUQzva4nyMSXZo1RtXaVyrJ0=;
 b=IqGBjwMj8iONwBWLb/UhVRWqVNWMqLneZCjMuqNua9ihoUJiGeUpB058RhtPtub0Aa92
 xeo1Aj6Am4uT6MYYZTptR1unGjSF1CtDuNnf70iN7UxgRqaN5PngjeO8TMQxRhwoiRYB
 npZjgrNpJ78Dk4NP4EPKx4Bs2zxwgiBVYgQRMJ3iGKCDmd2cpkjTtVFt1LSsplW31sD2
 HvqfSZAEFHtDiSU5BwA5A9DhAv+8/fdoyRklMVRM7GN8PhX4huA8gC0cH3j2t2mlpmN8
 ClCAaj3UiEapUJf0+WnDafcCqtktlEzcaKvpry2OD3hqRNuHTG0TsTvAfKysFxI/d0LS Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 306j6m9jf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 22:09:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036M7Vwn112972;
        Mon, 6 Apr 2020 22:09:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30741bvyq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 22:09:53 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036M9qXW013758;
        Mon, 6 Apr 2020 22:09:52 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 15:09:52 -0700
Subject: Re: [PATCH v8 01/20] xfs: Add xfs_has_attr and subroutines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-2-allison.henderson@oracle.com>
 <20200406143117.GC20708@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <42a5f0aa-3a50-543e-bfae-79873cfc87e5@oracle.com>
Date:   Mon, 6 Apr 2020 15:09:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200406143117.GC20708@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 suspectscore=2 lowpriorityscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/6/20 7:31 AM, Brian Foster wrote:
> On Fri, Apr 03, 2020 at 03:12:10PM -0700, Allison Collins wrote:
>> This patch adds a new functions to check for the existence of an
>> attribute. Subroutines are also added to handle the cases of leaf
>> blocks, nodes or shortform. Common code that appears in existing attr
>> add and remove functions have been factored out to help reduce the
>> appearance of duplicated code.  We will need these routines later for
>> delayed attributes since delayed operations cannot return error codes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 181 ++++++++++++++++++++++++++++--------------
>>   fs/xfs/libxfs/xfs_attr.h      |   1 +
>>   fs/xfs/libxfs/xfs_attr_leaf.c |  97 +++++++++++++++-------
>>   fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
>>   4 files changed, 191 insertions(+), 91 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index e4fe3dc..2a0d3d3 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -703,21 +749,57 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>>   
>>   	trace_xfs_attr_leaf_get(args);
>>   
>> -	args->blkno = 0;
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
>> -	if (error)
>> -		return error;
>> +	error = xfs_attr_leaf_hasname(args, &bp);
>>   
>> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>>   	if (error != -EEXIST)  {
>>   		xfs_trans_brelse(args->trans, bp);
>>   		return error;
>> -	}
>> +	} else if (error != -EEXIST)
>> +		return error;
>> +
> 
> The if/else above looks busted (the same check for both branches).
Sorry, that one should have been ENOATTR for this branch.  Will fix.

> 
>> +
>>   	error = xfs_attr3_leaf_getvalue(bp, args);
>>   	xfs_trans_brelse(args->trans, bp);
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
>> +		else
>> +			xfs_da_state_free(state);
>> +		return retval;
>> +	}
>> +
>> +	xfs_da_state_free(state);
>> +
> 
> Inverting the logic is a bit more clear IMO:
> 
> 	...
> 	error = xfs_da3_node_lookup_int(state, &retval);
> 	if (error) {
> 		...
> 		return error;
> 	}
> 
> 	if (statep)
> 		...
> 	else
> 		...
> 	return retval;
> }
> 
Sure, will flip.  Thanks for the reviews!

Allison

> With those things addressed:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
>> +	return error;
>> +}
>> +
>>   /*========================================================================
>>    * External routines when attribute list size > geo->blksize
>>    *========================================================================*/
>> @@ -750,17 +832,14 @@ xfs_attr_node_addname(
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
>> +	if (retval != -ENOATTR && retval != -EEXIST)
>>   		goto out;
>> +
>>   	blk = &state->path.blk[ state->path.active-1 ];
>>   	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>   	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
>> @@ -965,29 +1044,15 @@ xfs_attr_node_removename(
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
>> @@ -1082,7 +1147,8 @@ xfs_attr_node_removename(
>>   	error = 0;
>>   
>>   out:
>> -	xfs_da_state_free(state);
>> +	if (state)
>> +		xfs_da_state_free(state);
>>   	return error;
>>   }
>>   
>> @@ -1202,31 +1268,23 @@ xfs_attr_node_get(xfs_da_args_t *args)
>>   {
>>   	xfs_da_state_t *state;
>>   	xfs_da_state_blk_t *blk;
>> -	int error, retval;
>> +	int error;
>>   	int i;
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
>> -		retval = error;
>> -		goto out_release;
>> -	}
>> -	if (retval != -EEXIST)
>> +	error = xfs_attr_node_hasname(args, &state);
>> +	if (error != -EEXIST)
>>   		goto out_release;
>>   
>>   	/*
>>   	 * Get the value, local or "remote"
>>   	 */
>>   	blk = &state->path.blk[state->path.active - 1];
>> -	retval = xfs_attr3_leaf_getvalue(blk->bp, args);
>> +	error = xfs_attr3_leaf_getvalue(blk->bp, args);
>>   
>>   	/*
>>   	 * If not in a transaction, we have to release all the buffers.
>> @@ -1237,8 +1295,9 @@ xfs_attr_node_get(xfs_da_args_t *args)
>>   		state->path.blk[i].bp = NULL;
>>   	}
>>   
>> -	xfs_da_state_free(state);
>> -	return retval;
>> +	if (state)
>> +		xfs_da_state_free(state);
>> +	return error;
>>   }
>>   
>>   /* Returns true if the attribute entry name is valid. */
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 0d2d059..66575b8 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -89,6 +89,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
>>   int xfs_attr_get(struct xfs_da_args *args);
>>   int xfs_attr_set(struct xfs_da_args *args);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>> +int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>>   
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 863444e..9f39e7a 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -664,18 +664,63 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
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
>> +xfs_attr_sf_findname(
>> +	struct xfs_da_args	 *args,
>> +	struct xfs_attr_sf_entry **sfep,
>> +	unsigned int		 *basep)
>> +{
>> +	struct xfs_attr_shortform *sf;
>> +	struct xfs_attr_sf_entry *sfe;
>> +	unsigned int		base = sizeof(struct xfs_attr_sf_hdr);
>> +	int			size = 0;
>> +	int			end;
>> +	int			i;
>> +
>> +	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
>> +	sfe = &sf->list[0];
>> +	end = sf->hdr.count;
>> +	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
>> +			     base += size, i++) {
>> +		size = XFS_ATTR_SF_ENTSIZE(sfe);
>> +		if (!xfs_attr_match(args, sfe->namelen, sfe->nameval,
>> +				    sfe->flags))
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
>> -xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>> +xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff)
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
>> @@ -686,11 +731,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>>   	ifp = dp->i_afp;
>>   	ASSERT(ifp->if_flags & XFS_IFINLINE);
>>   	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
>> -	sfe = &sf->list[0];
>> -	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
>> -		ASSERT(!xfs_attr_match(args, sfe->namelen, sfe->nameval,
>> -			sfe->flags));
>> -	}
>> +	error = xfs_attr_sf_findname(args, &sfe, NULL);
>> +	ASSERT(error != -EEXIST);
>>   
>>   	offset = (char *)sfe - (char *)sf;
>>   	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
>> @@ -733,31 +775,26 @@ xfs_attr_fork_remove(
>>    * Remove an attribute from the shortform attribute list structure.
>>    */
>>   int
>> -xfs_attr_shortform_remove(xfs_da_args_t *args)
>> +xfs_attr_shortform_remove(struct xfs_da_args *args)
>>   {
>> -	xfs_attr_shortform_t *sf;
>> -	xfs_attr_sf_entry_t *sfe;
>> -	int base, size=0, end, totsize, i;
>> -	xfs_mount_t *mp;
>> -	xfs_inode_t *dp;
>> +	struct xfs_attr_shortform	*sf;
>> +	struct xfs_attr_sf_entry	*sfe;
>> +	int				size = 0, end, totsize;
>> +	unsigned int			base;
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
>> -		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
>> -				sfe->flags))
>> -			break;
>> -	}
>> -	if (i == end)
>> -		return -ENOATTR;
>> +
>> +	error = xfs_attr_sf_findname(args, &sfe, &base);
>> +	if (error != -EEXIST)
>> +		return error;
>> +	size = XFS_ATTR_SF_ENTSIZE(sfe);
>>   
>>   	/*
>>   	 * Fix up the attribute fork data, covering the hole
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
>> index 6dd2d93..88ec042 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
>> @@ -52,6 +52,9 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>>   int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>>   			struct xfs_buf **leaf_bp);
>>   int	xfs_attr_shortform_remove(struct xfs_da_args *args);
>> +int	xfs_attr_sf_findname(struct xfs_da_args *args,
>> +			     struct xfs_attr_sf_entry **sfep,
>> +			     unsigned int *basep);
>>   int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>>   int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>>   xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
>> -- 
>> 2.7.4
>>
> 
