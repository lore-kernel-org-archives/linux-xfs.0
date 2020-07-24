Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EDAC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 05:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B78F920737
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 05:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgGXFfd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 01:35:33 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:46430 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726277AbgGXFfc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 01:35:32 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 247FBD5A713;
        Fri, 24 Jul 2020 15:35:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jyqMg-0003Y7-JZ; Fri, 24 Jul 2020 15:35:26 +1000
Date:   Fri, 24 Jul 2020 15:35:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 00/25] xfs: Delay Ready Attributes
Message-ID: <20200724053526.GP2005@dread.disaster.area>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200724034100.GN2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724034100.GN2005@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=wVkfdLxGgUcmzkAhm8wA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 24, 2020 at 01:41:00PM +1000, Dave Chinner wrote:
> On Mon, Jul 20, 2020 at 05:15:41PM -0700, Allison Collins wrote:
> > Hi all,
> > 
> > This set is a subset of a larger series for delayed attributes. Which is a
> > subset of an even larger series, parent pointers. Delayed attributes allow
> > attribute operations (set and remove) to be logged and committed in the same
> > way that other delayed operations do. This allows more complex operations (like
> > parent pointers) to be broken up into multiple smaller transactions. To do
> > this, the existing attr operations must be modified to operate as either a
> > delayed operation or a inline operation since older filesystems will not be
> > able to use the new log entries.  This means that they cannot roll, commit, or
> > finish transactions.  Instead, they return -EAGAIN to allow the calling
> > function to handle the transaction. In this series, we focus on only the clean
> > up and refactoring needed to accomplish this. We will introduce delayed attrs
> > and parent pointers in a later set.
> > 
> > At the moment, I would like people to focus their review efforts on just this
> > "delay ready" subseries, as I think that is a more conservative use of peoples
> > review time.  I also think the set is a bit much to manage all at once, and we
> > need to get the infrastructure ironed out before we focus too much anything
> > that depends on it. But I do have the extended series for folks that want to
> > see the bigger picture of where this is going.
> > 
> > To help organize the set, I've arranged the patches to make sort of mini sets.
> > I thought it would help reviewers break down the reviewing some. For reviewing
> > purposes, the set could be broken up into 4 different phases:
> > 
> > Error code filtering (patches 1-2):
> > These two patches are all about finding and catching error codes that need to
> > be sent back up to user space before starting delayed operations.  Errors that
> > happen during a delayed operation are treated like internal errors that cause a
> > shutdown.  But we wouldnt want that for example: when the user tries to rename
> > a non existent attr.  So the idea is that we need to find all such conditions,
> > and take care of them before starting a delayed operation.
> >    xfs: Add xfs_has_attr and subroutines
> >    xfs: Check for -ENOATTR or -EEXIST
> > 
> > Move transactions upwards (patches 3-12): 
> > The goal of this subset is to try and move all the transaction specific code up
> > the call stack much as possible.  The idea being that once we get them to the
> > top, we can introduce the statemachine to handle the -EAGAIN logic where ever
> > the transactions used to be.
> >   xfs: Factor out new helper functions xfs_attr_rmtval_set
> >   xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
> >   xfs: Split apart xfs_attr_leaf_addname
> >   xfs: Refactor xfs_attr_try_sf_addname
> >   xfs: Pull up trans roll from xfs_attr3_leaf_setflag
> >   xfs: Factor out xfs_attr_rmtval_invalidate
> >   xfs: Pull up trans roll in xfs_attr3_leaf_clearflag
> >   xfs: Refactor xfs_attr_rmtval_remove
> >   xfs: Pull up xfs_attr_rmtval_invalidate
> >   xfs: Add helper function xfs_attr_node_shrink
> > 
> > Modularizing and cleanups (patches 13-22):
> > Now that we have pulled the transactions up to where we need them, it's time to
> > start breaking down the top level functions into new subfunctions. The goal
> > being to work towards a top level function that deals mostly with the
> > statemachine, and helpers for those states
> >   xfs: Remove unneeded xfs_trans_roll_inode calls
> >   xfs: Remove xfs_trans_roll in xfs_attr_node_removename
> >   xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
> >   xfs: Add helper function xfs_attr_leaf_mark_incomplete
> >   xfs: Add remote block helper functions
> >   xfs: Add helper function xfs_attr_node_removename_setup
> >   xfs: Add helper function xfs_attr_node_removename_rmt
> >   xfs: Simplify xfs_attr_leaf_addname
> >   xfs: Simplify xfs_attr_node_addname
> >   xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname
> 
> I'm happy to see everything up to here merged.

BTW, that translates as:

Acked-by: Dave Chinner <dchinner@redhat.com>

For the first 22 patches.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
