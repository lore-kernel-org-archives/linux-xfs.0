Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E18CC4BA2D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 22:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDF0524653
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 22:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgBZWeX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:34:23 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56898 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727709AbgBZWeX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 17:34:23 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C87C57EA5CE;
        Thu, 27 Feb 2020 09:34:18 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j75Fx-0004bd-Tp; Thu, 27 Feb 2020 09:34:17 +1100
Date:   Thu, 27 Feb 2020 09:34:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 13/19] xfs: Add delay ready attr remove routines
Message-ID: <20200226223417.GA10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-14-allison.henderson@oracle.com>
 <20200225085705.GI10776@dread.disaster.area>
 <6075dabe-c503-05e4-ac3a-9eb028d40e9d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6075dabe-c503-05e4-ac3a-9eb028d40e9d@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=nvTomIvHLNvSZW_WDGgA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 04:57:46PM -0800, Allison Collins wrote:
> On 2/25/20 1:57 AM, Dave Chinner wrote:
> > On Sat, Feb 22, 2020 at 07:06:05PM -0700, Allison Collins wrote:
> > > +out:
> > > +	return error;
> > > +}
> > 
> > Brian commented on the structure of this loop better than I could.
> > 
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
> > >   	struct xfs_da_args      *args)
> > >   {
> > >   	struct xfs_inode	*dp = args->dp;
> > >   	int			error;
> > > +	/* State machine switch */
> > > +	switch (args->dac.dela_state) {
> > > +	case XFS_DAS_RM_SHRINK:
> > > +	case XFS_DAS_RMTVAL_REMOVE:
> > > +		goto node;
> > > +	default:
> > > +		break;
> > > +	}
> > 
> > Why separate out the state machine? Doesn't this shortcut the
> > xfs_inode_hasattr() check? Shouldn't that come first?
> Well, the idea is that when we first start the routine, we come in with
> neither state set, and we fall through to the break.  So we execute the
> check the first time through.
> 
> Though now that you point it out, I should probably go back and put the
> explicit numbering back in the enum (starting with 1) or they will default
> to zero, which would be incorrect.  I had pulled it out in one of the last
> reviews thinking it would be ok, but it should go back in.
> 
> > 
> > As it is:
> > 
> > 	case XFS_DAS_RM_SHRINK:
> > 	case XFS_DAS_RMTVAL_REMOVE:
> > 		return xfs_attr_node_removename(args);
> > 	default:
> > 		break;
> > 
> > would be nicer, and if this is the only way we can get to
> > xfs_attr_node_removename(c, getting rid of it from the code
> > below could be done, too.
> Well, the remove path is a lot simpler than the set path, so that trick does
> work here :-)
> 
> The idea though was to establish "jump points" with the "XFS_DAS_*" states.
> Based on the state, we jump back to where we were.  We could break this
> pattern for the remove path, but I dont think we'd want to do the same for
> the others.  The set routine is a really big function that would end up
> being inside a really big switch!

Right, which is why I think it should be factored into function
calls first, then the switch statement simply becomes a small set of
function calls.

We use that pattern quite a bit in the da_btree code to call
the correct dir/attr function based on the type of block we are
manipulating (i.e. based on da_state context). e.g. xfs_da3_split(),
xfs_da3_join(), etc.

> > >   	struct xfs_da_geometry *geo;	/* da block geometry */
> > >   	struct xfs_name	name;		/* name, length and argument  flags*/
> > >   	uint8_t		filetype;	/* filetype of inode for directories */
> > > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > > index 1887605..9a649d1 100644
> > > --- a/fs/xfs/scrub/common.c
> > > +++ b/fs/xfs/scrub/common.c
> > > @@ -24,6 +24,8 @@
> > >   #include "xfs_rmap_btree.h"
> > >   #include "xfs_log.h"
> > >   #include "xfs_trans_priv.h"
> > > +#include "xfs_da_format.h"
> > > +#include "xfs_da_btree.h"
> > >   #include "xfs_attr.h"
> > >   #include "xfs_reflink.h"
> > >   #include "scrub/scrub.h"
> > 
> > Hmmm - why are these new includes necessary? You didn't add anything
> > new to these files or common header files to make the includes
> > needed....
> 
> Because the delayed attr context uses things from those headers.  And we put
> the context in xfs_da_args.  Now everything that uses xfs_da_args needs
> those includes.  But maybe if we do what you suggest above, we wont need to.
> :-)

put:

struct xfs_da_state;

and whatever other forward declarations are require for the pointer
types used in the delayed attr context at the top of xfs_attr.h.

These are just pointers in the structure, so we don't need the full
structure definitions if the pointers aren't actually dereferenced
by the code that includes the header file.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
