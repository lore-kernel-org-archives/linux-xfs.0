Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46778 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdAMHdQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2017 02:33:16 -0500
Date: Thu, 12 Jan 2017 23:33:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix eofblocks race with file extending async dio
 writes
Message-ID: <20170113073315.GA30685@infradead.org>
References: <1484156571-65403-1-git-send-email-bfoster@redhat.com>
 <20170112135603.GD5756@infradead.org>
 <20170112140559.GD14085@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170112140559.GD14085@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Thu, Jan 12, 2017 at 09:05:59AM -0500, Brian Foster wrote:
> !need_iolock means the iolock is already held. I guess the name is kind
> of confusing. !need_iolock doesn't mean that the lock is unnecessary, it
> just means that we're calling from a context where it's already held.
> See the xfs_icache_free_eofblocks() call from
> xfs_file_buffered_aio_write() for reference.
> 
> I suppose I could add an ASSERT(xfs_isilocked()) after that block to
> better document that..

Yeah.  In fact I'd prefer to kill that parameter at all, it's horrible.
Instead we should always expect the lock and assert that it's held,
and have the two current need_iolock = false callers take it manually.

This will increase lock hold times a bit for the current need_iolock
callers, but the most important one, xfs_release already does a
previous unlocked xfs_can_free_eofblocks check, and
xfs_inode_free_eofblocks is only called it the inode is tagged, so this
should not be an issue (and if it is a xfs_can_free_eofblocks call
comes to rescue).

Btw, there is a comment incorrectly referring to xfs_free_eofblocks
in xfs_inode_free_cowblocks while we're at it.
