Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE21C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 19:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7264A2067B
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 19:19:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bFQ82gOo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732181AbfKHTTe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 14:19:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52868 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731335AbfKHTTd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 14:19:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8JDlNV069904
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:19:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=27ni0NyG8LDscnc8lo2d7D0MhLzPPTlkAWZRaljBYKs=;
 b=bFQ82gOo8dxRPFsF5UNy3duDLsDb+Kf3fy9lnf2GI9Qr58EY57C2WHe1Ml30dIxN5Qmv
 5vIRg0iuOYqCIZMlVZi6po7IugBzI3CdfCQEwnnpqdP6/VOB8g929FeHK7jodmCZXGlE
 sOEX1ws4srPQRkrzj8O4AHbmMhVeHqtkOX7opVeSqnEZYRtQ/JlQ5W9vMCaLLkRQ1Brv
 t8FU3w1VCDTaSNrbgwFu3dsKT7spuvXUZOot44TXMKUaYAHsqpSclOzTT7yXV45z9/Za
 Itf8MY0hGT/n8nE4+5fS4aERTz+G1uz2jcI+DXRfEOzaZpmSzBBJ3mgFp2L6hGgXgNrV zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w41w17721-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 19:19:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8JD3Jm038130
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:19:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w5cxk7ddc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 19:19:31 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA8JJUXR010307
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:19:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 11:19:29 -0800
Date:   Fri, 8 Nov 2019 11:19:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 04/17] xfs: Add xfs_dabuf defines
Message-ID: <20191108191928.GU6219@magnolia>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107012801.22863-5-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080188
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080188
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:27:48PM -0700, Allison Collins wrote:
> This patch adds two new defines XFS_DABUF_MAP_NOMAPPING and
> XFS_DABUF_MAP_HOLE_OK.  This helps to clean up hard numbers and
> makes the code easier to read
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       | 14 +++++++-----
>  fs/xfs/libxfs/xfs_attr_leaf.c  | 23 +++++++++++--------
>  fs/xfs/libxfs/xfs_attr_leaf.h  |  3 +++
>  fs/xfs/libxfs/xfs_da_btree.c   | 50 ++++++++++++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_dir2_block.c |  6 +++--
>  fs/xfs/libxfs/xfs_dir2_data.c  |  3 ++-
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |  9 +++++---
>  fs/xfs/libxfs/xfs_dir2_node.c  | 10 +++++----
>  fs/xfs/scrub/dabtree.c         |  6 ++---
>  fs/xfs/scrub/dir.c             |  4 +++-
>  fs/xfs/xfs_attr_inactive.c     |  6 +++--
>  fs/xfs/xfs_attr_list.c         | 16 +++++++++-----
>  12 files changed, 97 insertions(+), 53 deletions(-)

<snip>

> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index bb08800..017480e 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -16,6 +16,9 @@ struct xfs_da_state_blk;
>  struct xfs_inode;
>  struct xfs_trans;
>  
> +#define XFS_DABUF_MAP_NOMAPPING	(-1) /* Caller doesn't have a mapping. */
> +#define XFS_DABUF_MAP_HOLE_OK	(-2) /* don't complain if we land in a hole. */

These are parameters to xfs_da_{get,read,reada}_buf, please put them
next to the declarations for those functions.

Also they probably ought to be explicitly cast to xfs_daddr_t, e.g.

/* Force a fresh lookup for the dir/attr mapping. */
#define XFS_DABUF_MAP_NOMAPPING	((xfs_daddr_t)-1)

/* Don't complain if we land in a hole. */
#define XFS_DABUF_MAP_HOLE_OK	((xfs_daddr_t)-2)

> +
>  /*
>   * Used to keep a list of "remote value" extents when unlinking an inode.
>   */

<snip>

> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 8dedc30..6bc7651 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -20,6 +20,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> +#include "xfs_attr_leaf.h"
>  
>  /*
>   * Local function prototypes.
> @@ -123,8 +124,9 @@ xfs_dir3_block_read(
>  	struct xfs_mount	*mp = dp->i_mount;
>  	int			err;
>  
> -	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, -1, bpp,
> -				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
> +	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk,
> +			      XFS_DABUF_MAP_NOMAPPING, bpp, XFS_DATA_FORK,
> +			      &xfs_dir3_block_buf_ops);
>  	if (!err && tp && *bpp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
>  	return err;

I think this misses the xfs_dir3_data_read call in
xfs_dir2_leaf_to_block?

> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 2c79be4..a4188de 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -17,6 +17,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> +#include "xfs_attr_leaf.h"
>  
>  static xfs_failaddr_t xfs_dir2_data_freefind_verify(
>  		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
> @@ -653,7 +654,7 @@ xfs_dir3_data_init(
>  	 * Get the buffer set up for the block.
>  	 */
>  	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, blkno),
> -			       -1, &bp, XFS_DATA_FORK);
> +			       XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
>  	if (error)
>  		return error;
>  	bp->b_ops = &xfs_dir3_data_buf_ops;
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index b7046e2..a2cba6bd 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -19,6 +19,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
> +#include "xfs_attr_leaf.h"
>  
>  /*
>   * Local function declarations.
> @@ -311,7 +312,7 @@ xfs_dir3_leaf_get_buf(
>  	       bno < xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET));
>  
>  	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, bno),
> -			       -1, &bp, XFS_DATA_FORK);
> +			       XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
>  	if (error)
>  		return error;
>  
> @@ -594,7 +595,8 @@ xfs_dir2_leaf_addname(
>  
>  	trace_xfs_dir2_leaf_addname(args);
>  
> -	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
> +	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk,
> +				   XFS_DABUF_MAP_NOMAPPING, &lbp);
>  	if (error)
>  		return error;
>  

I think there are some missing conversions for xfs_dir3_data_read calls
in xfs_dir2_leaf_addname...

> @@ -1189,7 +1191,8 @@ xfs_dir2_leaf_lookup_int(
>  	tp = args->trans;
>  	mp = dp->i_mount;
>  
> -	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
> +	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk,
> +				   XFS_DABUF_MAP_NOMAPPING, &lbp);
>  	if (error)
>  		return error;
>  

...and two more dir3_leaf_read calls further down in this function...

...and one more in xfs_dir2_leaf_trim_data...

> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 8bbd742..0a803e4 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -20,6 +20,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> +#include "xfs_attr_leaf.h"
>  
>  /*
>   * Function declarations.
> @@ -227,7 +228,7 @@ xfs_dir2_free_read(
>  	xfs_dablk_t		fbno,
>  	struct xfs_buf		**bpp)
>  {
> -	return __xfs_dir3_free_read(tp, dp, fbno, -1, bpp);
> +	return __xfs_dir3_free_read(tp, dp, fbno, XFS_DABUF_MAP_NOMAPPING, bpp);
>  }
>  
>  static int
> @@ -237,7 +238,7 @@ xfs_dir2_free_try_read(
>  	xfs_dablk_t		fbno,
>  	struct xfs_buf		**bpp)
>  {
> -	return __xfs_dir3_free_read(tp, dp, fbno, -2, bpp);
> +	return __xfs_dir3_free_read(tp, dp, fbno, XFS_DABUF_MAP_HOLE_OK, bpp);
>  }
>  
>  static int
> @@ -254,7 +255,7 @@ xfs_dir3_free_get_buf(
>  	struct xfs_dir3_icfree_hdr hdr;
>  
>  	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, fbno),
> -				   -1, &bp, XFS_DATA_FORK);
> +				   XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
>  	if (error)
>  		return error;
>  

...there's also a missing call in xfs_dir2_leafn_lookup_for_entry...

> @@ -1495,7 +1496,8 @@ xfs_dir2_leafn_toosmall(
>  		 * Read the sibling leaf block.
>  		 */
>  		error = xfs_dir3_leafn_read(state->args->trans, dp,
> -					    blkno, -1, &bp);
> +					    blkno, XFS_DABUF_MAP_NOMAPPING,
> +					    &bp);
>  		if (error)
>  			return error;
>  

...and another one in xfs_dir2_node_addname_int.

> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 77ff9f9..353455c 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -355,9 +355,9 @@ xchk_da_btree_block(
>  		goto out_nobuf;
>  
>  	/* Read the buffer. */
> -	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno, -2,
> -			&blk->bp, dargs->whichfork,
> -			&xchk_da_btree_buf_ops);
> +	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno,
> +				XFS_DABUF_MAP_HOLE_OK, &blk->bp,
> +				dargs->whichfork, &xchk_da_btree_buf_ops);
>  	if (!xchk_da_process_error(ds, level, &error))
>  		goto out_nobuf;
>  	if (blk->bp)
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 1e2e117..eb0fa0f 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -18,6 +18,7 @@
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/dabtree.h"
> +#include "xfs_attr_leaf.h"
>  
>  /* Set us up to scrub directories. */
>  int

I also noticed missing conversions for xfs_dir3_data_read in
xchk_dir_rec, xchk_directory_data_bestfree,
xchk_directory_leaf1_bestfree, and xchk_directory_free_bestfree.

> @@ -492,7 +493,8 @@ xchk_directory_leaf1_bestfree(
>  	int				error;
>  
>  	/* Read the free space block. */
> -	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
> +	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk,
> +				   XFS_DABUF_MAP_NOMAPPING, &bp);
>  	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
>  		goto out;
>  	xchk_buffer_recheck(sc, bp);

There's also a missing xfs_dir3_data_readahead conversion in
xchk_parent_count_parent_dentries in fs/xfs/scrub/parent.c.

> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index f83f11d..9c22915 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -235,7 +235,8 @@ xfs_attr3_node_inactive(
>  		 * traversal of the tree so we may deal with many blocks
>  		 * before we come back to this one.
>  		 */
> -		error = xfs_da3_node_read(*trans, dp, child_fsb, -1, &child_bp,
> +		error = xfs_da3_node_read(*trans, dp, child_fsb,
> +					  XFS_DABUF_MAP_NOMAPPING, &child_bp,
>  					  XFS_ATTR_FORK);
>  		if (error)
>  			return error;
> @@ -321,7 +322,8 @@ xfs_attr3_root_inactive(
>  	 * the extents in reverse order the extent containing
>  	 * block 0 must still be there.
>  	 */
> -	error = xfs_da3_node_read(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
> +	error = xfs_da3_node_read(*trans, dp, 0, XFS_DABUF_MAP_NOMAPPING, &bp,
> +				  XFS_ATTR_FORK);
>  	if (error)
>  		return error;
>  	blkno = bp->b_bn;
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index c02f22d..fab416c 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -224,8 +224,9 @@ xfs_attr_node_list_lookup(
>  	ASSERT(*pbp == NULL);
>  	cursor->blkno = 0;
>  	for (;;) {
> -		error = xfs_da3_node_read(tp, dp, cursor->blkno, -1, &bp,
> -				XFS_ATTR_FORK);
> +		error = xfs_da3_node_read(tp, dp, cursor->blkno,
> +					  XFS_DABUF_MAP_NOMAPPING, &bp,
> +					  XFS_ATTR_FORK);
>  		if (error)
>  			return error;
>  		node = bp->b_addr;
> @@ -309,8 +310,9 @@ xfs_attr_node_list(
>  	 */
>  	bp = NULL;
>  	if (cursor->blkno > 0) {
> -		error = xfs_da3_node_read(context->tp, dp, cursor->blkno, -1,
> -					      &bp, XFS_ATTR_FORK);
> +		error = xfs_da3_node_read(context->tp, dp, cursor->blkno,
> +					  XFS_DABUF_MAP_NOMAPPING, &bp,
> +					  XFS_ATTR_FORK);
>  		if ((error != 0) && (error != -EFSCORRUPTED))
>  			return error;
>  		if (bp) {
> @@ -377,7 +379,8 @@ xfs_attr_node_list(
>  			break;
>  		cursor->blkno = leafhdr.forw;
>  		xfs_trans_brelse(context->tp, bp);
> -		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno, -1, &bp);
> +		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno,
> +					    XFS_DABUF_MAP_NOMAPPING, &bp);
>  		if (error)
>  			return error;
>  	}
> @@ -497,7 +500,8 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
>  	trace_xfs_attr_leaf_list(context);
>  
>  	context->cursor->blkno = 0;
> -	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, -1, &bp);
> +	error = xfs_attr3_leaf_read(context->tp, context->dp, 0,
> +				    XFS_DABUF_MAP_NOMAPPING, &bp);
>  	if (error)
>  		return error;
>  

...more missing conversions of xfs_dir3_data_read in
xfs_dir2_leaf_readbuf; and of xfs_dir3_data_readahead in
xfs_dir2_leaf_readbuf...

...and a missing conversion of xfs_dir3_data_readahead in xfs_dir_open
in fs/xfs/xfs_file.c.

--D

> -- 
> 2.7.4
> 
