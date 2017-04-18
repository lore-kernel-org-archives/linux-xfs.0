Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756543AbdDRLjI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Apr 2017 07:39:08 -0400
Date: Tue, 18 Apr 2017 13:39:02 +0200
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 8/8] nowait aio: btrfs
Message-ID: <20170418113902.GS4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170414120257.8932-1-rgoldwyn@suse.de>
 <20170414120257.8932-9-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170414120257.8932-9-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Fri, Apr 14, 2017 at 07:02:57AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Return EAGAIN if any of the following checks fail
>  + i_rwsem is not lockable
>  + NODATACOW or PREALLOC is not set
>  + Cannot nocow at the desired location
>  + Writing beyond end of file which is not allocated
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Acked-by: David Sterba <dsterba@suse.com>

> +	if ((iocb->ki_flags & IOCB_NOWAIT) &&
> +			(iocb->ki_flags & IOCB_DIRECT)) {
> +		/* Don't sleep on inode rwsem */
> +		if (!inode_trylock(inode))
> +			return -EAGAIN;
> +		/*
> +		 * We will allocate space in case nodatacow is not set,
> +		 * so bail
> +		 */
> +		if (!(BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
> +					      BTRFS_INODE_PREALLOC)) ||
> +		    check_can_nocow(BTRFS_I(inode), pos, &count) <= 0) {
> +			inode_unlock(inode);
> +			return -EAGAIN;
> +		}
> +	} else

	} else {

> +		inode_lock(inode);

	}
