Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C13C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 21:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8C0E23977
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 21:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbhANVdm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 16:33:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727659AbhANVdl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 16:33:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F62823977;
        Thu, 14 Jan 2021 21:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610659980;
        bh=ytvt16heIVP2JlUI5SXIMt2ISRUxZLr1TDTHI01cXmg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PjOK8fT1bTp9J04mJZ7of06ZH9XmC3nJ02RtPySkGTrsYydVptOqAs03Jso09nmTx
         AfRAhNU/QPCuL8tJluI7r44gXZdS/AfHvP28Eg8UC3NCsyhQ0dQpMkRfxXP3I/001s
         smMHqqo/oJc7TTE79utAW/+xcLkhNG/fLBDY15rYNxgrhzUTabPcRFgKdyIv9RpqRo
         pp4+T5Yt8T1vEOcd5C13pzIYxPt9f/bC6FzdPykVhYvGgr4o/x2QYYB/DJ2zSxdJsH
         3qP4NTMiPCZ/aJimC+1IC1b8+HMJWooWR6/PWbiQhHA5bohfNIb7aRPzxoyCo40vNM
         +TqpCRCYSdqDg==
Date:   Thu, 14 Jan 2021 13:32:59 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <20210114213259.GF1164246@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040740189.1582286.17385075679159461086.stgit@magnolia>
 <X/8IfJj+qgnl303O@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/8IfJj+qgnl303O@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 03:49:32PM +0100, Christoph Hellwig wrote:
> > +/* Estimate the amount of parallelism available for a given device. */
> > +unsigned int
> > +xfs_buftarg_guess_threads(
> > +	struct xfs_buftarg	*btp)
> > +{
> > +	int			iomin;
> > +	int			ioopt;
> > +
> > +	/*
> > +	 * The device tells us that it is non-rotational, and we take that to
> > +	 * mean there are no moving parts and that the device can handle all
> > +	 * the CPUs throwing IO requests at it.
> > +	 */
> > +	if (blk_queue_nonrot(btp->bt_bdev->bd_disk->queue))
> > +		return num_online_cpus();
> > +
> > +	/*
> > +	 * The device has a preferred and minimum IO size that suggest a RAID
> > +	 * setup, so infer the number of disks and assume that the parallelism
> > +	 * is equal to the disk count.
> > +	 */
> > +	iomin = bdev_io_min(btp->bt_bdev);
> > +	ioopt = bdev_io_opt(btp->bt_bdev);
> > +	if (iomin > 0 && ioopt > iomin)
> > +		return ioopt / iomin;
> > +
> > +	/*
> > +	 * The device did not indicate that it has any capabilities beyond that
> > +	 * of a rotating disk with a single drive head, so we estimate no
> > +	 * parallelism at all.
> > +	 */
> > +	return 1;
> > +}
> 
> Why is this in xfs_buf.c despite having nothing to do with the buffer
> cache?

Initially I assigned it to the buftarg code on the grounds that this is
how you'd estimate the level of parallelism available through the data
device buftarg.

I don't really care where it goes, though.  xfs_pwork_guess_threads
would be fine too.

> Also I think we need some sort of manual override in case the guess is
> wrong.

Hm, where would we put it?  One of the xfs sysctls?  And would we be
able to resize the background blockgc workqueue size too?

--D
