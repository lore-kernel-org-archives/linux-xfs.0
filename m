Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7EF9B7F37
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 21:13:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A204304039
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 19:13:53 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	308dm10AI8MAtYHI for <xfs@oss.sgi.com>;
	Fri, 12 Jul 2013 19:13:51 -0700 (PDT)
Date: Sat, 13 Jul 2013 12:13:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Initialize all quota inodes to be NULLFSINO
Message-ID: <20130713021349.GH3438@dastard>
References: <1373593665.20769.10.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373593665.20769.10.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Thu, Jul 11, 2013 at 08:47:45PM -0500, Chandra Seetharaman wrote:
> 
> mkfs doesn't initialize the quota inodes to NULLFSINO as it
> does for the other internal inodes. This leads to check for two
> values (0 and NULLFSINO) to make sure if a quota inode is
> valid.
> 
> Solve that problem by initializing the values to NULLFSINO
> if they are 0.
> 
> Note that these values are not written back to on-disk
> superblock unless some quota is enabled on the filesystem.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  fs/xfs/xfs_mount.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 2b0ba35..8b95933 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -572,6 +572,18 @@ out_unwind:
>  static void
>  xfs_sb_quota_from_disk(struct xfs_sb *sbp)
>  {
> +	/*
> +	 * older mkfs doesn't initialize quota inodes to NULLFSINO,
> +	 * which leads to two values for a quota inode to be invalid:
> +	 * 0 and NULLFSINO. Fix it.
> +	 */
> +	if (sbp->sb_uquotino == 0)
> +		sbp->sb_uquotino = NULLFSINO;
> +	if (sbp->sb_gquotino == 0)
> +		sbp->sb_gquotino = NULLFSINO;
> +	if (sbp->sb_pquotino == 0)
> +		sbp->sb_pquotino = NULLFSINO;

There coment needs to point out that this is changing the in-memory
superblock value right here, so we don't need to make changing
sb_pquotino dependent on the superblock having support for this
feature.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
