Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:33961 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751156AbdJCUIk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:08:40 -0400
Date: Wed, 4 Oct 2017 07:07:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] xfsprogs: mkfs refactor
Message-ID: <20171003200726.GK3666@dastard>
References: <20171003080607.GM15067@dastard>
 <20171003171604.GC6503@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003171604.GC6503@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 10:16:04AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 03, 2017 at 07:06:07PM +1100, Dave Chinner wrote:
> > Hi Eric,
> > 
> > I've put the latest mkfs refactor code that I have up in place
> > you can pull it from. I've rebased it against the current for-next
> > tree (4.13.1 release) and fixed all the problems that xfstests
> > exposes. The only thing I haven't fixed is xfs/191 that does mkfs
> > command line behaviour verification because the refactored version
> > fixes several problems that the old mkfs didn't handle correctly
> > (e.g. being able to specify certain things like agsize in blocks or
> > sectors).
> > 
> > There's a small filter patch needed for xfstests that I'll post in
> > a reply to this pull request that will filter out the new "defaults
> > sourced from ..." output and so prevent spurious xfstests failures.
> > 
> > If you want I can tag the branch with a signed tag for you to pull
> > from (same process as Linus prefers) rather than just a branch in a
> > tree. If you'd prefer that I post this as patches instead, then let
> > me know and I'll bomb the list instead.
> 
> I had a look at mkfs-refactor.  It looks ok to me (I defer to Eric on
> the question of pull req. vs. patchbomb) though I have one question:
> 
> calculate_log_size calls max_trans_res, and max_trans_res assembles a
> fake struct xfs_mount in order to call libxfs_log_calc_minimum_size.
> I've fixed a few mkfs bugs over the past couple of years that all stem
> from us forgetting to propagate superblock settings from the
> configuration we're building in main() into the fake xfs_mount->m_sb
> that we use to calculate the minimum log size, which results in a
> disagreement between the kernel and mkfs as to what is the minimum log
> size for a given fs configuration.  This disagreement pops up in the
> form of a freshly mkfs'd 500MB filesystem immediately failing to mount.
> 
> With this branch applied it looks like we've nearly finished filling out
> the real xfs_mount->m_sb when we call calculate_log_size, so could we
> refactor setup_superblock to set all the non-log superblock fields in
> the real m_sb and then pass that directly into max_trans_res so that we
> can memcpy the real superblock settings into the fake struct xfs_mount?

Yes, I plan on making further cleanups like that. There are a few
others, like the remaining uses of the global block size and sector
size variables because the parameter structures are not fed into
number conversion functions that use them.

> Doing that will eliminate a whole class of "we forgot that we have to
> set sb_newfield in setup_superblock /and/ in max_trans_res and now mkfs
> creates broken filesystems" bugs.  Even now there are small
> discrepancies between (for example) tr_itruncate.tr_logres in the kernel
> and in mkfs, which make me nervous.  AFAICT the discrepancies result in
> mkfs using a minimum log size that is larger than what the kernel
> calculates, so there's no user-visible badness.

Getting rid of the max_trans_res problem will be good, but it won't
completely fix the problem up.  Other nasties in this area that need
further cleanup is the units that stripe configuration are passed
around in, when we store the log stripe unit into the superblock,
documenting what the values in the sb variable are supposed to be,
how sector size and blocksize affects LSU, etc. These were all
things I tripped over that led to similar "why doesn't this
filesystem mount/crash log recovery?" issues.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
