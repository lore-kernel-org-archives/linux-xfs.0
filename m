Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37148 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753844AbcLOT1X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Dec 2016 14:27:23 -0500
Subject: Re: [PATCH 2/3] xfs_repair: fix bogus rmapbt record owner check
References: <148182550558.24784.5628335536185073955.stgit@birch.djwong.org>
 <148182551170.24784.17780632480854888664.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7ace24be-d8c5-e306-9b33-ca6693eae586@sandeen.net>
Date: Thu, 15 Dec 2016 13:20:36 -0600
MIME-Version: 1.0
In-Reply-To: <148182551170.24784.17780632480854888664.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 12/15/16 12:11 PM, Darrick J. Wong wrote:
> Make the reverse mapping owner check actually validate inode numbers.

Thanks, you also sent this on 11/4 so it's in my stack already.

-Eric
 
> Coverity-id: 1371628
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/scan.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 0e13581..b9ef4dc 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -1052,8 +1052,12 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
>  			}
>  
>  			/* Look for impossible owners. */
> -			if (!(owner > 0 || (owner > XFS_RMAP_OWN_MIN &&
> -					    owner <= XFS_RMAP_OWN_FS)))
> +			if (!((owner > XFS_RMAP_OWN_MIN &&
> +			       owner <= XFS_RMAP_OWN_FS) ||
> +			      (XFS_INO_TO_AGNO(mp, owner) < mp->m_sb.sb_agcount &&
> +			       XFS_AGINO_TO_AGBNO(mp,
> +					XFS_INO_TO_AGINO(mp, owner)) <
> +					mp->m_sb.sb_agblocks)))
>  				do_warn(
>  	_("invalid owner in rmap btree record %d (%"PRId64" %u) block %u/%u\n"),
>  						i, owner, len, agno, bno);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
