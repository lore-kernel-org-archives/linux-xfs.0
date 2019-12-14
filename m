Return-Path: <SRS0=IS9S=2E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C48AC43603
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 06:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6A142465B
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 06:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ECPclrEo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbfLNG6i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Dec 2019 01:58:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59352 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfLNG6h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Dec 2019 01:58:37 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE6tWZJ087935;
        Sat, 14 Dec 2019 06:58:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MICXcSSvLdRaL22z4tzohM0Ud1gHPq/x0HgIyF3SAAM=;
 b=ECPclrEo0vALDXPTmiNc6HBVQobwXW5Pmw0QFQfg4hNP4eMbVohkl4XHM6Q51mftyGz1
 GhvIFX15ZCNMIyogj84OCn8LUkkuoyxUpT0PBv3mIIbYlWx4LwekmQMGlP3dLD/PDkcy
 nWOyha8Si4kcYaGqUK5Y1/91fFMN0yP7bDT2WiGvIo4hj8CK7hblVJcSUzJEBnit2vLd
 zOnjm7Jglxw1mvFaW2skdzG3kJ6Dj5DuJQeoLit2CSBEUBycND8Z11if9b9Nklm5rksX
 oB47kiSK+YnPVrGWAfpdn5cIYwcwVSo+7cn1I+hhluD3aiVJtH0M67Y2cFrlsgvuroE+ IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wvq5u0d8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 06:58:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE6wWCY077564;
        Sat, 14 Dec 2019 06:58:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wvq2pnwhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 06:58:32 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBE6wRsn009816;
        Sat, 14 Dec 2019 06:58:28 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 22:58:27 -0800
Subject: Re: [PATCH v5 04/14] xfs: Add xfs_has_attr and subroutines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-5-allison.henderson@oracle.com>
 <20191213130823.GC43376@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <8c953b06-fa0c-2f17-3a1b-6d7257653197@oracle.com>
Date:   Fri, 13 Dec 2019 23:58:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191213130823.GC43376@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912140050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912140049
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/13/19 6:08 AM, Brian Foster wrote:
> On Wed, Dec 11, 2019 at 09:15:03PM -0700, Allison Collins wrote:
>> From: Allison Henderson <allison.henderson@oracle.com>
>>
>> This patch adds a new functions to check for the existence of
>> an attribute.  Subroutines are also added to handle the cases
>> of leaf blocks, nodes or shortform.  Common code that appears
>> in existing attr add and remove functions have been factored
>> out to help reduce the appearance of duplicated code.  We will
>> need these routines later for delayed attributes since delayed
>> operations cannot return error codes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 166 +++++++++++++++++++++++++++---------------
>>   fs/xfs/libxfs/xfs_attr.h      |   1 +
>>   fs/xfs/libxfs/xfs_attr_leaf.c | 110 +++++++++++++++++-----------
>>   fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
>>   4 files changed, 182 insertions(+), 98 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 9628ed8..88de43c 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -310,6 +313,36 @@ xfs_attr_set_args(
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
>> +		struct xfs_buf	*bp = NULL;
>> +		int		error = xfs_attr_leaf_hasname(args, &bp);
>> +
> 
> I'd prefer to not obfuscate function calls in variable declarations like
> this. I'd say just declare bp and error at the top and let this be:
Sure, this style was a suggestion from Christoph in the last review so I 
tried to combine everyones requests as best as possible.  I'm not very 
particular about the aesthetics, so I don't mind moving things around, 
but if people feel strongly one way or another, please chime in.

> 
> 		error = xfs_attr_leaf_hasname(...)
> 
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
>> @@ -583,26 +616,20 @@ STATIC int
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
> 
> Do we need to call xfs_trans_brelse() in certain cases before we return?
> For example, consider if the read succeeds but the lookup returns
> something other than -ENOATTR or -EEXIST. Perhaps the _hasname() func
> should just call brelse() itself if it's returning an unexpected error
> after reading in the buf so the caller doesn't need to care about it..
Generally it should be released at some point if the call is successful 
(so on -EEXIST).  Later when we get into the state machine, we don't 
release right away, because we need to hold it across the transaction rolls.

I think though I might be able to factor up releasing the buffer on 
error though.  I'll see if I can work that into the next version.

> 
>>   	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>>   		xfs_trans_brelse(args->trans, bp);
>>   		return retval;
> ...
>> @@ -864,20 +940,17 @@ xfs_attr_node_addname(
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
> 
> The else case below checks for -EEXIST, but it looks like we'd return
> here..
> 
> Brian

Ok, will clean out.  Thx!
Allison

> 
>> +
>>   	blk = &state->path.blk[ state->path.active-1 ];
>>   	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> -	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>> +	if (args->name.type & ATTR_REPLACE) {
>>   		goto out;
>>   	} else if (retval == -EEXIST) {
>>   		if (args->name.type & ATTR_CREATE)
>> @@ -1079,29 +1152,15 @@ xfs_attr_node_removename(
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
>> @@ -1196,7 +1255,8 @@ xfs_attr_node_removename(
>>   	error = 0;
>>   
>>   out:
>> -	xfs_da_state_free(state);
>> +	if (state)
>> +		xfs_da_state_free(state);
>>   	return error;
>>   }
>>   
>> @@ -1316,31 +1376,23 @@ xfs_attr_node_get(xfs_da_args_t *args)
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
>> @@ -1352,7 +1404,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
>>   	}
>>   
>>   	xfs_da_state_free(state);
>> -	return retval;
>> +	return error;
>>   }
>>   
>>   /* Returns true if the attribute entry name is valid. */
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
>> index 5465446..ef96971 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -654,18 +654,66 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
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
>> @@ -676,18 +724,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
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
>> +	error = xfs_attr_sf_findname(args, &sfe, NULL);
>> +	ASSERT(error != -EEXIST);
>>   
>>   	offset = (char *)sfe - (char *)sf;
>>   	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
>> @@ -730,35 +768,25 @@ xfs_attr_fork_remove(
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
>> +	error = xfs_attr_sf_findname(args, &sfe, &base);
>> +	if (error != -EEXIST)
>> +		return error;
>> +	size = XFS_ATTR_SF_ENTSIZE(sfe);
>>   
>>   	/*
>>   	 * Fix up the attribute fork data, covering the hole
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
>> index f4a188e..f6165ff 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
>> @@ -62,6 +62,9 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
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
