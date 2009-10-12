Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9CKg4pI054068 for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 15:42:04 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC2E3C14F57
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 13:43:32 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id fOepjffthG262AWD for
	<xfs@oss.sgi.com>; Mon, 12 Oct 2009 13:43:32 -0700 (PDT)
Message-ID: <4AD394F4.60809@sandeen.net>
Date: Mon, 12 Oct 2009 15:43:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 05/14] repair: reduce byte swapping in scan_freelist
References: <20090902175531.469184575@bombadil.infradead.org>
	<20090902175840.573208011@bombadil.infradead.org>
In-Reply-To: <20090902175840.573208011@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

> Store the ag number in a local native endian variable to avoid 
> byteswapping
> it over and over again.
>
>
> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
> Index: xfsprogs-dev/repair/scan.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/scan.c	2009-08-21 19:03:26.000000000 +0000
> +++ xfsprogs-dev/repair/scan.c	2009-08-21 19:05:32.000000000 +0000
> @@ -943,23 +943,26 @@ scan_freelist(
>  {
>  	xfs_agfl_t	*agfl;
>  	xfs_buf_t	*agflbuf;
> +	xfs_agnumber_t	agno;
>  	xfs_agblock_t	bno;
>  	int		count;
>  	int		i;
>  
> +	agno = be32_to_cpu(agf->agf_seqno);
> +
>  	if (XFS_SB_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
> -			XFS_AGF_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
> -			XFS_AGI_BLOCK(mp) != XFS_AGFL_BLOCK(mp))
> -		set_agbno_state(mp, be32_to_cpu(agf->agf_seqno),
> -				XFS_AGFL_BLOCK(mp), XR_E_FS_MAP);
> +	    XFS_AGF_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
> +	    XFS_AGI_BLOCK(mp) != XFS_AGFL_BLOCK(mp))
> +		set_agbno_state(mp, agno, XFS_AGFL_BLOCK(mp), XR_E_FS_MAP);
> +
>  	if (be32_to_cpu(agf->agf_flcount) == 0)
>  		return;
> -	agflbuf = libxfs_readbuf(mp->m_dev, XFS_AG_DADDR(mp,
> -				be32_to_cpu(agf->agf_seqno),
> -				XFS_AGFL_DADDR(mp)), XFS_FSS_TO_BB(mp, 1), 0);
> +
> +	agflbuf = libxfs_readbuf(mp->m_dev,
> +				 XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
> +				 XFS_FSS_TO_BB(mp, 1), 0);
>  	if (!agflbuf)  {
> -		do_abort(_("can't read agfl block for ag %d\n"),
> -			be32_to_cpu(agf->agf_seqno));
> +		do_abort(_("can't read agfl block for ag %d\n"), agno);
>  		return;
>  	}
>  	agfl = XFS_BUF_TO_AGFL(agflbuf);
> @@ -967,12 +970,11 @@ scan_freelist(
>  	count = 0;
>  	for (;;) {
>  		bno = be32_to_cpu(agfl->agfl_bno[i]);
> -		if (verify_agbno(mp, be32_to_cpu(agf->agf_seqno), bno))
> -			set_agbno_state(mp, be32_to_cpu(agf->agf_seqno),
> -					bno, XR_E_FREE);
> +		if (verify_agbno(mp, agno, bno))
> +			set_agbno_state(mp, agno, bno, XR_E_FREE);
>  		else
>  			do_warn(_("bad agbno %u in agfl, agno %d\n"),
> -				bno, be32_to_cpu(agf->agf_seqno));
> +				bno, agno);
>  		count++;
>  		if (i == be32_to_cpu(agf->agf_fllast))
>  			break;
> @@ -981,8 +983,7 @@ scan_freelist(
>  	}
>  	if (count != be32_to_cpu(agf->agf_flcount)) {
>  		do_warn(_("freeblk count %d != flcount %d in ag %d\n"), count,
> -			be32_to_cpu(agf->agf_flcount),
> -			be32_to_cpu(agf->agf_seqno));
> +			be32_to_cpu(agf->agf_flcount), agno);
>  	}
>  	libxfs_putbuf(agflbuf);
>  }
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
