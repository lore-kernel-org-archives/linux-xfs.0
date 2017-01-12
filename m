Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751014AbdALOF7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:05:59 -0500
Date: Thu, 12 Jan 2017 09:05:59 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix eofblocks race with file extending async dio
 writes
Message-ID: <20170112140559.GD14085@bfoster.bfoster>
References: <1484156571-65403-1-git-send-email-bfoster@redhat.com>
 <20170112135603.GD5756@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170112135603.GD5756@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 12, 2017 at 05:56:03AM -0800, Christoph Hellwig wrote:
> >  		if (need_iolock) {
> >  			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
> >  				return -EAGAIN;
> >  		}
> > +		inode_dio_wait(VFS_I(ip));
> 
> inode_dio_wait generally is only safe to call with i_rwsem held
> exclsuively, so if we'd need the call for the !need_iolock this would
> be broken.  Fortunately we don't even need the call in that case, so
> this should be safe.  I'd still prefer to move the inode_dio_wait call
> into the need_iolock block to make that clear, though.

!need_iolock means the iolock is already held. I guess the name is kind
of confusing. !need_iolock doesn't mean that the lock is unnecessary, it
just means that we're calling from a context where it's already held.
See the xfs_icache_free_eofblocks() call from
xfs_file_buffered_aio_write() for reference.

I suppose I could add an ASSERT(xfs_isilocked()) after that block to
better document that..

Brian
