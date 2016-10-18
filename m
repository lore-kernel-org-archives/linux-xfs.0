Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58457 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754614AbcJRFYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2016 01:24:15 -0400
Date: Mon, 17 Oct 2016 22:24:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: unset MS_ACTIVE if mount fails
Message-ID: <20161018052413.GA32065@infradead.org>
References: <20161018011051.GB20337@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161018011051.GB20337@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Mon, Oct 17, 2016 at 06:10:51PM -0700, Darrick J. Wong wrote:
> As part of the inode block map intent log item recovery process, we had
> to set the IRECOVERY flag to prevent an unlinked inode from being
> truncated during the first iput call.  This required us to set MS_ACTIVE
> so that iput puts the inode on the lru instead of immediately evicting
> the inode.
> 
> Unfortunately, if the mount fails later on, the inodes that have been
> loaded (root dir and realtime) actually need to be evicted since we're
> aborting the mount.  If we don't clear MS_ACTIVE in the failure step,
> those inodes are not evicted and therefore leak.   The leak was found
> by running xfs/130 and rmmoding xfs immediately after the test.

Actually that was an item I wanted to sort out about reflink before
we got it merged..

Can you explain why we even added the MS_ACTIVE flag?  Is it
to fool iput_final into keeping the inode on the lru?  I'd really
prefer if we could just do it in our own ->drop_inode call then
instead of messing with MS_ACTIVE.
