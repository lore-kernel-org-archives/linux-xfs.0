Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6MO5Ux094368 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 16:24:05 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QhqpP0Cr01hTeCfb for <xfs@oss.sgi.com>;
	Tue, 06 Nov 2012 14:26:00 -0800 (PST)
Date: Wed, 7 Nov 2012 09:25:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 09/10] xfs: add minimum file size filtering to
	eofblocks scan
Message-ID: <20121106222559.GI24575@dastard>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
	<1352213447-59791-10-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352213447-59791-10-git-send-email-bfoster@redhat.com>
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

On Tue, Nov 06, 2012 at 09:50:46AM -0500, Brian Foster wrote:
> Support minimum file size filtering in the eofblocks scan. The
> caller must set the XFS_EOF_FLAGS_MINFILESIZE flags bit and minimum
> file size value in bytes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_fs.h     |    6 ++++--
>  fs/xfs/xfs_icache.c |   11 +++++++++--
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index 88eb1bc..082b743 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -348,7 +348,8 @@ struct xfs_eofblocks {
>  	uid_t		eof_uid;
>  	gid_t		eof_gid;
>  	prid_t		eof_prid;
> -	__u32		pad[27];
> +	__u64           eof_min_file_size;
> +	__u32		pad[25];

And that's an exact example of why you should pad out to 8 byte
boundaries like I suggested earlier ;)

What this ends up with is:

	prid		eof_prid;
	<implicit, arch dependent 4 byte hole>
	__u64		eof_min_file_size;
	__32		pad[25];

What you should have is something like:

	prid		eof_prid;
	__u32		pad32;
	__u64		eof_min_file_size;
	__u64		pad64[12];

You should check the way the compiler sees the user visible
structures with pahole - it shows up problems like this in an
obvious manner ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
