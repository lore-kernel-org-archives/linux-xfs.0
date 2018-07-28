Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58582 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725755AbeG1ECs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 28 Jul 2018 00:02:48 -0400
Subject: Re: [PATCH 1/2] misc: use xfs_agfl_walk where appropriate
References: <153273025311.29060.14065633572750924491.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <50fd5f62-3de1-17ac-2afd-ea2cfdbb8c8e@sandeen.net>
Date: Fri, 27 Jul 2018 19:38:06 -0700
MIME-Version: 1.0
In-Reply-To: <153273025311.29060.14065633572750924491.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 7/27/18 3:24 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the xfs_agfl_walk function to iterate every block in the AGFL,
> instead of open-coding it db and repair.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/check.c               |   60 ++++++++++++++++++++++--------------------
>  db/freesp.c              |   31 ++++++++--------------
>  libxfs/libxfs_api_defs.h |    1 +
>  repair/scan.c            |   66 +++++++++++++++++++++++++---------------------
>  4 files changed, 81 insertions(+), 77 deletions(-)
> 
> 
> diff --git a/db/check.c b/db/check.c
> index 9846d672..76c28d49 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -4010,16 +4010,30 @@ scan_ag(
>  	pop_cur();
>  }
>  
> +struct agfl_state {
> +	xfs_agnumber_t	agno;
> +	unsigned int	count;
> +};
> +
> +static int
> +scan_agfl(
> +	struct xfs_mount	*mp,
> +	xfs_agblock_t		bno,
> +	void			*priv)
> +{
> +	struct agfl_state	*as = priv;
> +
> +	set_dbmap(as->agno, bno, 1, DBM_FREELIST, as->agno, XFS_AGFL_BLOCK(mp));
> +	as->count++;
> +	return 0;
> +}
> +
>  static void
>  scan_freelist(
> -	xfs_agf_t	*agf)
> +	xfs_agf_t		*agf)
>  {
> -	xfs_agnumber_t	seqno = be32_to_cpu(agf->agf_seqno);
> -	xfs_agfl_t	*agfl;
> -	xfs_agblock_t	bno;
> -	uint		count;
> -	int		i;
> -	__be32		*freelist;
> +	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
> +	struct agfl_state	state;
>  
>  	if (XFS_SB_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
>  	    XFS_AGF_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
> @@ -4032,46 +4046,36 @@ scan_freelist(
>  	set_cur(&typtab[TYP_AGFL],
>  		XFS_AG_DADDR(mp, seqno, XFS_AGFL_DADDR(mp)),
>  		XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
> -	if ((agfl = iocur_top->data) == NULL) {
> +	if (iocur_top->data == NULL) {
>  		dbprintf(_("can't read agfl block for ag %u\n"), seqno);
>  		serious_error++;
>  		pop_cur();
>  		return;
>  	}
> -	i = be32_to_cpu(agf->agf_flfirst);
>  
>  	/* verify agf values before proceeding */
>  	if (be32_to_cpu(agf->agf_flfirst) >= libxfs_agfl_size(mp) ||
>  	    be32_to_cpu(agf->agf_fllast) >= libxfs_agfl_size(mp)) {
>  		dbprintf(_("agf %d freelist blocks bad, skipping "
> -			  "freelist scan\n"), i);
> +			  "freelist scan\n"), seqno);

This appears to be a change in output as well, though it also appears to be
a correct bugfix.  Just making sure ... right?

(similar changes in each utility)

-Eric

