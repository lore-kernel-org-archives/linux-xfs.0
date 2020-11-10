Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BD9C388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 21:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE18207D3
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 21:57:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UmncTD+0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgKJV5I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 16:57:08 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52332 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgKJV5I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 16:57:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AALe5ld095433;
        Tue, 10 Nov 2020 21:57:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=oKpREjsxy3mv10+J+cdG5CZzMFLaJoFEc0ALb7w5hEI=;
 b=UmncTD+0hbBaqpONovdEcvR6+3QMqz4XJU9Wly8VWAxYThKUla63E3/06UTARW61aSoB
 aYlp1mDlFQHSLFBK48bHeYHF+O9fMGFyzbvy4FuEQ9wee70NrMldUZPmeUzuz0Lb4Yly
 Hw5cS++KxfE0/HLiPtxkrUFB6eNibAkBJJWIDtVucUqkJnHfyGrdx7S7sAhB5OVgDwE0
 3wp8CjAHB34jnNTSDf3b4tdKumT0BamZDpjI9wBMdUFvDO71iuVHLXdprXhr66PNn9vZ
 tbpVCzIaqU/e/qSxBevwHLjQ04ZFaLFPvcNd175LbJzdoTQL42Ab+tncpAcxrVrNn9FZ Yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3axcx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 21:57:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AALf5ko084190;
        Tue, 10 Nov 2020 21:57:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34qgp7exm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 21:57:05 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AALv3Ma007502;
        Tue, 10 Nov 2020 21:57:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 13:57:03 -0800
Date:   Tue, 10 Nov 2020 13:57:02 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 03/10] xfs: Add delay ready attr set routines
Message-ID: <20201110215702.GH9695@magnolia>
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-4-allison.henderson@oracle.com>
 <534604869.YD8572SIOA@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534604869.YD8572SIOA@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=1 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=1
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 07:02:55PM +0530, Chandan Babu R wrote:
> On Friday 23 October 2020 12:04:28 PM IST Allison Henderson wrote:
> > This patch modifies the attr set routines to be delay ready. This means
> > they no longer roll or commit transactions, but instead return -EAGAIN
> > to have the calling routine roll and refresh the transaction.  In this
> > series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
> > state machine like switch to keep track of where it was when EAGAIN was
> > returned. See xfs_attr.h for a more detailed diagram of the states.
> > 
> > Two new helper functions have been added: xfs_attr_rmtval_set_init and
> > xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
> > xfs_attr_rmtval_set, but they store the current block in the delay attr
> > context to allow the caller to roll the transaction between allocations.
> > This helps to simplify and consolidate code used by
> > xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
> > now become a simple loop to refresh the transaction until the operation
> > is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
> > removed.
> 
> One nit. xfs_attr_rmtval_remove()'s prototype declaration needs to be removed
> from xfs_attr_remote.h.
> 
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c        | 370 ++++++++++++++++++++++++++--------------
> >  fs/xfs/libxfs/xfs_attr.h        | 126 +++++++++++++-
> >  fs/xfs/libxfs/xfs_attr_remote.c |  99 +++++++----
> >  fs/xfs/libxfs/xfs_attr_remote.h |   4 +
> >  fs/xfs/xfs_trace.h              |   1 -
> >  5 files changed, 439 insertions(+), 161 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 6ca94cb..95c98d7 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -44,7 +44,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
> >   * Internal routines when attribute list is one block.
> >   */
> >  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> > -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> > +STATIC int xfs_attr_leaf_addname(struct xfs_delattr_context *dac);
> >  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> >  STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> >  
> > @@ -52,12 +52,15 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> >   * Internal routines when attribute list is more than one block.
> >   */
> >  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> > -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> > +STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
> >  STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
> >  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> >  				 struct xfs_da_state **state);
> >  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> >  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> > +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
> > +STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
> > +			     struct xfs_buf **leaf_bp);
> >  
> >  int
> >  xfs_inode_hasattr(
> > @@ -218,8 +221,11 @@ xfs_attr_is_shortform(
> >  
> >  /*
> >   * Attempts to set an attr in shortform, or converts short form to leaf form if
> > - * there is not enough room.  If the attr is set, the transaction is committed
> > - * and set to NULL.
> > + * there is not enough room.  This function is meant to operate as a helper
> > + * routine to the delayed attribute functions.  It returns -EAGAIN to indicate
> > + * that the calling function should roll the transaction, and then proceed to
> > + * add the attr in leaf form.  This subroutine does not expect to be recalled
> > + * again like the other delayed attr routines do.
> >   */
> >  STATIC int
> >  xfs_attr_set_shortform(
> > @@ -227,16 +233,16 @@ xfs_attr_set_shortform(
> >  	struct xfs_buf		**leaf_bp)
> >  {
> >  	struct xfs_inode	*dp = args->dp;
> > -	int			error, error2 = 0;
> > +	int			error = 0;
> >  
> >  	/*
> >  	 * Try to add the attr to the attribute list in the inode.
> >  	 */
> >  	error = xfs_attr_try_sf_addname(dp, args);
> > +
> > +	/* Should only be 0, -EEXIST or ENOSPC */
> >  	if (error != -ENOSPC) {
> > -		error2 = xfs_trans_commit(args->trans);
> > -		args->trans = NULL;
> > -		return error ? error : error2;
> > +		return error;
> >  	}
> >  	/*
> >  	 * It won't fit in the shortform, transform to a leaf block.  GROT:
> > @@ -249,18 +255,10 @@ xfs_attr_set_shortform(
> >  	/*
> >  	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
> >  	 * push cannot grab the half-baked leaf buffer and run into problems
> > -	 * with the write verifier. Once we're done rolling the transaction we
> > -	 * can release the hold and add the attr to the leaf.
> > +	 * with the write verifier.
> >  	 */
> >  	xfs_trans_bhold(args->trans, *leaf_bp);
> > -	error = xfs_defer_finish(&args->trans);
> > -	xfs_trans_bhold_release(args->trans, *leaf_bp);
> > -	if (error) {
> > -		xfs_trans_brelse(args->trans, *leaf_bp);
> > -		return error;
> > -	}
> > -
> > -	return 0;
> > +	return -EAGAIN;
> >  }
> >  
> >  /*
> > @@ -268,7 +266,7 @@ xfs_attr_set_shortform(
> >   * also checks for a defer finish.  Transaction is finished and rolled as
> >   * needed, and returns true of false if the delayed operation should continue.
> >   */
> > -int
> > +STATIC int
> >  xfs_attr_trans_roll(
> >  	struct xfs_delattr_context	*dac)
> >  {
> > @@ -297,61 +295,130 @@ int
> >  xfs_attr_set_args(
> >  	struct xfs_da_args	*args)
> >  {
> > -	struct xfs_inode	*dp = args->dp;
> > -	struct xfs_buf          *leaf_bp = NULL;
> > -	int			error = 0;
> > +	struct xfs_buf			*leaf_bp = NULL;
> > +	int				error = 0;
> > +	struct xfs_delattr_context	dac = {
> > +		.da_args	= args,
> > +	};
> > +
> > +	do {
> > +		error = xfs_attr_set_iter(&dac, &leaf_bp);
> > +		if (error != -EAGAIN)
> > +			break;
> > +
> > +		error = xfs_attr_trans_roll(&dac);
> > +		if (error)
> > +			return error;
> > +
> > +		if (leaf_bp) {
> > +			xfs_trans_bjoin(args->trans, leaf_bp);
> > +			xfs_trans_bhold(args->trans, leaf_bp);
> > +		}
> 
> When xfs_attr_set_iter() causes a "short form" attribute list to be converted
> to "leaf form", leaf_bp would point to an xfs_buf which has been added to the
> transaction and also XFS_BLI_HOLD flag is set on the buffer (last statement in
> xfs_attr_set_shortform()). XFS_BLI_HOLD flag makes sure that the new
> transaction allocated by xfs_attr_trans_roll() would continue to have leaf_bp
> in the transaction's item list. Hence I think the above calls to
> xfs_trans_bjoin() and xfs_trans_bhold() are not required.

I /think/ the defer ops will rejoin the buffer each time it rolls, which
means that xfs_attr_trans_roll returns with the buffer already joined to
the transaction?  And I think you're right that the bhold isn't needed,
because holding is dictated by the lower levels (i.e. _set_iter).

> Please let me know if I am missing something obvious here.

The entire function goes away by the end of the series. :)

--D

> 
> -- 
> chandan
> 
> 
> 
