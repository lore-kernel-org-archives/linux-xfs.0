Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB6CF7F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 19:43:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9F4D304070
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 17:43:43 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bPkoALCrgHVqdiEp for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 17:43:42 -0800 (PST)
Message-ID: <530FE9CD.4000701@sandeen.net>
Date: Thu, 27 Feb 2014 19:43:41 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] metadump: don't verify metadata being dumped
References: <1393548825-16499-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1393548825-16499-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 2/27/14, 6:53 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The discontiguous buffer support series added a verifier check on
> the metadata buffers before they go written to the metadump image.
> If this failed, it returned an error, and the restul woul dbe that
> we stopped processing the metadata and exited, resulting in a
> truncated dump.
> 
> xfs_metadump is supposed to dump the metadata in the filesystem
> for forensic analysis purposes, which means we actually want it to
> retain any corruptions it finds in the filesystem. Hence running the
> verifier - even to recalculate CRCs - is the wrong thing to be
> doing. And stopping the dum pwhen we come across an error is even
> worse.
> 
> Therefore remove the code tha truns the verifier and causes all
> these problems and replace it with a comment explaining why we don't
> want to run verifiers in the metadump process.

This leaves the net functional change from 
8ab75c db: enable metadump on CRC filesystems
as:

@@ -1727,6 +1743,9 @@ copy_inode_chunk(
 
                if (!process_inode(agno, agino + i, dip))
                        goto pop_out;
+
+               /* calculate the new CRC for the inode */
+               xfs_dinode_calc_crc(mp, dip);
        }
 skip_processing:
        if (!write_buf(iocur_top))

which seems a) minimal, but also b) like we shouldn't be recalculating
CRCs if the point is to copy out existing fs state...?

OTOH if we're obfuscating, we would HAVE to recalculate CRCs,
but then would lose the info that the CRC was bad before.

So probably should skip CRC recalculating if the original CRC
was bad, in the obfuscating case?

Maybe this patch stands ok on its own but it seems like there's
more work to do.  :)

-Eric

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  db/metadump.c | 23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 5baf83d..c10e76a 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -190,6 +190,13 @@ write_buf_segment(
>  	return 0;
>  }
>  
> +/*
> + * we want to preserve the state of the metadata in the dump - whether it is
> + * intact or corrupt, so even if the buffer has a verifier attached to it we
> + * don't want to run it prior to writing the buffer to the metadump image.
> + * Even just recalculating the CRCs is the wrong thing to do here as it can
> + * hide errors that only the CRCs were detecting.
> + */
>  static int
>  write_buf(
>  	iocur_t		*buf)
> @@ -197,22 +204,6 @@ write_buf(
>  	int		i;
>  	int		ret;
>  
> -	/*
> -	 * Run the write verifier to recalculate the buffer CRCs and check
> -	 * we are writing something valid to disk
> -	 */
> -	if (buf->bp && buf->bp->b_ops) {
> -		buf->bp->b_error = 0;
> -		buf->bp->b_ops->verify_write(buf->bp);
> -		if (buf->bp->b_error) {
> -			fprintf(stderr,
> -	_("%s: write verifer failed on bno 0x%llx/0x%x\n"),
> -				__func__, (long long)buf->bp->b_bn,
> -				buf->bp->b_bcount);
> -			return -buf->bp->b_error;
> -		}
> -	}
> -
>  	/* handle discontiguous buffers */
>  	if (!buf->bbmap) {
>  		ret = write_buf_segment(buf->data, buf->bb, buf->blen);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
