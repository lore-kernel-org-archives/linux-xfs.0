Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdALOjk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jan 2017 09:39:40 -0500
Date: Thu, 12 Jan 2017 05:56:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix eofblocks race with file extending async dio
 writes
Message-ID: <20170112135603.GD5756@infradead.org>
References: <1484156571-65403-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484156571-65403-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

>  		if (need_iolock) {
>  			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
>  				return -EAGAIN;
>  		}
> +		inode_dio_wait(VFS_I(ip));

inode_dio_wait generally is only safe to call with i_rwsem held
exclsuively, so if we'd need the call for the !need_iolock this would
be broken.  Fortunately we don't even need the call in that case, so
this should be safe.  I'd still prefer to move the inode_dio_wait call
into the need_iolock block to make that clear, though.
