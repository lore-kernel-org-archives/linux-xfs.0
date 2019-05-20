Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40242 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfETWJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 18:09:06 -0400
Date: Mon, 20 May 2019 15:08:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/20] xfs: fix a trivial comment typo in the
 xfs_trans_committed_bulk
Message-ID: <20190520220859.GE5335@magnolia>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:00AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 912b42f5fe4a..19f91312561a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -815,7 +815,7 @@ xfs_log_item_batch_insert(
>   *
>   * If we are called with the aborted flag set, it is because a log write during
>   * a CIL checkpoint commit has failed. In this case, all the items in the
> - * checkpoint have already gone through iop_commited and iop_unlock, which
> + * checkpoint have already gone through iop_committed and iop_unlock, which
>   * means that checkpoint commit abort handling is treated exactly the same
>   * as an iclog write error even though we haven't started any IO yet. Hence in
>   * this case all we need to do is iop_committed processing, followed by an
> -- 
> 2.20.1
> 
