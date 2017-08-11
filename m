Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37453 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753036AbdHKNDE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 09:03:04 -0400
Date: Fri, 11 Aug 2017 06:03:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: toggle readonly state around
 xfs_log_mount_finish
Message-ID: <20170811130303.GB24839@infradead.org>
References: <e98c7179-fdb0-1cc7-544b-c55489451db5@redhat.com>
 <6c81fb42-4601-dc0f-6ebb-a73c7c40aaa4@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c81fb42-4601-dc0f-6ebb-a73c7c40aaa4@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Jul 21, 2017 at 10:25:35AM -0500, Eric Sandeen wrote:
> When we do log recovery on a readonly mount, unlinked inode
> processing does not happen due to the readonly checks in
> xfs_inactive(), which are trying to prevent any I/O on a
> readonly mount.
> 
> This is misguided - we do I/O on readonly mounts all the time,
> for consistency; for example, log recovery.  So do the same
> RDONLY flag twiddling around xfs_log_mount_finish() as we
> do around xfs_log_mount(), for the same reason.
> 
> This all cries out for a big rework but for now this is a
> simple fix to an obvious problem.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> 
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0bd1341..ca56d85 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -743,16 +743,23 @@
>  	struct xfs_mount	*mp)
>  {
>  	int	error = 0;
> +	int	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);

bool?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
