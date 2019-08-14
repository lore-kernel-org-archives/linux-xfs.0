Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35938 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbfHNKZE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Aug 2019 06:25:04 -0400
Date: Wed, 14 Aug 2019 20:23:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: Opencode and remove DEFINE_SINGLE_BUF_MAP
Message-ID: <20190814102355.GM6129@dread.disaster.area>
References: <20190813090306.31278-1-nborisov@suse.com>
 <20190813090306.31278-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813090306.31278-4-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Aug 13, 2019 at 12:03:06PM +0300, Nikolay Borisov wrote:
> This macro encodes a trivial struct initializations, just open code it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Hmmmm.

We have defines for this sort of structure definition and
initialisation all over the kernel. e.g. LIST_HEAD(),
DEFINE_PER_CPU(), DEFINE_HASHTABLE(), DEFINE_SPINLOCK(), etc...

And really, the intent of the define was to make it easy to get
rid of all the callers of the non-map buffer interfaces by moving
the map definition into the callers of xfs_buf_get, _read, etc
and then enabling use to remove the non-map interfaces
altogether.

Hence I'd much prefer to see the xfs_buf_{get,read,readahead} and
xfs_trans_buf_{get,read} wrapper functions go away than removing the
define.

> ---
>  fs/xfs/xfs_buf.c   | 4 ++--
>  fs/xfs/xfs_buf.h   | 9 +++------
>  fs/xfs/xfs_trans.h | 6 ++++--
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 99c66f80d7cc..389c5b590f11 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -658,7 +658,7 @@ xfs_buf_incore(
>  {
>  	struct xfs_buf		*bp;
>  	int			error;
> -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };

FWIW, I'm not a fan of single line definitions like this because
they are really hard to read. If you are converting to this form, it
should be like this:

	struct xfs_buf_map map = {
		.bm_bn = blkno,
		.bm_len = numblks,
	};

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
