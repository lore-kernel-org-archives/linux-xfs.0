Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A4867F52
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 14:56:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1DBF730407B
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:56:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7Ujm13UiarnrQaN6 for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:56:31 -0700 (PDT)
Date: Tue, 15 Apr 2014 15:40:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/9] repair: detect CRC errors in AG headers
Message-ID: <20140415194029.GC3470@laptop.bfoster>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397550301-31883-6-git-send-email-david@fromorbit.com>
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

On Tue, Apr 15, 2014 at 06:24:57PM +1000, Dave Chinner wrote:
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
>  repair/scan.c | 66 ++++++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 38 insertions(+), 28 deletions(-)
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 1744c32..6c43474 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -1207,28 +1207,31 @@ scan_ag(
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
>  	sbbuf = libxfs_readbuf(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
>  				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
>  	if (!sbbuf)  {
> -		do_error(_("can't get root superblock for ag %d\n"), agno);
> -		return;
> +		objname = _("root superblock");
> +		goto out_free;
>  	}
> +	if (sbbuf->b_error == EFSBADCRC || sbbuf->b_error == EFSCORRUPTED)
> +		sb_dirty = 1;
> +
>  	sb = (xfs_sb_t *)calloc(BBSIZE, 1);
>  	if (!sb) {
>  		do_error(_("can't allocate memory for superblock\n"));
> -		libxfs_putbuf(sbbuf);
> -		return;
> +		goto out_free;
>  	}
>  	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbbuf));
>  
> @@ -1236,23 +1239,22 @@ scan_ag(
>  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
>  			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agf_buf_ops);
>  	if (!agfbuf)  {
> -		do_error(_("can't read agf block for ag %d\n"), agno);
> -		libxfs_putbuf(sbbuf);
> -		free(sb);
> -		return;
> +		objname = _("agf block");
> +		goto out_free;
>  	}
> +	if (agfbuf->b_error == EFSBADCRC || agfbuf->b_error == EFSCORRUPTED)
> +		agf_dirty = 1;
>  	agf = XFS_BUF_TO_AGF(agfbuf);
>  
>  	agibuf = libxfs_readbuf(mp->m_dev,
>  			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
>  			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agi_buf_ops);
>  	if (!agibuf)  {
> -		do_error(_("can't read agi block for ag %d\n"), agno);
> -		libxfs_putbuf(agfbuf);
> -		libxfs_putbuf(sbbuf);
> -		free(sb);
> -		return;
> +		objname = _("agi block");
> +		goto out_free;
>  	}
> +	if (agibuf->b_error == EFSBADCRC || agibuf->b_error == EFSCORRUPTED)
> +		agi_dirty = 1;
>  	agi = XFS_BUF_TO_AGI(agibuf);
>  
>  	/* fix up bad ag headers */
> @@ -1277,7 +1279,7 @@ scan_ag(
>  			do_warn(_("would reset bad sb for ag %d\n"), agno);
>  		}
>  	}
> -	if (status & XR_AG_AGF)  {
> +	if (agf_dirty || status & XR_AG_AGF)  {
>  		if (!no_modify) {
>  			do_warn(_("reset bad agf for ag %d\n"), agno);
>  			agf_dirty = 1;
> @@ -1285,7 +1287,7 @@ scan_ag(
>  			do_warn(_("would reset bad agf for ag %d\n"), agno);
>  		}
>  	}
> -	if (status & XR_AG_AGI)  {
> +	if (agi_dirty || status & XR_AG_AGI)  {
>  		if (!no_modify) {
>  			do_warn(_("reset bad agi for ag %d\n"), agno);
>  			agi_dirty = 1;

There are a few asserts a bit further down this function that assume
*_dirty is set only when in !no_modify mode. E.g.:

	ASSERT(agi_dirty == 0 || (agi_dirty && !no_modify));

You'll probably want to remove those. Or...

> @@ -1295,15 +1297,9 @@ scan_ag(
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
> +		goto out_free;
>  	}

Would we want to skip the ag, as such, on a CRC error in no_modify mode?
If so, perhaps we could set the status variable on crc errors and
bitwise or the value returned from verify_set_agheader().

Brian

>  
>  	scan_freelist(agf, agcnts);
> @@ -1341,6 +1337,20 @@ scan_ag(
>  	print_inode_list(i);
>  #endif
>  	return;
> +
> +out_free:
> +	if (sb)
> +		free(sb);
> +	if (agibuf)
> +		libxfs_putbuf(agibuf);
> +	if (agfbuf)
> +		libxfs_putbuf(agfbuf);
> +	if (sbbuf)
> +		libxfs_putbuf(sbbuf);
> +	if (objname)
> +		do_error(_("can't get %s for ag %d\n"), objname, agno);
> +	return;
> +
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
