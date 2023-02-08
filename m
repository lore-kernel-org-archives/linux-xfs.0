Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6544C05027
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 19:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbjBHTlF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 14:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBHTlE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 14:41:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369884C6F9
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 11:41:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE96FB81F26
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 19:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520F0C433EF;
        Wed,  8 Feb 2023 19:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675885260;
        bh=Lb7tQdks6HDiMN1x4sSbLkSXzXRsdUoztkshy47WEI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g4+lNTLWcNGN03HtsbSubSt/zKjgTqWHj1VtaCDKX4c1rdVJY14kaIE0Lvz5ncIUU
         51E3pDMwKKKrrvjVI8K7VnxjPpVZ76OP3r02BXVhji7I6d8npTBBEMoY4ERZ3yOrgd
         P8MVGErFiiFl/4g9hR0MFuTzcOhFMG/el6oWSsF3J2V/laohCr2nisMHROuwxa79w5
         q924UjydsmzFV0I2pKwE+YR7ojfZ7fV4IoTvSH9Z0fbd1rS7NCoE3tfmV5NtmQ+AmU
         0d3j9HHNd4ClGpvdwYLdOGQo/VZa9zgZmBV4qu1dolrXDWmqpUTMxyFrbibCDcC10a
         9qKfMlBMDqKMg==
Date:   Wed, 8 Feb 2023 11:40:59 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>, linux-xfs@vger.kernel.org,
        chandan.babu@oracle.com, Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE 00/10] more xfs fixes for 5.15
Message-ID: <Y+P6y81Wmf4L66LC@magnolia>
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
 <CAOQ4uxgmHzWcxBDrzRb19ByCnNoayhha_MZ_eYN0YMC=RGTeMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgmHzWcxBDrzRb19ByCnNoayhha_MZ_eYN0YMC=RGTeMw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 08, 2023 at 09:02:58PM +0200, Amir Goldstein wrote:
> On Wed, Feb 8, 2023 at 7:52 PM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> >
> > Hello again,
> >
> > Here is the next batch of backports for 5.15.y. Testing included
> > 25 runs of auto group on 12 xfs configs. No regressions were seen.
> > I checked xfs/538 was run without issue as this test was mentioned
> > in 56486f307100. Also, from 86d40f1e49e9, I ran ran xfs/117 with
> > XFS compiled as a module and TEST_FS_MODULE_REOLOAD set, but I was
> > unable to reproduce the issue.
> 
> Did you find any tests that started to pass or whose failure rate reduced?

I wish Leah had, but there basically aren't any tests for the problems
fixed in this set for her to find. :(

The first two patches I think were from when Dave was working on log
intent whiteouts, turned on KASAN to diagnose some other problem he had,
and began pulling on the ball of string (as it were) as he noticed other
things in the codebase.  We don't usually bother with regression tests
for kernel memory leaks, since they're not so easy to reproduce.

Patches 3-6 are fixes for a rash of fuzzer reports that someone in China
posted last May:
https://bugzilla.kernel.org/show_bug.cgi?id=215927

(There are more than just that one)

As usual, the submitter didn't bother to help triage and just dumped a
ton of work in our laps.  They didn't follow up with any regression
tests, because few fuzz kiddiez ever do.  At the time, I was too burned
out to deal with it, so Dave posted fixes.

Patches 7-8 would manifest themselves as test VMs halting on ASSERTs if
you configure your kernel to panic.  Not strictly needed since most LTS
kernels probably don't even have XFS_DEBUG=y, but it makes the lives of
recoveryloop runners easier if they do.

Patch 9 trips xfs/434 and xfs/436, but they only run if you have slab
debugging enabled and build XFS as a module.  I don't know why very few
people do this.

Patch 10 is a memory leak if you have XFS_DEBUG=y.  No need for a
separate test for this one, since kmemleak catches it.  If you turn it
on.

(IOWs, LGTM for the whole set.)

> There are very few Fixes: annotations in these commits so it is hard for
> me to assess if any of them are relevant/important/worth the effort/risk
> to backport to 5.10.

<nod> Dave's fixpatches rarely have Fixes tags attached.  It's difficult
to get him to do that because he has so much bad history with AUTOSEL.
I've tried to get him to add them in the past, but if I'm already
stressed out and Dave doesn't reply then I tend to merge the fix and
move on.

> Unless I know of reproducible bugs in 5.10, I don't think I will invest
> in backporting this series to 5.10.
> Chandan, if you find any of these fixes relevant and important for 5.4
> let me know and I will make the effort to consider them for 5.10.
> 
> Leah, please consider working on the SGID bug fixes for the next 5.15
> update, because my 5.10 SGID fixes series [1] has been blocked for
> months and because there are several reproducible test cases in xfstest.

Whenever y'all get to 6.0, beware of commit 2ed5b09b3e8f ("xfs: make
inode attribute forks a permanent part of struct xfs_inode"), which is a
KASAN UAF that we fixed by eliminating the 'F'.  Do not pull on the
devilstring ("...the file capabilities code calls getxattr with and
without i_rwsem held...") if you can avoid it.

> I did not push on that until now because SGID test expectations were
> a moving target, but since xfstests commit 81e6f628 ("generic: update
> setgid tests") in this week's xfstests release, I think that tests should be
> stable and we can finally start backporting all relevant SGID fixes to
> align the SGID behavior of LTS kernels with that of upstream.

Oh good, I've been (gently) waiting on that one too. :)

--D

> Thanks,
> Amir.
> 
> [1] https://github.com/amir73il/linux/commits/xfs-5.10.y-sgid-fixes
> 
> >
> > Below I've outlined which series the backports came from:
> >
> > series "xfs: intent whiteouts" (1):
> > [01/10] cb512c921639613ce03f87e62c5e93ed9fe8c84d
> >     xfs: zero inode fork buffer at allocation
> > [02/10] c230a4a85bcdbfc1a7415deec6caf04e8fca1301
> >     xfs: fix potential log item leak
> >
> > series "xfs: fix random format verification issues" (2):
> > [1/4] dc04db2aa7c9307e740d6d0e173085301c173b1a
> >     xfs: detect self referencing btree sibling pointers
> > [2/4] 1eb70f54c445fcbb25817841e774adb3d912f3e8 -> already in 5.15.y
> >     xfs: validate inode fork size against fork format
> > [3/4] dd0d2f9755191690541b09e6385d0f8cd8bc9d8f
> >     xfs: set XFS_FEAT_NLINK correctly
> > [4/4] f0f5f658065a5af09126ec892e4c383540a1c77f
> >     xfs: validate v5 feature fields
> >
> > series "xfs: small fixes for 5.19 cycle" (3):
> > [1/3] 5672225e8f2a872a22b0cecedba7a6644af1fb84
> >     xfs: avoid unnecessary runtime sibling pointer endian conversions
> > [2/3] 5b55cbc2d72632e874e50d2e36bce608e55aaaea
> >     fs: don't assert fail on perag references on teardown
> > [2/3] 56486f307100e8fc66efa2ebd8a71941fa10bf6f
> >     xfs: assert in xfs_btree_del_cursor should take into account error
> >
> > series "xfs: random fixes for 5.19" (4):
> > [1/2] 86d40f1e49e9a909d25c35ba01bea80dbcd758cb
> >     xfs: purge dquots after inode walk fails during quotacheck
> > [2/2] a54f78def73d847cb060b18c4e4a3d1d26c9ca6d
> >     xfs: don't leak btree cursor when insrec fails after a split
> >
> > (1) https://lore.kernel.org/all/20220503221728.185449-1-david@fromorbit.com/
> > (2) https://lore.kernel.org/all/20220502082018.1076561-1-david@fromorbit.com/
> > (3) https://lore.kernel.org/all/20220524022158.1849458-1-david@fromorbit.com/
> > (4) https://lore.kernel.org/all/165337056527.993079.1232300816023906959.stgit@magnolia/
> >
> > Darrick J. Wong (2):
> >   xfs: purge dquots after inode walk fails during quotacheck
> >   xfs: don't leak btree cursor when insrec fails after a split
> >
> > Dave Chinner (8):
> >   xfs: zero inode fork buffer at allocation
> >   xfs: fix potential log item leak
> >   xfs: detect self referencing btree sibling pointers
> >   xfs: set XFS_FEAT_NLINK correctly
> >   xfs: validate v5 feature fields
> >   xfs: avoid unnecessary runtime sibling pointer endian conversions
> >   xfs: don't assert fail on perag references on teardown
> >   xfs: assert in xfs_btree_del_cursor should take into account error
> >
> >  fs/xfs/libxfs/xfs_ag.c         |   3 +-
> >  fs/xfs/libxfs/xfs_btree.c      | 175 +++++++++++++++++++++++++--------
> >  fs/xfs/libxfs/xfs_inode_fork.c |  12 ++-
> >  fs/xfs/libxfs/xfs_sb.c         |  70 +++++++++++--
> >  fs/xfs/xfs_bmap_item.c         |   2 +
> >  fs/xfs/xfs_icreate_item.c      |   1 +
> >  fs/xfs/xfs_qm.c                |   9 +-
> >  fs/xfs/xfs_refcount_item.c     |   2 +
> >  fs/xfs/xfs_rmap_item.c         |   2 +
> >  9 files changed, 221 insertions(+), 55 deletions(-)
> >
> > --
> > 2.39.1.519.gcb327c4b5f-goog
> >
