Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CA7AF7F37
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 08:29:27 -0500 (CDT)
Message-ID: <52024BB4.5060109@sgi.com>
Date: Wed, 07 Aug 2013 08:29:24 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/12] xfs: fix the comment of xfs_iroot_realloc()
References: <1375870269-13157-1-git-send-email-zwu.kernel@gmail.com>
	<1375870269-13157-8-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1375870269-13157-8-git-send-email-zwu.kernel@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: zwu.kernel@gmail.com
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

On 08/07/13 05:11, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
>
> Signed-off-by: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
> ---
>   fs/xfs/xfs_inode.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index bb262c2..ccca9cd 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2103,7 +2103,7 @@ xfs_ifree(
>    *
>    * The caller must not request to add more records than would fit in
>    * the on-disk inode root.  If the if_broot is currently NULL, then
> - * if we adding records one will be allocated.  The caller must also
> + * if we are adding records, one will be allocated.  The caller must also
>    * not request that the number of records go below zero, although
>    * it can go to zero.
>    *


Change this to xfs_inode_fork.c and the series will apply on top of 
Dave's "current patch queue for Linux 3.12":

   http://oss.sgi.com/archives/xfs/2013-07/msg00411.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
