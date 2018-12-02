Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53702 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbeLBP7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 10:59:10 -0500
Date: Sun, 2 Dec 2018 07:59:06 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: allow remap flags to be passed to
 vfs_clone_file_range
Message-ID: <20181202155906.GA15501@infradead.org>
References: <20181130204238.GE8131@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181130204238.GE8131@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, amir73il@gmail.com, linux-unionfs@vger.kernel.org

On Fri, Nov 30, 2018 at 12:42:38PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In overlayfs, ovl_remap_file_range calls vfs_clone_file_range on the
> lower filesystem's inode, passing through whatever remap flags it got
> from its caller.  Since vfs_copy_file_range first tries a filesystem's
> remap function with REMAP_FILE_CAN_SHORTEN, this can get passed through
> to the second vfs_copy_file_range call, which isn't an issue.
> Remove the WARN_ON because it's unnecessary.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This looks ok:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But this also indicates that do_clone_file_range/vfs_clone_file_range
are misnamed now, as they are wrappers for the remap_file_range method.
