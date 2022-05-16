Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B09C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 08:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239849AbiEPIL6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 04:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237470AbiEPIL5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 04:11:57 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8803136B72
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 01:11:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C9F0410E670C;
        Mon, 16 May 2022 18:11:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nqVpZ-00Caf3-3N; Mon, 16 May 2022 18:11:53 +1000
Date:   Mon, 16 May 2022 18:11:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_repair: detect v5 featureset mismatches in
 secondary supers
Message-ID: <20220516081153.GO1098723@dread.disaster.area>
References: <165176674590.248791.17672675617466150793.stgit@magnolia>
 <165176675148.248791.14783205262181556770.stgit@magnolia>
 <57914c5f-c39a-e3de-14cf-6565ee82f834@redhat.com>
 <20220512191329.GH27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512191329.GH27195@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6282074b
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=jxupxQsw6ARn95slIIwA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 12, 2022 at 12:13:29PM -0700, Darrick J. Wong wrote:
> On Thu, May 12, 2022 at 02:02:33PM -0500, Eric Sandeen wrote:
> > On 5/5/22 11:05 AM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Make sure we detect and correct mismatches between the V5 features
> > > described in the primary and the secondary superblocks.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > 
> > > +	if ((mp->m_sb.sb_features_incompat ^ sb->sb_features_incompat) &
> > > +			~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR) {
> > 
> > I'd like to add a comment about why XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR is special.
> > (Why is XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR special? Just because userspace doesn't
> > bother to set it on all superblocks in the upgrade paths, right?)
> 
> Right -- we only set it on the primary super to force users to run
> xfs_repair.  Repair will clear NEEDSREPAIR on the primary and all
> secondaries before it exits

Oh no it doesn't! :)

I just debugged the persistent xfs/158 failure down to repair only
writing the secondary superblocks with "features_changed" is true.

xfs/158 trashes the repair process after setting the inobtcnt and
needrepair feature bits in the primary superblock. That's the only
code that sets the internal "features_changed" flag that triggers
secondary superblock writeback. If repair then dies after this it
won't get set on the next run without the upgrade options set on the
command line. Hence we re-run repair without the upgrade feature
being enabled to check that it still recovers correctly.

The result is that repair does the right thing in completing the
feature upgrade because it sees the feature flag in the primary
superblock, but it *never sets "features_changed"* and so the
secondary superblocks are not updated when it is done. It then goes
on to check NEEDSREPAIR in the primary superblock and clears it,
allowing the fileystem to mount again.

This results in secondary superblocks with in-progress set and
mis-matched feature bits, resulting in xfs_scrub reporting corrupt
secondary superblocks and so failing the test.

This change will probably mask that specific bug - it'll still be
lying their waiting to pounce on some unsuspecting bystander, but it
will be masked by other code detecting the feature mismatch that it
causes and correcting it that way...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
