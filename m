Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 16CA77F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 13:12:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B7F13AC002
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 11:12:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nFGBa0XyZb03WZax (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 11:12:05 -0800 (PST)
Date: Mon, 4 Jan 2016 14:12:04 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/9] xfs_mdrestore: correctly account bytes read
Message-ID: <20160104191204.GC19852@bfoster.bfoster>
References: <1450733829-9319-1-git-send-email-david@fromorbit.com>
	<1450733829-9319-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1450733829-9319-4-git-send-email-david@fromorbit.com>
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

On Tue, Dec 22, 2015 at 08:37:03AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Progess indication comes in the form of a "X MB read" output. This
> doesn't match up with the actual number of bytes read from the
> metadump file because it only accounts header blocks in the file,
> not actual metadata blocks that are restored, Hence the number
> reported is usually much lower than the size of the metadump file,
> hence it's impossible to use to guage progress of the restore.

				  gauge

Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> While there, fix the progress output so that it overwrites the
> previous progress output line correctly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  mdrestore/xfs_mdrestore.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index ebc5e54..70a160c 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -133,7 +133,7 @@ perform_restore(
>  
>  	for (;;) {
>  		if (show_progress && (bytes_read & ((1 << 20) - 1)) == 0)
> -			print_progress("%lld MB read\n", bytes_read >> 20);
> +			print_progress("%lld MB read", bytes_read >> 20);
>  
>  		for (cur_index = 0; cur_index < mb_count; cur_index++) {
>  			if (pwrite64(dst_fd, &block_buffer[cur_index <<
> @@ -160,7 +160,7 @@ perform_restore(
>  								1, src_f) != 1)
>  			fatal("error reading from file: %s\n", strerror(errno));
>  
> -		bytes_read += block_size;
> +		bytes_read += block_size + (mb_count << tmb.mb_blocklog);
>  	}
>  
>  	if (progress_since_warning)
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
