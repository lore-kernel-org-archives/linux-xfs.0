Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750758AbcJQJbv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 05:31:51 -0400
Date: Mon, 17 Oct 2016 11:31:48 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Lock ordering in iomap code
Message-ID: <20161017093148.GA6375@quack2.suse.cz>
References: <20161007111314.GA24081@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161007111314.GA24081@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri 07-10-16 13:13:14, Jan Kara wrote:
> Hi Christoph,
> 
> when converting ext4 DAX path to iomap code I've come across one locking
> issue: Buffered writes for iomap code work through iomap_write_actor
> function. What that ends up doing is that it calls fs to map extent of
> blocks (->iomap_begin in iomap_apply()) and then proceeds to lock pages in
> iomap_write_actor() and copy data to them. Then ->iomap_end is called to
> finish work for that extent.
> 
> OTOH page faults for iomap code work through iomap_page_mkwrite() which
> first grabs page lock and then calls iomap_apply() which ends up calling
> ->iomap_begin(). So this effectively nests all locks acquired in
> ->iomap_begin() under page lock. This makes it impossible for any lock to
> be held between ->iomap_begin() and ->iomap_end() as you immediately get
> lock inversion between this lock and page lock. Also any lock acquired in
> ->iomap_begin() gets nested under page lock and that is already no-go for
> ext4 as we need to start a transaction there and that needs to happen
> before grabbing page lock. I believe this is a bug in iomap_page_mkwrite()
> but wanted to check with you... The slight trouble is that when we change
> iomap_page_mkwrite() to work similarly to buffered write path, we have to
> watch out for races with truncate - both xfs and ext4 have these "mmap
> locks" which protect against that but the iomap fault code will be relying
> on fs properly serializing it against truncate which was not the case with
> the old fault path. So we'll probably need some comments about that in the
> code.
> 
> Somewhat related issue is that the old buffered write handled by
> generic_perform_write() made block mapping for a page happen under a page
> lock while the new iomap code does that before grabbing page lock. This
> opens a new set of races possible between write(2) and page fault (page
> fault can now see a state of page and block allocation information after
> ->iomap_begin() was called but before the data got copied into the page). I
> have yet to think through all the possible implications but this will
> definitely need a close checking...
> 
> And DAX iomap code has similar issues, only instead of the page lock the
> radix tree entry lock is in the game...

Ping? I have ext4 DAX read & write path working with the iomap code but to
convert the fault path, I need this resolved. Are you OK with moving
iomap_begin() / iomap_end() calls outside of page lock / entry lock in the
fault path?

I was also thinking about the implications of iomap_begin() (and thus block
allocation for buffered writes in nodelalloc case) being no longer protected
by page lock and at least for ext2 / ext3 compatibility modes this will
lead to uninitialized data exposure when page fault races in the right way
with buffered write. So current locking scheme in iomap code is not easily
usable for ext4 for buffered writes.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
