Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33329 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727204AbfBAHZW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 02:25:22 -0500
Date: Fri, 1 Feb 2019 08:25:20 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/11] xfs: don't try to map blocks beyond i_size in
 writeback
Message-ID: <20190201072520.GB14711@lst.de>
References: <20190131075524.4769-1-hch@lst.de> <20190131075524.4769-5-hch@lst.de> <20190131181108.GF36239@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131181108.GF36239@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 01:11:09PM -0500, Brian Foster wrote:
> The code looks fine, but I don't see any more value in this code than
> the similar code down in xfs_iomap_write_allocate(). The comment implies
> this skips writeback for the rest of the file, but AFACT the higher
> level page->index code in xfs_do_writepage() already does that. All
> these checks do is skip the remaining blocks in the current page. When
> you consider that we're most likely sending an I/O in the latter case
> either way, I'm curious why we'd bother to keep this around at all.

It just seems a little pointless to take locks and do a lookup in the
extent tree.  But I can try dropping it and re-run tests without it.
