Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C6CC43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9334F222CF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfKMEIS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 23:08:18 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:37560 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727032AbfKMEIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 23:08:17 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B10193A1E69;
        Wed, 13 Nov 2019 15:08:12 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iUjwx-0001D1-LJ; Wed, 13 Nov 2019 15:08:11 +1100
Date:   Wed, 13 Nov 2019 15:08:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
Message-ID: <20191113040811.GS4614@dread.disaster.area>
References: <20191111213630.14680-1-amir73il@gmail.com>
 <20191111223508.GS6219@magnolia>
 <CAOQ4uxgC8Gz+uyCaV_Prw=uUVNtwv0j7US8sbkfoTphC4Z6b6A@mail.gmail.com>
 <20191112211153.GO4614@dread.disaster.area>
 <20191113035611.GE6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113035611.GE6219@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=Q3LfPZcm-AddFAA5BcUA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 07:56:11PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 13, 2019 at 08:11:53AM +1100, Dave Chinner wrote:
> > Backwards comaptible in-place upgrades are largely a myth: we don't
> > allow changes to the on-disk format without feature bits that limit
> > what old kernels can do with new formats. In this case it requires
> > an incompat bit because the moment an upper bit in the ns field is
> > set then the timestamps go bad on old kernels. Hence it's not a
> > compatible change and filesytems with this format cannot be mounted
> > on kernels that don't support it.
> > 
> > So, an in-place upgrade process is a one-way operation - once you
> > start converting and have >2038 dates, there is no going back
> > without an offline admin operation. That means there's no real need
> > to try to retain the old format at all. IOWs, for in-place upgrade,
> > all we need is an inode flag to indicate what format the timestamp
> > is in once the superblock incompat flag is set. Eventually the SB
> > flag becomes the mkfs default, and then eventually it becomes the
> > only supported format. This is what we've done before for things
> > like NLINK, ATTR2, etc.
> 
> /me is confused, are you advocating for an upgrade path that is: (1)
> admin sets incompat feature; (2) as people try to store dates beyond
> 2038 we set an inode flag and write the timestamp in the new format?

If we decide that we want to allow in-place upgrade, then this is
the way we've done it in the past. remember how long we supported
reading v1 inodes but only supported writing v2 inodes? i.e. we
converted old 16 bit nlink inodes to 32 bit nlink inodes silently
and automatically when they were dirtied.

i.e. once the superblock feature bit is set, we can convert inode
the timestamp format on inode writeback.

> I guess we could do that.  I'd kinda thought that we'd just set an
> incompat flag and users simply have to backup, reformat, and reinstall.
> OTOH it's a fairly minor update so maybe we can support one way upgrade.

Sure, we can do that, too, but the kernel code still has to support
reading and write both formats. Given that, on-the fly conversion is
a trivial addition to the code...

> > > One thing I wasn't certain about is that it seems that xfs (and xfs_repair)
> > > allows for negative nsec value. Not sure if that is intentional and why.
> > > I suppose it is an oversight? That is something that xfs_repair would
> > > need to check and fix before upgrade if we do go with the epoch bits.
> > 
> > It's not an oversight - it's somethign the on-disk format allowed.
> > Who knows if it ever got used (or how it got used), but it's
> > somethign we can only fix by changing the on-disk format (as you can
> > see from the discussion above).
> 
> The disk format allows it; scrub warns about it, and the kernel at least
> in theory clamps the nsec value to 0...1e9.

Yup, but those are relatively recent things when compared to when
the XFS on-disk format was defined... :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
