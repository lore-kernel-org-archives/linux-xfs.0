Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F303FC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 06:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1C03208B3
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 06:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbhAWGmY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 01:42:24 -0500
Received: from verein.lst.de ([213.95.11.211]:39268 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbhAWGmW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 01:42:22 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7426968B05; Sat, 23 Jan 2021 07:41:39 +0100 (CET)
Date:   Sat, 23 Jan 2021 07:41:39 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reduce ilock acquisitions in xfs_file_fsync
Message-ID: <20210123064139.GA709@lst.de>
References: <20210122164643.620257-1-hch@lst.de> <20210122164643.620257-3-hch@lst.de> <20210122210801.GD4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122210801.GD4662@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 08:08:01AM +1100, Dave Chinner wrote:
> That is, we already elide the call to generic_write_sync() in direct
> IO in the case that the device supports FUA and it's a pure
> overwrite with no dirty metadata on the inode. Hence for a lot of
> storage and AIO/io_uring+DIO w/ O_DSYNC workloads we're already
> eliding this fsync-based lock cycle.
> 
> In the case where we can't do a REQ_FUA IO because it is not
> supported by the device, then don't we really only need a cache
> flush at IO completion rather than the full generic_write_sync()
> call path? That would provide this optimisation to all the
> filesystems using iomap_dio_rw(), not just XFS....
> 
> In fact, I wonder if we need to do anything other than just use
> REQ_FUA unconditionally in iomap for this situation, as the block
> layer will translate REQ_FUA to a write+post-flush if the device
> doesn't support FUA writes directly.
> 
> You're thoughts on that, Christoph?

For the pure overwrite O_DIRECT + O_DSYNC case we'd get away with just
a flush.  And using REQ_FUA will get us there, so it might be worth
a try.
