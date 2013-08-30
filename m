Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E08347F50
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 08:56:42 -0500 (CDT)
Message-ID: <5220A496.9040409@sgi.com>
Date: Fri, 30 Aug 2013 08:56:38 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: dtype changed xfs_dir2_sfe_put_ino to
	xfs_dir3_sfe_put_ino
References: <1377843681-31878-1-git-send-email-david@fromorbit.com>
	<1377843681-31878-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1377843681-31878-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/30/13 01:21, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> So fix up the export in xfs_dir2.h that is needed by userspace.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_dir2.h | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
> index 768ddad..9910401 100644
> --- a/fs/xfs/xfs_dir2.h
> +++ b/fs/xfs/xfs_dir2.h
> @@ -70,8 +70,9 @@ extern void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *sfp,
>   		xfs_ino_t ino);
>   extern xfs_ino_t xfs_dir3_sfe_get_ino(struct xfs_mount *mp,
>   		struct xfs_dir2_sf_hdr *sfp, struct xfs_dir2_sf_entry *sfep);
> -extern void xfs_dir2_sfe_put_ino( struct xfs_dir2_sf_hdr *,
> -		struct xfs_dir2_sf_entry *sfep, xfs_ino_t ino);
> +extern void xfs_dir3_sfe_put_ino(struct xfs_mount *mp,
> +		struct xfs_dir2_sf_hdr *hdr, struct xfs_dir2_sf_entry *sfep,
> +		xfs_ino_t ino);
>
>   extern int xfs_dir2_isblock(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
>   extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp, int *r);

Okay xfs_dir2_sfe_put_ino() does not exist. xfs_dir3_sfe_put_ino() is 
remotely used in xfs_repair but not in kernel.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
