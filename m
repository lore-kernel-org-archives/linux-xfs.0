Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4D3AF7F51
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 13:21:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C9A78AC005
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 11:21:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0sjYzWm77Qj1p1PR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 07 Jul 2014 11:21:23 -0700 (PDT)
Date: Mon, 7 Jul 2014 14:21:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: tidy up xfs_set_inode32
Message-ID: <20140707182117.GE4123@laptop.bfoster>
References: <53B4E1EE.40702@redhat.com>
 <53B4E2C5.1000303@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53B4E2C5.1000303@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jul 02, 2014 at 11:57:41PM -0500, Eric Sandeen wrote:
> xfs_set_inode32() caught my eye because it had
> weird spacing around the "-1's".  In cleaning that
> up, I realized that the assignment in the declaration
> of "ino" is never used; it's rewritten before it gets
> read.
> 
> Drop the ino initializer from its declaration since it's
> not used, and move the agino initialization into the body
> of the function, mostly so that we can have pretty
> whitespace and not exceed 80 columns.  :)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e71c0f8..39c9315 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -609,8 +609,8 @@ xfs_set_inode32(struct xfs_mount *mp, xfs_agnumber_t agcount)
>  	xfs_agnumber_t	maxagi = 0;
>  	xfs_sb_t	*sbp = &mp->m_sb;
>  	xfs_agnumber_t	max_metadata;
> -	xfs_agino_t	agino =	XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks -1, 0);
> -	xfs_ino_t	ino = XFS_AGINO_TO_INO(mp, sbp->sb_agcount -1, agino);
> +	xfs_agino_t	agino;
> +	xfs_ino_t	ino;
>  	xfs_perag_t	*pag;
>  
>  	/* Calculate how much should be reserved for inodes to meet
> @@ -628,6 +628,8 @@ xfs_set_inode32(struct xfs_mount *mp, xfs_agnumber_t agcount)
>  		max_metadata = agcount;
>  	}
>  
> +	agino =	XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
> +
>  	for (index = 0; index < agcount; index++) {
>  		ino = XFS_AGINO_TO_INO(mp, index, agino);
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
