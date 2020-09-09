Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC05C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 02:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 705D621D40
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 02:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbgIJCYY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 22:24:24 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55343 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729479AbgIJCWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 22:22:07 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6FF91824BF9;
        Thu, 10 Sep 2020 08:59:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kG93x-0002Fj-Hl; Thu, 10 Sep 2020 08:59:37 +1000
Date:   Thu, 10 Sep 2020 08:59:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: quotaoff, transaction quiesce, and dquot logging
Message-ID: <20200909225937.GS12131@dread.disaster.area>
References: <20200904155949.GF529978@bfoster>
 <20200904222936.GH12131@dread.disaster.area>
 <20200908155602.GB721341@bfoster>
 <20200908210720.GP12131@dread.disaster.area>
 <20200909150035.GC765129@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909150035.GC765129@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=IuRgj43g c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=7-415B0cAAAA:8
        a=Jvu4AkJxm7GkgfUIu_oA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 09, 2020 at 11:00:35AM -0400, Brian Foster wrote:
> On Wed, Sep 09, 2020 at 07:07:20AM +1000, Dave Chinner wrote:
> > On Tue, Sep 08, 2020 at 11:56:02AM -0400, Brian Foster wrote:
> > > - xfs_trans_mod_dquot_byino() (via xfs_bmapi_write() -> ... -> xfs_bmap_btalloc() ->
> > >   xfs_bmap_btalloc_accounting()) skips accounting the allocated blocks
> > >   to the group dquot because it is not enabled
> > 
> > Right, the reservation functions need to do the same thing as
> > xfs_trans_mod_dquot_byino(). I simply missed that for the
> > reservation functions. i.e. Adding the same style of check like:
> > 
> > 	if (XFS_IS_UQUOTA_ON(mp) && udq)
> > 
> > before doing anything with user quota will avoid this problem as
> > we are already in transaction context and the UQUOTA on or off state
> > will not change until the transaction ends.
> > 
> > > concept itself. It seems like we should be able to head this issue off
> > > somewhere in this sequence (i.e., checking the appropriate flag before
> > > the dquot is attached), but it also seems like the quotaoff start/end
> > > plus various quota flags all fit together a certain way and I feel like
> > > some pieces of the puzzle are still missing from a design standpoint...
> > 
> > I can't think of anything that is missing - the quota off barrier
> > gives us an atomic quota state change w.r.t. running transactions,
> > so we just need to make sure we check the quota state before joining
> > anything quota related to a transaction rather than assume that the
> > presence of a dquot attached to an inode means that quotas are on.
> > 
> 
> This gets back to my earlier questions around the various quota flags.
> If I trace through the code of some operations, it seems like this
> approach should work (once this logging issue is addressed, and more
> testing required of course). However if I refer back to the runtime
> macro comment:
> 
> /*
>  * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
>  * quota will be not be switched off as long as that inode lock is held.
>  */
> 
> This will technically no longer be the case because the updated quotaoff
> will clear all of the flags before cycling any ilocks and detaching
> dquots. I'm aware it will drain the transaction subsystem, but does
> anything else depend on not seeing such a state change with an inode
> lock held? I haven't seen anything so far that would conflict, but the
> comment here is rather vague on details.

Not that I know of. I would probably rewrite the above comment as:

/*
 * Checking XFS_IS_*QUOTA_ON() while inside an active quota modifying
 * transaction context guarantees quota will be not be switched until after the
 * entire rolling transaction chain is completed.
 */

To clarify the situation. Having the inode locked will now only
guarantee that the dquot will not go away while the inode is locked,
it doesn't guarantee that quota will not switch off any more.

> Conversely, if not, I'm wondering whether there's a need for an ACTIVE
> flag at all if we'd clear it at the same time as the ACCT|ENFD flags
> during quotaoff anyways. It sounds like the answer to both those
> questions is no based on your previous responses, perhaps reason being
> that the transaction drain on the quotaoff side effectively replaces the
> need for this rule on the general transaction side. Hm? Note that I
> wouldn't remove the ACTIVE flag immediately anyways, but I want to make
> sure the concern is clear..

Yes, I think you are right - the ACTIVE flag could probably away as
it doesn't really play a part in the quota-off dance anymore. We'd
still need the IS_QUOTA_ON() checks, but they'd look at ACCT|ENFD
instead...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
