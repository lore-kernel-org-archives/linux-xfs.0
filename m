Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51818 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751621AbeEDVwn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 17:52:43 -0400
Subject: Re: [PATCH 07/11] xfs_repair: only update in-core extent state after
 scanning full extent
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401963554.13319.9264510034231335778.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a1a8bc18-48b6-f893-63bf-96682f7e1472@sandeen.net>
Date: Fri, 4 May 2018 16:52:42 -0500
MIME-Version: 1.0
In-Reply-To: <152401963554.13319.9264510034231335778.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 4/17/18 9:47 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In process_bmbt_reclist_int, only update the in-core extent state after
> clearing the entire extent for conflicts.  If we encounter conflicts
> we'll try rebuilding the fork from rmap data and rescanning the fork.
> It is essential to avoid polluting the in-memory state with garbage
> data so that we don't end up nuking other files needlessly.  Found by
> fuzzing recs[1].blockcount = middlebit in xfs/380.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

AFAICT this makes sense. :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/dinode.c |   30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index ceffc52..c8c1850 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -751,7 +751,6 @@ _("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
>  				/* fall through ... */
>  			case XR_E_INUSE1:	/* seen by rmap */
>  			case XR_E_UNKNOWN:
> -				set_bmap_ext(agno, agbno, blen, XR_E_INUSE);
>  				break;
>  
>  			case XR_E_BAD_STATE:
> @@ -773,7 +772,6 @@ _("%s fork in inode %" PRIu64 " claims metadata block %" PRIu64 "\n"),
>  
>  			case XR_E_INUSE:
>  			case XR_E_MULT:
> -				set_bmap_ext(agno, agbno, blen, XR_E_MULT);
>  				if (type == XR_INO_DATA &&
>  				    xfs_sb_version_hasreflink(&mp->m_sb))
>  					break;
> @@ -792,6 +790,34 @@ _("%s fork in %s inode %" PRIu64 " claims CoW block %" PRIu64 "\n"),
>  				do_error(
>  _("illegal state %d in block map %" PRIu64 "\n"),
>  					state, b);
> +				goto done;
> +			}
> +		}
> +
> +		/*
> +		 * Update the internal extent map only after we've checked
> +		 * every block in this extent.  The first time we reject this
> +		 * data fork we'll try to rebuild the bmbt from rmap data.
> +		 * After a successful rebuild we'll try this scan again.
> +		 * (If the rebuild fails we won't come back here.)
> +		 */
> +		agbno = XFS_FSB_TO_AGBNO(mp, irec.br_startblock);
> +		ebno = agbno + irec.br_blockcount;
> +		for (; agbno < ebno; agbno += blen) {
> +			state = get_bmap_ext(agno, agbno, ebno, &blen);
> +			switch (state)  {
> +			case XR_E_FREE:
> +			case XR_E_FREE1:
> +			case XR_E_INUSE1:
> +			case XR_E_UNKNOWN:
> +				set_bmap_ext(agno, agbno, blen, XR_E_INUSE);
> +				break;
> +			case XR_E_INUSE:
> +			case XR_E_MULT:
> +				set_bmap_ext(agno, agbno, blen, XR_E_MULT);
> +				break;
> +			default:
> +				break;
>  			}
>  		}
>  		if (collect_rmaps) { /* && !check_dups */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
