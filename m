Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFA4C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 06:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06A5D2253D
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 06:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgLDGLm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 01:11:42 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:51054 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725550AbgLDGLm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 01:11:42 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id B5D2D1098D7;
        Fri,  4 Dec 2020 17:10:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kl4J1-000JjL-1W; Fri, 04 Dec 2020 17:10:59 +1100
Date:   Fri, 4 Dec 2020 17:10:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] spaceman: physically move a regular inode
Message-ID: <20201204061059.GF3913616@dread.disaster.area>
References: <20201110225924.4031404-1-david@fromorbit.com>
 <20201201140742.GA1205666@bfoster>
 <20201201211557.GL2842436@dread.disaster.area>
 <20201202123006.GA1278877@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202123006.GA1278877@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=0euc3Nsfh_ZNLAS2PgwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 02, 2020 at 07:30:06AM -0500, Brian Foster wrote:
> On Wed, Dec 02, 2020 at 08:15:57AM +1100, Dave Chinner wrote:
> > On Tue, Dec 01, 2020 at 09:07:42AM -0500, Brian Foster wrote:
> > > On Wed, Nov 11, 2020 at 09:59:24AM +1100, Dave Chinner wrote:
> > > For example, might it make sense to implement a policy where move_inode
> > > simply moves an inode to the first AG the tempdir lands in that is < the
> > > AG of the source inode? We'd probably want to be careful to make sure
> > > that we don't attempt to dump the entire set of moved files into the
> > > same AG, but I assume the temp dir creation logic would effectively
> > > rotor across the remaining set of AGs we do want to allow.. Thoughts?
> > 
> > Yes, we could. But I simply decided that a basic, robust shrink to
> > the minimum possible size will have to fill the filesystem from AG 0
> > up, and not move to AG 1 until AG 0 is full.  I also know that the
> > kernel allocation policies will skip to the next AG if there is lock
> > contention, space or other allocation setup issues, hence I wanted
> > to be able to direct movement to the lowest possible AGs first...
> > 
> > THere's enough complexity in an optimal shrink implementation that
> > it will keep someone busy full time for a couple of years. I want to
> > provide the basic functionality userspace needs only spending a
> > couple of days a week for a couple of months on it. If we want it
> > fast and deployable on existing systems, compromises will need to be
> > made...
> > 
> 
> Yeah, I'm not suggesting we implement the eventual policy here. I do
> think it would be nice if the userspace command implemented some
> reasonable default when a target AG is not specified. That could be the
> "anything less than source AG" logic I described above, a default target
> of AG 0, or something similarly simple...

That's the plan. This patch is just a way of testing the mechanism
in a simple way without involving a full shrink or scanning AGs, or
anything like that.

i.e:

$ ~/packages/xfs_spaceman  -c "help move_inode" -c "help find_owner" -c "help resolve_owner" -c "help relocate" /mnt/scratch
move_inode -a agno -- Move an inode into a new AG.

Physically move an inode into a new allocation group

 -a agno       -- destination AG agno for the current open file

find_owner -a agno -- Find inodes owning physical blocks in a given AG

Find inodes owning physical blocks in a given AG.

 -a agno  -- Scan the given AG agno.

resolve_owner  -- Resolve paths to inodes owning physical blocks in a given AG

Resolve inodes owning physical blocks in a given AG.  This requires
the find_owner command to be run first to populate the table of
inodes that need to have their paths resolved.

relocate -a agno [-h agno] -- Relocate data in an AG.

Relocate all the user data and metadata in an AG.

This function will discover all the relocatable objects in a single
AG and move them to a lower AG as preparation for a shrink
operation.

	-a <agno>       Allocation group to empty
	-h <agno>       Highest target AG allowed to relocate into
$

So, essentially, I can test all the bits in one command with
"relocate", or I can test different types of objects 1 at a time
with "move_inode", or I can look at what "relocate" failed to move
with "find_owner" and "resolve_owner"....

An actual shrink operation will effectively run "relocate" on all
the AGs that it wants to empty, setting the highest AG that
relocation is allowed into to the last full AG that will remain in
the shrunk filesystem, then check the AGs are empty, then run the
shrink ioctl....

But to get there, I'm bootstrapping the functionality one testable
module at a time, then refactoring them to combine them into more
complex operations...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
