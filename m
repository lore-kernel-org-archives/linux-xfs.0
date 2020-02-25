Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8A9C4BA00
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 22:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C692D2176D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 22:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgBYW1a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 17:27:30 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58823 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727227AbgBYW1a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 17:27:30 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 70C753A2B1E;
        Wed, 26 Feb 2020 09:27:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6ifk-0004M9-DS; Wed, 26 Feb 2020 09:27:24 +1100
Date:   Wed, 26 Feb 2020 09:27:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v7 03/19] xfs: Add xfs_has_attr and subroutines
Message-ID: <20200225222724.GN10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-4-allison.henderson@oracle.com>
 <CAOQ4uxiUVy3OfFsqx_KyirE6pD0XvnzNEehn7Vv4cxXw8kTSjQ@mail.gmail.com>
 <20200225062612.GE10776@dread.disaster.area>
 <CAOQ4uxh2K3Tee+KWtv+bU7xHHjRjrjw0BxmL5RuWc2uv2FVpHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh2K3Tee+KWtv+bU7xHHjRjrjw0BxmL5RuWc2uv2FVpHw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=yPCof4ZbAAAA:8 a=Cb2sko6NMFlXZbRPq6sA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 08:43:53AM +0200, Amir Goldstein wrote:
> On Tue, Feb 25, 2020 at 8:26 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Sun, Feb 23, 2020 at 02:20:32PM +0200, Amir Goldstein wrote:
> > > On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> > > <allison.henderson@oracle.com> wrote:
> > > >
> > > > From: Allison Henderson <allison.henderson@oracle.com>
> > > >
> > > > This patch adds a new functions to check for the existence of an attribute.
> > > > Subroutines are also added to handle the cases of leaf blocks, nodes or shortform.
> > > > Common code that appears in existing attr add and remove functions have been
> > > > factored out to help reduce the appearance of duplicated code.  We will need these
> > > > routines later for delayed attributes since delayed operations cannot return error
> > > > codes.
> > > >
> > > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_attr.c      | 171 ++++++++++++++++++++++++++++--------------
> > > >  fs/xfs/libxfs/xfs_attr.h      |   1 +
> > > >  fs/xfs/libxfs/xfs_attr_leaf.c | 111 +++++++++++++++++----------
> > > >  fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
> > > >  4 files changed, 188 insertions(+), 98 deletions(-)
> > > >
> > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > > index 9acdb23..2255060 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > > @@ -46,6 +46,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
> > > >  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> > > >  STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> > > >  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> > > > +STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> > > >
> > > >  /*
> > > >   * Internal routines when attribute list is more than one block.
> > > > @@ -53,6 +54,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> > > >  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> > > >  STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> > > >  STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> > > > +STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> > > > +                                struct xfs_da_state **state);
> > > >  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> > > >  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> > > >
> > > > @@ -310,6 +313,37 @@ xfs_attr_set_args(
> > > >  }
> > > >
> > > >  /*
> > > > + * Return EEXIST if attr is found, or ENOATTR if not
> > >
> > > This is a very silly return value for a function named has_attr in my taste.
> > > I realize you inherited this interface from xfs_attr3_leaf_lookup_int(), but
> > > IMO this change looks like a very good opportunity to change that internal
> > > API:
> >
> > tl;dr Cleaning up this API is work for another patchset.
> >
> > >
> > > xfs_has_attr?
> > >
> > > 0: NO
> > > 1: YES (or stay with the syscall standard of -ENOATTR)
> > > <0: error
> >
> > While I agree with your sentiment, Amir, the API you suggest is an
> > anti-pattern. We've been removing ternary return value APIs like
> > this from XFS and replacing them with an explicit error return value
> > and an operational return parameter like so:
> >
> >         error = xfs_has_attr(&exists)
> >         if (error)
> >                 return error;
> >
> 
> That would be neat and tidy.
> 
> One of the outcomes of new reviewers is comments on code unrelated
> to the changes... I have no problem of keeping API as is for Allison's
> change, but I did want to point out that the API became worse to read
> due to the helper name change from _lookup_attr to _has_attr, which
> really asks for a yes or no answer.

No argument from me on that. :P

But we really need to make progress on the new attribute features
rather than get bogged down in completely rewriting the attribute
code because it's a bit gross and smelly. The smell can be removed
later...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
