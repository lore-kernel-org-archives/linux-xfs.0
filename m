Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34019 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725751AbeJAFTY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 01:19:24 -0400
Date: Mon, 1 Oct 2018 00:44:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: set page dirty after partial delalloc on mkwrite
Message-ID: <20180930224435.GA18893@lst.de>
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
> This problem is reliably reproduced by generic/083 on XFS on ppc64
> systems (64k page size, 4k block size). It results in leaked
> delalloc blocks on inode reclaim, which triggers an assert failure
> in xfs_fs_destroy_inode() and filesystem accounting inconsistency.

Interesting - I've not seen this on 1k block size / 4k page size
systems.

> This patch addresses the problem with generic/083, but I'm still in the
> process of running broader testing. I wanted to get it on the list for
> review in the meantime...

But in general this looks sensible to me.  So if the testing passes
this looks good to me.
