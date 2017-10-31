Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37318 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752707AbdJaKKA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Oct 2017 06:10:00 -0400
Date: Tue, 31 Oct 2017 18:09:58 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs: flush the range before zero partial block range on
 truncate down
Message-ID: <20171031100958.GL17339@eguan.usersys.redhat.com>
References: <20171027125328.25001-1-eguan@redhat.com>
 <20171028060529.GA29505@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171028060529.GA29505@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 27, 2017 at 11:05:29PM -0700, Christoph Hellwig wrote:
> On Fri, Oct 27, 2017 at 08:53:28PM +0800, Eryu Guan wrote:
> > But it's possible that a buffer write overwrites the unwritten
> > extent, which won't be converted to a normal extent until I/O
> > completion, and iomap_truncate_page() skips zeroing wrongly because
> > of the not-converted unwritten extent. This would cause a subsequent
> > mmap read sees non-zeros beyond EOF.
> 
> I suspect the right fix is to look at the in-core state im the iomap
> truncate helpers instead of doing a duplicate flush.

I may (and very likely) miss something, but my understanding is that
iomap_truncate_page() already looks at the in-core extent state provided
by xfs_file_iomap_begin()

xfs_setattr_size()
 iomap_truncate_page()
  iomap_zero_range()
   iomap_apply()
    xfs_file_iomap_begin()	# finds extent according to the range
    iomap_zero_range_actor() 	# sees iomap->type == IOMAP_UNWRITTEN

And this in-core extent state won't be converted to XFS_EXT_NORM until
writeback & I/O completion, so I think a flush is required.

Thanks,
Eryu
