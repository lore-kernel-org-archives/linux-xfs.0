Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753338AbeBASvx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Feb 2018 13:51:53 -0500
Date: Thu, 1 Feb 2018 12:51:51 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs: don't allow reflink + realtime filesystems
Message-ID: <20180201185151.GA30056@redhat.com>
References: <20180201005709.GM4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180201005709.GM4849@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Jan 31, 2018 at 04:57:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We don't support realtime filesystems with reflink either, so fail
> those mounts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/xfs_super.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a83a9f0..7aba628 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1684,6 +1684,13 @@ xfs_fs_fill_super(
>  		}
>  	}
>  
> +	if (xfs_sb_version_hasreflink(&mp->m_sb) && mp->m_sb.sb_rblocks) {
> +		xfs_alert(mp,
> +	"reflink not compatible with realtime device!");
> +		error = -EINVAL;
> +		goto out_filestream_unmount;
> +	}
> +
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && mp->m_sb.sb_rblocks) {
>  		xfs_alert(mp,
>  	"reverse mapping btree not compatible with realtime device!");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
