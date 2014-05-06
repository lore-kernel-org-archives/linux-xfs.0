Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 651467FBD
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 02:56:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE4C8AC007
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 00:56:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 79Fps9xH1GdAON2J (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 00:56:37 -0700 (PDT)
Date: Tue, 6 May 2014 00:56:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix directory readahead offset off-by-one
Message-ID: <20140506075637.GA13191@infradead.org>
References: <1399347728-19752-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399347728-19752-1-git-send-email-david@fromorbit.com>
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

On Tue, May 06, 2014 at 01:42:08PM +1000, Dave Chinner wrote:
> Fix the warning by ensuring that the readahead offset is correctly
> incremented.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_dir2_readdir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 50b72f7..fe2db98 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -456,7 +456,7 @@ xfs_dir2_leaf_readbuf(
>  		/*
>  		 * Advance offset through the mapping table.
>  		 */
> -		for (j = 0; j < mp->m_dirblkfsbs; j++) {
> +		for (j = 0; j < mp->m_dirblkfsbs; ) {
>  			/*
>  			 * The rest of this extent but not more than a dir
>  			 * block.

This looks correct, but it would seem a little more idiomatic to write
this as:

		for (j = 0; j < mp->m_dirblkfsbs; j += length) {

and remove the j increment from the body.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
