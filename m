Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36083 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932547AbcJYRNd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 13:13:33 -0400
Date: Tue, 25 Oct 2016 09:13:29 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 5/6] iomap: implement direct I/O
Message-ID: <20161025171329.2txmbsgdnvn5vinn@kmo-pixel>
References: <1477408098-10153-1-git-send-email-hch@lst.de>
 <1477408098-10153-6-git-send-email-hch@lst.de>
 <20161025153156.cjhcvvoxd3c6pqf7@kmo-pixel>
 <20161025163443.GA8730@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161025163443.GA8730@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, axboe@fb.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Tue, Oct 25, 2016 at 06:34:43PM +0200, Christoph Hellwig wrote:
> On Tue, Oct 25, 2016 at 07:31:56AM -0800, Kent Overstreet wrote:
> Yes, this is the basic idea behind the whole iomap code - we have
> a generic apply function that calls into the fs allocator, and then
> takes a callback that it applies to one extent at a time.  It really
> helps a lot to separate responsibilities and factor the code into
> independent functions.
> 
> I looked at carrying over bios between different invocations of the
> callback, but it quickly turned into a mess.

Really? Ages ago that was the approach I was taking with my dio rewrite and it
worked out fine - it was using get_block but I'd think the code would look
almost exactly the same with iomap.

Anyways I'm not at all advocating you redo your code - if it works, please ship
this so direct-IO.c can die in a fire! - but I would encourage you to take a
look at my code, I think there's some good ideas in there.  I think my (ancient,
and I never got it 100% debugged) dio rewrite is easiest to follow - maybe
you've already seen it if you found my bio_get_user_pages() code, but if you
haven't:
https://evilpiepirate.org/git/linux-bcache.git/tree/fs/direct-io.c?h=dio

getting on a bit of a tangent now: the actor approach you're taking with
iomap_apply() really reminds me of going through internal vs. external iterators
in bcache. We started out with internal iterators - which is what's still in the
upstream code, bch_btree_map_keys() is roughly equivalent to iomap_apply() where
you pass it a callback and it does the iteration.

But later we ended up switching to external iterators - we've now got a struct
btree_iter, with functions for init/peek/advance/set_pos, and inserting at an
iterator's current position. It was actually another guy who convinced me to
consider switching to external iterators (Slava Pestov), and it was quite a pain
in the ass (walking a btree directly is a whole lot easier than implementing a
state machine to do it, partly) - but it was _hugely_ worth it in the long run
because it they're a whole lot more flexible to use and they made a lot of
things possible that honestly I wouldn't have thought of before I had them.

Don't know that it's actually relevant here - I haven't dug into your iomap code
yet, just lately I've been noticing more places in the kernel where people have
implemented stuff with internal iterators (e.g. the crypto code) or no real
iterator at all for things where I'm pretty sure an external iterator could make
things a whole lot simpler.

> git://git.infradead.org/users/hch/vfs.git iomap-dio

Cool, reading.

Also - what are you doing about the race between shooting down the range in the
pagecache and dirty pages being readded? The existing direct IO code falls back
to buffered IO for that, but your code doesn't appear to - I seem to recall that
XFS has its own locking for this, are you just relying on that for now?  It'd be
really nice to get some generic locking for this, anything that relies on
pagecache invalidation is sketchy as hell in other filesystems.
