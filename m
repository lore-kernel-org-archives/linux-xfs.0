Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:26031 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726427AbeJAHGk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 03:06:40 -0400
Date: Mon, 1 Oct 2018 10:31:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] iomap: set page dirty after partial delalloc on mkwrite
Message-ID: <20181001003131.GN31060@dastard>
References: <20180928173956.42428-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180928173956.42428-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Fri, Sep 28, 2018 at 01:39:56PM -0400, Brian Foster wrote:
> The iomap page fault mechanism currently dirties the associated page
> after the full block range of the page has been allocated. This
> leaves the page susceptible to delayed allocations without ever
> being set dirty on sub-page block sized filesystems.
> 
> For example, consider a page fault on a page with one preexisting
> real (non-delalloc) block allocated in the middle of the page. The
> first iomap_apply() iteration performs delayed allocation on the
> range up to the preexisting block, the next iteration finds the
> preexisting block, and the last iteration attempts to perform
> delayed allocation on the range after the prexisting block to the
> end of the page. If the first allocation succeeds and the final
> allocation fails with -ENOSPC, iomap_apply() returns the error and
> iomap_page_mkwrite() fails to dirty the page having already
> performed partial delayed allocation. This eventually results in the
> page being invalidated without ever converting the delayed
> allocation to real blocks.
> 
> This problem is reliably reproduced by generic/083 on XFS on ppc64
> systems (64k page size, 4k block size). It results in leaked
> delalloc blocks on inode reclaim, which triggers an assert failure
> in xfs_fs_destroy_inode() and filesystem accounting inconsistency.
> 
> Move the set_page_dirty() call from iomap_page_mkwrite() to the
> actor callback, similar to how the buffer head implementation works.
> The actor callback is called iff ->iomap_begin() returns success, so
> ensures the page is dirtied as soon as possible after an allocation.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks sensible to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> ---
> 
> This patch addresses the problem with generic/083, but I'm still in the
> process of running broader testing. I wanted to get it on the list for
> review in the meantime...

It's been fine on my weekend test runs in the my candidate fixes for
4.19 branch. There have been no regressions for v4 512b and v5 1k
block size test runs from it - I got 14 complete fstests runs of sub
page block size configs across multiple test machines over the
weekend, so I've pushed it with that branch.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
