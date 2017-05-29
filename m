Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56023 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750844AbdE2IVS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 May 2017 04:21:18 -0400
Date: Mon, 29 May 2017 10:21:14 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 09/10] xfs: nowait aio support
Message-ID: <20170529082114.GC3608@quack2.suse.cz>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
 <20170524164150.9492-10-rgoldwyn@suse.de>
 <20170528093113.GB14519@infradead.org>
 <cfc1e7ad-f74b-a14a-ac30-8472f7f684af@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfc1e7ad-f74b-a14a-ac30-8472f7f684af@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Sun 28-05-17 21:38:26, Goldwyn Rodrigues wrote:
> On 05/28/2017 04:31 AM, Christoph Hellwig wrote:
> > Despite my previous reviewed-by tag this will need another fix:
> > 
> > xfs_file_iomap_begin needs to return EAGAIN if we don't have the extent
> > list in memoery already.  E.g. something like this:
> > 
> > 	if ((flags & IOMAP_NOWAIT) && !(ip->i_d.if_flags & XFS_IFEXTENTS)) {
> > 		error = -EAGAIN;
> > 		goto out_unlock;
> > 	}
> > 
> > right after locking the ilock.
> 
> I am not sure if it is right to penalize the application to write to
> file which has been freshly opened (and is the first one to open). It
> basically means extent maps needs to be read from disk. Do you see a
> reason it would have a non-deterministic wait if it is the only user? I
> understand the block layer can block if it has too many requests though.

Well, submitting such write will have to wait for read of metadata from
disk. That is certainly considered blocking so Christoph is right that we
must return EAGAIN in such case.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
