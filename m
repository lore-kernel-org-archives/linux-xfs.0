Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A3D7029DF8
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 09:06:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 937F28F8035
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 07:06:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ehnWjD9T43QBiIxV for
	<xfs@oss.sgi.com>; Tue, 29 Apr 2014 07:06:22 -0700 (PDT)
Date: Tue, 29 Apr 2014 10:06:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/9] repair: detect CRC errors in AG headers
Message-ID: <20140429140619.GC59046@bfoster.bfoster>
References: <1398719099-19194-1-git-send-email-david@fromorbit.com>
	<1398719099-19194-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398719099-19194-6-git-send-email-david@fromorbit.com>
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

On Tue, Apr 29, 2014 at 07:04:55AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> repair doesn't currently detect verifier errors in AG header
> blocks - apart from the primary superblock they are not detected.
> They are, fortunately, corrected in the important cases (AGF, AGI
> and AGFL) because these structures are rebuilt in phase 5, but if
> you run xfs_repair in checking mode it won't report them as bad.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/scan.c | 83 +++++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 49 insertions(+), 34 deletions(-)
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 1744c32..dec84ed 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -1207,39 +1207,38 @@ scan_ag(
>  	void		*arg)
>  {
>  	struct aghdr_cnts *agcnts = arg;
> -	xfs_agf_t	*agf;
> -	xfs_buf_t	*agfbuf;
> +	struct xfs_agf	*agf;
> +	struct xfs_buf	*agfbuf = NULL;
>  	int		agf_dirty = 0;
> -	xfs_agi_t	*agi;
> -	xfs_buf_t	*agibuf;
> +	struct xfs_agi	*agi;
> +	struct xfs_buf	*agibuf = NULL;
>  	int		agi_dirty = 0;
> -	xfs_sb_t	*sb;
> -	xfs_buf_t	*sbbuf;
> +	struct xfs_sb	*sb = NULL;
> +	struct xfs_buf	*sbbuf = NULL;
>  	int		sb_dirty = 0;
>  	int		status;
> +	char		*objname = NULL;
>  
> -	sbbuf = libxfs_readbuf(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
> -				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
> -	if (!sbbuf)  {
> -		do_error(_("can't get root superblock for ag %d\n"), agno);
> -		return;
> -	}
> -	sb = (xfs_sb_t *)calloc(BBSIZE, 1);
> +	sb = (struct xfs_sb *)calloc(BBSIZE, 1);
>  	if (!sb) {
>  		do_error(_("can't allocate memory for superblock\n"));
> -		libxfs_putbuf(sbbuf);
>  		return;
>  	}
> +
> +	sbbuf = libxfs_readbuf(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
> +				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
> +	if (!sbbuf)  {
> +		objname = _("root superblock");
> +		goto out_free_sb;
> +	}
>  	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbbuf));
>  
>  	agfbuf = libxfs_readbuf(mp->m_dev,
>  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
>  			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agf_buf_ops);
>  	if (!agfbuf)  {
> -		do_error(_("can't read agf block for ag %d\n"), agno);
> -		libxfs_putbuf(sbbuf);
> -		free(sb);
> -		return;
> +		objname = _("agf block");
> +		goto out_free_sbbuf;
>  	}
>  	agf = XFS_BUF_TO_AGF(agfbuf);
>  
> @@ -1247,11 +1246,8 @@ scan_ag(
>  			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
>  			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agi_buf_ops);
>  	if (!agibuf)  {
> -		do_error(_("can't read agi block for ag %d\n"), agno);
> -		libxfs_putbuf(agfbuf);
> -		libxfs_putbuf(sbbuf);
> -		free(sb);
> -		return;
> +		objname = _("agi block");
> +		goto out_free_agfbuf;
>  	}
>  	agi = XFS_BUF_TO_AGI(agibuf);
>  
> @@ -1295,15 +1291,9 @@ scan_ag(
>  	}
>  
>  	if (status && no_modify)  {
> -		libxfs_putbuf(agibuf);
> -		libxfs_putbuf(agfbuf);
> -		libxfs_putbuf(sbbuf);
> -		free(sb);
> -
>  		do_warn(_("bad uncorrected agheader %d, skipping ag...\n"),
>  			agno);
> -
> -		return;
> +		goto out_free_agibuf;
>  	}
>  
>  	scan_freelist(agf, agcnts);
> @@ -1312,21 +1302,34 @@ scan_ag(
>  	validate_agi(agi, agno, agcnts);
>  
>  	ASSERT(agi_dirty == 0 || (agi_dirty && !no_modify));
> +	ASSERT(agf_dirty == 0 || (agf_dirty && !no_modify));
> +	ASSERT(sb_dirty == 0 || (sb_dirty && !no_modify));
> +
> +	/*
> +	 * Only pay attention to CRC/verifier errors if we can correct them.
> +	 * While there, ensure that we corrected a corruption error if the
> +	 * verifier detected one.
> +	 */
> +	if (!no_modify) {
> +		ASSERT(agi_dirty || agibuf->b_error != EFSCORRUPTED);
> +		ASSERT(agf_dirty || agfbuf->b_error != EFSCORRUPTED);
> +		ASSERT(sb_dirty || sbbuf->b_error != EFSCORRUPTED);
> +
> +		agi_dirty += (agibuf->b_error == EFSBADCRC);
> +		agf_dirty += (agfbuf->b_error == EFSBADCRC);
> +		sb_dirty += (sbbuf->b_error == EFSBADCRC);
> +	}

So we'll detect and correct the CRC error in normal mode, but no longer
issue the preceding warnings ("would reset bad ...") for CRC errors in
no_modify mode. Is that desired?

I ask because it looks like a departure from previous versions.
Otherwise, the code looks fine to me.

Brian

>  
>  	if (agi_dirty && !no_modify)
>  		libxfs_writebuf(agibuf, 0);
>  	else
>  		libxfs_putbuf(agibuf);
>  
> -	ASSERT(agf_dirty == 0 || (agf_dirty && !no_modify));
> -
>  	if (agf_dirty && !no_modify)
>  		libxfs_writebuf(agfbuf, 0);
>  	else
>  		libxfs_putbuf(agfbuf);
>  
> -	ASSERT(sb_dirty == 0 || (sb_dirty && !no_modify));
> -
>  	if (sb_dirty && !no_modify) {
>  		if (agno == 0)
>  			memcpy(&mp->m_sb, sb, sizeof(xfs_sb_t));
> @@ -1341,6 +1344,18 @@ scan_ag(
>  	print_inode_list(i);
>  #endif
>  	return;
> +
> +out_free_agibuf:
> +	libxfs_putbuf(agibuf);
> +out_free_agfbuf:
> +	libxfs_putbuf(agfbuf);
> +out_free_sbbuf:
> +	libxfs_putbuf(sbbuf);
> +out_free_sb:
> +	free(sb);
> +
> +	if (objname)
> +		do_error(_("can't get %s for ag %d\n"), objname, agno);
>  }
>  
>  #define SCAN_THREADS 32
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
