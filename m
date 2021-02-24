Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D086BC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BEFB64F14
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236219AbhBXWCU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 17:02:20 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:47313 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233880AbhBXWCU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 17:02:20 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id E332747EB3;
        Thu, 25 Feb 2021 09:01:35 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF2Dv-002lhJ-31; Thu, 25 Feb 2021 09:01:35 +1100
Date:   Thu, 25 Feb 2021 09:01:35 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: move and rename xfs_blkdev_issue_flush
Message-ID: <20210224220135.GC4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-4-david@fromorbit.com>
 <20210224204529.GS7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224204529.GS7272@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=o_jlO35omj6ZrJFDXNYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 12:45:29PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 23, 2021 at 02:34:37PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Move it to xfs_bio_io.c as we are about to add new async cache flush
> > functionality that uses bios directly, so all this stuff should be
> > in the same place. Rename the function to xfs_flush_bdev() to match
> > the xfs_rw_bdev() function that already exists in this file.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> I don't get why it's necessary to consolidate the synchronous flush
> function with the (future) async flush, since all the sync flush callers
> go through a buftarg, including the log.  All this seems to do is shift
> pointer dereferencing into callers.
> 
> Why not make the async flush function take a buftarg?

Because we pretty much got rid of the buffer/buftarg abstraction
from the log IO code completely by going direct to bios. The async
flush goes direct to bios like the rest of the log code does. And
given that xfs_blkdev_issue_flush() is just a one line wrapper
around the blkdev interface, it just seems totally weird to wrap it
differently to other interfaces that go direct to the bios and block
devices.

Part of the problem here is that we've completely screwed up the
separation/abstraction of the log from the xfs_mount and buftargs.
The log just doesn't use buftargs anymore except as a holder of the
log bdev, and the only other interaction it has with them is when
the metadata device cache needs to be invalidated after log recovery
and during unmount.

It just doesn't make sense to me to have bdev flush interfaces that
the log uses hidden behind an abstraction that the rest of the
log subsystem doesn't use...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
