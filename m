Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56998 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbdB1OF3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 09:05:29 -0500
Date: Tue, 28 Feb 2017 06:04:55 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: LTP write03 writev07 xfs failures
Message-ID: <20170228140455.GB9371@infradead.org>
References: <20170227042220.syhudcilvyettwnf@XZHOUW.usersys.redhat.com>
 <20170227160901.GB9344@bfoster.bfoster>
 <20170227201334.GC9344@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170227201334.GC9344@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Xiong Zhou <xzhou@redhat.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Mon, Feb 27, 2017 at 03:13:35PM -0500, Brian Foster wrote:
> After playing around a bit, I don't think using i_size is the right
> approach either. It just exacerbates the original problem on buffered
> writes into sparse files. We can end up leaving around however many
> delalloc blocks we've allocated.
> 
> I think we need a way to differentiate preexisting (previously written)
> delalloc blocks from those allocated and unused by the current write. We
> might be able to do that by looking at the pagecache, but I think that
> means looking at the buffer state to make sure we handle sub-page block
> sizes correctly. I.e., make *_iomap_end_delalloc() punch out all
> delalloc blocks in the non-written range that are either not page backed
> or not dirty+delalloc buffer backed. Hm?

That sounds ugly, but right off my mind I see no other way.  I'll need
to take a look at what the old pre-iomap code did there, as I think
none of these issues happened there.
