Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EBEF17F95
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 17:49:22 -0500 (CDT)
Date: Tue, 2 Apr 2013 17:49:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 09/21] xfs: add version 3 inode format with CRCs
Message-ID: <20130402224922.GA22182@sgi.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363091454-8852-10-git-send-email-david@fromorbit.com>
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

Hi Dave,

On Tue, Mar 12, 2013 at 11:30:42PM +1100, Dave Chinner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Add a new inode version with a larger core.  The primary objective is
> to allow for a crc of the inode, and location information (uuid and ino)
> to verify it was written in the right place.  We also extend it by:
> 
> 	a creation time (for Samba);
> 	a changecount (for NFSv4);
> 	a flush sequence (in LSN format for recovery);
> 	an additional inode flags field; and
> 	some additional padding.
> 
> These additional fields are not implemented yet, but already laid
> out in the structure.
> 
> [dchinner@redhat.com] Added LSN and flags field, some factoring and rework to
> capture all the necessary information in the crc calculation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.h    |    4 +-
>  fs/xfs/xfs_dinode.h      |   33 +++++++--
>  fs/xfs/xfs_ialloc.c      |   23 +++++-
>  fs/xfs/xfs_inode.c       |  179 ++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_inode.h       |   26 +++++++
>  fs/xfs/xfs_inode_item.c  |    2 +-
>  fs/xfs/xfs_log_recover.c |   35 +++++++--
>  fs/xfs/xfs_trans_buf.c   |    5 +-
>  8 files changed, 237 insertions(+), 70 deletions(-)

...

> diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
> index 6b5bd17..bdc946a 100644
> --- a/fs/xfs/xfs_dinode.h
> +++ b/fs/xfs/xfs_dinode.h
> @@ -19,7 +19,7 @@
>  #define	__XFS_DINODE_H__
>  
>  #define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
> -#define XFS_DINODE_GOOD_VERSION(v)	(((v) == 1 || (v) == 2))
> +#define XFS_DINODE_GOOD_VERSION(v)	((v) >= 1 && (v) <= 3)
>  
>  typedef struct xfs_timestamp {
>  	__be32		t_sec;		/* timestamp seconds */
> @@ -70,11 +70,36 @@ typedef struct xfs_dinode {
>  
>  	/* di_next_unlinked is the only non-core field in the old dinode */
>  	__be32		di_next_unlinked;/* agi unlinked list ptr */
> -} __attribute__((packed)) xfs_dinode_t;
> +
> +	/* start of the extended dinode, writable fields */
> +	__be32		di_crc;		/* CRC of the inode */
> +	__be64		di_changecount;	/* number of attribute changes */
> +	__be64		di_lsn;		/* flush sequence */
> +	__be64		di_flags2;	/* more random flags */
> +	__u8		di_pad2[16];	/* more padding for future expansion */

Please add to the pad:

(as an optimisation for the most common case, a single link)
8 bytes for a parent inode pointer
4 bytes for a name offset in the parent's data fork

and
4 bytes for an allocation policy

Thanks,
	Ben

> +
> +	/* fields only written to during inode creation */
> +	xfs_timestamp_t	di_crtime;	/* time created */
> +	__be64		di_ino;		/* inode number */
> +	uuid_t		di_uuid;	/* UUID of the filesystem */
> +
> +	/* structure must be padded to 64 bit alignment */
> +} xfs_dinode_t;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
