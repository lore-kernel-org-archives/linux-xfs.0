Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 717C27FB3
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 19:53:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 00183AC002
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 17:53:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	n6QlGGJvTHVQ1FGV for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2015 17:53:24 -0700 (PDT)
Date: Fri, 5 Jun 2015 10:53:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/28] repair: handle sparse format inobt record
	freecount correctly
Message-ID: <20150605005322.GL9143@dastard>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
	<1433270521-62026-16-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433270521-62026-16-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 02, 2015 at 02:41:48PM -0400, Brian Foster wrote:
> The sparse inode chunk feature introduces a new inobt record format that
> converts ir_freecount from 4 bytes to 1 byte. ir_freecount references
> throughout repair currently assume the 'full' format and endian-convert
> from the 32-bit value.
> 
> Update the xfs_repair inobt scan and tree rebuild codepaths to use the
> correct record format for ir_freecount when sparse inodes is enabled.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  repair/phase5.c |  6 +++++-
>  repair/scan.c   | 37 +++++++++++++++++++++++++------------
>  2 files changed, 30 insertions(+), 13 deletions(-)
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index d01e72b..04bf049 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -1240,7 +1240,11 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  				inocnt += is_inode_free(ino_rec, k);
>  			}
>  
> -			bt_rec[j].ir_u.f.ir_freecount = cpu_to_be32(inocnt);
> +			if (xfs_sb_version_hassparseinodes(&mp->m_sb))
> +				bt_rec[j].ir_u.sp.ir_freecount = inocnt;
> +			else
> +				bt_rec[j].ir_u.f.ir_freecount =
> +							cpu_to_be32(inocnt);
>  			freecount += inocnt;
>  			count += XFS_INODES_PER_CHUNK;

Can you make this a "inorec_set_freecount(mp, rec, count)" helper?

> diff --git a/repair/scan.c b/repair/scan.c
> index e64d0e5..f42459c 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -751,11 +751,16 @@ scan_single_ino_chunk(
>  	int			off;
>  	int			state;
>  	ino_tree_node_t		*ino_rec, *first_rec, *last_rec;
> +	int			freecount;
>  
>  	ino = be32_to_cpu(rp->ir_startino);
>  	off = XFS_AGINO_TO_OFFSET(mp, ino);
>  	agbno = XFS_AGINO_TO_AGBNO(mp, ino);
>  	lino = XFS_AGINO_TO_INO(mp, agno, ino);
> +	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
> +		freecount = rp->ir_u.sp.ir_freecount;
> +	else
> +		freecount = be32_to_cpu(rp->ir_u.f.ir_freecount);

And this a "freecount = inorec_get_freecount(mp, rec)" helper?

The code is otherwise fine, so I'll apply this patch as is to keep
working through the series. Can you send the helper update as a
delta patch that applies at the end of the entire series?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
