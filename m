Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 466DBC001DF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 12:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjGTMJW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 08:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjGTMJU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 08:09:20 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C68268C;
        Thu, 20 Jul 2023 05:09:15 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E90C16732D; Thu, 20 Jul 2023 14:09:10 +0200 (CEST)
Date:   Thu, 20 Jul 2023 14:09:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] block: use iomap for writes to block devices
Message-ID: <20230720120910.GB13266@lst.de>
References: <20230424054926.26927-1-hch@lst.de> <20230424054926.26927-17-hch@lst.de> <b96b397e-2f5e-7910-3bb3-7405d0e293a7@suse.de> <ZG09wR4WOI8zDxJK@dread.disaster.area> <ZG4SGYOogQtEZrll@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZG4SGYOogQtEZrll@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 24, 2023 at 02:33:13PM +0100, Matthew Wilcox wrote:
> As you can see, do_page_cache_ra() does limit readahead to i_size.
> Is ractl->mapping->host the correct way to find the inode?  I always
> get confused.

As far as I can tell it is the right inode, the indirection through
file->f_mapping ensures it actually points to the backing inode.
