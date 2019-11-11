Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F07C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 23:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E35521925
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 23:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iz6U7L2S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfKKXel (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 18:34:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58548 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKXel (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 18:34:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABNIwkh110707;
        Mon, 11 Nov 2019 23:34:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/rnEbTzbzcFJ5ojCtqqsoY62Byus9XH8XXUVvmX31wA=;
 b=iz6U7L2ScFBfCvkrlSCzsTOU5aWIywbpTfBicCJ39o8uhpyyFGY3K4kkrZvqLEhRPkA+
 POyxd0AgpYgFoa4xssHuYXMNdqQ93xCtm6lyG0OdHzzkH4RrccQUWeelPvzBZCWTevJ6
 j9vmVTb2eVxfB/poCY6/uedFr4Reg2xu1zoskUV15wWpHrhX1YA+imNpdty3gvyGY8lr
 6CTnW46jvQal7LtcmDaIySFfRT5uH7zlTZStAAscd5RXWa1oGSazFjnbe8cB5bAmRMTn
 Yg+tLjC/sGWbbxHujUihYlZCbWy6iuAH4vaNYKmr0T4m4wFt2yRpYHzo3SV9UBJdruPH Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w5ndq1969-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 23:34:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABNIjHx100456;
        Mon, 11 Nov 2019 23:34:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w67011mbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 23:34:37 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABNYaIY003901;
        Mon, 11 Nov 2019 23:34:36 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 15:34:35 -0800
Subject: Re: [PATCH v4 05/17] xfs: Add xfs_has_attr and subroutines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-6-allison.henderson@oracle.com>
 <20191111174050.GC46312@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <088c755a-23bd-f683-813f-d72ff99b64f4@oracle.com>
Date:   Mon, 11 Nov 2019 16:34:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111174050.GC46312@bfoster>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110199
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/11/19 10:40 AM, Brian Foster wrote:
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
> 
> This mostly looks good to me. Just some small nits..
> 
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
> ...
>> @@ -310,6 +313,34 @@ xfs_attr_set_args(
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
>> +		error = xfs_attr_shortform_hasname(args, NULL, NULL);
>> +	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> +		error = xfs_attr_leaf_hasname(args, &bp);
>> +		if (error != -ENOATTR && error != -EEXIST)
>> +			goto out;
> 
> Hmm.. is this basically an indirect check for whether bp is set? If so,
> I think doing bp = NULL above and:
> 
> 		if (bp)
> 			xfs_trans_brelse(args->trans, bp);
> 
> ... is more straightforward.
> 
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
> ...
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
> 
> The state allocation handling is a little wonky here in the error
> scenario. I think precedent is that if we're returning an unexpected
> error, we should probably just free state directly rather than rely on
> the caller to do so. If the function returns "success" (meaning -EEXIST
> or -ENOATTR), then the caller owns the state memory. It might also make
> sense to NULL init the pointer either at the top of this helper or the
> caller.
> 
>> +
>>   /*========================================================================
>>    * External routines when attribute list size > geo->blksize
>>    *========================================================================*/
> ...
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
> 
> Can we kill retval in this function now? The only use is to assign error
> to it.
> 
>>   		goto out_release;
>>   	}
>> -	if (retval != -EEXIST)
>> -		goto out_release;
>>   
>>   	/*
>>   	 * Get the value, local or "remote"
> ...
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
>> +{
>> +	struct xfs_attr_shortform *sf;
>> +	struct xfs_attr_sf_entry *sfe;
>> +	int			base = sizeof(struct xfs_attr_sf_hdr);
>> +	int			size = 0;
>> +	int			end;
>> +	int			i;
>> +
>> +	base = sizeof(struct xfs_attr_sf_hdr);
> 
> Double init.
> 
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
> 
> Might as well fix up the typedef in the function signature (here and
> below) as well.
> 
> Brian

Sure, all the nits sound reasonable I will update them in the next 
version.  Thanks for the review!

Allison

> 
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
> 
