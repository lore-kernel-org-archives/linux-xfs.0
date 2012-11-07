Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7KVcO0177637 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 14:31:38 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	XdEcooc9St7swCF5 for <xfs@oss.sgi.com>;
	Wed, 07 Nov 2012 12:33:35 -0800 (PST)
Date: Thu, 8 Nov 2012 07:33:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 07/10] xfs: add inode id filtering to eofblocks scan
Message-ID: <20121107203333.GF6434@dastard>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
	<1352308874-64562-1-git-send-email-bfoster@redhat.com>
	<1352308874-64562-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352308874-64562-2-git-send-email-bfoster@redhat.com>
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

On Wed, Nov 07, 2012 at 12:21:13PM -0500, Brian Foster wrote:
> Support inode ID filtering in the eofblocks scan. The caller must
> set the associated XFS_EOF_FLAGS_*ID bit and ID field.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> ---
> 
> v7:
> - Separate padding into two fields to explicitly handle alignment requirements.
> - Fix up style of flags defines.
> 
>  fs/xfs/xfs_fs.h     |   14 ++++++++++++--
>  fs/xfs/xfs_icache.c |   22 ++++++++++++++++++++++
>  fs/xfs/xfs_ioctl.c  |    3 ++-
>  3 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index 26ff43a..7113564 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -345,13 +345,23 @@ typedef struct xfs_error_injection {
>  struct xfs_eofblocks {
>  	__u32		eof_version;
>  	__u32		eof_flags;
> -	__u64		pad[15];
> +	uid_t		eof_uid;
> +	gid_t		eof_gid;
> +	prid_t		eof_prid;
> +	__u32		pad32;
> +	__u64		pad64[13];
>  };

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
