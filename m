Return-Path: <SRS0=bXuc=2B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE25C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Dec 2019 20:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9EDF206C3
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Dec 2019 20:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfLKUwf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 15:52:35 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48016 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726368AbfLKUwf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 15:52:35 -0500
Received: from dread.disaster.area (pa49-195-139-249.pa.nsw.optusnet.com.au [49.195.139.249])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C8C4B82068E;
        Thu, 12 Dec 2019 07:52:30 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1if8yE-0005Fq-1m; Thu, 12 Dec 2019 07:52:30 +1100
Date:   Thu, 12 Dec 2019 07:52:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: stabilize insert range start boundary to avoid COW
 writeback race
Message-ID: <20191211205230.GD19256@dread.disaster.area>
References: <20191210132340.11330-1-bfoster@redhat.com>
 <20191210214100.GB19256@dread.disaster.area>
 <20191211124712.GB16095@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211124712.GB16095@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=KoypXv6BqLCQNZUs2nCMWg==:117 a=KoypXv6BqLCQNZUs2nCMWg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=O8Il8asTUDUE6ty3VY0A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22 a=26CFN5KYESCqVWovzqLp:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 11, 2019 at 07:47:12AM -0500, Brian Foster wrote:
> On Wed, Dec 11, 2019 at 08:41:00AM +1100, Dave Chinner wrote:
> > On Tue, Dec 10, 2019 at 08:23:40AM -0500, Brian Foster wrote:
> > I think insert/collapse need to be converted to work like a
> > truncate operation instead of a series on individual write
> > operations. That is, they are a permanent transaction that locks the
> > inode once and is rolled repeatedly until the entire extent listi
> > modification is done and then the inode is unlocked.
> > 
> 
> Note that I don't think it's sufficient to hold the inode locked only
> across the shift. For the insert case, I think we'd need to grab it
> before the extent split at the target offset and roll from there.
> Otherwise the same problem could be reintroduced if we eventually
> replaced the xfs_prepare_shift() tweak made by this patch. Of course,
> that doesn't look like a big problem. The locking is already elevated
> and split and shift even use the same transaction type, so it's mostly a
> refactor from a complexity standpoint. 

*nod*

> For the collapse case, we do have a per-shift quota reservation for some
> reason. If that is required, we'd have to somehow replace it with a
> worst case calculation. That said, it's not clear to me why that
> reservation even exists.

I'm not 100% sure, either, but....

> The pre-shift hole punch is already a separate
> transaction with its own such reservation. The shift can merge extents
> after that point (though most likely only on the first shift), but that
> would only ever remove extent records. Any thoughts or objections if I
> just killed that off?

Yeah, I suspect that it is the xfs_bmse_merge() case freeing blocks
the reservation is for, and I agree that it should only happen on
the first shift because all the others that are moved are identical
in size and shape and would have otherwise been merged at creation.

Hence I think we can probably kill the xfs_bmse_merge() case,
though it might be wrth checking first how often it gets called...

> > > To address this problem, update the shift preparation code to
> > > stabilize the start boundary along with the full range of the
> > > insert. Also update the existing corruption check to fail if any
> > > extent is shifted with a start offset behind the target offset of
> > > the insert range. This prevents insert from racing with COW
> > > writeback completion and fails loudly in the event of an unexpected
> > > extent shift.
> > 
> > It looks ok to avoid this particular symptom (backportable point
> > fix), but I really think we should convert insert/collapse to be
> > atomic w.r.t other extent list modifications....
> > 
> 
> Ok, I think that approach is reasonable so long as we do it in two
> phases as such to minimize backport churn and separate bug fix from
> behavior change.
> 
> Unless there is other feedback on this patch, is there any objection to
> getting this one reviewed/merged independently?

Not here. Seems like the right approach to me. SO for the original
patch:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
