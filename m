Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD823C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 21:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7946B20709
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 21:44:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ceVdwO+b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfKNVoj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 16:44:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43744 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfKNVoi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 16:44:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAELYNQY065538
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 21:44:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=n3Klxns5lt3VWVk8qKKxsIU9jtzFCWsSLzkrFQbMBg8=;
 b=ceVdwO+bQ3YE/jYjLXYj15WLEd2jZH2PVpaXoFjKpA6gxYGRoRujleuJnfU4/3vY/69A
 CKi0FJBbxryT9PZ9bjBn86rrtzIQQezwDGoq1NPb6ybr/PGSBp0OOtPakLJy3YUtaSkQ
 Q4nf8AVA1Opgv0w8P2X/Bd6wa/ERVY97xb0eqSjLbnw0oDRa6rbLQAnjR2OK2T35h2xN
 A/mKYdKTCN3zFtFh4Ybfb17MKwVxncfZa9lylSh6qtlcTIiU2L7Yi1FbZMdTgPCglEZH
 V8/SWWeteqLKz+bMghpCsgjVabTM5qyb1xamT/97H+gZ3DZ8wJLacc2CrfJmJML6P8oh tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w5mvu60yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 21:44:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAELd62q094952
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 21:44:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w8ngb466h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 21:44:32 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAELiVHW023281
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 21:44:31 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Nov 2019 13:44:31 -0800
Subject: Re: [PATCH] xfs: Add xfs_dabuf defines
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191110011927.13427-1-allison.henderson@oracle.com>
 <20191114204023.GK6219@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <4f6684d7-0191-a3de-bdd7-17cf3543683e@oracle.com>
Date:   Thu, 14 Nov 2019 14:44:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191114204023.GK6219@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911140176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911140176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/14/19 1:40 PM, Darrick J. Wong wrote:
> On Sat, Nov 09, 2019 at 06:19:27PM -0700, Allison Collins wrote:
>> This patch adds two new defines XFS_DABUF_MAP_NOMAPPING and
>> XFS_DABUF_MAP_HOLE_OK.  This helps to clean up hard numbers and
>> makes the code easier to read.  This patch was originally part
>> of the delayed attribute series, but seemed generalized enough
>> to be a stand alone patch.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Looks good,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D

Alrighty, thank you!

Allison

> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c       | 14 +++++++-----
>>   fs/xfs/libxfs/xfs_attr_leaf.c  | 23 +++++++++++--------
>>   fs/xfs/libxfs/xfs_da_btree.c   | 50 ++++++++++++++++++++++++++++--------------
>>   fs/xfs/libxfs/xfs_da_btree.h   | 10 +++++++++
>>   fs/xfs/libxfs/xfs_dir2_block.c |  9 +++++---
>>   fs/xfs/libxfs/xfs_dir2_data.c  |  3 ++-
>>   fs/xfs/libxfs/xfs_dir2_leaf.c  | 17 ++++++++------
>>   fs/xfs/libxfs/xfs_dir2_node.c  | 15 ++++++++-----
>>   fs/xfs/scrub/dabtree.c         |  6 ++---
>>   fs/xfs/scrub/dir.c             | 15 ++++++++-----
>>   fs/xfs/scrub/parent.c          |  3 ++-
>>   fs/xfs/xfs_attr_inactive.c     |  6 +++--
>>   fs/xfs/xfs_attr_list.c         | 16 +++++++++-----
>>   fs/xfs/xfs_dir2_readdir.c      |  6 +++--
>>   fs/xfs/xfs_file.c              |  2 +-
>>   15 files changed, 127 insertions(+), 68 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 510ca69..316c60e 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -589,7 +589,8 @@ xfs_attr_leaf_addname(
>>   	 */
>>   	dp = args->dp;
>>   	args->blkno = 0;
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
>> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> +				    XFS_DABUF_MAP_NOMAPPING, &bp);
>>   	if (error)
>>   		return error;
>>   
>> @@ -715,7 +716,7 @@ xfs_attr_leaf_addname(
>>   		 * remove the "old" attr from that block (neat, huh!)
>>   		 */
>>   		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> -					   -1, &bp);
>> +					   XFS_DABUF_MAP_NOMAPPING, &bp);
>>   		if (error)
>>   			return error;
>>   
>> @@ -769,7 +770,8 @@ xfs_attr_leaf_removename(
>>   	 */
>>   	dp = args->dp;
>>   	args->blkno = 0;
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
>> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> +				    XFS_DABUF_MAP_NOMAPPING, &bp);
>>   	if (error)
>>   		return error;
>>   
>> @@ -813,7 +815,8 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>>   	trace_xfs_attr_leaf_get(args);
>>   
>>   	args->blkno = 0;
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
>> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> +				    XFS_DABUF_MAP_NOMAPPING, &bp);
>>   	if (error)
>>   		return error;
>>   
>> @@ -1173,7 +1176,8 @@ xfs_attr_node_removename(
>>   		ASSERT(state->path.blk[0].bp);
>>   		state->path.blk[0].bp = NULL;
>>   
>> -		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, -1, &bp);
>> +		error = xfs_attr3_leaf_read(args->trans, args->dp, 0,
>> +					    XFS_DABUF_MAP_NOMAPPING, &bp);
>>   		if (error)
>>   			goto out;
>>   
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 56e62b3..42dd3c9 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -1160,11 +1160,13 @@ xfs_attr3_leaf_to_node(
>>   	error = xfs_da_grow_inode(args, &blkno);
>>   	if (error)
>>   		goto out;
>> -	error = xfs_attr3_leaf_read(args->trans, dp, 0, -1, &bp1);
>> +	error = xfs_attr3_leaf_read(args->trans, dp, 0, XFS_DABUF_MAP_NOMAPPING,
>> +				    &bp1);
>>   	if (error)
>>   		goto out;
>>   
>> -	error = xfs_da_get_buf(args->trans, dp, blkno, -1, &bp2, XFS_ATTR_FORK);
>> +	error = xfs_da_get_buf(args->trans, dp, blkno, XFS_DABUF_MAP_NOMAPPING,
>> +			       &bp2, XFS_ATTR_FORK);
>>   	if (error)
>>   		goto out;
>>   
>> @@ -1226,8 +1228,8 @@ xfs_attr3_leaf_create(
>>   
>>   	trace_xfs_attr_leaf_create(args);
>>   
>> -	error = xfs_da_get_buf(args->trans, args->dp, blkno, -1, &bp,
>> -					    XFS_ATTR_FORK);
>> +	error = xfs_da_get_buf(args->trans, args->dp, blkno,
>> +			       XFS_DABUF_MAP_NOMAPPING, &bp, XFS_ATTR_FORK);
>>   	if (error)
>>   		return error;
>>   	bp->b_ops = &xfs_attr3_leaf_buf_ops;
>> @@ -1996,7 +1998,7 @@ xfs_attr3_leaf_toosmall(
>>   		if (blkno == 0)
>>   			continue;
>>   		error = xfs_attr3_leaf_read(state->args->trans, state->args->dp,
>> -					blkno, -1, &bp);
>> +					blkno, XFS_DABUF_MAP_NOMAPPING, &bp);
>>   		if (error)
>>   			return error;
>>   
>> @@ -2726,7 +2728,8 @@ xfs_attr3_leaf_clearflag(
>>   	/*
>>   	 * Set up the operation.
>>   	 */
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
>> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> +				    XFS_DABUF_MAP_NOMAPPING, &bp);
>>   	if (error)
>>   		return error;
>>   
>> @@ -2793,7 +2796,8 @@ xfs_attr3_leaf_setflag(
>>   	/*
>>   	 * Set up the operation.
>>   	 */
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
>> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> +				    XFS_DABUF_MAP_NOMAPPING, &bp);
>>   	if (error)
>>   		return error;
>>   
>> @@ -2855,7 +2859,8 @@ xfs_attr3_leaf_flipflags(
>>   	/*
>>   	 * Read the block containing the "old" attr
>>   	 */
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp1);
>> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> +				    XFS_DABUF_MAP_NOMAPPING, &bp1);
>>   	if (error)
>>   		return error;
>>   
>> @@ -2864,7 +2869,7 @@ xfs_attr3_leaf_flipflags(
>>   	 */
>>   	if (args->blkno2 != args->blkno) {
>>   		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
>> -					   -1, &bp2);
>> +					    XFS_DABUF_MAP_NOMAPPING, &bp2);
>>   		if (error)
>>   			return error;
>>   	} else {
>> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
>> index 4fd1223..459ae03 100644
>> --- a/fs/xfs/libxfs/xfs_da_btree.c
>> +++ b/fs/xfs/libxfs/xfs_da_btree.c
>> @@ -343,7 +343,8 @@ xfs_da3_node_create(
>>   	trace_xfs_da_node_create(args);
>>   	ASSERT(level <= XFS_DA_NODE_MAXDEPTH);
>>   
>> -	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, whichfork);
>> +	error = xfs_da_get_buf(tp, dp, blkno, XFS_DABUF_MAP_NOMAPPING, &bp,
>> +			       whichfork);
>>   	if (error)
>>   		return error;
>>   	bp->b_ops = &xfs_da3_node_buf_ops;
>> @@ -568,7 +569,8 @@ xfs_da3_root_split(
>>   
>>   	dp = args->dp;
>>   	tp = args->trans;
>> -	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, args->whichfork);
>> +	error = xfs_da_get_buf(tp, dp, blkno, XFS_DABUF_MAP_NOMAPPING, &bp,
>> +			       args->whichfork);
>>   	if (error)
>>   		return error;
>>   	node = bp->b_addr;
>> @@ -1109,8 +1111,9 @@ xfs_da3_root_join(
>>   	btree = dp->d_ops->node_tree_p(oldroot);
>>   	child = be32_to_cpu(btree[0].before);
>>   	ASSERT(child != 0);
>> -	error = xfs_da3_node_read(args->trans, dp, child, -1, &bp,
>> -					     args->whichfork);
>> +	error = xfs_da3_node_read(args->trans, dp, child,
>> +				  XFS_DABUF_MAP_NOMAPPING, &bp,
>> +				  args->whichfork);
>>   	if (error)
>>   		return error;
>>   	xfs_da_blkinfo_onlychild_validate(bp->b_addr, oldroothdr.level);
>> @@ -1225,7 +1228,8 @@ xfs_da3_node_toosmall(
>>   		if (blkno == 0)
>>   			continue;
>>   		error = xfs_da3_node_read(state->args->trans, dp,
>> -					blkno, -1, &bp, state->args->whichfork);
>> +					blkno, XFS_DABUF_MAP_NOMAPPING, &bp,
>> +					state->args->whichfork);
>>   		if (error)
>>   			return error;
>>   
>> @@ -1517,7 +1521,8 @@ xfs_da3_node_lookup_int(
>>   		 */
>>   		blk->blkno = blkno;
>>   		error = xfs_da3_node_read(args->trans, args->dp, blkno,
>> -					-1, &blk->bp, args->whichfork);
>> +					XFS_DABUF_MAP_NOMAPPING, &blk->bp,
>> +					args->whichfork);
>>   		if (error) {
>>   			blk->blkno = 0;
>>   			state->path.active--;
>> @@ -1746,7 +1751,8 @@ xfs_da3_blk_link(
>>   		if (old_info->back) {
>>   			error = xfs_da3_node_read(args->trans, dp,
>>   						be32_to_cpu(old_info->back),
>> -						-1, &bp, args->whichfork);
>> +						XFS_DABUF_MAP_NOMAPPING, &bp,
>> +						args->whichfork);
>>   			if (error)
>>   				return error;
>>   			ASSERT(bp != NULL);
>> @@ -1767,7 +1773,8 @@ xfs_da3_blk_link(
>>   		if (old_info->forw) {
>>   			error = xfs_da3_node_read(args->trans, dp,
>>   						be32_to_cpu(old_info->forw),
>> -						-1, &bp, args->whichfork);
>> +						XFS_DABUF_MAP_NOMAPPING, &bp,
>> +						args->whichfork);
>>   			if (error)
>>   				return error;
>>   			ASSERT(bp != NULL);
>> @@ -1826,7 +1833,8 @@ xfs_da3_blk_unlink(
>>   		if (drop_info->back) {
>>   			error = xfs_da3_node_read(args->trans, args->dp,
>>   						be32_to_cpu(drop_info->back),
>> -						-1, &bp, args->whichfork);
>> +						XFS_DABUF_MAP_NOMAPPING, &bp,
>> +						args->whichfork);
>>   			if (error)
>>   				return error;
>>   			ASSERT(bp != NULL);
>> @@ -1843,7 +1851,8 @@ xfs_da3_blk_unlink(
>>   		if (drop_info->forw) {
>>   			error = xfs_da3_node_read(args->trans, args->dp,
>>   						be32_to_cpu(drop_info->forw),
>> -						-1, &bp, args->whichfork);
>> +						XFS_DABUF_MAP_NOMAPPING, &bp,
>> +						args->whichfork);
>>   			if (error)
>>   				return error;
>>   			ASSERT(bp != NULL);
>> @@ -1929,7 +1938,8 @@ xfs_da3_path_shift(
>>   		/*
>>   		 * Read the next child block into a local buffer.
>>   		 */
>> -		error = xfs_da3_node_read(args->trans, dp, blkno, -1, &bp,
>> +		error = xfs_da3_node_read(args->trans, dp, blkno,
>> +					  XFS_DABUF_MAP_NOMAPPING, &bp,
>>   					  args->whichfork);
>>   		if (error)
>>   			return error;
>> @@ -2222,7 +2232,8 @@ xfs_da3_swap_lastblock(
>>   	 * Read the last block in the btree space.
>>   	 */
>>   	last_blkno = (xfs_dablk_t)lastoff - args->geo->fsbcount;
>> -	error = xfs_da3_node_read(tp, dp, last_blkno, -1, &last_buf, w);
>> +	error = xfs_da3_node_read(tp, dp, last_blkno, XFS_DABUF_MAP_NOMAPPING,
>> +				  &last_buf, w);
>>   	if (error)
>>   		return error;
>>   	/*
>> @@ -2258,7 +2269,8 @@ xfs_da3_swap_lastblock(
>>   	 * If the moved block has a left sibling, fix up the pointers.
>>   	 */
>>   	if ((sib_blkno = be32_to_cpu(dead_info->back))) {
>> -		error = xfs_da3_node_read(tp, dp, sib_blkno, -1, &sib_buf, w);
>> +		error = xfs_da3_node_read(tp, dp, sib_blkno,
>> +					  XFS_DABUF_MAP_NOMAPPING, &sib_buf, w);
>>   		if (error)
>>   			goto done;
>>   		sib_info = sib_buf->b_addr;
>> @@ -2280,7 +2292,8 @@ xfs_da3_swap_lastblock(
>>   	 * If the moved block has a right sibling, fix up the pointers.
>>   	 */
>>   	if ((sib_blkno = be32_to_cpu(dead_info->forw))) {
>> -		error = xfs_da3_node_read(tp, dp, sib_blkno, -1, &sib_buf, w);
>> +		error = xfs_da3_node_read(tp, dp, sib_blkno,
>> +					  XFS_DABUF_MAP_NOMAPPING, &sib_buf, w);
>>   		if (error)
>>   			goto done;
>>   		sib_info = sib_buf->b_addr;
>> @@ -2304,7 +2317,8 @@ xfs_da3_swap_lastblock(
>>   	 * Walk down the tree looking for the parent of the moved block.
>>   	 */
>>   	for (;;) {
>> -		error = xfs_da3_node_read(tp, dp, par_blkno, -1, &par_buf, w);
>> +		error = xfs_da3_node_read(tp, dp, par_blkno,
>> +					  XFS_DABUF_MAP_NOMAPPING, &par_buf, w);
>>   		if (error)
>>   			goto done;
>>   		par_node = par_buf->b_addr;
>> @@ -2355,7 +2369,8 @@ xfs_da3_swap_lastblock(
>>   			error = -EFSCORRUPTED;
>>   			goto done;
>>   		}
>> -		error = xfs_da3_node_read(tp, dp, par_blkno, -1, &par_buf, w);
>> +		error = xfs_da3_node_read(tp, dp, par_blkno,
>> +					  XFS_DABUF_MAP_NOMAPPING, &par_buf, w);
>>   		if (error)
>>   			goto done;
>>   		par_node = par_buf->b_addr;
>> @@ -2533,7 +2548,8 @@ xfs_dabuf_map(
>>   	 * Caller doesn't have a mapping.  -2 means don't complain
>>   	 * if we land in a hole.
>>   	 */
>> -	if (mappedbno == -1 || mappedbno == -2) {
>> +	if (mappedbno == XFS_DABUF_MAP_NOMAPPING ||
>> +	    mappedbno == XFS_DABUF_MAP_HOLE_OK) {
>>   		/*
>>   		 * Optimize the one-block case.
>>   		 */
>> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
>> index ae0bbd2..8ad7945 100644
>> --- a/fs/xfs/libxfs/xfs_da_btree.h
>> +++ b/fs/xfs/libxfs/xfs_da_btree.h
>> @@ -176,6 +176,16 @@ int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
>>   			 struct xfs_buf **bpp, int which_fork);
>>   
>>   /*
>> + * xfs_dabuf_map defines
>> + */
>> +
>> +/* Force a fresh lookup for the dir/attr mapping. */
>> +#define XFS_DABUF_MAP_NOMAPPING	((xfs_daddr_t)-1)
>> +
>> +/* Don't complain if we land in a hole. */
>> +#define XFS_DABUF_MAP_HOLE_OK	((xfs_daddr_t)-2)
>> +
>> +/*
>>    * Utility routines.
>>    */
>>   int	xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno);
>> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
>> index 49e4bc3..e64471a 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_block.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
>> @@ -20,6 +20,7 @@
>>   #include "xfs_error.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_log.h"
>> +#include "xfs_attr_leaf.h"
>>   
>>   /*
>>    * Local function prototypes.
>> @@ -123,8 +124,9 @@ xfs_dir3_block_read(
>>   	struct xfs_mount	*mp = dp->i_mount;
>>   	int			err;
>>   
>> -	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, -1, bpp,
>> -				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
>> +	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk,
>> +			      XFS_DABUF_MAP_NOMAPPING, bpp, XFS_DATA_FORK,
>> +			      &xfs_dir3_block_buf_ops);
>>   	if (!err && tp && *bpp)
>>   		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
>>   	return err;
>> @@ -953,7 +955,8 @@ xfs_dir2_leaf_to_block(
>>   	 * Read the data block if we don't already have it, give up if it fails.
>>   	 */
>>   	if (!dbp) {
>> -		error = xfs_dir3_data_read(tp, dp, args->geo->datablk, -1, &dbp);
>> +		error = xfs_dir3_data_read(tp, dp, args->geo->datablk,
>> +						XFS_DABUF_MAP_NOMAPPING, &dbp);
>>   		if (error)
>>   			return error;
>>   	}
>> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
>> index 2c79be4..a4188de 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_data.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
>> @@ -17,6 +17,7 @@
>>   #include "xfs_trans.h"
>>   #include "xfs_buf_item.h"
>>   #include "xfs_log.h"
>> +#include "xfs_attr_leaf.h"
>>   
>>   static xfs_failaddr_t xfs_dir2_data_freefind_verify(
>>   		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
>> @@ -653,7 +654,7 @@ xfs_dir3_data_init(
>>   	 * Get the buffer set up for the block.
>>   	 */
>>   	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, blkno),
>> -			       -1, &bp, XFS_DATA_FORK);
>> +			       XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
>>   	if (error)
>>   		return error;
>>   	bp->b_ops = &xfs_dir3_data_buf_ops;
>> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
>> index a53e458..d11c83b 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
>> @@ -19,6 +19,7 @@
>>   #include "xfs_trace.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_buf_item.h"
>> +#include "xfs_attr_leaf.h"
>>   
>>   /*
>>    * Local function declarations.
>> @@ -311,7 +312,7 @@ xfs_dir3_leaf_get_buf(
>>   	       bno < xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET));
>>   
>>   	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, bno),
>> -			       -1, &bp, XFS_DATA_FORK);
>> +			       XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
>>   	if (error)
>>   		return error;
>>   
>> @@ -594,7 +595,8 @@ xfs_dir2_leaf_addname(
>>   
>>   	trace_xfs_dir2_leaf_addname(args);
>>   
>> -	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
>> +	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk,
>> +				   XFS_DABUF_MAP_NOMAPPING, &lbp);
>>   	if (error)
>>   		return error;
>>   
>> @@ -783,7 +785,7 @@ xfs_dir2_leaf_addname(
>>   		 */
>>   		error = xfs_dir3_data_read(tp, dp,
>>   				   xfs_dir2_db_to_da(args->geo, use_block),
>> -				   -1, &dbp);
>> +				   XFS_DABUF_MAP_NOMAPPING, &dbp);
>>   		if (error) {
>>   			xfs_trans_brelse(tp, lbp);
>>   			return error;
>> @@ -1189,7 +1191,8 @@ xfs_dir2_leaf_lookup_int(
>>   	tp = args->trans;
>>   	mp = dp->i_mount;
>>   
>> -	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
>> +	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk,
>> +				   XFS_DABUF_MAP_NOMAPPING, &lbp);
>>   	if (error)
>>   		return error;
>>   
>> @@ -1229,7 +1232,7 @@ xfs_dir2_leaf_lookup_int(
>>   				xfs_trans_brelse(tp, dbp);
>>   			error = xfs_dir3_data_read(tp, dp,
>>   					   xfs_dir2_db_to_da(args->geo, newdb),
>> -					   -1, &dbp);
>> +					   XFS_DABUF_MAP_NOMAPPING, &dbp);
>>   			if (error) {
>>   				xfs_trans_brelse(tp, lbp);
>>   				return error;
>> @@ -1271,7 +1274,7 @@ xfs_dir2_leaf_lookup_int(
>>   			xfs_trans_brelse(tp, dbp);
>>   			error = xfs_dir3_data_read(tp, dp,
>>   					   xfs_dir2_db_to_da(args->geo, cidb),
>> -					   -1, &dbp);
>> +					   XFS_DABUF_MAP_NOMAPPING, &dbp);
>>   			if (error) {
>>   				xfs_trans_brelse(tp, lbp);
>>   				return error;
>> @@ -1566,7 +1569,7 @@ xfs_dir2_leaf_trim_data(
>>   	 * Read the offending data block.  We need its buffer.
>>   	 */
>>   	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(args->geo, db),
>> -				   -1, &dbp);
>> +				   XFS_DABUF_MAP_NOMAPPING, &dbp);
>>   	if (error)
>>   		return error;
>>   
>> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
>> index 705c4f5..6754554 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_node.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
>> @@ -20,6 +20,7 @@
>>   #include "xfs_trans.h"
>>   #include "xfs_buf_item.h"
>>   #include "xfs_log.h"
>> +#include "xfs_attr_leaf.h"
>>   
>>   /*
>>    * Function declarations.
>> @@ -227,7 +228,7 @@ xfs_dir2_free_read(
>>   	xfs_dablk_t		fbno,
>>   	struct xfs_buf		**bpp)
>>   {
>> -	return __xfs_dir3_free_read(tp, dp, fbno, -1, bpp);
>> +	return __xfs_dir3_free_read(tp, dp, fbno, XFS_DABUF_MAP_NOMAPPING, bpp);
>>   }
>>   
>>   static int
>> @@ -237,7 +238,7 @@ xfs_dir2_free_try_read(
>>   	xfs_dablk_t		fbno,
>>   	struct xfs_buf		**bpp)
>>   {
>> -	return __xfs_dir3_free_read(tp, dp, fbno, -2, bpp);
>> +	return __xfs_dir3_free_read(tp, dp, fbno, XFS_DABUF_MAP_HOLE_OK, bpp);
>>   }
>>   
>>   static int
>> @@ -254,7 +255,7 @@ xfs_dir3_free_get_buf(
>>   	struct xfs_dir3_icfree_hdr hdr;
>>   
>>   	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, fbno),
>> -				   -1, &bp, XFS_DATA_FORK);
>> +				   XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
>>   	if (error)
>>   		return error;
>>   
>> @@ -795,7 +796,8 @@ xfs_dir2_leafn_lookup_for_entry(
>>   				error = xfs_dir3_data_read(tp, dp,
>>   						xfs_dir2_db_to_da(args->geo,
>>   								  newdb),
>> -						-1, &curbp);
>> +						XFS_DABUF_MAP_NOMAPPING,
>> +						&curbp);
>>   				if (error)
>>   					return error;
>>   			}
>> @@ -1495,7 +1497,8 @@ xfs_dir2_leafn_toosmall(
>>   		 * Read the sibling leaf block.
>>   		 */
>>   		error = xfs_dir3_leafn_read(state->args->trans, dp,
>> -					    blkno, -1, &bp);
>> +					    blkno, XFS_DABUF_MAP_NOMAPPING,
>> +					    &bp);
>>   		if (error)
>>   			return error;
>>   
>> @@ -1898,7 +1901,7 @@ xfs_dir2_node_addname_int(
>>   		/* Read the data block in. */
>>   		error = xfs_dir3_data_read(tp, dp,
>>   					   xfs_dir2_db_to_da(args->geo, dbno),
>> -					   -1, &dbp);
>> +					   XFS_DABUF_MAP_NOMAPPING, &dbp);
>>   	}
>>   	if (error)
>>   		return error;
>> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
>> index 77ff9f9..353455c 100644
>> --- a/fs/xfs/scrub/dabtree.c
>> +++ b/fs/xfs/scrub/dabtree.c
>> @@ -355,9 +355,9 @@ xchk_da_btree_block(
>>   		goto out_nobuf;
>>   
>>   	/* Read the buffer. */
>> -	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno, -2,
>> -			&blk->bp, dargs->whichfork,
>> -			&xchk_da_btree_buf_ops);
>> +	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno,
>> +				XFS_DABUF_MAP_HOLE_OK, &blk->bp,
>> +				dargs->whichfork, &xchk_da_btree_buf_ops);
>>   	if (!xchk_da_process_error(ds, level, &error))
>>   		goto out_nobuf;
>>   	if (blk->bp)
>> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
>> index 1e2e117..c5f806b 100644
>> --- a/fs/xfs/scrub/dir.c
>> +++ b/fs/xfs/scrub/dir.c
>> @@ -18,6 +18,7 @@
>>   #include "scrub/scrub.h"
>>   #include "scrub/common.h"
>>   #include "scrub/dabtree.h"
>> +#include "xfs_attr_leaf.h"
>>   
>>   /* Set us up to scrub directories. */
>>   int
>> @@ -217,7 +218,8 @@ xchk_dir_rec(
>>   		xchk_da_set_corrupt(ds, level);
>>   		goto out;
>>   	}
>> -	error = xfs_dir3_data_read(ds->dargs.trans, dp, rec_bno, -2, &bp);
>> +	error = xfs_dir3_data_read(ds->dargs.trans, dp, rec_bno,
>> +				   XFS_DABUF_MAP_HOLE_OK, &bp);
>>   	if (!xchk_fblock_process_error(ds->sc, XFS_DATA_FORK, rec_bno,
>>   			&error))
>>   		goto out;
>> @@ -339,7 +341,8 @@ xchk_directory_data_bestfree(
>>   		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
>>   	} else {
>>   		/* dir data format */
>> -		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk, -1, &bp);
>> +		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk,
>> +					   XFS_DABUF_MAP_HOLE_OK, &bp);
>>   	}
>>   	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
>>   		goto out;
>> @@ -492,7 +495,8 @@ xchk_directory_leaf1_bestfree(
>>   	int				error;
>>   
>>   	/* Read the free space block. */
>> -	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
>> +	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk,
>> +				   XFS_DABUF_MAP_NOMAPPING, &bp);
>>   	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
>>   		goto out;
>>   	xchk_buffer_recheck(sc, bp);
>> @@ -552,7 +556,8 @@ xchk_directory_leaf1_bestfree(
>>   		if (best == NULLDATAOFF)
>>   			continue;
>>   		error = xfs_dir3_data_read(sc->tp, sc->ip,
>> -				i * args->geo->fsbcount, -1, &dbp);
>> +				i * args->geo->fsbcount, XFS_DABUF_MAP_HOLE_OK,
>> +				&dbp);
>>   		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
>>   				&error))
>>   			break;
>> @@ -605,7 +610,7 @@ xchk_directory_free_bestfree(
>>   		}
>>   		error = xfs_dir3_data_read(sc->tp, sc->ip,
>>   				(freehdr.firstdb + i) * args->geo->fsbcount,
>> -				-1, &dbp);
>> +				XFS_DABUF_MAP_HOLE_OK, &dbp);
>>   		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
>>   				&error))
>>   			break;
>> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
>> index c962bd5..75a6f6f 100644
>> --- a/fs/xfs/scrub/parent.c
>> +++ b/fs/xfs/scrub/parent.c
>> @@ -80,7 +80,8 @@ xchk_parent_count_parent_dentries(
>>   	 */
>>   	lock_mode = xfs_ilock_data_map_shared(parent);
>>   	if (parent->i_d.di_nextents > 0)
>> -		error = xfs_dir3_data_readahead(parent, 0, -1);
>> +		error = xfs_dir3_data_readahead(parent, 0,
>> +						XFS_DABUF_MAP_NOMAPPING);
>>   	xfs_iunlock(parent, lock_mode);
>>   	if (error)
>>   		return error;
>> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
>> index f83f11d..9c22915 100644
>> --- a/fs/xfs/xfs_attr_inactive.c
>> +++ b/fs/xfs/xfs_attr_inactive.c
>> @@ -235,7 +235,8 @@ xfs_attr3_node_inactive(
>>   		 * traversal of the tree so we may deal with many blocks
>>   		 * before we come back to this one.
>>   		 */
>> -		error = xfs_da3_node_read(*trans, dp, child_fsb, -1, &child_bp,
>> +		error = xfs_da3_node_read(*trans, dp, child_fsb,
>> +					  XFS_DABUF_MAP_NOMAPPING, &child_bp,
>>   					  XFS_ATTR_FORK);
>>   		if (error)
>>   			return error;
>> @@ -321,7 +322,8 @@ xfs_attr3_root_inactive(
>>   	 * the extents in reverse order the extent containing
>>   	 * block 0 must still be there.
>>   	 */
>> -	error = xfs_da3_node_read(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
>> +	error = xfs_da3_node_read(*trans, dp, 0, XFS_DABUF_MAP_NOMAPPING, &bp,
>> +				  XFS_ATTR_FORK);
>>   	if (error)
>>   		return error;
>>   	blkno = bp->b_bn;
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index c02f22d..fab416c 100644
>> --- a/fs/xfs/xfs_attr_list.c
>> +++ b/fs/xfs/xfs_attr_list.c
>> @@ -224,8 +224,9 @@ xfs_attr_node_list_lookup(
>>   	ASSERT(*pbp == NULL);
>>   	cursor->blkno = 0;
>>   	for (;;) {
>> -		error = xfs_da3_node_read(tp, dp, cursor->blkno, -1, &bp,
>> -				XFS_ATTR_FORK);
>> +		error = xfs_da3_node_read(tp, dp, cursor->blkno,
>> +					  XFS_DABUF_MAP_NOMAPPING, &bp,
>> +					  XFS_ATTR_FORK);
>>   		if (error)
>>   			return error;
>>   		node = bp->b_addr;
>> @@ -309,8 +310,9 @@ xfs_attr_node_list(
>>   	 */
>>   	bp = NULL;
>>   	if (cursor->blkno > 0) {
>> -		error = xfs_da3_node_read(context->tp, dp, cursor->blkno, -1,
>> -					      &bp, XFS_ATTR_FORK);
>> +		error = xfs_da3_node_read(context->tp, dp, cursor->blkno,
>> +					  XFS_DABUF_MAP_NOMAPPING, &bp,
>> +					  XFS_ATTR_FORK);
>>   		if ((error != 0) && (error != -EFSCORRUPTED))
>>   			return error;
>>   		if (bp) {
>> @@ -377,7 +379,8 @@ xfs_attr_node_list(
>>   			break;
>>   		cursor->blkno = leafhdr.forw;
>>   		xfs_trans_brelse(context->tp, bp);
>> -		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno, -1, &bp);
>> +		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno,
>> +					    XFS_DABUF_MAP_NOMAPPING, &bp);
>>   		if (error)
>>   			return error;
>>   	}
>> @@ -497,7 +500,8 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
>>   	trace_xfs_attr_leaf_list(context);
>>   
>>   	context->cursor->blkno = 0;
>> -	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, -1, &bp);
>> +	error = xfs_attr3_leaf_read(context->tp, context->dp, 0,
>> +				    XFS_DABUF_MAP_NOMAPPING, &bp);
>>   	if (error)
>>   		return error;
>>   
>> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
>> index a0bec09..994e9e3 100644
>> --- a/fs/xfs/xfs_dir2_readdir.c
>> +++ b/fs/xfs/xfs_dir2_readdir.c
>> @@ -287,7 +287,8 @@ xfs_dir2_leaf_readbuf(
>>   	new_off = xfs_dir2_da_to_byte(geo, map.br_startoff);
>>   	if (new_off > *cur_off)
>>   		*cur_off = new_off;
>> -	error = xfs_dir3_data_read(args->trans, dp, map.br_startoff, -1, &bp);
>> +	error = xfs_dir3_data_read(args->trans, dp, map.br_startoff,
>> +				   XFS_DABUF_MAP_NOMAPPING, &bp);
>>   	if (error)
>>   		goto out;
>>   
>> @@ -322,7 +323,8 @@ xfs_dir2_leaf_readbuf(
>>   				break;
>>   			}
>>   			if (next_ra > *ra_blk) {
>> -				xfs_dir3_data_readahead(dp, next_ra, -2);
>> +				xfs_dir3_data_readahead(dp, next_ra,
>> +							XFS_DABUF_MAP_HOLE_OK);
>>   				*ra_blk = next_ra;
>>   			}
>>   			ra_want -= geo->fsbcount;
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 865543e..5512012 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -1104,7 +1104,7 @@ xfs_dir_open(
>>   	 */
>>   	mode = xfs_ilock_data_map_shared(ip);
>>   	if (ip->i_d.di_nextents > 0)
>> -		error = xfs_dir3_data_readahead(ip, 0, -1);
>> +		error = xfs_dir3_data_readahead(ip, 0, XFS_DABUF_MAP_NOMAPPING);
>>   	xfs_iunlock(ip, mode);
>>   	return error;
>>   }
>> -- 
>> 2.7.4
>>
