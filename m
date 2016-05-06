Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF0DE7CA0
	for <xfs@oss.sgi.com>; Fri,  6 May 2016 16:38:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C2832304039
	for <xfs@oss.sgi.com>; Fri,  6 May 2016 14:38:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OqtkGeoAZwXZAiiq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 06 May 2016 14:38:21 -0700 (PDT)
Date: Fri, 6 May 2016 16:38:18 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH] xfs_db: fix unaligned accesses
Message-ID: <20160506213818.GA18803@redhat.com>
References: <a8a63bc2-86ac-4f30-9b5d-79edf94cad57@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a8a63bc2-86ac-4f30-9b5d-79edf94cad57@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Anatoly Pugachev <matorola@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, May 06, 2016 at 03:43:53PM -0500, Eric Sandeen wrote:
> Fix 2 unaligned accesses in xfs_db which caused bus errors on
> sparc64.  Similar treatment was already done in xfs_repair and
> xfs_metadump but somehow xfs_db got missed.
> 
> Thanks to Anatoly for reminding me that unaligned access is
> a thing.  ;)
> 
> Resolves-oss-bugzilla: #1140
> Reported-by: Anatoly Pugachev <matorola@gmail.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> 
> diff --git a/db/check.c b/db/check.c
> index c626a5c..0871ed7 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2202,7 +2202,7 @@ process_btinode(
>  		pp = XFS_BMDR_PTR_ADDR(dib, 1, xfs_bmdr_maxrecs(
>  				XFS_DFORK_SIZE(dip, mp, whichfork), 0));
>  		for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++)
> -			scan_lbtree(be64_to_cpu(pp[i]),
> +			scan_lbtree(get_unaligned_be64(&pp[i]),
>  					be16_to_cpu(dib->bb_level),
>  					scanfunc_bmap, type, id, totd, toti,
>  					nex, blkmapp, 1,
> diff --git a/db/frag.c b/db/frag.c
> index 3beb416..36bb689 100644
> --- a/db/frag.c
> +++ b/db/frag.c
> @@ -258,8 +258,8 @@ process_btinode(
>  	pp = XFS_BMDR_PTR_ADDR(dib, 1,
>  		xfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
>  	for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++)
> -		scan_lbtree(be64_to_cpu(pp[i]), be16_to_cpu(dib->bb_level),
> -			scanfunc_bmap, extmapp,
> +		scan_lbtree(get_unaligned_be64(&pp[i]),
> +			 be16_to_cpu(dib->bb_level), scanfunc_bmap, extmapp,
>  			whichfork == XFS_DATA_FORK ? TYP_BMAPBTD : TYP_BMAPBTA);
>  }
>  
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
