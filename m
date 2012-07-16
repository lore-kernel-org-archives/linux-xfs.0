Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6GF4MJd249259 for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 10:04:22 -0500
Date: Mon, 16 Jul 2012 10:10:38 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: fix comment typo of struct xfs_da_blkinfo.
Message-ID: <20120716151038.GI29979@sgi.com>
References: <1342208293-3405-1-git-send-email-baozich@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1342208293-3405-1-git-send-email-baozich@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chen Baozi <baozich@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hey Chen,

On Sat, Jul 14, 2012 at 03:38:13AM +0800, Chen Baozi wrote:
> Fix trivial typo error that has written "It" to "Is".
> 
> Signed-off-by: Chen Baozi <baozich@gmail.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

Thanks for the patch!  I'm happy you're working on XFS.  Do you have any
time/interest in taking on a work item or two?  I have a few would-be-nices
which I've made notes of, and I'm sure that Dave or Christoph could also think
of a few if you're interested.

Thanks again,
-Ben

> ---
>  fs/xfs/xfs_da_btree.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
> index dbf7c07..be30bd4 100644
> --- a/fs/xfs/xfs_da_btree.h
> +++ b/fs/xfs/xfs_da_btree.h
> @@ -32,7 +32,7 @@ struct zone;
>  /*
>   * This structure is common to both leaf nodes and non-leaf nodes in the Btree.
>   *
> - * Is is used to manage a doubly linked list of all blocks at the same
> + * It is used to manage a doubly linked list of all blocks at the same
>   * level in the Btree, and to identify which type of block this is.
>   */
>  #define XFS_DA_NODE_MAGIC	0xfebe	/* magic number: non-leaf blocks */
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
