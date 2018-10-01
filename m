Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbeJARcD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 13:32:03 -0400
Date: Mon, 1 Oct 2018 06:54:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] iomap: set page dirty after partial delalloc on mkwrite
Message-ID: <20181001105448.GA53694@bfoster>
References: <20180928173956.42428-1-bfoster@redhat.com>
 <20180930224435.GA18893@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180930224435.GA18893@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Oct 01, 2018 at 12:44:35AM +0200, Christoph Hellwig wrote:
> On Fri, Sep 28, 2018 at 01:39:56PM -0400, Brian Foster wrote:
> > This problem is reliably reproduced by generic/083 on XFS on ppc64
> > systems (64k page size, 4k block size). It results in leaked
> > delalloc blocks on inode reclaim, which triggers an assert failure
> > in xfs_fs_destroy_inode() and filesystem accounting inconsistency.
> 
> Interesting - I've not seen this on 1k block size / 4k page size
> systems.
> 

I hadn't either. I tried again on x86-64 with a smaller block size when
I realized generic/083 only reproduced on ppc64 with 4k blocks and still
couldn't reproduce.

That said, an explicit test of the circumstances described in the commit
log (write fault on a page that performs partial delalloc and fails with
-ENOSPC) reproduces the problem reliably regardless of page size. I
suspect the 1k/512b block vs 4k page size is just too small of a window
for a sub-page/partial delalloc -ENOSPC as opposed to 4k fsb and 64k
pages to reproduce reliably via fsstress.

> > This patch addresses the problem with generic/083, but I'm still in the
> > process of running broader testing. I wanted to get it on the list for
> > review in the meantime...
> 
> But in general this looks sensible to me.  So if the testing passes
> this looks good to me.

As a follow up to Dave's additional testing (thanks!), I ran a few
xfstests runs on x86-64 and ppc64 over the weekend and didn't reproduce
any regressions (though I note that XFS has a high failure rate with
-bsize=64k, but that's a separate problem).

Brian
