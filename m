Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50ECC00140
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 06:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiHJGNE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Aug 2022 02:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiHJGND (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Aug 2022 02:13:03 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C5B861D49
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 23:13:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-193-158.pa.nsw.optusnet.com.au [49.181.193.158])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 090ED10E8589;
        Wed, 10 Aug 2022 16:13:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oLexe-00BKVD-By; Wed, 10 Aug 2022 16:12:58 +1000
Date:   Wed, 10 Aug 2022 16:12:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
Message-ID: <20220810061258.GL3600936@dread.disaster.area>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-2-allison.henderson@oracle.com>
 <YvKQ5+XotiXFDpTA@magnolia>
 <20220810015809.GK3600936@dread.disaster.area>
 <373809e97f15e14d181fea6e170bfd8e37a9c9e4.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <373809e97f15e14d181fea6e170bfd8e37a9c9e4.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62f34c6d
        a=SeswVvpAPK2RnNNwqI8AaA==:117 a=SeswVvpAPK2RnNNwqI8AaA==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=7-415B0cAAAA:8
        a=JWgpwEcqZZB558ldEVkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 09, 2022 at 10:01:49PM -0700, Alli wrote:
> On Wed, 2022-08-10 at 11:58 +1000, Dave Chinner wrote:
> > On Tue, Aug 09, 2022 at 09:52:55AM -0700, Darrick J. Wong wrote:
> > > On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison Henderson wrote:
> > > > Recent parent pointer testing has exposed a bug in the underlying
> > > > attr replay.  A multi transaction replay currently performs a
> > > > single step of the replay, then deferrs the rest if there is more
> > > > to do.
> > 
> > Yup.
> > 
> > > > This causes race conditions with other attr replays that
> > > > might be recovered before the remaining deferred work has had a
> > > > chance to finish.
> > 
> > What other attr replays are we racing against?  There can only be
> > one incomplete attr item intent/done chain per inode present in log
> > recovery, right?
> No, a rename queues up a set and remove before committing the
> transaction.  One for the new parent pointer, and another to remove the
> old one.

Ah. That really needs to be described in the commit message -
changing from "single intent chain per object" to "multiple
concurrent independent and unserialised intent chains per object" is
a pretty important design rule change...

The whole point of intents is to allow complex, multi-stage
operations on a single object to be sequenced in a tightly
controlled manner. They weren't intended to be run as concurrent
lines of modification on single items; if you need to do two
modifications on an object, the intent chain ties the two
modifications together into a single whole.

One of the reasons I rewrote the attr state machine for LARP was to
enable new multiple attr operation chains to be easily build from
the entry points the state machien provides. Parent attr rename
needs a new intent chain to be built, not run multiple independent
intent chains for each modification.

> It cant be an attr replace because technically the names are
> different.

I disagree - we have all the pieces we need in the state machine
already, we just need to define separate attr names for the
remove and insert steps in the attr intent.

That is, the "replace" operation we execute when an attr set
overwrites the value is "technically" a "replace value" operation,
but we actually implement it as a "replace entire attribute"
operation.

Without LARP, we do that overwrite in independent steps via an
intermediate INCOMPLETE state to allow two xattrs of the same name
to exist in the attr tree at the same time. IOWs, the attr value
overwrite is effectively a "set-swap-remove" operation on two
entirely independent xattrs, ensuring that if we crash we always
have either the old or new xattr visible.

With LARP, we can remove the original attr first, thereby avoiding
the need for two versions of the xattr to exist in the tree in the
first place. However, we have to do these two operations as a pair
of linked independent operations. The intent chain provides the
linking, and requires us to log the name and the value of the attr
that we are overwriting in the intent. Hence we can always recover
the modification to completion no matter where in the operation we
fail.

When it comes to a parent attr rename operation, we are effectively
doing two linked operations - remove the old attr, set the new attr
- on different attributes. Implementation wise, it is exactly the
same sequence as a "replace value" operation, except for the fact
that the new attr we add has a different name.

Hence the only real difference between the existing "attr replace"
and the intent chain we need for "parent attr rename" is that we
have to log two attr names instead of one. Basically, we have a new
XFS_ATTRI_OP_FLAGS... type for this, and that's what tells us that
we are operating on two different attributes instead of just one.

The recovery operation becomes slightly different - we have to run a
remove on the old, then a replace on the new - so there a little bit
of new code needed to manage that in the state machine.

These, however, are just small tweaks on the existing replace attr
operation, and there should be little difference in performance or
overhead between a "replace value" and a "replace entire xattr"
operation as they are largely the same runtime operation for LARP.

> So the recovered set grows the leaf, and returns the egain, then rest
> gets capture committed.  Next up is the recovered remove which pulls
> out the fork, which causes problems when the rest of the set operation
> resumes as a deferred operation.

Yup, and all this goes away when we build the right intent chain for
replacing a parent attr rename....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
