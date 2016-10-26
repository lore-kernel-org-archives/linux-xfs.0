Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47798 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750906AbcJZHop (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Oct 2016 03:44:45 -0400
Date: Wed, 26 Oct 2016 09:44:43 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] iomap: implement direct I/O
Message-ID: <20161026074443.GA28408@lst.de>
References: <1477408098-10153-1-git-send-email-hch@lst.de> <1477408098-10153-6-git-send-email-hch@lst.de> <20161025153156.cjhcvvoxd3c6pqf7@kmo-pixel> <20161025163443.GA8730@lst.de> <20161025171329.2txmbsgdnvn5vinn@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161025171329.2txmbsgdnvn5vinn@kmo-pixel>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, axboe@fb.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Tue, Oct 25, 2016 at 09:13:29AM -0800, Kent Overstreet wrote:
> Also - what are you doing about the race between shooting down the range in the
> pagecache and dirty pages being readded? The existing direct IO code falls back
> to buffered IO for that, but your code doesn't appear to - I seem to recall that
> XFS has its own locking for this, are you just relying on that for now?  It'd be
> really nice to get some generic locking for this, anything that relies on
> pagecache invalidation is sketchy as hell in other filesystems.

Yes, XFS always had a shared/exclusive lock for I/O operations,
which is taken exclusive for buffered writes and those corner cases
of direct writes that needs exclusіon (e.g. sub-fs block size I/O).

This prevents new dirty pages from being added while direct I/O is
in progress.  There is nothing to prevent direct reads, though - that's
why both the old common code, the old XFS code and this new code do
a second invalidation after the write is done.

Now that the VFS i_mutex has been replaced with i_rwsem we can apply
this scheme to common code as well by taking i_rwsem shared for
direct I/O reads.
