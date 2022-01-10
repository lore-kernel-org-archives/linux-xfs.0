Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8F4C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 23:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241878AbiAJXki (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 18:40:38 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34640 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241114AbiAJXki (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 18:40:38 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EC7EE62C288;
        Tue, 11 Jan 2022 10:40:35 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n74HC-00Dn0f-Lx; Tue, 11 Jan 2022 10:40:34 +1100
Date:   Tue, 11 Jan 2022 10:40:34 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Krister Johansen <kjlx@templeofstupid.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: xfs_bmap_extents_to_btree allocation warnings
Message-ID: <20220110234034.GC945095@dread.disaster.area>
References: <20220105071052.GD20464@templeofstupid.com>
 <20220106010123.GP945095@dread.disaster.area>
 <20220106085228.GA19131@templeofstupid.com>
 <20220110084152.GX945095@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110084152.GX945095@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=61dcc3f4
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=qKF-TjJs3tvgpoR8_qAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 10, 2022 at 07:41:52PM +1100, Dave Chinner wrote:
> On Thu, Jan 06, 2022 at 12:52:28AM -0800, Krister Johansen wrote:
> > On Thu, Jan 06, 2022 at 12:01:23PM +1100, Dave Chinner wrote:
> > > On Tue, Jan 04, 2022 at 11:10:52PM -0800, Krister Johansen wrote:
> > > So 1,871,665 of 228,849,020 blocks free in the AG. That's 99.2%
> > > full, so it's extremely likely you are hitting a full AG condition.
> > > 
> > > /me goes and looks at xfs_iomap_write_direct()....
> > > 
> > > .... and notices that it passes "0" as the total allocation block
> > > count, which means it isn't reserving space in the AG for both the
> > > data extent and the BMBT blocks...
> > > 
> > > ... and several other xfs_bmapi_write() callers have the same
> > > issue...
> > > 
> > > Ok, let me spend a bit more looking into this in more depth, but it
> > > looks like the problem is at the xfs_bmapi_write() caller level, not
> > > deep in the allocator itself.
> > 
> > At least on 5.4 xfs_bmapi_write is still passing resblks instead of
> > zero, which is computed in xfs_iomap_write_direct.
> 
> yup, I missed commit da781e64b28c ("xfs: don't set bmapi total block
> req where minleft is") back in 2019 where that behaviour was
> changed, and instead it changes xfs_bmapi_write() to implcitly
> manage space for BMBT blocks via args->minleft whilst still
> explicitly requiring the caller to reserve those blocks at
> transaction allocation time.

FWIW, I should have said here that you should really add that commit
to your current tree and see if that fixes the problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
