Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38232 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751954AbdATWUz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Jan 2017 17:20:55 -0500
Subject: Re: [PATCH 4/5] xfs_repair: zero shared_vn
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494394162.5256.166843220095123974.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <933788b7-2156-357e-029d-03294bf8f5bf@sandeen.net>
Date: Fri, 20 Jan 2017 16:20:27 -0600
MIME-Version: 1.0
In-Reply-To: <148494394162.5256.166843220095123974.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/20/17 2:25 PM, Darrick J. Wong wrote:
> Since shared_vn always has to be zero, zero it at the end of repair.

If it's not, shouldn't it be properly warned, fixed, exit-code
set, etc?

-Eric
 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/xfs_repair.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 622d569..ecfa6b4 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -1050,6 +1050,9 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
>  			be32_to_cpu(dsb->sb_unit), be32_to_cpu(dsb->sb_width));
>  	}
>  
> +	/* shared_vn is always zero. */
> +	dsb->sb_shared_vn = 0;
> +
>  	libxfs_writebuf(sbp, 0);
>  
>  	/*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
