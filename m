Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8IuLUq143856 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 12:56:21 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B04B722D2D3
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 10:56:20 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id pVWLgKzR3V4blZvq for <xfs@oss.sgi.com>;
	Tue, 08 Nov 2011 10:56:20 -0800 (PST)
Message-ID: <4EB97B53.7080600@sandeen.net>
Date: Tue, 08 Nov 2011 12:56:19 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs_repair: Add inline function to get avl tree node
References: <1320777990-6556-1-git-send-email-cmaiolino@redhat.com>
	<1320777990-6556-2-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1320777990-6556-2-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 11/8/11 12:46 PM, Carlos Maiolino wrote:
> dd get_inode_offset() inline function, which will return the offset
> of a specific node in the AVL tree avoiding the need to calculate the
> the offset each time it needs to be used.

might be good to find the open-coded instances of this, and
make them use the helper too.

-Eric

> ---
>  repair/incore.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/repair/incore.h b/repair/incore.h
> index ee0e86a..8e311c9 100644
> --- a/repair/incore.h
> +++ b/repair/incore.h
> @@ -311,6 +311,12 @@ void		get_inode_rec(struct xfs_mount *mp, xfs_agnumber_t agno,
>  			      ino_tree_node_t *ino_rec);
>  
>  extern avltree_desc_t     **inode_tree_ptrs;
> +
> +static inline int
> +get_inode_offset(struct xfs_mount *mp, xfs_ino_t ino, ino_tree_node_t *irec)
> +{
> +	return XFS_INO_TO_AGINO(mp, ino) - irec->ino_startnum;
> +}
>  static inline ino_tree_node_t *
>  findfirst_inode_rec(xfs_agnumber_t agno)
>  {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
