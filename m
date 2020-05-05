Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35FE2C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF07A206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:45:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RP38uPQP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgEEBpD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:45:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56054 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbgEEBpD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:45:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0451iMwb117094
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=kc4AsJY3/DhSS9oa8smtK4WpJFwIy8SqeN8G07fhBZQ=;
 b=RP38uPQPZt7R1JnAWOsQtUGZBGwZ1iU0gGxTEJvkCiK6g0na9JllaatGxKyptgA8lfGp
 S0nYwiluDivpZQOw2J3V122s5A5YaJ3qYD9kZejT6IaZobiH+u6cpKD0uWexpVy0MXrq
 bCcY3ZH+x1etPiFTnOOutXIYO+0nrsg7kfMgHxbtg+Afw0jEVK0TSqDPC3aePPNmHXzW
 1fr3UoA+74u1hvcbuz5JV5GLyIHP4AkZyHD2e9H+F4sFQx9R6qkM0EhUNgitNIX99CwR
 dtd/Djxfx7wanPiSEjOf/Pe+VrYMgiFpRWorkVxuVoAu6muiFbUH3RBJKkjkiN1nB4uz vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30s0tma32a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:44:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0451feXL151187
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:44:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30t1r3skqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:44:57 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0451iuob028353
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:44:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:44:56 -0700
Date:   Mon, 4 May 2020 18:44:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 22/24] xfs: Add delay ready attr remove routines
Message-ID: <20200505014455.GP5703@magnolia>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-23-allison.henderson@oracle.com>
 <20200504193346.GI5703@magnolia>
 <fbb0138a-aa8c-a943-02ba-510e2347ae7b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fbb0138a-aa8c-a943-02ba-510e2347ae7b@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=1
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 05:26:52PM -0700, Allison Collins wrote:
> 
> 
> On 5/4/20 12:33 PM, Darrick J. Wong wrote:
> > On Thu, Apr 30, 2020 at 03:50:14PM -0700, Allison Collins wrote:
> > > This patch modifies the attr remove routines to be delay ready. This
> > > means they no longer roll or commit transactions, but instead return
> > > -EAGAIN to have the calling routine roll and refresh the transaction. In
> > > this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
> > > uses a sort of state machine like switch to keep track of where it was
> > > when EAGAIN was returned. xfs_attr_node_removename has also been
> > > modified to use the switch, and a new version of xfs_attr_remove_args
> > > consists of a simple loop to refresh the transaction until the operation
> > > is completed.  A new XFS_DAC_DEFER_FINISH flag is used to finish the
> > > transaction where ever the existing code used to.
> > > 
> > > Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> > > version __xfs_attr_rmtval_remove. We will rename
> > > __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> > > done.
> > > 
> > > xfs_attr_rmtval_remove itself is still in use by the set routines (used
> > > during a rename).  For reasons of perserving existing function, we
> > > modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
> > > set.  Similar to how xfs_attr_remove_args does here.  Once we transition
> > > the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
> > > used and will be removed.
> > > 
> > > This patch also adds a new struct xfs_delattr_context, which we will use
> > > to keep track of the current state of an attribute operation. The new
> > > xfs_delattr_state enum is used to track various operations that are in
> > > progress so that we know not to repeat them, and resume where we left
> > > off before EAGAIN was returned to cycle out the transaction. Other
> > > members take the place of local variables that need to retain their
> > > values across multiple function recalls.
> > > 
> > > Below is a state machine diagram for attr remove operations. The
> > > XFS_DAS_* states indicate places where the function would return
> > > -EAGAIN, and then immediately resume from after being recalled by the
> > > calling function.  States marked as a "subroutine state" indicate that
> > > they belong to a subroutine, and so the calling function needs to pass
> > > them back to that subroutine to allow it to finish where it left off.
> > > But they otherwise do not have a role in the calling function other than
> > > just passing through.
> > > 
> > >   xfs_attr_remove_iter()
> > >           XFS_DAS_RM_SHRINK     ─┐
> > >           (subroutine state)     │
> > >                                  └─>xfs_attr_node_removename()
> > >                                                   │
> > >                                                   v
> > >                                                need to
> > >                                             shrink tree? ─n─┐
> > >                                                   │         │
> > >                                                   y         │
> > >                                                   │         │
> > >                                                   v         │
> > >                                           XFS_DAS_RM_SHRINK │
> > >                                                   │         │
> > >                                                   v         │
> > >                                                  done <─────┘
> > > 
> > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_attr.c        | 159 ++++++++++++++++++++++++++++++----------
> > >   fs/xfs/libxfs/xfs_attr.h        |  73 ++++++++++++++++++
> > >   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
> > >   fs/xfs/libxfs/xfs_attr_remote.c |  31 ++++----
> > >   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
> > >   fs/xfs/xfs_attr_inactive.c      |   2 +-
> > >   6 files changed, 215 insertions(+), 54 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index c8cae68..7213589 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -53,12 +53,21 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> > >    */
> > >   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> > >   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> > > -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> > > +STATIC int xfs_attr_node_removename(struct xfs_delattr_context *dac);
> > >   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> > >   				 struct xfs_da_state **state);
> > >   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> > >   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> > > +void
> > > +xfs_delattr_context_init(
> > > +	struct xfs_delattr_context	*dac,
> > > +	struct xfs_da_args		*args)
> > > +{
> > > +	memset(dac, 0, sizeof(struct xfs_delattr_context));
> > > +	dac->da_args = args;
> > 
> > Couldn't this could be open coded as:
> > 
> > struct xfs_delattr_context	dac = {
> > 	.da_args		= args,
> > };
> > 
> > in the callers?  One less helper function, and it means that the stack
> > contents will always be fully initialized.
> I believe Dave had suggested the initializer back when I had dac a member of
> args instead of the other way around.  I dont know that he was too
> particular about exactly what the initializer was though.  Is this generally
> the standard for initializers?

One of them, yes. :)

I've started to prefer that form simply because we don't have to
remember that some struct is uninitialized between its definition and
some later initializer function call.  There are (many) places where
we have to unpack other things before we can initialize a struct, but
for the simpler cases I like to reduce the brainpower needed to
understand code, lest I turn into Mr. D P Gumby.

> > 
> > > +}
> > > +
> > >   int
> > >   xfs_inode_hasattr(
> > >   	struct xfs_inode	*ip)
> > > @@ -263,6 +272,18 @@ xfs_attr_set_shortform(
> > >   	return 0;
> > >   }
> > > +int xfs_attr_defer_finish(
> > 
> > static inline int
> > xfs_attr_defer_finish(
> > 
> > > +	struct xfs_delattr_context      *dac)
> > > +{
> > > +	struct xfs_da_args              *args = dac->da_args;
> > > +
> > > +	if (!(dac->flags & XFS_DAC_DEFER_FINISH))
> > > +		return 0;
> > > +
> > > +	dac->flags &= ~XFS_DAC_DEFER_FINISH;
> > > +	return xfs_defer_finish(&args->trans);
> > 
> > I also wonder if you want to hoist the trans_roll_inode to here too?
> > 
> > Actually, what if this instead became:
> > 
> > static inline bool
> > xfs_attr_roll_again(
> > 	struct xfs_delattr_context	*dac,
> > 	int				*error)
> > {
> > 	if (*error != -EAGAIN)
> > 		return false;
> > 
> > 	if (dac->flags & XFS_DAC_DEFER_FINISH)) {
> > 		dac->flags &= ~XFS_DAC_DEFER_FINISH;
> > 		*error = xfs_defer_finish(&args->trans);
> > 		if (*error)
> > 			return false;
> > 	}
> > 
> > 	*error = xfs_trans_roll_inode(&dac->da_args->trans, dac->da_args->dp);
> > 	return *error == 0;
> > }
> > 
> Sure, that should be fine
> 
> > > +}
> > > +
> > >   /*
> > >    * Set the attribute specified in @args.
> > >    */
> > > @@ -363,23 +384,57 @@ xfs_has_attr(
> > >    */
> > >   int
> > >   xfs_attr_remove_args(
> > > -	struct xfs_da_args      *args)
> > > +	struct xfs_da_args	*args)
> > > +{
> > > +	int			error = 0;
> > > +	struct			xfs_delattr_context dac;
> > > +
> > > +	xfs_delattr_context_init(&dac, args);
> > > +
> > > +	do {
> > > +		error = xfs_attr_remove_iter(&dac);
> > > +		if (error != -EAGAIN)
> > > +			break;
> > > +
> > > +		error = xfs_attr_defer_finish(&dac);
> > > +		if (error)
> > > +			break;
> > > +
> > > +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> > > +		if (error)
> > > +			break;
> > > +	} while (true);
> > 
> > and then this whole function becomes:
> > 
> > int
> > xfs_attr_remove_args(
> > 	struct xfs_da_args		*args)
> > {
> > 	struct xfs_delattr_context	dac = {
> > 		.da_args		= args,
> > 	};
> > 
> > 	do {
> > 		error = xfs_attr_remove_iter(&dac);
> > 	} while (xfs_attr_roll_again(&dac, &error));
> > 
> > 	return error;
> > }
> Alrighty then
> 
> > 
> > > +
> > > +	return error;
> > > +}
> > > +
> > > +/*
> > > + * Remove the attribute specified in @args.
> > > + *
> > > + * This function may return -EAGAIN to signal that the transaction needs to be
> > > + * rolled.  Callers should continue calling this function until they receive a
> > > + * return value other than -EAGAIN.
> > > + */
> > > +int
> > > +xfs_attr_remove_iter(
> > > +	struct xfs_delattr_context *dac)
> > >   {
> > > +	struct xfs_da_args	*args = dac->da_args;
> > >   	struct xfs_inode	*dp = args->dp;
> > > -	int			error;
> > > +
> > > +	if (dac->dela_state == XFS_DAS_RM_SHRINK)
> > > +		goto node;
> > >   	if (!xfs_inode_hasattr(dp)) {
> > > -		error = -ENOATTR;
> > > +		return -ENOATTR;
> > >   	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> > >   		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> > > -		error = xfs_attr_shortform_remove(args);
> > > +		return xfs_attr_shortform_remove(args);
> > >   	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> > > -		error = xfs_attr_leaf_removename(args);
> > > -	} else {
> > > -		error = xfs_attr_node_removename(args);
> > > +		return xfs_attr_leaf_removename(args);
> > >   	}
> > > -
> > > -	return error;
> > > +node:
> > > +	return  xfs_attr_node_removename(dac);
> > >   }
> > >   /*
> > > @@ -1177,15 +1232,17 @@ xfs_attr_leaf_mark_incomplete(
> > >   /*
> > >    * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
> > > - * the blocks are valid.  Any remote blocks will be marked incomplete.
> > > + * the blocks are valid.  Any remote blocks will be marked incomplete and
> > > + * invalidated.
> > >    */
> > >   STATIC
> > >   int xfs_attr_node_removename_setup(
> > > -	struct xfs_da_args	*args,
> > > -	struct xfs_da_state	**state)
> > > +	struct xfs_delattr_context	*dac,
> > > +	struct xfs_da_state		**state)
> > >   {
> > > -	int			error;
> > > -	struct xfs_da_state_blk	*blk;
> > > +	struct xfs_da_args		*args = dac->da_args;
> > > +	int				error;
> > > +	struct xfs_da_state_blk		*blk;
> > >   	error = xfs_attr_node_hasname(args, state);
> > >   	if (error != -EEXIST)
> > > @@ -1195,6 +1252,13 @@ int xfs_attr_node_removename_setup(
> > >   	ASSERT(blk->bp != NULL);
> > >   	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> > > +	/*
> > > +	 * Store blk and state in the context incase we need to cycle out the
> > > +	 * transaction
> > > +	 */
> > > +	dac->blk = blk;
> > > +	dac->da_state = *state;
> > > +
> > >   	if (args->rmtblkno > 0) {
> > >   		error = xfs_attr_leaf_mark_incomplete(args, *state);
> > >   		if (error)
> > > @@ -1210,12 +1274,15 @@ int xfs_attr_node_removename_setup(
> > >   STATIC int
> > >   xfs_attr_node_removename_rmt (
> > > -	struct xfs_da_args	*args,
> > > -	struct xfs_da_state	*state)
> > > +	struct xfs_delattr_context	*dac,
> > > +	struct xfs_da_state		*state)
> > >   {
> > > -	int			error = 0;
> > > +	int				error = 0;
> > > -	error = xfs_attr_rmtval_remove(args);
> > > +	/*
> > > +	 * May return -EAGAIN to request that the caller recall this function
> > > +	 */
> > > +	error = __xfs_attr_rmtval_remove(dac);
> > >   	if (error)
> > >   		return error;
> > > @@ -1232,21 +1299,35 @@ xfs_attr_node_removename_rmt (
> > >    * This will involve walking down the Btree, and may involve joining
> > >    * leaf nodes and even joining intermediate nodes up to and including
> > >    * the root node (a special case of an intermediate node).
> > > + *
> > > + * This routine is meant to function as either an inline or delayed operation,
> > > + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
> > > + * functions will need to handle this, and recall the function until a
> > > + * successful error code is returned.
> > >    */
> > >   STATIC int
> > >   xfs_attr_node_removename(
> > > -	struct xfs_da_args	*args)
> > > +	struct xfs_delattr_context	*dac)
> > >   {
> > > -	struct xfs_da_state	*state;
> > > -	struct xfs_da_state_blk	*blk;
> > > -	int			retval, error;
> > > -	struct xfs_inode	*dp = args->dp;
> > > +	struct xfs_da_args		*args = dac->da_args;
> > > +	struct xfs_da_state		*state;
> > > +	struct xfs_da_state_blk		*blk;
> > > +	int				retval, error;
> > > +	struct xfs_inode		*dp = args->dp;
> > >   	trace_xfs_attr_node_removename(args);
> > > +	state = dac->da_state;
> > > +	blk = dac->blk;
> > > -	error = xfs_attr_node_removename_setup(args, &state);
> > > -	if (error)
> > > -		goto out;
> > > +	if (dac->dela_state == XFS_DAS_RM_SHRINK)
> > > +		goto das_rm_shrink;
> > > +
> > > +	if ((dac->flags & XFS_DAC_NODE_RMVNAME_INIT) == 0) {
> > > +		dac->flags |= XFS_DAC_NODE_RMVNAME_INIT;
> > > +		error = xfs_attr_node_removename_setup(dac, &state);
> > 
> > Shouldn't XFS_DAC_NODE_RMVNAME_INIT be set by
> > xfs_attr_node_removename_setup?
> I suppose it could be.  Initially this was a state not a flag, so that's why
> we see it here in this scope.
> 
> There may be reason to keep it there though.  These -EAGAIN functions are
> admittadly sort of jumpy, so when trying to trace them though, haveing the
> flag in the top level like that makes it clear that when we come back
> through on another iteration, we dont init twice.  Really, it's more to do
> with managing function re-entry than anything else going on in the init
> function.  I think Brian and I have been trying our best to keep code flow
> craziness in the same scope rather than letting them get burried in
> subfunctions.  Though I suppose it wouldnt be too hard to find if folks
> prefer the flag be in the subfunction?

Hm, ok, leave it there then. :)

> 
> 
> > 
> > > +		if (error)
> > > +			goto out;
> > > +	}
> > >   	/*
> > >   	 * If there is an out-of-line value, de-allocate the blocks.
> > > @@ -1254,8 +1335,13 @@ xfs_attr_node_removename(
> > >   	 * overflow the maximum size of a transaction and/or hit a deadlock.
> > >   	 */
> > >   	if (args->rmtblkno > 0) {
> > > -		error = xfs_attr_node_removename_rmt(args, state);
> > > -		if (error)
> > > +		/*
> > > +		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
> > > +		 */
> > > +		error = xfs_attr_node_removename_rmt(dac, state);
> > > +		if (error == -EAGAIN)
> > > +			return error;
> > > +		else if (error)
> > >   			goto out;
> > >   	}
> > > @@ -1274,17 +1360,14 @@ xfs_attr_node_removename(
> > >   		error = xfs_da3_join(state);
> > >   		if (error)
> > >   			goto out;
> > > -		error = xfs_defer_finish(&args->trans);
> > > -		if (error)
> > > -			goto out;
> > > -		/*
> > > -		 * Commit the Btree join operation and start a new trans.
> > > -		 */
> > > -		error = xfs_trans_roll_inode(&args->trans, dp);
> > > -		if (error)
> > > -			goto out;
> > > +
> > > +		dac->flags |= XFS_DAC_DEFER_FINISH;
> > > +		dac->dela_state = XFS_DAS_RM_SHRINK;
> > > +		return -EAGAIN;
> > >   	}
> > > +das_rm_shrink:
> > > +
> > >   	/*
> > >   	 * If the result is small enough, push it all into the inode.
> > >   	 */
> > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > index 66575b8..0430c79 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > @@ -74,6 +74,75 @@ struct xfs_attr_list_context {
> > >   };
> > > +/*
> > > + * ========================================================================
> > > + * Structure used to pass context around among the delayed routines.
> > > + * ========================================================================
> > > + */
> > > +
> > > +/*
> > > + * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
> > > + * states indicate places where the function would return -EAGAIN, and then
> > > + * immediately resume from after being recalled by the calling function. States
> > > + * marked as a "subroutine state" indicate that they belong to a subroutine, and
> > > + * so the calling function needs to pass them back to that subroutine to allow
> > > + * it to finish where it left off. But they otherwise do not have a role in the
> > > + * calling function other than just passing through.
> > > + *
> > > + * xfs_attr_remove_iter()
> > > + *	  XFS_DAS_RM_SHRINK ─┐
> > > + *	  (subroutine state) │
> > > + *	                     └─>xfs_attr_node_removename()
> > > + *	                                      │
> > > + *	                                      v
> > > + *	                                   need to
> > > + *	                                shrink tree? ─n─┐
> > > + *	                                      │         │
> > > + *	                                      y         │
> > > + *	                                      │         │
> > > + *	                                      v         │
> > > + *	                              XFS_DAS_RM_SHRINK │
> > > + *	                                      │         │
> > > + *	                                      v         │
> > > + *	                                     done <─────┘
> > > + *
> > > + */
> > > +
> > > +/*
> > > + * Enum values for xfs_delattr_context.da_state
> > > + *
> > > + * These values are used by delayed attribute operations to keep track  of where
> > > + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
> > > + * calling function to roll the transaction, and then recall the subroutine to
> > > + * finish the operation.  The enum is then used by the subroutine to jump back
> > > + * to where it was and resume executing where it left off.
> > > + */
> > > +enum xfs_delattr_state {
> > > +				      /* Zero is uninitalized */
> > > +	XFS_DAS_RM_SHRINK	= 1,  /* We are shrinking the tree */
> > > +};
> > > +
> > > +/*
> > > + * Defines for xfs_delattr_context.flags
> > > + */
> > > +#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
> > > +#define XFS_DAC_NODE_RMVNAME_INIT	0x02 /* xfs_attr_node_removename init */
> > > +
> > > +/*
> > > + * Context used for keeping track of delayed attribute operations
> > > + */
> > > +struct xfs_delattr_context {
> > > +	struct xfs_da_args      *da_args;
> > > +
> > > +	/* Used in xfs_attr_node_removename to roll through removing blocks */
> > > +	struct xfs_da_state     *da_state;
> > > +	struct xfs_da_state_blk *blk;
> > > +
> > > +	/* Used to keep track of current state of delayed operation */
> > > +	unsigned int            flags;
> > > +	enum xfs_delattr_state  dela_state;
> > > +};
> > > +
> > >   /*========================================================================
> > >    * Function prototypes for the kernel.
> > >    *========================================================================*/
> > > @@ -91,6 +160,10 @@ int xfs_attr_set(struct xfs_da_args *args);
> > >   int xfs_attr_set_args(struct xfs_da_args *args);
> > >   int xfs_has_attr(struct xfs_da_args *args);
> > >   int xfs_attr_remove_args(struct xfs_da_args *args);
> > > +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
> > > +int xfs_attr_defer_finish(struct xfs_delattr_context *dac);
> > >   bool xfs_attr_namecheck(const void *name, size_t length);
> > > +void xfs_delattr_context_init(struct xfs_delattr_context *dac,
> > > +			      struct xfs_da_args *args);
> > >   #endif	/* __XFS_ATTR_H__ */
> > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > index f55402b..2e36c8b 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > @@ -19,8 +19,8 @@
> > >   #include "xfs_bmap_btree.h"
> > >   #include "xfs_bmap.h"
> > >   #include "xfs_attr_sf.h"
> > > -#include "xfs_attr_remote.h"
> > >   #include "xfs_attr.h"
> > > +#include "xfs_attr_remote.h"
> > >   #include "xfs_attr_leaf.h"
> > >   #include "xfs_error.h"
> > >   #include "xfs_trace.h"
> > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > > index f770159..f2d46c7 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > > @@ -676,14 +676,16 @@ xfs_attr_rmtval_invalidate(
> > >    */
> > >   int
> > >   xfs_attr_rmtval_remove(
> > > -	struct xfs_da_args      *args)
> > > +	struct xfs_da_args		*args)
> > >   {
> > > -	xfs_dablk_t		lblkno;
> > > -	int			blkcnt;
> > > -	int			error = 0;
> > > -	int			retval = 0;
> > > +	struct xfs_delattr_context	dac;
> > > +	xfs_dablk_t			lblkno;
> > > +	int				blkcnt;
> > > +	int				error = 0;
> > > +	int				retval = 0;
> > >   	trace_xfs_attr_rmtval_remove(args);
> > > +	xfs_delattr_context_init(&dac, args);
> > >   	/*
> > >   	 * Keep de-allocating extents until the remote-value region is gone.
> > > @@ -691,10 +693,14 @@ xfs_attr_rmtval_remove(
> > >   	lblkno = args->rmtblkno;
> > >   	blkcnt = args->rmtblkcnt;
> > >   	do {
> > > -		retval = __xfs_attr_rmtval_remove(args);
> > > +		retval = __xfs_attr_rmtval_remove(&dac);
> > >   		if (retval && retval != EAGAIN)
> > >   			return retval;
> > > +		error = xfs_attr_defer_finish(&dac);
> > > +		if (error)
> > > +			break;
> > > +
> > >   		/*
> > >   		 * Close out trans and start the next one in the chain.
> > >   		 */
> > > @@ -713,9 +719,10 @@ xfs_attr_rmtval_remove(
> > >    */
> > >   int
> > >   __xfs_attr_rmtval_remove(
> > > -	struct xfs_da_args	*args)
> > > +	struct xfs_delattr_context	*dac)
> > >   {
> > > -	int			error, done;
> > > +	struct xfs_da_args		*args = dac->da_args;
> > > +	int				error, done;
> > >   	/*
> > >   	 * Unmap value blocks for this attr.
> > > @@ -725,12 +732,10 @@ __xfs_attr_rmtval_remove(
> > >   	if (error)
> > >   		return error;
> > > -	error = xfs_defer_finish(&args->trans);
> > > -	if (error)
> > > -		return error;
> > > -
> > > -	if (!done)
> > > +	if (!done) {
> > > +		dac->flags &= ~XFS_DAC_DEFER_FINISH;
> > 
> > Why do we strip off DEFER_FINISH here?  Is it because we're making
> > xfs_attr_rmtval_remove invoke xfs_defer_finish unconditionally to clear
> > out any pending rmap items?
> Sorry, that should have been a flag set, not a strip.  Will fix!
> 
> > 
> > If you transformed the do-while loop in xfs_attr_rmtval_remove to use
> > xfs_attr_roll_again, then you could make this set DEFER_FINISH, which
> > would make me a lot less suspicious that we're dropping state here.
> > 
> > (It would also clean up a lot of the defer_finish -> trans_roll_inode
> > code that's scattering everywhere...)
> Yes, will do that.  Thanks for the review!

:D

--D

> > 
> > --D
> > 
> > >   		return -EAGAIN;
> > > +	}
> > >   	return error;
> > >   }
> > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> > > index ee3337b..351da00 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_remote.h
> > > +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> > > @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> > >   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
> > >   		xfs_buf_flags_t incore_flags);
> > >   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> > > -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
> > > +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
> > >   #endif /* __XFS_ATTR_REMOTE_H__ */
> > > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> > > index c42f90e..b2150fa 100644
> > > --- a/fs/xfs/xfs_attr_inactive.c
> > > +++ b/fs/xfs/xfs_attr_inactive.c
> > > @@ -15,10 +15,10 @@
> > >   #include "xfs_da_format.h"
> > >   #include "xfs_da_btree.h"
> > >   #include "xfs_inode.h"
> > > +#include "xfs_attr.h"
> > >   #include "xfs_attr_remote.h"
> > >   #include "xfs_trans.h"
> > >   #include "xfs_bmap.h"
> > > -#include "xfs_attr.h"
> > >   #include "xfs_attr_leaf.h"
> > >   #include "xfs_quota.h"
> > >   #include "xfs_dir2.h"
> > > -- 
> > > 2.7.4
> > > 
