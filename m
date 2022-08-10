Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD92C00140
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 15:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiHJPyc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Aug 2022 11:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbiHJPxr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Aug 2022 11:53:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BFE7FE65
        for <linux-xfs@vger.kernel.org>; Wed, 10 Aug 2022 08:52:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8B026112B
        for <linux-xfs@vger.kernel.org>; Wed, 10 Aug 2022 15:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3954AC433D6;
        Wed, 10 Aug 2022 15:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660146742;
        bh=ypMyPJbsXpTHBYtj21AuAbwirsTX8OvUiqE2goXnqcg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dk0fxdJaKfKciMJ/ZX4j0JNzCSzBO5GUtAUkcesCqAWa9X/VH7wVKdyjkuLiOOt/U
         bUwQOa53x4zMJVe2BQh3ofhSgW5ttS4SxkFsSdoI2wq8lmtko0cB4ST3hk7FXKwEEy
         K1b+7c22DRXn0pTjBmj+HM9+U3jT0Zx21ofBJuZrRz5FL9OzzFrFTTLouyY4hAOnUI
         jPqdPMvFJBMwe4MB+TVllR50yqZ5Iz79ZOveREqg7HCfr4zFZN/EG2qca2vjvYMoKO
         DTFpZRuOWd6fuRRVRz5JYC+GbkK4P8ivVgOdrYQYB/cpBKZkkuII0NeEJEB3GSdQ/y
         3rlle0hze3UBA==
Date:   Wed, 10 Aug 2022 08:52:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Alli <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
Message-ID: <YvPUNbyPWjr5yLVN@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-2-allison.henderson@oracle.com>
 <YvKQ5+XotiXFDpTA@magnolia>
 <20220810015809.GK3600936@dread.disaster.area>
 <373809e97f15e14d181fea6e170bfd8e37a9c9e4.camel@oracle.com>
 <20220810061258.GL3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810061258.GL3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 10, 2022 at 04:12:58PM +1000, Dave Chinner wrote:
> On Tue, Aug 09, 2022 at 10:01:49PM -0700, Alli wrote:
> > On Wed, 2022-08-10 at 11:58 +1000, Dave Chinner wrote:
> > > On Tue, Aug 09, 2022 at 09:52:55AM -0700, Darrick J. Wong wrote:
> > > > On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison Henderson wrote:
> > > > > Recent parent pointer testing has exposed a bug in the underlying
> > > > > attr replay.  A multi transaction replay currently performs a
> > > > > single step of the replay, then deferrs the rest if there is more
> > > > > to do.
> > > 
> > > Yup.
> > > 
> > > > > This causes race conditions with other attr replays that
> > > > > might be recovered before the remaining deferred work has had a
> > > > > chance to finish.
> > > 
> > > What other attr replays are we racing against?  There can only be
> > > one incomplete attr item intent/done chain per inode present in log
> > > recovery, right?
> > No, a rename queues up a set and remove before committing the
> > transaction.  One for the new parent pointer, and another to remove the
> > old one.
> 
> Ah. That really needs to be described in the commit message -
> changing from "single intent chain per object" to "multiple
> concurrent independent and unserialised intent chains per object" is
> a pretty important design rule change...
> 
> The whole point of intents is to allow complex, multi-stage
> operations on a single object to be sequenced in a tightly
> controlled manner. They weren't intended to be run as concurrent
> lines of modification on single items; if you need to do two
> modifications on an object, the intent chain ties the two
> modifications together into a single whole.

Back when I made the suggestion that resulted in this patch, I was
pondering why it is that (say) atomic swapext didn't suffer from these
recovery problems, and I realized that for any given inode, you can only
have one ongoing swapext operation at a time.  That's why recovery of
swapext operations works fine, whereas pptr recovery has this quirk.

At the time, my thought process was more narrowly focused on making log
recovery mimic runtime more closely.  I didn't make the connection
between this problem and the other open question I had (see the bottom)
about how to fix pptr attrs when rebuilding a directory.

> One of the reasons I rewrote the attr state machine for LARP was to
> enable new multiple attr operation chains to be easily build from
> the entry points the state machien provides. Parent attr rename
> needs a new intent chain to be built, not run multiple independent
> intent chains for each modification.
> 
> > It cant be an attr replace because technically the names are
> > different.
> 
> I disagree - we have all the pieces we need in the state machine
> already, we just need to define separate attr names for the
> remove and insert steps in the attr intent.
> 
> That is, the "replace" operation we execute when an attr set
> overwrites the value is "technically" a "replace value" operation,
> but we actually implement it as a "replace entire attribute"
> operation.

OH.  Right.  I forgot that ATTR_REPLACE=="replace entire attr".

If I'm understanding this right, that means that the xfs_rename patch
ought to detect the situation where there's an existing dirent in the
target directory, and do something along the lines of:

	} else { /* target_ip != NULL */
		xfs_dir_replace(...);

		xfs_parent_defer_replace(tp, new_parent_ptr, target_dp,
				old_diroffset, target_name,
				new_diroffset);

		xfs_trans_ichgtime(...);

Where the xfs_parent_defer_replace operation does an ATTR_REPLACE to
switch:

(target_dp_ino, target_gen, old_diroffset) == <dontcare>

to this:

(target_dp_ino, target_gen, new_diroffset) == target_name

except, I think we have to log the old name in addition to the new name,
because userspace ATTR_REPLACE operations don't allow name changes?

I guess this also implies that xfs_dir_replace will pass out the offset
of the old name, in addition to the offset of the new name.

> Without LARP, we do that overwrite in independent steps via an
> intermediate INCOMPLETE state to allow two xattrs of the same name
> to exist in the attr tree at the same time. IOWs, the attr value
> overwrite is effectively a "set-swap-remove" operation on two
> entirely independent xattrs, ensuring that if we crash we always
> have either the old or new xattr visible.
> 
> With LARP, we can remove the original attr first, thereby avoiding
> the need for two versions of the xattr to exist in the tree in the
> first place. However, we have to do these two operations as a pair
> of linked independent operations. The intent chain provides the
> linking, and requires us to log the name and the value of the attr
> that we are overwriting in the intent. Hence we can always recover
> the modification to completion no matter where in the operation we
> fail.
> 
> When it comes to a parent attr rename operation, we are effectively
> doing two linked operations - remove the old attr, set the new attr
> - on different attributes. Implementation wise, it is exactly the
> same sequence as a "replace value" operation, except for the fact
> that the new attr we add has a different name.
> 
> Hence the only real difference between the existing "attr replace"
> and the intent chain we need for "parent attr rename" is that we
> have to log two attr names instead of one. Basically, we have a new
> XFS_ATTRI_OP_FLAGS... type for this, and that's what tells us that
> we are operating on two different attributes instead of just one.

This answers my earlier question: Yes, and yes.

> The recovery operation becomes slightly different - we have to run a
> remove on the old, then a replace on the new - so there a little bit
> of new code needed to manage that in the state machine.
> 
> These, however, are just small tweaks on the existing replace attr
> operation, and there should be little difference in performance or
> overhead between a "replace value" and a "replace entire xattr"
> operation as they are largely the same runtime operation for LARP.
> 
> > So the recovered set grows the leaf, and returns the egain, then rest
> > gets capture committed.  Next up is the recovered remove which pulls
> > out the fork, which causes problems when the rest of the set operation
> > resumes as a deferred operation.
> 
> Yup, and all this goes away when we build the right intent chain for
> replacing a parent attr rename....

Funnily enough, just last week I had thought that online repair was
going to require the ability to replace an entire xattr...

https://djwong.org/docs/xfs-online-fsck-design/#parent-pointers

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
