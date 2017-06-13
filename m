Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50818 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751802AbdFMWet (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Jun 2017 18:34:49 -0400
Subject: Re: [PATCH 04/10] xfs_repair: replace rmap_compare with libxfs
 version
References: <149643307433.15899.922559884171553380.stgit@birch.djwong.org>
 <149643309903.15899.5862825605175613525.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f4245387-e6bf-206e-101c-000a6a085f6f@sandeen.net>
Date: Tue, 13 Jun 2017 17:34:47 -0500
MIME-Version: 1.0
In-Reply-To: <149643309903.15899.5862825605175613525.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/2/17 2:51 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that libxfs has a function to compare rmaps, replace xfs_repair's
> helper function with that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libxfs/libxfs_api_defs.h |    1 +
>  repair/rmap.c            |   32 ++------------------------------
>  2 files changed, 3 insertions(+), 30 deletions(-)
> 
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 31239ca..2d8d9c8 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -144,5 +144,6 @@
>  #define xfs_refcount_get_rec		libxfs_refcount_get_rec
>  #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
>  #define xfs_refc_block			libxfs_refc_block
> +#define xfs_rmap_compare		libxfs_rmap_compare
>  
>  #endif /* __LIBXFS_API_DEFS_H__ */
> diff --git a/repair/rmap.c b/repair/rmap.c
> index 7508973..ab6e583 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -49,37 +49,9 @@ static struct xfs_ag_rmap *ag_rmaps;
>  static bool rmapbt_suspect;
>  static bool refcbt_suspect;
>  
> -/*
> - * Compare rmap observations for array sorting.
> - */
> -static int
> -rmap_compare(
> -	const void		*a,
> -	const void		*b)
> +static inline int rmap_compare(const void *a, const void *b)
>  {
> -	const struct xfs_rmap_irec	*pa;
> -	const struct xfs_rmap_irec	*pb;
> -	__u64			oa;
> -	__u64			ob;
> -
> -	pa = a; pb = b;
> -	oa = libxfs_rmap_irec_offset_pack(pa);
> -	ob = libxfs_rmap_irec_offset_pack(pb);
> -
> -	if (pa->rm_startblock < pb->rm_startblock)
> -		return -1;
> -	else if (pa->rm_startblock > pb->rm_startblock)
> -		return 1;
> -	else if (pa->rm_owner < pb->rm_owner)
> -		return -1;
> -	else if (pa->rm_owner > pb->rm_owner)
> -		return 1;
> -	else if (oa < ob)
> -		return -1;
> -	else if (oa > ob)
> -		return 1;
> -	else
> -		return 0;
> +	return libxfs_rmap_compare(a, b);
>  }
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
