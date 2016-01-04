Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0ADA27F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 13:11:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F03DB8F8040
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 11:11:51 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JpreCJ1UNyyFmqzF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 11:11:50 -0800 (PST)
Date: Mon, 4 Jan 2016 14:11:48 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/9] metadump: clean up btree block region zeroing
Message-ID: <20160104191147.GA19852@bfoster.bfoster>
References: <1450733829-9319-1-git-send-email-david@fromorbit.com>
	<1450733829-9319-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1450733829-9319-2-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 22, 2015 at 08:37:01AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Abstract out all the common operations in the btree block zeroing
> so that we only have one copy of offset/len calculations and don't
> require lots of casts for the pointer arithmetic.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  db/metadump.c | 61 +++++++++++++++++++++++------------------------------------
>  1 file changed, 24 insertions(+), 37 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 8455fdd..a185da5 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -258,8 +258,8 @@ zero_btree_node(
>  	xfs_inobt_key_t		*ikp;
>  	xfs_alloc_ptr_t		*app;
>  	xfs_alloc_key_t		*akp;
> -	void			*zp1, *zp2;
> -	int			zlen1, zlen2;
> +	char			*zp1, *zp2;
> +	char			*key_end;
>  
>  	nrecs = be16_to_cpu(block->bb_numrecs);
>  
> @@ -268,43 +268,36 @@ zero_btree_node(
>  	case TYP_BMAPBTD:
>  		bkp = XFS_BMBT_KEY_ADDR(mp, block, 1);
>  		bpp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
> -		zp1 = &bkp[nrecs];
> -		zlen1 = (char *)&bpp[0] - (char *)&bkp[nrecs];
> -		zp2 = &bpp[nrecs];
> -		zlen2 = (char *)block + mp->m_sb.sb_blocksize -
> -							(char *)&bpp[nrecs];
> +		zp1 = (char *)&bkp[nrecs];
> +		zp2 = (char *)&bpp[nrecs];
> +		key_end = (char *)bpp;
>  		break;
>  	case TYP_INOBT:
>  	case TYP_FINOBT:
>  		ikp = XFS_INOBT_KEY_ADDR(mp, block, 1);
>  		ipp = XFS_INOBT_PTR_ADDR(mp, block, 1, mp->m_inobt_mxr[1]);
> -		zp1 = &ikp[nrecs];
> -		zlen1 = (char *)&ipp[0] - (char *)&ikp[nrecs];
> -		zp2 = &ipp[nrecs];
> -		zlen2 = (char *)block + mp->m_sb.sb_blocksize -
> -							(char *)&ipp[nrecs];
> +		zp1 = (char *)&ikp[nrecs];
> +		zp2 = (char *)&ipp[nrecs];
> +		key_end = (char *)ipp;
>  		break;
>  	case TYP_BNOBT:
>  	case TYP_CNTBT:
>  		akp = XFS_ALLOC_KEY_ADDR(mp, block, 1);
>  		app = XFS_ALLOC_PTR_ADDR(mp, block, 1, mp->m_alloc_mxr[1]);
> -		zp1 = &akp[nrecs];
> -		zlen1 = (char *)&app[0] - (char *)&akp[nrecs];
> -		zp2 = &app[nrecs];
> -		zlen2 = (char *)block + mp->m_sb.sb_blocksize -
> -							(char *)&app[nrecs];
> +		zp1 = (char *)&akp[nrecs];
> +		zp2 = (char *)&app[nrecs];
> +		key_end = (char *)app;
>  		break;
>  	default:
> -		zp1 = NULL;
> -		break;
> +		return;
>  	}
>  
> -	if (zp1 && zp2) {
> -		/* Zero from end of keys to beginning of pointers */
> -		memset(zp1, 0, zlen1);
> -		/* Zero from end of pointers to end of block */
> -		memset(zp2, 0, zlen2);
> -	}
> +
> +	/* Zero from end of keys to beginning of pointers */
> +	memset(zp1, 0, key_end - zp1);
> +
> +	/* Zero from end of pointers to end of block */
> +	memset(zp2, 0, (char *)block + mp->m_sb.sb_blocksize - zp2);
>  }
>  
>  static void
> @@ -316,8 +309,7 @@ zero_btree_leaf(
>  	struct xfs_bmbt_rec	*brp;
>  	struct xfs_inobt_rec	*irp;
>  	struct xfs_alloc_rec	*arp;
> -	void			*zp;
> -	int			zlen;
> +	char			*zp;
>  
>  	nrecs = be16_to_cpu(block->bb_numrecs);
>  
> @@ -325,29 +317,24 @@ zero_btree_leaf(
>  	case TYP_BMAPBTA:
>  	case TYP_BMAPBTD:
>  		brp = XFS_BMBT_REC_ADDR(mp, block, 1);
> -		zp = &brp[nrecs];
> -		zlen = (char *)block + mp->m_sb.sb_blocksize - (char *)&brp[nrecs];
> +		zp = (char *)&brp[nrecs];
>  		break;
>  	case TYP_INOBT:
>  	case TYP_FINOBT:
>  		irp = XFS_INOBT_REC_ADDR(mp, block, 1);
> -		zp = &irp[nrecs];
> -		zlen = (char *)block + mp->m_sb.sb_blocksize - (char *)&irp[nrecs];
> +		zp = (char *)&irp[nrecs];
>  		break;
>  	case TYP_BNOBT:
>  	case TYP_CNTBT:
>  		arp = XFS_ALLOC_REC_ADDR(mp, block, 1);
> -		zp = &arp[nrecs];
> -		zlen = (char *)block + mp->m_sb.sb_blocksize - (char *)&arp[nrecs];
> +		zp = (char *)&arp[nrecs];
>  		break;
>  	default:
> -		zp = NULL;
> -		break;
> +		return;
>  	}
>  
>  	/* Zero from end of records to end of block */
> -	if (zp && zlen < mp->m_sb.sb_blocksize)
> -		memset(zp, 0, zlen);
> +	memset(zp, 0, (char *)block + mp->m_sb.sb_blocksize - zp);
>  }
>  
>  static void
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
