Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6MG0sB093633 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 16:16:00 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	AljRaQM87AXf6Tnb for <xfs@oss.sgi.com>;
	Tue, 06 Nov 2012 14:17:56 -0800 (PST)
Date: Wed, 7 Nov 2012 09:17:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 07/10] xfs: add inode id filtering to eofblocks scan
Message-ID: <20121106221754.GG24575@dastard>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
	<1352213447-59791-8-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352213447-59791-8-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 06, 2012 at 09:50:44AM -0500, Brian Foster wrote:
> Support inode ID filtering in the eofblocks scan. The caller must
> set the associated XFS_EOF_FLAGS_*ID bit and ID field.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_fs.h     |   11 +++++++++--
>  fs/xfs/xfs_icache.c |   22 ++++++++++++++++++++++
>  2 files changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index 26ff43a..88eb1bc 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -345,13 +345,20 @@ typedef struct xfs_error_injection {
>  struct xfs_eofblocks {
>  	__u32		eof_version;
>  	__u32		eof_flags;
> -	__u64		pad[15];
> +	uid_t		eof_uid;
> +	gid_t		eof_gid;
> +	prid_t		eof_prid;
> +	__u32		pad[27];
>  };

The typical way of doing this to ensure that the structure remains
the same size and people are aware of alignment issues is this:

 -	__u64		pad[15];
 +	uid_t		eof_uid;
 +	gid_t		eof_gid;
 +	prid_t		eof_prid;
 +	__u32		pad32;
 +	__u64		pad64[13];

That way it is clear that we need pad out to 8 byte boundaries even
on 32 bit systems.

>  
>  /* eof_flags values */
>  #define XFS_EOF_FLAGS_SYNC		(1 << 0) /* sync/wait mode scan */
> +#define XFS_EOF_FLAGS_UID		(1 << 1) /* filter by uid */
> +#define XFS_EOF_FLAGS_GID		(1 << 2) /* filter by gid */
> +#define XFS_EOF_FLAGS_PRID		(1 << 3) /* filter by project id */
>  #define XFS_EOF_FLAGS_VALID	\
> -	(XFS_EOF_FLAGS_SYNC)
> +	(XFS_EOF_FLAGS_SYNC|XFS_EOF_FLAGS_UID|XFS_EOF_FLAGS_GID| \
> +	 XFS_EOF_FLAGS_PRID)

A little bit of white space goes a long way:

#define XFS_EOF_FLAGS_VALID \
	(XFS_EOF_FLAGS_SYNC | \
	 XFS_EOF_FLAGS_UID | \
	 XFS_EOF_FLAGS_GID | \
	 XFS_EOF_FLAGS_PRID)

Is much easier to read and extend in future.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
