Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A193CCA47F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 06:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358910AbiFPGHW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 02:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358907AbiFPGHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 02:07:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06E8CCE;
        Wed, 15 Jun 2022 23:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lQ1idLnL2UCMJjEJnkwsAGfziMzzcuwKz3HZqhqoSgY=; b=YpAt3w8FxJkqvgT9iUxi24xofx
        8+MvlP+t2PLJClmbzMh18BN6ZwDbMmncgLTl17zD+v64zcQMphUoIRaaPqzZ9Kcpf+7tyKKylosSd
        OBn0bXQZGwNn1yI7B/kUkJqGiMJWwXuRRwgQUA3cJpfiVH00RtuJeKBV1dYTiGYoxczXS8RI9iqPE
        IKx0AVVX9KzBGe6L7/GrOI+YrFxVeLneipAWwETP8dgETplOiFEcQKIPl+aG6wgIFJdwWuEWPkEWf
        I0c4yVCYAk3jbyZnzK9cGmY24O5LW7GYL7W6PZ6EU+ypD46A/EQ820J0qw64K/4/XVRxXZkCVCaTN
        vOIrX+fA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1iez-000gG0-HX; Thu, 16 Jun 2022 06:07:17 +0000
Date:   Wed, 15 Jun 2022 23:07:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-api@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH v2 1/7] statx: add I/O alignment information
Message-ID: <YqrIlVtI85zF9qyO@infradead.org>
References: <20220518235011.153058-1-ebiggers@kernel.org>
 <20220518235011.153058-2-ebiggers@kernel.org>
 <YobNXbYnhBiqniTH@magnolia>
 <20220520032739.GB1098723@dread.disaster.area>
 <YqgbuDbdH2OLcbC7@sol.localdomain>
 <YqnapOLvHDmX/3py@infradead.org>
 <YqpzqZQgu0Zz+vW1@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqpzqZQgu0Zz+vW1@sol.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 15, 2022 at 05:04:57PM -0700, Eric Biggers wrote:
> One more thing.  I'm trying to add support for STATX_DIOALIGN on block devices.
> Unfortunately I don't think it is going to work, at all, since the inode is for
> the device node and not the block device itself.  This is true even after the
> file is opened (I previously thought that at least that case would work).

For an open file the block device inode is pointed to by
file->f_mapping->host.

> Were you expecting that this would work on block devices?  It seems they will
> need a different API -- a new BLK* ioctl, or files in /sys/block/$dev/queue.

blkdev_get_no_open on inode->i_rdev gets you the block device, which
then has bdev->bd_inode point to the underlying block device, although
for a block device those limit probably would be retrieved not from
the inode but the gendisk / request_queue anyway.
