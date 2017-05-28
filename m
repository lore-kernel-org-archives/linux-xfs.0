Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56509 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbdE1JbY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2017 05:31:24 -0400
Date: Sun, 28 May 2017 02:31:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/10] xfs: nowait aio support
Message-ID: <20170528093113.GB14519@infradead.org>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
 <20170524164150.9492-10-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170524164150.9492-10-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>

Despite my previous reviewed-by tag this will need another fix:

xfs_file_iomap_begin needs to return EAGAIN if we don't have the extent
list in memoery already.  E.g. something like this:

	if ((flags & IOMAP_NOWAIT) && !(ip->i_d.if_flags & XFS_IFEXTENTS)) {
		error = -EAGAIN;
		goto out_unlock;
	}

right after locking the ilock.
