Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42290 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdCADqo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 22:46:44 -0500
Date: Tue, 28 Feb 2017 19:46:06 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 3/8] nowait aio: return if direct write will trigger
 writeback
Message-ID: <20170301034606.GK16328@bombadil.infradead.org>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-4-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228233610.25456-4-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: jack@suse.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Tue, Feb 28, 2017 at 05:36:05PM -0600, Goldwyn Rodrigues wrote:
> Find out if the write will trigger a wait due to writeback. If yes,
> return -EAGAIN.
> 
> This introduces a new function filemap_range_has_page() which
> returns true if the file's mapping has a page within the range
> mentioned.

Ugh, this is pretty inefficient.  If that's all you want to know, then
using the radix tree directly will be far more efficient than spinning
up all the pagevec machinery only to discard the pages found.

But what's going to kick these pages out of cache?  Shouldn't we rather
find the pages, kick them out if clean, start writeback if not, and *then*
return -EAGAIN?

So maybe we want to spin up the pagevec machinery after all so we can
do that extra work?

