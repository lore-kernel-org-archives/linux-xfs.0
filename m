Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CF6C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 21:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A74BB23A7A
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 21:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbhAVVKB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Jan 2021 16:10:01 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:47631 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729524AbhAVVIs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jan 2021 16:08:48 -0500
Received: from dread.disaster.area (pa49-180-243-77.pa.nsw.optusnet.com.au [49.180.243.77])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 74FD01107AFD;
        Sat, 23 Jan 2021 08:08:02 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l33ez-001Ky6-CM; Sat, 23 Jan 2021 08:08:01 +1100
Date:   Sat, 23 Jan 2021 08:08:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reduce ilock acquisitions in xfs_file_fsync
Message-ID: <20210122210801.GD4662@dread.disaster.area>
References: <20210122164643.620257-1-hch@lst.de>
 <20210122164643.620257-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122164643.620257-3-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=juxvdbeFDU67v5YkIhU0sw==:117 a=juxvdbeFDU67v5YkIhU0sw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=in2YdIHcAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=yFBkLyyzgI3YvqyS8foA:9 a=CjuIK1q_8ugA:10
        a=jvJaD-jWAXz1fu1h5wd8:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 22, 2021 at 05:46:43PM +0100, Christoph Hellwig wrote:
> If the inode is not pinned by the time fsync is called we don't need the
> ilock to protect against concurrent clearing of ili_fsync_fields as the
> inode won't need a log flush or clearing of these fields.  Not taking
> the iolock allows for full concurrency of fsync and thus O_DSYNC
> completions with io_uring/aio write submissions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Code looks good, so

Reviewed-by: Dave Chinner <dchinner@redhat.com>

But it makes me wonder...

That is, we already elide the call to generic_write_sync() in direct
IO in the case that the device supports FUA and it's a pure
overwrite with no dirty metadata on the inode. Hence for a lot of
storage and AIO/io_uring+DIO w/ O_DSYNC workloads we're already
eliding this fsync-based lock cycle.

In the case where we can't do a REQ_FUA IO because it is not
supported by the device, then don't we really only need a cache
flush at IO completion rather than the full generic_write_sync()
call path? That would provide this optimisation to all the
filesystems using iomap_dio_rw(), not just XFS....

In fact, I wonder if we need to do anything other than just use
REQ_FUA unconditionally in iomap for this situation, as the block
layer will translate REQ_FUA to a write+post-flush if the device
doesn't support FUA writes directly.

You're thoughts on that, Christoph?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
