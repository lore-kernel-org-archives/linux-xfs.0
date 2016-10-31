Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933578AbcJaQZx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Oct 2016 12:25:53 -0400
Date: Mon, 31 Oct 2016 12:25:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't BUG() on mixed direct and mapped I/O
Message-ID: <20161031162551.GB57171@bfoster.bfoster>
References: <1477923268-59559-1-git-send-email-bfoster@redhat.com>
 <20161031154642.GA28355@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161031154642.GA28355@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 31, 2016 at 08:46:42AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 31, 2016 at 10:14:28AM -0400, Brian Foster wrote:
> > We've had reports of generic/095 causing XFS to BUG() in
> > __xfs_get_blocks() due to the existence of delalloc blocks on a direct
> > I/O read. generic/095 issues a mix of various types of I/O, including
> > direct and memory mapped I/O to a single file.
> 
> Can you explain the scenario in which case this happens in a little
> more detail?  The patch looks fine to me, but I'd really like to
> understand how this happens.

Sure... the case I reproduced is a race between a direct I/O read and a
mapped write to a hole in a file. The direct read gets through
xfs_file_dio_aio_read() and down to __xfs_get_blocks() while the region
is still a hole. Before the xfs_bmapi_read() call from
__xfs_get_blocks(), a mapped write occurs and allocates delalloc blocks
in the associated file range. xfs_bmapi_read() then returns a delalloc
mapping for a dio read and falls through to the BUG_ON().

FWIW, the specific reproducer was a tweaked variant of generic/095 to up
the iodepth (1024), iodepth_batch (60), and numjobs (20) fio params. It
was also on a ppc64 box with a 64k page size, so that might have also
improved the chances of a race. This can be manufactured on demand with a
hack to delay the dio read in __xfs_get_blocks(), however. E.g., stick a
'if (!create && direct) ssleep(N);' right before xfs_bmapi_read(), run a
single block dio read to a hole in the file, and then a single block
mapped write to the same offset as the read while it is delayed.

Brian

