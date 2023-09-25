Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E234CE7A95
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 15:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjIYPS2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbjIYPS1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 11:18:27 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE4B109;
        Mon, 25 Sep 2023 08:18:20 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C6B0C68D05; Mon, 25 Sep 2023 17:18:16 +0200 (CEST)
Date:   Mon, 25 Sep 2023 17:18:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, brauner@kernel.org,
        syzbot+1fa947e7f09e136925b8@syzkaller.appspotmail.com
Subject: Re: [PATCH] iomap: add a workaround for racy i_size updates on
 block devices
Message-ID: <20230925151816.GA444@lst.de>
References: <20230925095133.311224-1-hch@lst.de> <20230925150902.GA11456@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230925150902.GA11456@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 25, 2023 at 08:09:02AM -0700, Darrick J. Wong wrote:
> > +			/*
> > +			 * This can happen if truncating the block device races
> > +			 * with the check in the caller as i_size updates on
> > +			 * block devices aren't synchronized by i_rwsem for
> > +			 * block devices.
> 
> Why /are/ bdevs special like this (not holding i_rwsem during a
> truncate) anyway?  Is it because we require the sysadmin to coordinate
> device shrink vs. running programs?

It's not just truncate, they also don't hold a lock on write.

I think the reason is that there is no such things as the block allocator
and block truncation that happens for block devices, they historically
had a fixed size, and at some point we allowed to change that size
by various crude means that are only slowly becoming more standardized
and formal.  Real block device size changes are about 100% growing of
the device, as that is an actually useful feature.  Shrinks OTOH are
usuall a "cute" hack: block drivers set the size to 0 stop I/O when they
are shut down.  I've been wanting to replace that with an actual check
in the bdev fd I/O path for a while, but that would also mean the
shrinking case would still be around, just exercised a lot less.

