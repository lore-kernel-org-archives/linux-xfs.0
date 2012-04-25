Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3PLUSYG242499 for <xfs@oss.sgi.com>; Wed, 25 Apr 2012 16:30:28 -0500
Message-ID: <4F986CF1.2040606@sgi.com>
Date: Wed, 25 Apr 2012 16:30:25 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fs/xfs/xfs_dinode.h: fix comments of xfs_dinode_t.
References: <1334166755-32052-1-git-send-email-baozich@gmail.com>
In-Reply-To: <1334166755-32052-1-git-send-email-baozich@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chen Baozi <baozich@gmail.com>
Cc: xfs@oss.sgi.com

On 04/11/12 12:52, Chen Baozi wrote:
> Signed-off-by: Chen Baozi<baozich@gmail.com>
> ---
>   fs/xfs/xfs_dinode.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
> index a372163..1d9643b 100644
> --- a/fs/xfs/xfs_dinode.h
> +++ b/fs/xfs/xfs_dinode.h
> @@ -33,7 +33,7 @@ typedef struct xfs_timestamp {
>    * variable size the leftover area split into a data and an attribute fork.
>    * The format of the data and attribute fork depends on the format of the
>    * inode as indicated by di_format and di_aformat.  To access the data and
> - * attribute use the XFS_DFORK_PTR, XFS_DFORK_DPTR, and XFS_DFORK_PTR macros
> + * attribute use the XFS_DFORK_DPTR, XFS_DFORK_APTR, and XFS_DFORK_PTR macros
>    * below.
>    *
>    * There is a very similar struct icdinode in xfs_inode which matches the
> -- 1.7.1

Good catch. Please add a commit message and then you also can add:

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
