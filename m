Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BBFC35DF2
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 06:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B598B21D7E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 06:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgBYG0Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 01:26:16 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34728 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbgBYG0Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 01:26:16 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 291317E9831;
        Tue, 25 Feb 2020 17:26:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6TfY-0006zh-DO; Tue, 25 Feb 2020 17:26:12 +1100
Date:   Tue, 25 Feb 2020 17:26:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v7 03/19] xfs: Add xfs_has_attr and subroutines
Message-ID: <20200225062612.GE10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-4-allison.henderson@oracle.com>
 <CAOQ4uxiUVy3OfFsqx_KyirE6pD0XvnzNEehn7Vv4cxXw8kTSjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiUVy3OfFsqx_KyirE6pD0XvnzNEehn7Vv4cxXw8kTSjQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=GLpFB0M0WjkZrZDLBS8A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 02:20:32PM +0200, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
> >
> > From: Allison Henderson <allison.henderson@oracle.com>
> >
> > This patch adds a new functions to check for the existence of an attribute.
> > Subroutines are also added to handle the cases of leaf blocks, nodes or shortform.
> > Common code that appears in existing attr add and remove functions have been
> > factored out to help reduce the appearance of duplicated code.  We will need these
> > routines later for delayed attributes since delayed operations cannot return error
> > codes.
> >
> > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c      | 171 ++++++++++++++++++++++++++++--------------
> >  fs/xfs/libxfs/xfs_attr.h      |   1 +
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 111 +++++++++++++++++----------
> >  fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
> >  4 files changed, 188 insertions(+), 98 deletions(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 9acdb23..2255060 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -46,6 +46,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
> >  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> >  STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> >  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> > +STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> >
> >  /*
> >   * Internal routines when attribute list is more than one block.
> > @@ -53,6 +54,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> >  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> >  STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> >  STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> > +STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> > +                                struct xfs_da_state **state);
> >  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> >  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> >
> > @@ -310,6 +313,37 @@ xfs_attr_set_args(
> >  }
> >
> >  /*
> > + * Return EEXIST if attr is found, or ENOATTR if not
> 
> This is a very silly return value for a function named has_attr in my taste.
> I realize you inherited this interface from xfs_attr3_leaf_lookup_int(), but
> IMO this change looks like a very good opportunity to change that internal
> API:

tl;dr Cleaning up this API is work for another patchset.

> 
> xfs_has_attr?
> 
> 0: NO
> 1: YES (or stay with the syscall standard of -ENOATTR)
> <0: error

While I agree with your sentiment, Amir, the API you suggest is an
anti-pattern. We've been removing ternary return value APIs like
this from XFS and replacing them with an explicit error return value
and an operational return parameter like so:

	error = xfs_has_attr(&exists)
	if (error)
		return error;

	if (!exists && REPLACE) {
		error = -ENOATTR;
		goto out_error_release;
	}
	if (exists && CREATE) {
		error = -EEXIST;
		goto out_error_release;
	}

	.....

out_error_release:
	xfs_trans_brelse(args->trans, bp);
	return error;

This allows us to separate out fatal metadata fetch and parsing
errors from the operational logic that is run on the status returned
from a successful function call.

IMO, this sort of API change needs to be driven right down into
the internal functions that generate ENOATTR/EEXIST in the first
place. Otherwise all we are doing here is forcing the new code to
translate ENOATTR/EEXIST to some intermediate error code that the
higher layer code then has to convert back to ENOATTR/EEXIST so that
it's callers function properly.

Hence I don't think chagning this API just for this new function
makes the code simpler or easier to maintain. And I don't really
think changing the entire API is in the scope of this work. Hence,
even though I don't like the API, I think it is fine to be retained
for this patchset.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
