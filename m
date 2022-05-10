Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EDEC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 22:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiEJWF2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 18:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiEJWF1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 18:05:27 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F645262665
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 15:05:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AC2D15345E2;
        Wed, 11 May 2022 08:05:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1noXyt-00AS7m-Hl; Wed, 11 May 2022 08:05:23 +1000
Date:   Wed, 11 May 2022 08:05:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [QUESTION] Upgrade xfs filesystem to reflink support?
Message-ID: <20220510220523.GU1098723@dread.disaster.area>
References: <CAOQ4uxjBR_Z-j_g8teFBih7XPiUCtELgf=k8=_ye84J00ro+RA@mail.gmail.com>
 <20220509182043.GW27195@magnolia>
 <CAOQ4uxih7gP25XHh0wm6g9A0b8z05xAbvqEGHD8a_2uw-oDBSw@mail.gmail.com>
 <20220510190212.GC27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510190212.GC27195@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=627ae1a5
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=8PpxK2j8F9KN90Y3Yw8A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 12:02:12PM -0700, Darrick J. Wong wrote:
> On Tue, May 10, 2022 at 09:21:03AM +0300, Amir Goldstein wrote:
> > On Mon, May 9, 2022 at 9:20 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > I think the upcoming nrext64 xfsprogs patches took in the first patch in
> > > that series.
> > >
> > > Question: Now that mkfs has a min logsize of 64MB, should we refuse
> > > upgrades for any filesystem with logsize < 64MB?
> > 
> > I think that would make a lot of sense. We do need to reduce the upgrade
> > test matrix as much as we can, at least as a starting point.
> > Our customers would have started with at least 1TB fs, so should not
> > have a problem with minimum logsize on upgrade.
> > 
> > BTW, in LSFMM, Ted had a session about "Resize patterns" regarding the
> > practice of users to start with a small fs and grow it, which is encouraged by
> > Cloud providers pricing model.
> > 
> > I had asked Ted about the option to resize the ext4 journal and he replied
> > that in theory it could be done, because the ext4 journal does not need to be
> > contiguous. He thought that it was not the case for XFS though.
> 
> It's theoretically possible, but I'd bet that making it work reliably
> will be difficult for an infrequent operation.  The old log would probably
> have to clean itself, and then write a single transaction containing
> both the bnobt update to allocate the new log as well as an EFI to erase
> it.  Then you write to the new log a single transaction containing the
> superblock and an EFI to free the old log.  Then you update the primary
> super and force it out to disk, un-quiesce the log, and finish that EFI
> so that the old log gets freed.
> 
> And then you have to go back and find the necessary parts that I missed.

The new log transaction to say "the new log is over there" so log
recovery knows that the old log is being replaced and can go find
the new log and recover it to free the old log.

IOWs, there's a heap of log recovery work needed, a new
intent/transaction type, futzing with feature bits because old
kernels won't be able to recovery such a operation, etc.

Then there's interesting issues that haven't ever been considered,
like having a discontiguity in the LSN as we physically switch logs.
What cycle number does the new log start at? What happens to all the
head and tail tracking fields when we switch to the new log? What
about all the log items in the AIL which is ordered by LSN? What
about all the active log items that track a specific LSN for
recovery integrity purposes (e.g. inode allocation buffers)? What
about updating the reservation grant heads that track log space
usage? Updating all the static size calculations used by the log
code which has to be done before the new log can be written to via
iclogs.

The allocation of the new log extent and the freeing of the old log
extent is the easy bit. Handling the failure cases to provide an
atomic, always recoverable switch and managing all the runtime state
and accounting changes that are necessary is the hard part...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
