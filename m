Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D187C388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 23:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C4E720781
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 23:17:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JviwwY71"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbgKJXR6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 18:17:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46784 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730894AbgKJXR5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 18:17:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AANGHqm165759;
        Tue, 10 Nov 2020 23:17:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=ZzFRJEe7vQGY/ZILHVlUbSWeJuINS/unfTnf0GFHqfo=;
 b=JviwwY71WdIMmmis6XVdTOuqwwQWHnhhgqS2u4ZL7zL1mLblU7k6dKsEwjTwM105nrZ8
 dHxaTx5hc0Tv5pAsnhHd4Kl4e1QibGy+nwLXCeDtDekECkYuwovpbjz0j90yBeYTr2j+
 rZ93/HUrLeSRO8u7ensZm9Wg8bLHe8Akc7TSIa82Ki+JJDToaKlYasTiEd3+Xqdd2EEA
 69BKsmp05iDH5XXaWbTOTeDFZ8DguP1rqj3Fd8zbyob02V1tf7ZVkaL2rzEteKVOILdi
 MtbvSLEMAv0LHp/aIvGlh3CZzgdBsZeHDPWRUnNICBW9lsilJP4G0ItvEwV2LIZ2xfeG Rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhkxec8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 23:17:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AANFEfY075220;
        Tue, 10 Nov 2020 23:15:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34p55p8hv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 23:15:53 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AANFqk5025129;
        Tue, 10 Nov 2020 23:15:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 15:15:51 -0800
Date:   Tue, 10 Nov 2020 15:15:50 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 02/10] xfs: Add delay ready attr remove routines
Message-ID: <20201110231550.GK9695@magnolia>
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-3-allison.henderson@oracle.com>
 <20201027121645.GB1560077@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201027121645.GB1560077@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100156
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 08:16:45AM -0400, Brian Foster wrote:
> On Thu, Oct 22, 2020 at 11:34:27PM -0700, Allison Henderson wrote:
> > This patch modifies the attr remove routines to be delay ready. This
> > means they no longer roll or commit transactions, but instead return
> > -EAGAIN to have the calling routine roll and refresh the transaction. In
> > this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
> > uses a sort of state machine like switch to keep track of where it was
> > when EAGAIN was returned. xfs_attr_node_removename has also been
> > modified to use the switch, and a new version of xfs_attr_remove_args
> > consists of a simple loop to refresh the transaction until the operation
> > is completed.  A new XFS_DAC_DEFER_FINISH flag is used to finish the
> > transaction where ever the existing code used to.
> > 
> > Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> > version __xfs_attr_rmtval_remove. We will rename
> > __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> > done.
> > 
> > xfs_attr_rmtval_remove itself is still in use by the set routines (used
> > during a rename).  For reasons of preserving existing function, we
> > modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
> > set.  Similar to how xfs_attr_remove_args does here.  Once we transition
> > the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
> > used and will be removed.
> > 
> > This patch also adds a new struct xfs_delattr_context, which we will use
> > to keep track of the current state of an attribute operation. The new
> > xfs_delattr_state enum is used to track various operations that are in
> > progress so that we know not to repeat them, and resume where we left
> > off before EAGAIN was returned to cycle out the transaction. Other
> > members take the place of local variables that need to retain their
> > values across multiple function recalls.  See xfs_attr.h for a more
> > detailed diagram of the states.
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c        | 200 +++++++++++++++++++++++++++++-----------
> >  fs/xfs/libxfs/xfs_attr.h        |  72 +++++++++++++++
> >  fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
> >  fs/xfs/libxfs/xfs_attr_remote.c |  37 ++++----
> >  fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
> >  fs/xfs/xfs_attr_inactive.c      |   2 +-
> >  6 files changed, 241 insertions(+), 74 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index f4d39bf..6ca94cb 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
<snip>
> > @@ -1282,31 +1356,53 @@ xfs_attr_node_remove_step(
> >   *
> >   * This routine will find the blocks of the name to remove, remove them and
> >   * shirnk the tree if needed.
> > + *
> > + * This routine is meant to function as either an inline or delayed operation,
> > + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
> > + * functions will need to handle this, and recall the function until a
> > + * successful error code is returned.
> >   */
> >  STATIC int
> > -xfs_attr_node_removename(
> > -	struct xfs_da_args	*args)
> > +xfs_attr_node_removename_iter(
> > +	struct xfs_delattr_context	*dac)
> >  {
> > -	struct xfs_da_state	*state;
> > -	int			error;
> > -	struct xfs_inode	*dp = args->dp;
> > +	struct xfs_da_args		*args = dac->da_args;
> > +	struct xfs_da_state		*state;
> > +	int				error;
> > +	struct xfs_inode		*dp = args->dp;
> >  
> >  	trace_xfs_attr_node_removename(args);
> > +	state = dac->da_state;
> >  
> > -	error = xfs_attr_node_removename_setup(args, &state);
> > -	if (error)
> > -		goto out;
> > +	if ((dac->flags & XFS_DAC_NODE_RMVNAME_INIT) == 0) {
> > +		dac->flags |= XFS_DAC_NODE_RMVNAME_INIT;
> > +		error = xfs_attr_node_removename_setup(dac, &state);
> > +		if (error)
> > +			goto out;
> > +	}
> >  
> > -	error = xfs_attr_node_remove_step(args, state);
> > -	if (error)
> > -		goto out;
> > +	switch (dac->dela_state) {
> > +	case XFS_DAS_UNINIT:
> > +		error = xfs_attr_node_remove_step(dac);
> > +		if (error)
> > +			break;
> >  
> 
> I think there's a bit more preliminary refactoring to do here to isolate
> the state management to this one function. I.e., from the discussion on
> the previous version, we'd ideally pull the logic that checks for the
> subsequent shrink state out of xfs_attr_node_remove_step() and lift it
> into this branch. See the pseudocode in the previous discussion for an
> example of what I mean:
> 
>   https://lore.kernel.org/linux-xfs/20200901170020.GC174813@bfoster/
> 
> The general goal of that is to refactor the existing code such that all
> of the state transitions and whatnot are shown in one place and the rest
> is broken down into smaller functional helpers.

Agreed.

--D

> Brian
> 
> > -	/*
> > -	 * If the result is small enough, push it all into the inode.
> > -	 */
> > -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> > -		error = xfs_attr_node_shrink(args, state);
> > +		/* do not break, proceed to shrink if needed */
> > +	case XFS_DAS_RM_SHRINK:
> > +		/*
> > +		 * If the result is small enough, push it all into the inode.
> > +		 */
> > +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> > +			error = xfs_attr_node_shrink(args, state);
> >  
> > +		break;
> > +	default:
> > +		ASSERT(0);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (error == -EAGAIN)
> > +		return error;
> >  out:
> >  	if (state)
> >  		xfs_da_state_free(state);
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index 3e97a93..64dcf0f 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -74,6 +74,74 @@ struct xfs_attr_list_context {
> >  };
> >  
> >  
> > +/*
> > + * ========================================================================
> > + * Structure used to pass context around among the delayed routines.
> > + * ========================================================================
> > + */
> > +
> > +/*
> > + * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
> > + * states indicate places where the function would return -EAGAIN, and then
> > + * immediately resume from after being recalled by the calling function. States
> > + * marked as a "subroutine state" indicate that they belong to a subroutine, and
> > + * so the calling function needs to pass them back to that subroutine to allow
> > + * it to finish where it left off. But they otherwise do not have a role in the
> > + * calling function other than just passing through.
> > + *
> > + * xfs_attr_remove_iter()
> > + *	  XFS_DAS_RM_SHRINK ─┐
> > + *	  (subroutine state) │
> > + *	                     └─>xfs_attr_node_removename()
> > + *	                                      │
> > + *	                                      v
> > + *	                                   need to
> > + *	                                shrink tree? ─n─┐
> > + *	                                      │         │
> > + *	                                      y         │
> > + *	                                      │         │
> > + *	                                      v         │
> > + *	                              XFS_DAS_RM_SHRINK │
> > + *	                                      │         │
> > + *	                                      v         │
> > + *	                                     done <─────┘
> > + *
> > + */
> > +
> > +/*
> > + * Enum values for xfs_delattr_context.da_state
> > + *
> > + * These values are used by delayed attribute operations to keep track  of where
> > + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
> > + * calling function to roll the transaction, and then recall the subroutine to
> > + * finish the operation.  The enum is then used by the subroutine to jump back
> > + * to where it was and resume executing where it left off.
> > + */
> > +enum xfs_delattr_state {
> > +	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
> > +	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
> > +};
> > +
> > +/*
> > + * Defines for xfs_delattr_context.flags
> > + */
> > +#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
> > +#define XFS_DAC_NODE_RMVNAME_INIT	0x02 /* xfs_attr_node_removename init */
> > +
> > +/*
> > + * Context used for keeping track of delayed attribute operations
> > + */
> > +struct xfs_delattr_context {
> > +	struct xfs_da_args      *da_args;
> > +
> > +	/* Used in xfs_attr_node_removename to roll through removing blocks */
> > +	struct xfs_da_state     *da_state;
> > +
> > +	/* Used to keep track of current state of delayed operation */
> > +	unsigned int            flags;
> > +	enum xfs_delattr_state  dela_state;
> > +};
> > +
> >  /*========================================================================
> >   * Function prototypes for the kernel.
> >   *========================================================================*/
> > @@ -91,6 +159,10 @@ int xfs_attr_set(struct xfs_da_args *args);
> >  int xfs_attr_set_args(struct xfs_da_args *args);
> >  int xfs_has_attr(struct xfs_da_args *args);
> >  int xfs_attr_remove_args(struct xfs_da_args *args);
> > +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
> > +int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
> >  bool xfs_attr_namecheck(const void *name, size_t length);
> > +void xfs_delattr_context_init(struct xfs_delattr_context *dac,
> > +			      struct xfs_da_args *args);
> >  
> >  #endif	/* __XFS_ATTR_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index bb128db..338377e 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -19,8 +19,8 @@
> >  #include "xfs_bmap_btree.h"
> >  #include "xfs_bmap.h"
> >  #include "xfs_attr_sf.h"
> > -#include "xfs_attr_remote.h"
> >  #include "xfs_attr.h"
> > +#include "xfs_attr_remote.h"
> >  #include "xfs_attr_leaf.h"
> >  #include "xfs_error.h"
> >  #include "xfs_trace.h"
> > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > index 48d8e9c..1426c15 100644
> > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > @@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
> >   */
> >  int
> >  xfs_attr_rmtval_remove(
> > -	struct xfs_da_args      *args)
> > +	struct xfs_da_args		*args)
> >  {
> > -	int			error;
> > -	int			retval;
> > +	int				error;
> > +	struct xfs_delattr_context	dac  = {
> > +		.da_args	= args,
> > +	};
> >  
> >  	trace_xfs_attr_rmtval_remove(args);
> >  
> > @@ -685,19 +687,17 @@ xfs_attr_rmtval_remove(
> >  	 * Keep de-allocating extents until the remote-value region is gone.
> >  	 */
> >  	do {
> > -		retval = __xfs_attr_rmtval_remove(args);
> > -		if (retval && retval != -EAGAIN)
> > -			return retval;
> > +		error = __xfs_attr_rmtval_remove(&dac);
> > +		if (error != -EAGAIN)
> > +			break;
> >  
> > -		/*
> > -		 * Close out trans and start the next one in the chain.
> > -		 */
> > -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> > +		error = xfs_attr_trans_roll(&dac);
> >  		if (error)
> >  			return error;
> > -	} while (retval == -EAGAIN);
> >  
> > -	return 0;
> > +	} while (true);
> > +
> > +	return error;
> >  }
> >  
> >  /*
> > @@ -707,9 +707,10 @@ xfs_attr_rmtval_remove(
> >   */
> >  int
> >  __xfs_attr_rmtval_remove(
> > -	struct xfs_da_args	*args)
> > +	struct xfs_delattr_context	*dac)
> >  {
> > -	int			error, done;
> > +	struct xfs_da_args		*args = dac->da_args;
> > +	int				error, done;
> >  
> >  	/*
> >  	 * Unmap value blocks for this attr.
> > @@ -719,12 +720,10 @@ __xfs_attr_rmtval_remove(
> >  	if (error)
> >  		return error;
> >  
> > -	error = xfs_defer_finish(&args->trans);
> > -	if (error)
> > -		return error;
> > -
> > -	if (!done)
> > +	if (!done) {
> > +		dac->flags |= XFS_DAC_DEFER_FINISH;
> >  		return -EAGAIN;
> > +	}
> >  
> >  	return error;
> >  }
> > diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> > index 9eee615..002fd30 100644
> > --- a/fs/xfs/libxfs/xfs_attr_remote.h
> > +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> > @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> >  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
> >  		xfs_buf_flags_t incore_flags);
> >  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> > -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
> > +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
> >  #endif /* __XFS_ATTR_REMOTE_H__ */
> > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> > index bfad669..aaa7e66 100644
> > --- a/fs/xfs/xfs_attr_inactive.c
> > +++ b/fs/xfs/xfs_attr_inactive.c
> > @@ -15,10 +15,10 @@
> >  #include "xfs_da_format.h"
> >  #include "xfs_da_btree.h"
> >  #include "xfs_inode.h"
> > +#include "xfs_attr.h"
> >  #include "xfs_attr_remote.h"
> >  #include "xfs_trans.h"
> >  #include "xfs_bmap.h"
> > -#include "xfs_attr.h"
> >  #include "xfs_attr_leaf.h"
> >  #include "xfs_quota.h"
> >  #include "xfs_dir2.h"
> > -- 
> > 2.7.4
> > 
> 
