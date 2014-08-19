Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 79BFE7F3F
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 13:15:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 593A28F804C
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 11:15:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 6lKjbzZ9JnOtGlW4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Aug 2014 11:15:43 -0700 (PDT)
Date: Tue, 19 Aug 2014 11:15:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: add a few more verifier tests
Message-ID: <20140819181542.GA31177@infradead.org>
References: <53F2C103.8030607@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F2C103.8030607@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

> Anyway - bounds checking when we read from disk is a good thing!

Absolutelt!

Looks good modulo a few nitpicks below.

Reviewed-by: Christoph Hellwig <hch@lst.de>

> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 4bffffe..a4a9e0e 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2209,6 +2209,10 @@ xfs_agf_verify(
>  	      be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp)))
>  		return false;
>  
> +	if (!(be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) <= XFS_BTREE_MAXLEVELS &&
> +	      be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) <= XFS_BTREE_MAXLEVELS))
> +		return false;

Maybe it's just me, but negated numeric comparisms always confuse the
hell out of me, why not simply:

	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS)
		return false;
	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > XFS_BTREE_MAXLEVELS)
		return false;

> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2051,6 +2051,8 @@ xfs_agi_verify(
>  	if (!XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)))
>  		return false;
>  
> +	if (!(be32_to_cpu(agi->agi_level) <= XFS_BTREE_MAXLEVELS))
> +		return false;

Same here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
