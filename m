Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdFZKl5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2017 06:41:57 -0400
Date: Mon, 26 Jun 2017 03:41:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] vfs: Add page_cache_seek_hole_data helper
Message-ID: <20170626104156.GA23149@infradead.org>
References: <1498177173-30798-1-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498177173-30798-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>

On Fri, Jun 23, 2017 at 02:19:31AM +0200, Andreas Gruenbacher wrote:
> Both ext4 and xfs implement seeking for the next hole or piece of data
> in unwritten extents by scanning the page cache, and both versions share
> the same bug when iterating the buffers of a page: the start offset into
> the page isn't taken into account, so when a page fits more than two
> filesystem blocks, things will go wrong.  For example, on a filesystem
> with a block size of 1k, the following command will fail:
> 
>   xfs_io -f -c "falloc 0 4k" \
>             -c "pwrite 1k 1k" \
>             -c "pwrite 3k 1k" \
>             -c "seek -a -r 0" foo

Can you wire this up for xfstests, please?
