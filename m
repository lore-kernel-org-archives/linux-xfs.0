Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58064 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934300AbcJQK1A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 06:27:00 -0400
Date: Mon, 17 Oct 2016 12:26:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: Lock ordering in iomap code
Message-ID: <20161017102657.GA12164@lst.de>
References: <20161007111314.GA24081@quack2.suse.cz> <20161017093148.GA6375@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161017093148.GA6375@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

Hi Jan,

sorry for the delay, I've been overloaded with various projects
recently..

> Ping? I have ext4 DAX read & write path working with the iomap code but to
> convert the fault path, I need this resolved. Are you OK with moving
> iomap_begin() / iomap_end() calls outside of page lock / entry lock in the
> fault path?

Yes, that sounds fine.
> 
> I was also thinking about the implications of iomap_begin() (and thus block
> allocation for buffered writes in nodelalloc case) being no longer protected
> by page lock and at least for ext2 / ext3 compatibility modes this will
> lead to uninitialized data exposure when page fault races in the right way
> with buffered write. So current locking scheme in iomap code is not easily
> usable for ext4 for buffered writes.

Right, the iomap I/O code assumes that you either use delalloc, or that
your have unwritten extents that your convert to written once I/O has
finished.  XFS uses the latter feature for direct I/O, or if an extent
size hints is set.

I can't really think of a good way to handle file systems without
either feature - the problem is that we'd have to introduce a file-wide
(or range based) lock to protect allocated but not written ranges.
