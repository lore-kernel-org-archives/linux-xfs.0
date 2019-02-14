Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52450 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388186AbfBNVlg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 16:41:36 -0500
Date: Thu, 14 Feb 2019 13:41:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: don't ever put nlink > 0 inodes on the unlinked
 list
Message-ID: <20190214214135.GA9152@infradead.org>
References: <155009104740.32028.193157199378698979.stgit@magnolia>
 <155009105350.32028.13101526675073908023.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155009105350.32028.13101526675073908023.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 13, 2019 at 12:50:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When XFS creates an O_TMPFILE file, the inode is created with nlink = 1,
> put on the unlinked list, and then the VFS sets nlink = 0 in d_tmpfile.
> If we crash before anything logs the inode (it's dirty incore but the
> vfs doesn't tell us it's dirty so we never log that change), the iunlink
> processing part of recovery will then explode with a pile of:
> 
> XFS: Assertion failed: VFS_I(ip)->i_nlink == 0, file:
> fs/xfs/xfs_log_recover.c, line: 5072
> 
> Worse yet, since nlink is nonzero, the inodes also don't get cleaned up
> and they just leak until the next xfs_repair run.
> 
> Therefore, change xfs_iunlink to require that inodes being put on the
> unlinked list have nlink == 0, change the tmpfile callers to instantiate
> nodes that way, and set the nlink to 1 just prior to calling d_tmpfile.
> Fix the comment for xfs_iunlink while we're at it.

Looks good for a quick fix, even if I think we should fix it different
in the long term:

Reviewed-by: Christoph Hellwig <hch@lst.de>
