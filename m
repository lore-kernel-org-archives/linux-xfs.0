Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EED7C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 22:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33E4E23977
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 22:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbhANWjd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 17:39:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729586AbhANWjc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 17:39:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0575F2339E;
        Thu, 14 Jan 2021 22:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610663932;
        bh=adCnwZMcG6yMOLrLEWDqhhLPUlGxcTK1G6J6o4VUvDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mA6w9h2SRHGj3wDZUcFt5qek4XeHQNUmxLz3P+ykCjbeaQyutRZ+zRkcmuSUObMXP
         QEKLXbBlUXF4xRL0XF6vsA/GSMRK7mO7L+zNNt2Ym2O8VG9T59cVkCjXB6I+Bm4Fkw
         7O0WTb58u9NeJMCE6yE27rDP6tT9APrevZFxzVn+pd0UQJG4h51ULTwGIoAVTEBLbn
         1wiTnoeTA/y1PSWBG0lgtpM673RrlKUSjT14uNPOWjhZLymu7ossR7TNM+qfBmWELX
         eDts0iwHDGfU9y9FxC85t6DhGBXnU9tI1Dd51bBhpvfQLbOxcjdxgyQGT+MzKStf6O
         drIhkHiIIdwhg==
Date:   Thu, 14 Jan 2021 14:38:49 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <20210114223849.GI1164246@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040740189.1582286.17385075679159461086.stgit@magnolia>
 <X/8IfJj+qgnl303O@infradead.org>
 <20210114213259.GF1164246@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114213259.GF1164246@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 01:32:59PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 13, 2021 at 03:49:32PM +0100, Christoph Hellwig wrote:
> > > +/* Estimate the amount of parallelism available for a given device. */
> > > +unsigned int
> > > +xfs_buftarg_guess_threads(
> > > +	struct xfs_buftarg	*btp)
> > > +{
> > > +	int			iomin;
> > > +	int			ioopt;
> > > +
> > > +	/*
> > > +	 * The device tells us that it is non-rotational, and we take that to
> > > +	 * mean there are no moving parts and that the device can handle all
> > > +	 * the CPUs throwing IO requests at it.
> > > +	 */
> > > +	if (blk_queue_nonrot(btp->bt_bdev->bd_disk->queue))
> > > +		return num_online_cpus();
> > > +
> > > +	/*
> > > +	 * The device has a preferred and minimum IO size that suggest a RAID
> > > +	 * setup, so infer the number of disks and assume that the parallelism
> > > +	 * is equal to the disk count.
> > > +	 */
> > > +	iomin = bdev_io_min(btp->bt_bdev);
> > > +	ioopt = bdev_io_opt(btp->bt_bdev);
> > > +	if (iomin > 0 && ioopt > iomin)
> > > +		return ioopt / iomin;
> > > +
> > > +	/*
> > > +	 * The device did not indicate that it has any capabilities beyond that
> > > +	 * of a rotating disk with a single drive head, so we estimate no
> > > +	 * parallelism at all.
> > > +	 */
> > > +	return 1;
> > > +}
> > 
> > Why is this in xfs_buf.c despite having nothing to do with the buffer
> > cache?
> 
> Initially I assigned it to the buftarg code on the grounds that this is
> how you'd estimate the level of parallelism available through the data
> device buftarg.
> 
> I don't really care where it goes, though.  xfs_pwork_guess_threads
> would be fine too.
> 
> > Also I think we need some sort of manual override in case the guess is
> > wrong.

There already /is/ a pwork_threads sysctl knob for controlling
quotacheck parallelism; and for the block gc workqueue I add WQ_SYSFS so
that you can set /sys/bus/workqueue/devices/xfs-*/max_active.

--D
> 
> Hm, where would we put it?  One of the xfs sysctls?  And would we be
> able to resize the background blockgc workqueue size too?

> --D
