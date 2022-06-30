Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70E9C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jun 2022 22:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiF3Wvv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jun 2022 18:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiF3Wvu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jun 2022 18:51:50 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E37475073B
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 15:51:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2D9135ECE89;
        Fri,  1 Jul 2022 08:51:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o730j-00D2MU-L5; Fri, 01 Jul 2022 08:51:45 +1000
Date:   Fri, 1 Jul 2022 08:51:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs_repair: clear DIFLAG2_NREXT64 when filesystem
 doesn't support nrext64
Message-ID: <20220630225145.GB227878@dread.disaster.area>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
 <165644936573.1089996.11135224585697421312.stgit@magnolia>
 <20220628225857.GO227878@dread.disaster.area>
 <Yrzb9xFYKzvfQ/tP@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrzb9xFYKzvfQ/tP@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62be2904
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=5aSSoww3ul8zVyLEY9gA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 04:10:47PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 29, 2022 at 08:58:57AM +1000, Dave Chinner wrote:
> > On Tue, Jun 28, 2022 at 01:49:25PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Clear the nrext64 inode flag if the filesystem doesn't have the nrext64
> > > feature enabled in the superblock.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  repair/dinode.c |   19 +++++++++++++++++++
> > >  1 file changed, 19 insertions(+)
> > > 
> > > 
> > > diff --git a/repair/dinode.c b/repair/dinode.c
> > > index 00de31fb..547c5833 100644
> > > --- a/repair/dinode.c
> > > +++ b/repair/dinode.c
> > > @@ -2690,6 +2690,25 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
> > >  			}
> > >  		}
> > >  
> > > +		if (xfs_dinode_has_large_extent_counts(dino) &&
> > > +		    !xfs_has_large_extent_counts(mp)) {
> > > +			if (!uncertain) {
> > > +				do_warn(
> > > +	_("inode %" PRIu64 " is marked large extent counts but file system does not support large extent counts\n"),
> > > +					lino);
> > > +			}
> > > +			flags2 &= ~XFS_DIFLAG2_NREXT64;
> > > +
> > > +			if (no_modify) {
> > > +				do_warn(_("would zero extent counts.\n"));
> > > +			} else {
> > > +				do_warn(_("zeroing extent counts.\n"));
> > > +				dino->di_nextents = 0;
> > > +				dino->di_anextents = 0;
> > > +				*dirty = 1;
> > 
> > Is that necessary? If the existing extent counts are within the
> > bounds of the old extent fields, then shouldn't we just rewrite the
> > current values into the old format rather than trashing all the
> > data/xattrs on the inode?
> 
> It's hard to know what to do here -- we haven't actually checked the
> forks yet, so we don't know if the dinode flag was set but the !nrext64
> extent count fields are ok so all we have to do is clear the dinode
> flag; or if the dinode flag was set, the nrext64 extent count fields are
> correct and must be moved to the !nrext64 fields; or what?
> 
> I guess I could just leave the extent count fields as-is and let the
> process_*_fork functions deal with it.

Can we check it -after- the inode has otherwise been validated
and do the conversion then?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
