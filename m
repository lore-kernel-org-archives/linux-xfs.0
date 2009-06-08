Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n587gBjW215489 for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 02:42:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FBE2148F40B
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2009 00:49:30 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nGXNFPeLsyvqCL8M for
	<xfs@oss.sgi.com>; Mon, 08 Jun 2009 00:49:30 -0700 (PDT)
Date: Mon, 8 Jun 2009 03:42:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_repair: catch bad depth in traverse_int_dir2block
Message-ID: <20090608074230.GA28066@infradead.org>
References: <4A2C8AD8.9030107@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A2C8AD8.9030107@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Richard Kolkovich <richard@intrameta.com>, xfs-oss <xfs@oss.sgi.com>

On Sun, Jun 07, 2009 at 10:51:52PM -0500, Eric Sandeen wrote:
> A bad on-disk tree depth in traverse_int_dir2block() can
> later cause a segfault when it's used as an array index in
> this function; if we get something beyond the max depth,
> just error out and the dir will get rebuilt.
> 
> Reported-by: Richard Kolkovich <richard@intrameta.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 9575fb1..2723e3b 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -339,9 +339,17 @@ traverse_int_dir2block(xfs_mount_t	*mp,
>  		/*
>  		 * maintain level counter
>  		 */
> -		if (i == -1)
> +		if (i == -1) {
>  			i = da_cursor->active = be16_to_cpu(node->hdr.level);
> -		else  {
> +			if (i >= XFS_DA_NODE_MAXDEPTH) {
> +				do_warn(_("bad header depth for directory "
> +					  "inode %llu\n"),
> +					da_cursor->ino);
> +				da_brelse(bp);
> +				i = -1;
> +				goto error_out;
> +			}
> +		} else {

>From reading the surrounding code this means the dir is now flagged
as corrupted and we attemp to rebuild it.  Which is the only thing we
can do here for now.


Reviewed-by: Christoph Hellwig <hch@lst.de>

It would be very good to have an xfsqa testcase with a forcibly
corrupted directoty (checked in image or using xfs_db) to verify this
behaviour.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
