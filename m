Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABD9C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 17:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiEPR7q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 13:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiEPR7p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 13:59:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8253B39BBA
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 10:59:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A1ED610D5
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 17:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FB8C385AA;
        Mon, 16 May 2022 17:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652723983;
        bh=7WZcbtG2C8XB++rumG8NnHTO4pmKZN0uhSRh2w45tR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IcygrzSR4G4D93XCEDhl615Aq0U0GLWSWC23eXJTIKcLB5LCIZ7YGPvBwlSOWHkdv
         qdaS+9kn51w+YGlh650OdTnQe7gYP32kt55zvx0UJ44doBqQmsp3UE4s8MhOeOMuau
         FHLfO4DhQa5RON0RqKQMcS85WuB7kJdZvZLVGiEEizfuKxaNUEAxmTbZ2FagDFGlvU
         Y/0VxLHY2XY7HK9ygkN1VHfNp18cDgne56AU9hjv+ZQA8JTV+OZ3jmzaPFaX1BL95x
         Ash5r8u+7FC5J0EPunRvbHTTEl3MFDb+R5TNBQ55oLUc+TbJV3Tc7ncqqjg76Gh6E2
         MGPc2ohLfd3sg==
Date:   Mon, 16 May 2022 10:59:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_repair: detect v5 featureset mismatches in
 secondary supers
Message-ID: <YoKRDhAgythlT0if@magnolia>
References: <165176674590.248791.17672675617466150793.stgit@magnolia>
 <165176675148.248791.14783205262181556770.stgit@magnolia>
 <57914c5f-c39a-e3de-14cf-6565ee82f834@redhat.com>
 <20220512191329.GH27195@magnolia>
 <20220516081153.GO1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516081153.GO1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 16, 2022 at 06:11:53PM +1000, Dave Chinner wrote:
> On Thu, May 12, 2022 at 12:13:29PM -0700, Darrick J. Wong wrote:
> > On Thu, May 12, 2022 at 02:02:33PM -0500, Eric Sandeen wrote:
> > > On 5/5/22 11:05 AM, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Make sure we detect and correct mismatches between the V5 features
> > > > described in the primary and the secondary superblocks.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > 
> > > 
> > > > +	if ((mp->m_sb.sb_features_incompat ^ sb->sb_features_incompat) &
> > > > +			~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR) {
> > > 
> > > I'd like to add a comment about why XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR is special.
> > > (Why is XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR special? Just because userspace doesn't
> > > bother to set it on all superblocks in the upgrade paths, right?)
> > 
> > Right -- we only set it on the primary super to force users to run
> > xfs_repair.  Repair will clear NEEDSREPAIR on the primary and all
> > secondaries before it exits
> 
> Oh no it doesn't! :)
> 
> I just debugged the persistent xfs/158 failure down to repair only
> writing the secondary superblocks with "features_changed" is true.
> 
> xfs/158 trashes the repair process after setting the inobtcnt and
> needrepair feature bits in the primary superblock. That's the only
> code that sets the internal "features_changed" flag that triggers
> secondary superblock writeback. If repair then dies after this it
> won't get set on the next run without the upgrade options set on the
> command line. Hence we re-run repair without the upgrade feature
> being enabled to check that it still recovers correctly.
> 
> The result is that repair does the right thing in completing the
> feature upgrade because it sees the feature flag in the primary
> superblock, but it *never sets "features_changed"* and so the
> secondary superblocks are not updated when it is done. It then goes
> on to check NEEDSREPAIR in the primary superblock and clears it,
> allowing the fileystem to mount again.
> 
> This results in secondary superblocks with in-progress set and
> mis-matched feature bits, resulting in xfs_scrub reporting corrupt
> secondary superblocks and so failing the test.
> 
> This change will probably mask that specific bug - it'll still be
> lying their waiting to pounce on some unsuspecting bystander, but it
> will be masked by other code detecting the feature mismatch that it
> causes and correcting it that way...

Ah, ok.  You're pointing out that repair needs to set features_changed
right after printing "clearing needsrepair flag and regenerating
metadata", and that this patch sort of papers over the underlying issue.

The genesis of this patch wasn't xfs/158 failing, it was the secondary
sb fuzz testing noticing that xfs_scrub reported a failure whereas
xfs_repair didn't.

So, I'll go add an extra patch to fix the upgrade case, and I think we
can let Eric add this one to his tree.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
