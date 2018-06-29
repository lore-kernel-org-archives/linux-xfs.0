Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55004 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966726AbeF2P7N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 29 Jun 2018 11:59:13 -0400
Date: Fri, 29 Jun 2018 17:59:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 23/24] iomap: add support for sub-pagesize buffered I/O
        without buffer heads
Message-ID: <20180629155920.GA9777@lst.de>
References: <20180615130209.1970-1-hch@lst.de> <20180615130209.1970-24-hch@lst.de> <20180619165211.GD2806@bfoster> <20180620075655.GA2668@lst.de> <20180620143252.GE3241@bfoster> <20180620160803.GA4838@magnolia> <20180620181259.GD4493@bfoster> <20180620190230.GB4838@magnolia> <20180621084646.GA5764@lst.de> <20180623130624.GA16691@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180623130624.GA16691@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sat, Jun 23, 2018 at 09:06:24AM -0400, Brian Foster wrote:
> to reproduce after creating a new fs or using a largish fs. I think it's
> hit or miss based on the content of free space in the filesystem. The
> appended diff applied on top of Darrick's recent xfstests test[1] makes
> this reproduce reliably for me (with -bsize=1k).

Yes, I can reproduce the issue with that patch.

> The former returns zeroes for the post-eof (i_size == 0x21a20) portion
> of the page due to the (iblock < lblock) check in
> block_read_full_page(). If the block is post eof, get_block() isn't
> called, the bh is left unmapped and the portion of the page is
> explicitly zeroed in the same loop. The iomap code appears to read and
> expose whatever is on disk if the block is allocated. I'm guessing we at
> least need to consider doing something similar in iomap_readpage_actor()
> (or perhaps somewhere in that path that also covers the write path)..?
> I'm not sure it's sufficient to rely on writeback to zero the page and
> otherwise let it expose garbage until that point.

This:

	if (iomap->type != IOMAP_MAPPED || pos >= i_size_read(inode)) {
		zero_user(page, poff, plen);
		iomap_set_range_uptodate(page, poff, plen);
		goto done;
	}

is supposed to do the equivalent zeroing code.  I put a little tracing
code in and we get back a mapped extent from 0x21400:0x22000, which
makes sense.  It seems like we have an actual problem with the
zero_page_rage code somehow.  I'll need some more time to investigate
that.
