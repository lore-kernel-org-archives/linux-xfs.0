Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F4FC35DF5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 08:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 039432176D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 08:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbgBYI5J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 03:57:09 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39361 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729175AbgBYI5J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 03:57:09 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 769743A1BCC;
        Tue, 25 Feb 2020 19:57:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6W1Z-0007rF-F3; Tue, 25 Feb 2020 19:57:05 +1100
Date:   Tue, 25 Feb 2020 19:57:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 13/19] xfs: Add delay ready attr remove routines
Message-ID: <20200225085705.GI10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200223020611.1802-14-allison.henderson@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=UIjSZZChOt3YotitUuAA:9
        a=rFpL5r2-HN0EidKi:21 a=Dg46I8nL5tVPZHUn:21 a=QEXdDO2ut3YA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 22, 2020 at 07:06:05PM -0700, Allison Collins wrote:
> This patch modifies the attr remove routines to be delay ready. This means they no
> longer roll or commit transactions, but instead return -EAGAIN to have the calling
> routine roll and refresh the transaction. In this series, xfs_attr_remove_args has
> become xfs_attr_remove_iter, which uses a sort of state machine like switch to keep
> track of where it was when EAGAIN was returned. xfs_attr_node_removename has also
> been modified to use the switch, and a  new version of xfs_attr_remove_args
> consists of a simple loop to refresh the transaction until the operation is
> completed.
> 
> This patch also adds a new struct xfs_delattr_context, which we will use to keep
> track of the current state of an attribute operation. The new xfs_delattr_state
> enum is used to track various operations that are in progress so that we know not
> to repeat them, and resume where we left off before EAGAIN was returned to cycle
> out the transaction. Other members take the place of local variables that need
> to retain their values across multiple function recalls.
> 
> Below is a state machine diagram for attr remove operations. The XFS_DAS_* states

Ok, so I find all the DA/da prefixes in this code confusing,
especially as they have very similar actual names. e.g. da_state
vs delattr_state, DAS vs DA_STATE, etc.

Basically, I can't tell from reading the code what "DA" the actual
variable belongs to, and in a few months time I'll most definitely
have forgotten and have to relearn it from scratch.

So while "Delayed Attributes" is a great name for the feature, I
don't think it makes a great acronym for shortening variable names
because of the conflict with the existing DA namespace prefix.

Also, "dac" as shorthand for delattr context is also overloaded.
"DAC" is "discretionary access control" and is quite widely used
in the kernel (e.g. CAP_DAC_READ_SEARCH, CAP_DAC_OVERRIDE) so again
I read thsi code and it doesn't make much sense.

I haven't come up with a better name - "attribute iterator" is the
best I've managed (marketing++ - XFS has AI now!) and shortening it
down to ator would go a long way to alleviating my namespace
confusion....

> indicate places where the function would return -EAGAIN, and then immediately
> resume from after being recalled by the calling function.  States marked as a
> "subroutine state" indicate that they belong to a subroutine, and so the calling
> function needs to pass them back to that subroutine to allow it to finish where
> it left off. But they otherwise do not have a role in the calling function other
> than just passing through.
> 
>  xfs_attr_remove_iter()
>          XFS_DAS_RM_SHRINK     ─┐
>          (subroutine state)     │
>                                 │
>          XFS_DAS_RMTVAL_REMOVE ─┤
>          (subroutine state)     │
>                                 └─>xfs_attr_node_removename()
>                                                  │
>                                                  v
>                                          need to remove
>                                    ┌─n──  rmt blocks?
>                                    │             │
>                                    │             y
>                                    │             │
>                                    │             v
>                                    │  ┌─>XFS_DAS_RMTVAL_REMOVE
>                                    │  │          │
>                                    │  │          v
>                                    │  └──y── more blks
>                                    │         to remove?
>                                    │             │
>                                    │             n
>                                    │             │
>                                    │             v
>                                    │         need to
>                                    └─────> shrink tree? ─n─┐
>                                                  │         │
>                                                  y         │
>                                                  │         │
>                                                  v         │
>                                          XFS_DAS_RM_SHRINK │
>                                                  │         │
>                                                  v         │
>                                                 done <─────┘

Nice.

> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c     | 114 +++++++++++++++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_attr.h     |   1 +
>  fs/xfs/libxfs/xfs_da_btree.h |  30 ++++++++++++
>  fs/xfs/scrub/common.c        |   2 +
>  fs/xfs/xfs_acl.c             |   2 +
>  fs/xfs/xfs_attr_list.c       |   1 +
>  fs/xfs/xfs_ioctl.c           |   2 +
>  fs/xfs/xfs_ioctl32.c         |   2 +
>  fs/xfs/xfs_iops.c            |   2 +
>  fs/xfs/xfs_xattr.c           |   1 +
>  10 files changed, 141 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 5d73bdf..cd3a3f7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -368,11 +368,60 @@ xfs_has_attr(
>   */
>  int
>  xfs_attr_remove_args(
> +	struct xfs_da_args	*args)
> +{
> +	int			error = 0;
> +	int			err2 = 0;
> +
> +	do {
> +		error = xfs_attr_remove_iter(args);
> +		if (error && error != -EAGAIN)
> +			goto out;
> +
> +		if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
> +			args->dac.flags &= ~XFS_DAC_FINISH_TRANS;
> +
> +			err2 = xfs_defer_finish(&args->trans);
> +			if (err2) {
> +				error = err2;
> +				goto out;
> +			}
> +		}
> +
> +		err2 = xfs_trans_roll_inode(&args->trans, args->dp);
> +		if (err2) {
> +			error = err2;
> +			goto out;
> +		}
> +
> +	} while (error == -EAGAIN);
> +out:
> +	return error;
> +}

Brian commented on the structure of this loop better than I could.

> +
> +/*
> + * Remove the attribute specified in @args.
> + *
> + * This function may return -EAGAIN to signal that the transaction needs to be
> + * rolled.  Callers should continue calling this function until they receive a
> + * return value other than -EAGAIN.
> + */
> +int
> +xfs_attr_remove_iter(
>  	struct xfs_da_args      *args)
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	int			error;
>  
> +	/* State machine switch */
> +	switch (args->dac.dela_state) {
> +	case XFS_DAS_RM_SHRINK:
> +	case XFS_DAS_RMTVAL_REMOVE:
> +		goto node;
> +	default:
> +		break;
> +	}

Why separate out the state machine? Doesn't this shortcut the
xfs_inode_hasattr() check? Shouldn't that come first?

As it is:

	case XFS_DAS_RM_SHRINK:
	case XFS_DAS_RMTVAL_REMOVE:
		return xfs_attr_node_removename(args);
	default:
		break;

would be nicer, and if this is the only way we can get to
xfs_attr_node_removename(), getting rid of it from the code
below could be done, too.


> +
>  	if (!xfs_inode_hasattr(dp)) {
>  		error = -ENOATTR;
>  	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> @@ -381,6 +430,7 @@ xfs_attr_remove_args(
>  	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>  		error = xfs_attr_leaf_removename(args);
>  	} else {
> +node:
>  		error = xfs_attr_node_removename(args);
>  	}
>  
> @@ -895,9 +945,8 @@ xfs_attr_leaf_removename(
>  		/* bp is gone due to xfs_da_shrink_inode */
>  		if (error)
>  			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +
> +		args->dac.flags |= XFS_DAC_FINISH_TRANS;
>  	}
>  	return 0;
>  }
> @@ -1218,6 +1267,11 @@ xfs_attr_node_addname(
>   * This will involve walking down the Btree, and may involve joining
>   * leaf nodes and even joining intermediate nodes up to and including
>   * the root node (a special case of an intermediate node).
> + *
> + * This routine is meant to function as either an inline or delayed operation,
> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
> + * functions will need to handle this, and recall the function until a
> + * successful error code is returned.
>   */
>  STATIC int
>  xfs_attr_node_removename(
> @@ -1230,10 +1284,24 @@ xfs_attr_node_removename(
>  	struct xfs_inode	*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
> +	state = args->dac.da_state;
> +	blk = args->dac.blk;
> +
> +	/* State machine switch */
> +	switch (args->dac.dela_state) {
> +	case XFS_DAS_RMTVAL_REMOVE:
> +		goto rm_node_blks;
> +	case XFS_DAS_RM_SHRINK:
> +		goto rm_shrink;
> +	default:
> +		break;
> +	}

This really is calling out for this function to be broken into three
smaller functions. That would greatly simplify the code flow and
logic here.

> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index ce7b039..ea873a5 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -155,6 +155,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
>  int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
> +int xfs_attr_remove_iter(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 14f1be3..3c78498 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -50,9 +50,39 @@ enum xfs_dacmp {
>  };
>  
>  /*
> + * Enum values for xfs_delattr_context.da_state
> + *
> + * These values are used by delayed attribute operations to keep track  of where
> + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
> + * calling function to roll the transaction, and then recall the subroutine to
> + * finish the operation.  The enum is then used by the subroutine to jump back
> + * to where it was and resume executing where it left off.
> + */
> +enum xfs_delattr_state {
> +	XFS_DAS_RM_SHRINK,	/* We are shrinking the tree */
> +	XFS_DAS_RMTVAL_REMOVE,	/* We are removing remote value blocks */
> +};
> +
> +/*
> + * Defines for xfs_delattr_context.flags
> + */
> +#define	XFS_DAC_FINISH_TRANS	0x1 /* indicates to finish the transaction */
> +
> +/*
> + * Context used for keeping track of delayed attribute operations
> + */
> +struct xfs_delattr_context {
> +	struct xfs_da_state	*da_state;
> +	struct xfs_da_state_blk *blk;
> +	unsigned int		flags;
> +	enum xfs_delattr_state	dela_state;
> +};
> +
> +/*
>   * Structure to ease passing around component names.
>   */
>  typedef struct xfs_da_args {
> +	struct xfs_delattr_context dac; /* context used for delay attr ops */

Probably should put this at the end of the structure rather than the
front.

I'm also wondering if it should be kept separate to the da_args and
contain a pointer to the da_args instead of being wrapped inside
them.

i.e. we put the iterating state structure on the stack, then

	struct attr_iter	ater = {
		.da_args = args,
	};

	do {
		error = xfs_attr_remove_iter(&ater);
		.....
	
And that largely separates the delayed attribute iteration state
from the da_args that holds the internal attribute manipulation
information.

>  	struct xfs_da_geometry *geo;	/* da block geometry */
>  	struct xfs_name	name;		/* name, length and argument  flags*/
>  	uint8_t		filetype;	/* filetype of inode for directories */
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 1887605..9a649d1 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -24,6 +24,8 @@
>  #include "xfs_rmap_btree.h"
>  #include "xfs_log.h"
>  #include "xfs_trans_priv.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_reflink.h"
>  #include "scrub/scrub.h"

Hmmm - why are these new includes necessary? You didn't add anything
new to these files or common header files to make the includes
needed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
