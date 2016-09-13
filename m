Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12457 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759533AbcIMXMN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Sep 2016 19:12:13 -0400
Date: Tue, 13 Sep 2016 17:12:10 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 09/10] xfs: refactor xfs_setfilesize
Message-ID: <20160913231210.GG26002@linux.intel.com>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-10-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473438884-674-10-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

On Fri, Sep 09, 2016 at 06:34:43PM +0200, Christoph Hellwig wrote:
> Rename the current function to __xfs_setfilesize and add a non-static
> wrapper that also takes care of creating the transaction.  This new
> helper will be used by the new iomap-based DAX path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c | 33 ++++++++++++++++++++++-----------
>  fs/xfs/xfs_aops.h |  1 +
>  2 files changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 7575cfc..0bd3e27 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -199,8 +199,8 @@ xfs_setfilesize_trans_alloc(
>  /*
>   * Update on-disk file size now that data has been written to disk.
>   */
> -STATIC int

This can remain STATIC, as it is only used in this file.

> -xfs_setfilesize(
> +int
> +__xfs_setfilesize(
>  	struct xfs_inode	*ip,
>  	struct xfs_trans	*tp,
>  	xfs_off_t		offset,
