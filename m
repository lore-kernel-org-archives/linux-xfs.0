Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39420 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdCPNUy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2017 09:20:54 -0400
Date: Thu, 16 Mar 2017 06:20:52 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 3/8] nowait aio: return if direct write will trigger
 writeback
Message-ID: <20170316132052.GG4033@bombadil.infradead.org>
References: <20170315215107.5628-1-rgoldwyn@suse.de>
 <20170315215107.5628-4-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170315215107.5628-4-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Wed, Mar 15, 2017 at 04:51:02PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Find out if the write will trigger a wait due to writeback. If yes,
> return -EAGAIN.
> 
> This introduces a new function filemap_range_has_page() which
> returns true if the file's mapping has a page within the range
> mentioned.
> 
> Return -EINVAL for buffered AIO: there are multiple causes of
> delay such as page locks, dirty throttling logic, page loading
> from disk etc. which cannot be taken care of.

Also, this patch only touches the write path; we have a similar call to
write_and_wait_range() in generic_file_read_iter().

Actually, why do we even have that?  Why can't we satisfy an O_DIRECT
read from the cache?
