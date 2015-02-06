Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 36F137FA5
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 16:41:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8E03EAC008
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 14:41:04 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ra6pk9KDv8xURFtp for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 14:41:01 -0800 (PST)
Date: Sat, 7 Feb 2015 09:40:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 01/18] xfs: add sparse inode chunk alignment
	superblock field
Message-ID: <20150206224047.GO12722@dastard>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423252385-3063-2-git-send-email-bfoster@redhat.com>
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

On Fri, Feb 06, 2015 at 02:52:48PM -0500, Brian Foster wrote:
> Add sb_spinoalignmt to the superblock to specify sparse inode chunk
> alignment. This also currently represents the minimum allowable sparse
> chunk allocation size.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 6 +++---
>  fs/xfs/libxfs/xfs_sb.c     | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 8eb7189..051c24d 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -170,7 +170,7 @@ typedef struct xfs_sb {
>  	__uint32_t	sb_features_log_incompat;
>  
>  	__uint32_t	sb_crc;		/* superblock crc */
> -	__uint32_t	sb_pad;
> +	xfs_extlen_t	sb_spinoalignmt;/* sparse inode chunk alignment */

That's a mounthful. sb_spino_align is a bit easier to read, IMO.

> @@ -282,7 +282,7 @@ typedef enum {
>  	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
>  	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_FEATURES_COMPAT,
>  	XFS_SBS_FEATURES_RO_COMPAT, XFS_SBS_FEATURES_INCOMPAT,
> -	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_PAD,
> +	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_SPINOALIGNMT,
>  	XFS_SBS_PQUOTINO, XFS_SBS_LSN,
>  	XFS_SBS_FIELDCOUNT
>  } xfs_sb_field_t;

These are gone in the for-next tree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
