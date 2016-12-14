Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34528 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932170AbcLNLIV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2016 06:08:21 -0500
Date: Wed, 14 Dec 2016 02:44:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: handle error if xfs_btree_get_bufs fails
Message-ID: <20161214104403.GA16862@infradead.org>
References: <4348f961-deda-8733-1cd7-dd7ca646bb6b@redhat.com>
 <f4473870-0514-87c3-6cf2-1dfd548a1e4a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4473870-0514-87c3-6cf2-1dfd548a1e4a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jason L Tibbitts III <tibbs@math.uh.edu>

On Mon, Dec 12, 2016 at 04:39:49PM -0600, Eric Sandeen wrote:
> Jason reported that a corrupted filesystem failed to replay
> the log with a metadata block out of bounds warning:
> 
> XFS (dm-2): _xfs_buf_find: Block out of range: block 0x80270fff8, EOFS 0x9c40000 
> 
> _xfs_buf_find() and xfs_btree_get_bufs() return NULL if
> that happens, and then when xfs_alloc_fix_freelist() calls
> xfs_trans_binval() on that NULL bp, we oops with:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000000000f8
> 
> We don't handle _xfs_buf_find errors very well, every
> caller higher up the stack gets to guess at why it failed.
> But we should at least handle it somehow, so return
> EFSCORRUPTED here.
> 
> Reported-by: Jason L Tibbitts III <tibbs@math.uh.edu>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine, although the Subject line needs to lose to Re:

Reviewed-by: Christoph Hellwig <hch@lst.de>
