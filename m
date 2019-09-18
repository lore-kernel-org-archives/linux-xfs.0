Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AF3C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 19:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9BBD20578
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 19:55:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mje5UBtQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbfIRTz6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 15:55:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46838 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731909AbfIRTz6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 15:55:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IJs2TZ016977;
        Wed, 18 Sep 2019 19:55:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=OS1ErQnrBDEDhYIOZLJiS88X41xmVzKmrgzPHhlLVRg=;
 b=Mje5UBtQGoU/LZXJBcsuKEKodBsnRzzW0AC33cyAHLZHzl8ZD39WIFmibuKvHeU5YAhY
 VyUKeE24saBKDgHFEllz1tsBxIRvf5htAUiHjjqParu96KfFdCxwUX0eauFmAY3HxI35
 SXW8gI0Qpeb6IzyrKlzcWCZ4DR0YwnOJnkiv+aStuduXFjDwK7ocvnBQRSPWNMsceZR+
 feu3PZQ+wXpmejRKBPcBCsNZ6+bL+1+Nbq1nTZP1zh+QqtzTDezWU+OsbP7+uxM9BETU
 HAm7bVBT41kbay6hFPQw/B2NIjUYeA3bUSj4xU4K1Enf1MJl2CK9pWzSKCU4T8hsIEo2 CA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v385dx66s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 19:55:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IJrkWm188291;
        Wed, 18 Sep 2019 19:55:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v37mb6rcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 19:55:39 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8IJtcjZ014394;
        Wed, 18 Sep 2019 19:55:38 GMT
Received: from [192.168.1.9] (/67.1.21.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 12:55:38 -0700
Subject: Re: [PATCH v3 02/19] xfs: Embed struct xfs_name in xfs_da_args
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-3-allison.henderson@oracle.com>
 <20190918164408.GF29377@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <550640de-2dfc-33f1-f40a-0e878e64d7d4@oracle.com>
Date:   Wed, 18 Sep 2019 12:55:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918164408.GF29377@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 9/18/19 9:44 AM, Brian Foster wrote:
> On Thu, Sep 05, 2019 at 03:18:20PM -0700, Allison Collins wrote:
>> This patch embeds an xfs_name in xfs_da_args, replacing the name,
>> namelen, and flags members.  This helps to clean up the xfs_da_args
>> structure and make it more uniform with the new xfs_name parameter
>> being passed around.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        |  34 ++++++-------
>>   fs/xfs/libxfs/xfs_attr_leaf.c   | 106 +++++++++++++++++++++-------------------
>>   fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
>>   fs/xfs/libxfs/xfs_da_btree.c    |   5 +-
>>   fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
>>   fs/xfs/libxfs/xfs_dir2.c        |  22 ++++-----
>>   fs/xfs/libxfs/xfs_dir2_block.c  |   6 +--
>>   fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +--
>>   fs/xfs/libxfs/xfs_dir2_node.c   |   8 +--
>>   fs/xfs/libxfs/xfs_dir2_sf.c     |  30 ++++++------
>>   fs/xfs/scrub/attr.c             |  12 ++---
>>   fs/xfs/xfs_trace.h              |  20 ++++----
>>   12 files changed, 130 insertions(+), 125 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index d0308d6..50e099f 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -71,13 +71,13 @@ xfs_attr_args_init(
>>   	args->geo = dp->i_mount->m_attr_geo;
>>   	args->whichfork = XFS_ATTR_FORK;
>>   	args->dp = dp;
>> -	args->flags = name->type;
>> -	args->name = name->name;
>> -	args->namelen = name->len;
>> -	if (args->namelen >= MAXNAMELEN)
>> +	args->name.type = name->type;
>> +	args->name.name = name->name;
>> +	args->name.len = name->len;
> 
> Looks like this could be a struct copy:
> 
> 	args->name = *name;
> 
>> +	if (args->name.len >= MAXNAMELEN)
>>   		return -EFAULT;		/* match IRIX behaviour */
>>   
>> -	args->hashval = xfs_da_hashname(args->name, args->namelen);
>> +	args->hashval = xfs_da_hashname(args->name.name, args->name.len);
>>   	return 0;
>>   }
>>   
> ...
>> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
>> index 867c5de..e8d6721 100644
>> --- a/fs/xfs/libxfs/xfs_dir2.c
>> +++ b/fs/xfs/libxfs/xfs_dir2.c
> ...
>> @@ -259,8 +259,8 @@ xfs_dir_createname(
>>   		return -ENOMEM;
>>   
>>   	args->geo = dp->i_mount->m_dir_geo;
>> -	args->name = name->name;
>> -	args->namelen = name->len;
>> +	args->name.name = name->name;
>> +	args->name.len = name->len;
>>   	args->filetype = name->type;
>>   	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
>>   	args->inumber = inum;
>> @@ -355,8 +355,8 @@ xfs_dir_lookup(
>>   	 */
>>   	args = kmem_zalloc(sizeof(*args), KM_NOFS);
>>   	args->geo = dp->i_mount->m_dir_geo;
>> -	args->name = name->name;
>> -	args->namelen = name->len;
>> +	args->name.name = name->name;
>> +	args->name.len = name->len;
>>   	args->filetype = name->type;
>>   	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
>>   	args->dp = dp;
>> @@ -427,8 +427,8 @@ xfs_dir_removename(
>>   		return -ENOMEM;
>>   
>>   	args->geo = dp->i_mount->m_dir_geo;
>> -	args->name = name->name;
>> -	args->namelen = name->len;
>> +	args->name.name = name->name;
>> +	args->name.len = name->len;
>>   	args->filetype = name->type;
>>   	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
>>   	args->inumber = ino;
>> @@ -488,8 +488,8 @@ xfs_dir_replace(
>>   		return -ENOMEM;
>>   
>>   	args->geo = dp->i_mount->m_dir_geo;
>> -	args->name = name->name;
>> -	args->namelen = name->len;
>> +	args->name.name = name->name;
>> +	args->name.len = name->len;
>>   	args->filetype = name->type;
>>   	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
>>   	args->inumber = inum;
> 
> More struct copy candidates above. Modulo that and the comments on the
> previous patch, the rest LGTM:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
i

Alrighty, will do.  Thanks for the review ;-)

Allison

> 
>> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
>> index 9595ced..94269b9 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_block.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
>> @@ -355,7 +355,7 @@ xfs_dir2_block_addname(
>>   	if (error)
>>   		return error;
>>   
>> -	len = dp->d_ops->data_entsize(args->namelen);
>> +	len = dp->d_ops->data_entsize(args->name.len);
>>   
>>   	/*
>>   	 * Set up pointers to parts of the block.
>> @@ -539,8 +539,8 @@ xfs_dir2_block_addname(
>>   	 * Create the new data entry.
>>   	 */
>>   	dep->inumber = cpu_to_be64(args->inumber);
>> -	dep->namelen = args->namelen;
>> -	memcpy(dep->name, args->name, args->namelen);
>> +	dep->namelen = args->name.len;
>> +	memcpy(dep->name, args->name.name, args->name.len);
>>   	dp->d_ops->data_put_ftype(dep, args->filetype);
>>   	tagp = dp->d_ops->data_entry_tag_p(dep);
>>   	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
>> index a53e458..b7046e2 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
>> @@ -610,7 +610,7 @@ xfs_dir2_leaf_addname(
>>   	ents = dp->d_ops->leaf_ents_p(leaf);
>>   	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
>>   	bestsp = xfs_dir2_leaf_bests_p(ltp);
>> -	length = dp->d_ops->data_entsize(args->namelen);
>> +	length = dp->d_ops->data_entsize(args->name.len);
>>   
>>   	/*
>>   	 * See if there are any entries with the same hash value
>> @@ -813,8 +813,8 @@ xfs_dir2_leaf_addname(
>>   	 */
>>   	dep = (xfs_dir2_data_entry_t *)dup;
>>   	dep->inumber = cpu_to_be64(args->inumber);
>> -	dep->namelen = args->namelen;
>> -	memcpy(dep->name, args->name, dep->namelen);
>> +	dep->namelen = args->name.len;
>> +	memcpy(dep->name, args->name.name, dep->namelen);
>>   	dp->d_ops->data_put_ftype(dep, args->filetype);
>>   	tagp = dp->d_ops->data_entry_tag_p(dep);
>>   	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
>> index 705c4f5..8bbd742 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_node.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
>> @@ -604,7 +604,7 @@ xfs_dir2_leafn_lookup_for_addname(
>>   		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
>>   		       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
>>   	}
>> -	length = dp->d_ops->data_entsize(args->namelen);
>> +	length = dp->d_ops->data_entsize(args->name.len);
>>   	/*
>>   	 * Loop over leaf entries with the right hash value.
>>   	 */
>> @@ -1869,7 +1869,7 @@ xfs_dir2_node_addname_int(
>>   	__be16			*tagp;		/* data entry tag pointer */
>>   	__be16			*bests;
>>   
>> -	length = dp->d_ops->data_entsize(args->namelen);
>> +	length = dp->d_ops->data_entsize(args->name.len);
>>   	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &findex,
>>   					   length);
>>   	if (error)
>> @@ -1924,8 +1924,8 @@ xfs_dir2_node_addname_int(
>>   	/* Fill in the new entry and log it. */
>>   	dep = (xfs_dir2_data_entry_t *)dup;
>>   	dep->inumber = cpu_to_be64(args->inumber);
>> -	dep->namelen = args->namelen;
>> -	memcpy(dep->name, args->name, dep->namelen);
>> +	dep->namelen = args->name.len;
>> +	memcpy(dep->name, args->name.name, dep->namelen);
>>   	dp->d_ops->data_put_ftype(dep, args->filetype);
>>   	tagp = dp->d_ops->data_entry_tag_p(dep);
>>   	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
>> index 85f14fc..fdc1431 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
>> @@ -291,7 +291,7 @@ xfs_dir2_sf_addname(
>>   	/*
>>   	 * Compute entry (and change in) size.
>>   	 */
>> -	incr_isize = dp->d_ops->sf_entsize(sfp, args->namelen);
>> +	incr_isize = dp->d_ops->sf_entsize(sfp, args->name.len);
>>   	objchange = 0;
>>   
>>   	/*
>> @@ -375,7 +375,7 @@ xfs_dir2_sf_addname_easy(
>>   	/*
>>   	 * Grow the in-inode space.
>>   	 */
>> -	xfs_idata_realloc(dp, dp->d_ops->sf_entsize(sfp, args->namelen),
>> +	xfs_idata_realloc(dp, dp->d_ops->sf_entsize(sfp, args->name.len),
>>   			  XFS_DATA_FORK);
>>   	/*
>>   	 * Need to set up again due to realloc of the inode data.
>> @@ -385,9 +385,9 @@ xfs_dir2_sf_addname_easy(
>>   	/*
>>   	 * Fill in the new entry.
>>   	 */
>> -	sfep->namelen = args->namelen;
>> +	sfep->namelen = args->name.len;
>>   	xfs_dir2_sf_put_offset(sfep, offset);
>> -	memcpy(sfep->name, args->name, sfep->namelen);
>> +	memcpy(sfep->name, args->name.name, sfep->namelen);
>>   	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
>>   	dp->d_ops->sf_put_ftype(sfep, args->filetype);
>>   
>> @@ -446,7 +446,7 @@ xfs_dir2_sf_addname_hard(
>>   	 */
>>   	for (offset = dp->d_ops->data_first_offset,
>>   	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
>> -	      add_datasize = dp->d_ops->data_entsize(args->namelen),
>> +	      add_datasize = dp->d_ops->data_entsize(args->name.len),
>>   	      eof = (char *)oldsfep == &buf[old_isize];
>>   	     !eof;
>>   	     offset = new_offset + dp->d_ops->data_entsize(oldsfep->namelen),
>> @@ -476,9 +476,9 @@ xfs_dir2_sf_addname_hard(
>>   	/*
>>   	 * Fill in the new entry, and update the header counts.
>>   	 */
>> -	sfep->namelen = args->namelen;
>> +	sfep->namelen = args->name.len;
>>   	xfs_dir2_sf_put_offset(sfep, offset);
>> -	memcpy(sfep->name, args->name, sfep->namelen);
>> +	memcpy(sfep->name, args->name.name, sfep->namelen);
>>   	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
>>   	dp->d_ops->sf_put_ftype(sfep, args->filetype);
>>   	sfp->count++;
>> @@ -522,7 +522,7 @@ xfs_dir2_sf_addname_pick(
>>   	dp = args->dp;
>>   
>>   	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>> -	size = dp->d_ops->data_entsize(args->namelen);
>> +	size = dp->d_ops->data_entsize(args->name.len);
>>   	offset = dp->d_ops->data_first_offset;
>>   	sfep = xfs_dir2_sf_firstentry(sfp);
>>   	holefit = 0;
>> @@ -807,7 +807,7 @@ xfs_dir2_sf_lookup(
>>   	/*
>>   	 * Special case for .
>>   	 */
>> -	if (args->namelen == 1 && args->name[0] == '.') {
>> +	if (args->name.len == 1 && args->name.name[0] == '.') {
>>   		args->inumber = dp->i_ino;
>>   		args->cmpresult = XFS_CMP_EXACT;
>>   		args->filetype = XFS_DIR3_FT_DIR;
>> @@ -816,8 +816,8 @@ xfs_dir2_sf_lookup(
>>   	/*
>>   	 * Special case for ..
>>   	 */
>> -	if (args->namelen == 2 &&
>> -	    args->name[0] == '.' && args->name[1] == '.') {
>> +	if (args->name.len == 2 &&
>> +	    args->name.name[0] == '.' && args->name.name[1] == '.') {
>>   		args->inumber = dp->d_ops->sf_get_parent_ino(sfp);
>>   		args->cmpresult = XFS_CMP_EXACT;
>>   		args->filetype = XFS_DIR3_FT_DIR;
>> @@ -912,7 +912,7 @@ xfs_dir2_sf_removename(
>>   	 * Calculate sizes.
>>   	 */
>>   	byteoff = (int)((char *)sfep - (char *)sfp);
>> -	entsize = dp->d_ops->sf_entsize(sfp, args->namelen);
>> +	entsize = dp->d_ops->sf_entsize(sfp, args->name.len);
>>   	newsize = oldsize - entsize;
>>   	/*
>>   	 * Copy the part if any after the removed entry, sliding it down.
>> @@ -1002,12 +1002,12 @@ xfs_dir2_sf_replace(
>>   	} else
>>   		i8elevated = 0;
>>   
>> -	ASSERT(args->namelen != 1 || args->name[0] != '.');
>> +	ASSERT(args->name.len != 1 || args->name.name[0] != '.');
>>   	/*
>>   	 * Replace ..'s entry.
>>   	 */
>> -	if (args->namelen == 2 &&
>> -	    args->name[0] == '.' && args->name[1] == '.') {
>> +	if (args->name.len == 2 &&
>> +	    args->name.name[0] == '.' && args->name.name[1] == '.') {
>>   		ino = dp->d_ops->sf_get_parent_ino(sfp);
>>   		ASSERT(args->inumber != ino);
>>   		dp->d_ops->sf_put_parent_ino(sfp, args->inumber);
>> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
>> index 0edc7f8..42f7c07 100644
>> --- a/fs/xfs/scrub/attr.c
>> +++ b/fs/xfs/scrub/attr.c
>> @@ -147,17 +147,17 @@ xchk_xattr_listent(
>>   		return;
>>   	}
>>   
>> -	args.flags = ATTR_KERNOTIME;
>> +	args.name.type = ATTR_KERNOTIME;
>>   	if (flags & XFS_ATTR_ROOT)
>> -		args.flags |= ATTR_ROOT;
>> +		args.name.type |= ATTR_ROOT;
>>   	else if (flags & XFS_ATTR_SECURE)
>> -		args.flags |= ATTR_SECURE;
>> +		args.name.type |= ATTR_SECURE;
>>   	args.geo = context->dp->i_mount->m_attr_geo;
>>   	args.whichfork = XFS_ATTR_FORK;
>>   	args.dp = context->dp;
>> -	args.name = name;
>> -	args.namelen = namelen;
>> -	args.hashval = xfs_da_hashname(args.name, args.namelen);
>> +	args.name.name = name;
>> +	args.name.len = namelen;
>> +	args.hashval = xfs_da_hashname(args.name.name, args.name.len);
>>   	args.trans = context->tp;
>>   	args.value = xchk_xattr_valuebuf(sx->sc);
>>   	args.valuelen = valuelen;
>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>> index eaae275..e0f524d 100644
>> --- a/fs/xfs/xfs_trace.h
>> +++ b/fs/xfs/xfs_trace.h
>> @@ -1669,7 +1669,7 @@ DECLARE_EVENT_CLASS(xfs_da_class,
>>   	TP_STRUCT__entry(
>>   		__field(dev_t, dev)
>>   		__field(xfs_ino_t, ino)
>> -		__dynamic_array(char, name, args->namelen)
>> +		__dynamic_array(char, name, args->name.len)
>>   		__field(int, namelen)
>>   		__field(xfs_dahash_t, hashval)
>>   		__field(xfs_ino_t, inumber)
>> @@ -1678,9 +1678,10 @@ DECLARE_EVENT_CLASS(xfs_da_class,
>>   	TP_fast_assign(
>>   		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
>>   		__entry->ino = args->dp->i_ino;
>> -		if (args->namelen)
>> -			memcpy(__get_str(name), args->name, args->namelen);
>> -		__entry->namelen = args->namelen;
>> +		if (args->name.len)
>> +			memcpy(__get_str(name), args->name.name,
>> +			       args->name.len);
>> +		__entry->namelen = args->name.len;
>>   		__entry->hashval = args->hashval;
>>   		__entry->inumber = args->inumber;
>>   		__entry->op_flags = args->op_flags;
>> @@ -1733,7 +1734,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
>>   	TP_STRUCT__entry(
>>   		__field(dev_t, dev)
>>   		__field(xfs_ino_t, ino)
>> -		__dynamic_array(char, name, args->namelen)
>> +		__dynamic_array(char, name, args->name.len)
>>   		__field(int, namelen)
>>   		__field(int, valuelen)
>>   		__field(xfs_dahash_t, hashval)
>> @@ -1743,12 +1744,13 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
>>   	TP_fast_assign(
>>   		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
>>   		__entry->ino = args->dp->i_ino;
>> -		if (args->namelen)
>> -			memcpy(__get_str(name), args->name, args->namelen);
>> -		__entry->namelen = args->namelen;
>> +		if (args->name.len)
>> +			memcpy(__get_str(name), args->name.name,
>> +			       args->name.len);
>> +		__entry->namelen = args->name.len;
>>   		__entry->valuelen = args->valuelen;
>>   		__entry->hashval = args->hashval;
>> -		__entry->flags = args->flags;
>> +		__entry->flags = args->name.type;
>>   		__entry->op_flags = args->op_flags;
>>   	),
>>   	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d valuelen %d "
>> -- 
>> 2.7.4
>>
