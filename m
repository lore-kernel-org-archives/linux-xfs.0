Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44575 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932543AbcJYQeq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Oct 2016 12:34:46 -0400
Date: Tue, 25 Oct 2016 18:34:43 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] iomap: implement direct I/O
Message-ID: <20161025163443.GA8730@lst.de>
References: <1477408098-10153-1-git-send-email-hch@lst.de> <1477408098-10153-6-git-send-email-hch@lst.de> <20161025153156.cjhcvvoxd3c6pqf7@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161025153156.cjhcvvoxd3c6pqf7@kmo-pixel>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, axboe@fb.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Tue, Oct 25, 2016 at 07:31:56AM -0800, Kent Overstreet wrote:
> So you're still walking the mappings, then for each mapping allocating a bio and
> pinning pages - opposite of my approach, I started out by allocating a bio and
> pinning pages and then walk the mapping, splitting the bio as needed.
> 
> I still like my approach better, I think it ought to perform better when doing
> fragmented IOs and it feels cleaner to me - you're not going back and forth
> between calling into the gup() code, and your filesystem's btree code, both of
> which are going to require taking their own set of locks and such. That said, I
> doubt it's much of a difference and your code is so much simpler than
> direct-IO.c that who cares :)

Yes, this is the basic idea behind the whole iomap code - we have
a generic apply function that calls into the fs allocator, and then
takes a callback that it applies to one extent at a time.  It really
helps a lot to separate responsibilities and factor the code into
independent functions.

I looked at carrying over bios between different invocations of the
callback, but it quickly turned into a mess.  In the end the only thing
we'd optimize with it is the gup call - bios would have to be split
anyway, etc, etc.  So with this code there indeed is a worsr case
for badly fragmented files, but I'd rather work on the fs allocator
to further reduce the amount of fragmentation we have rather than
working around it.  E.g. for XFS Darrick and I have sketched a rough
plan for an auto-COW mode where we'd simply not reuse fragmented blocks
for an overwrite and will instead give the caller a nice contiguous
single extent.

> Do you have your code up in a git repo somewhere? I'm going to compare it to
> bcachefs's dio code and see if I can remember all edge cases I hit when I was
> working on that.

Git:

git://git.infradead.org/users/hch/vfs.git iomap-dio

Gitweb:

http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/iomap-dio
