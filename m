Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:64795
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752900AbdHOBgs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 21:36:48 -0400
Date: Tue, 15 Aug 2017 11:36:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: refactor xfs_trans_roll
Message-ID: <20170815013645.GD21024@dastard>
References: <20170813144216.11192-1-hch@lst.de>
 <20170813144216.11192-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170813144216.11192-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Aug 13, 2017 at 04:42:14PM +0200, Christoph Hellwig wrote:
> Split xfs_trans_roll into a low-level helper that just rolls the
> actual transaction and a new higher level xfs_trans_roll_inode
> that takes care of logging and rejoining the inode.  This gets
> rid of the NULL inode case, and allows to simplify the special
> cases in the deferred operation code.

....

> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 2011620008de..c43e78b5c035 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1034,26 +1034,19 @@ xfs_trans_cancel(
>   * chunk we've been working on and get a new transaction to continue.
>   */
>  int
> -xfs_trans_roll(
> -	struct xfs_trans	**tpp,
> -	struct xfs_inode	*dp)
> +__xfs_trans_roll(
> +	struct xfs_trans	**tpp)

Do we really need the "__" prefix? Seems unnecessary to me because
all the existing callers are modified...

Other than that, every else looks good.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
