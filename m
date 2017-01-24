Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37590 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbdAXCiK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jan 2017 21:38:10 -0500
Subject: Re: [PATCH v3 4/5] xfs_repair: zero shared_vn
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494394162.5256.166843220095123974.stgit@birch.djwong.org>
 <20170121000925.GJ12985@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2c15be8f-be0c-36c9-3c82-a55e0ade977a@sandeen.net>
Date: Mon, 23 Jan 2017 20:38:07 -0600
MIME-Version: 1.0
In-Reply-To: <20170121000925.GJ12985@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/20/17 6:09 PM, Darrick J. Wong wrote:
> Since shared_vn always has to be zero, zero it at the start of repair.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> v2: reset shared_vn in phase 1 and tell the user about it, per sandeen
> v3: more suggestions by sandeen to make the new code more consistent
> ---
>  repair/phase1.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/repair/phase1.c b/repair/phase1.c
> index 126d0b3..9799883 100644
> --- a/repair/phase1.c
> +++ b/repair/phase1.c
> @@ -138,6 +138,13 @@ _("Cannot disable lazy-counters on V5 fs\n"));
>  		}
>  	}
>  
> +	/* shared_vn should be zero */
> +	if (sb->sb_shared_vn) {
> +		do_warn(_("resetting shared_vn to zero\n"));
> +		sb->sb_shared_vn = 0;
> +		primary_sb_modified = 1;
> +	}
> +
>  	if (primary_sb_modified)  {
>  		if (!no_modify)  {
>  			do_warn(_("writing modified primary superblock\n"));
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
