Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2517AC4320A
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 18:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0837361262
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 18:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhHWSQ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 14:16:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229837AbhHWSQz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Aug 2021 14:16:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9F93611CB;
        Mon, 23 Aug 2021 18:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629742572;
        bh=ebt8d5hUo2Hne7AlOeoX6nY9Dd7tk3qWVNzI39fns1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mUrOVPcW5rVslYcZX2az2fIajYE/NPpageHF0C6ylVJh2q8w6ddlDYY18kh/9Z/B+
         Tg9gGM5oKNb0btVvtpqr1wBSHD3akdnomeMA0XkBlSjP+ZwVjd8WRJRhzU3DuiUvpY
         o8kkgSIS29b902fNJOALEc5jXXNs9d1k18PhzD2JSsni/Xh0uQ1zN/u3mK3W4nHmYZ
         +UtLjmrTCMK3elA8dkt6APb14P/ml10FwUBbWLo+l++W43OIldO61bVtnJFYgHyZeK
         P+/qn5i+g+E9x/t+mWpFgcfozZi75e6+cLjnyDb0HlIQFg5k7m7BbDl/iVgzd8ZaWu
         /MGyTEsAGhgag==
Date:   Mon, 23 Aug 2021 11:16:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 02/12] xfs: Rename MAXEXTNUM, MAXAEXTNUM to
 XFS_IFORK_EXTCNT_MAXS32, XFS_IFORK_EXTCNT_MAXS16
Message-ID: <20210823181612.GB12640@magnolia>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-3-chandanrlinux@gmail.com>
 <20210727215611.GK559212@magnolia>
 <20210727220318.GN559212@magnolia>
 <87eebjw2lj.fsf@garuda>
 <87y28sg5e5.fsf@debian-BULLSEYE-live-builder-AMD64>
 <87v93wfx48.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v93wfx48.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 23, 2021 at 12:47:43PM +0530, Chandan Babu R wrote:
> On 23 Aug 2021 at 09:48, Chandan Babu R wrote:
> > On 28 Jul 2021 at 08:45, Chandan Babu R wrote:
> >> On 28 Jul 2021 at 03:33, Darrick J. Wong wrote:
> >>> On Tue, Jul 27, 2021 at 02:56:11PM -0700, Darrick J. Wong wrote:
> >>>> On Mon, Jul 26, 2021 at 05:15:31PM +0530, Chandan Babu R wrote:
> >>>> > In preparation for introducing larger extent count limits, this commit renames
> >>>> > existing extent count limits based on their signedness and width.
> >>>> > 
> >>>> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> >>>> > ---
> >>>> >  fs/xfs/libxfs/xfs_bmap.c       | 4 ++--
> >>>> >  fs/xfs/libxfs/xfs_format.h     | 8 ++++----
> >>>> >  fs/xfs/libxfs/xfs_inode_buf.c  | 4 ++--
> >>>> >  fs/xfs/libxfs/xfs_inode_fork.c | 3 ++-
> >>>> >  fs/xfs/scrub/inode_repair.c    | 2 +-
> >>>> >  5 files changed, 11 insertions(+), 10 deletions(-)
> >>>> > 
> >>>> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> >>>> > index f3c9a0ebb0a5..8f262405a5b5 100644
> >>>> > --- a/fs/xfs/libxfs/xfs_bmap.c
> >>>> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> >>>> > @@ -76,10 +76,10 @@ xfs_bmap_compute_maxlevels(
> >>>> >  	 * available.
> >>>> >  	 */
> >>>> >  	if (whichfork == XFS_DATA_FORK) {
> >>>> > -		maxleafents = MAXEXTNUM;
> >>>> > +		maxleafents = XFS_IFORK_EXTCNT_MAXS32;
> >>>> 
> >>>> I'm not in love with these names, since they tell me roughly about the
> >>>> size of the constant (which I could glean from the definition) but less
> >>>> about when I would expect to find them.  How about:
> >>>> 
> >>>> #define XFS_MAX_DFORK_NEXTENTS    ((xfs_extnum_t) 0x7FFFFFFF)
> >>>> #define XFS_MAX_AFORK_NEXTENTS    ((xfs_aextnum_t)0x00007FFF)
> >>>
> >>> Or, given that 'DFORK' already means 'ondisk fork', how about:
> >>>
> >>> XFS_MAX_DATA_NEXTENTS
> >>> XFS_MAX_ATTR_NEXTENTS
> >>
> >> Yes, I agree. These names are better. I will incorporate your suggestions
> >> before posting V3.
> >>
> >
> > Using XFS_MAX_[ATTR|DATA]_NEXTENTS won't be feasible later in the patch series
> > since the maximum extent count for the two inode forks depend on whether
> > XFS_SB_FEAT_INCOMPAT_NREXT64 feature bit is set or not. With the incompat
> > feature bit set, extent counts for attr and data forks can have maximum values
> > of (2^32 - 1) and (2^48 - 1) respectively. With the incompat feature bit not
> > set, extent counts for attr and data forks can have maximum values of (2^15 -
> > 1) and (2^31 - 1) respectively.
> >
> > Also, xfs_iext_max_nextents() (an inline function introduced in the next patch
> > in this series) abstracts away the logic of determining the maximum extent
> > count for an inode fork.
> 
> I think introducing xfs_iext_max_nextents() before renaming the max extent
> counter macros would reduce proliferation of XFS_IFORK_EXTCNT_MAX* macros
> across the source code. If you are ok with it, I will reorder the current
> patch and the next patch.

Sounds good to me. :)

--D

> -- 
> chandan
