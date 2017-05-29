Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43736 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750897AbdE2Cid (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 28 May 2017 22:38:33 -0400
Subject: Re: [PATCH 09/10] xfs: nowait aio support
References: <20170524164150.9492-1-rgoldwyn@suse.de>
 <20170524164150.9492-10-rgoldwyn@suse.de>
 <20170528093113.GB14519@infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <cfc1e7ad-f74b-a14a-ac30-8472f7f684af@suse.de>
Date: Sun, 28 May 2017 21:38:26 -0500
MIME-Version: 1.0
In-Reply-To: <20170528093113.GB14519@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>



On 05/28/2017 04:31 AM, Christoph Hellwig wrote:
> Despite my previous reviewed-by tag this will need another fix:
> 
> xfs_file_iomap_begin needs to return EAGAIN if we don't have the extent
> list in memoery already.  E.g. something like this:
> 
> 	if ((flags & IOMAP_NOWAIT) && !(ip->i_d.if_flags & XFS_IFEXTENTS)) {
> 		error = -EAGAIN;
> 		goto out_unlock;
> 	}
> 
> right after locking the ilock.
> 

I am not sure if it is right to penalize the application to write to
file which has been freshly opened (and is the first one to open). It
basically means extent maps needs to be read from disk. Do you see a
reason it would have a non-deterministic wait if it is the only user? I
understand the block layer can block if it has too many requests though.

-- 
Goldwyn
