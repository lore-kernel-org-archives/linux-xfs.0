Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7KWSqD177740 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 14:32:29 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	YQnYlkqm0PALZXI8 for <xfs@oss.sgi.com>;
	Wed, 07 Nov 2012 12:34:25 -0800 (PST)
Date: Thu, 8 Nov 2012 07:33:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 09/10] xfs: add minimum file size filtering to
	eofblocks scan
Message-ID: <20121107203357.GG6434@dastard>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
	<1352308874-64562-1-git-send-email-bfoster@redhat.com>
	<1352308874-64562-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352308874-64562-3-git-send-email-bfoster@redhat.com>
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

On Wed, Nov 07, 2012 at 12:21:14PM -0500, Brian Foster wrote:
> Support minimum file size filtering in the eofblocks scan. The
> caller must set the XFS_EOF_FLAGS_MINFILESIZE flags bit and minimum
> file size value in bytes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> ---
> 
> v7:
> - Add eof_min_file_size such that it is aligned.
> - Updated flags style.
> 
>  fs/xfs/xfs_fs.h     |    7 +++++--
>  fs/xfs/xfs_icache.c |   11 +++++++++--
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index 7113564..8455c9c 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -349,7 +349,8 @@ struct xfs_eofblocks {
>  	gid_t		eof_gid;
>  	prid_t		eof_prid;
>  	__u32		pad32;
> -	__u64		pad64[13];
> +	__u64		eof_min_file_size;
> +	__u64		pad64[12];
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
