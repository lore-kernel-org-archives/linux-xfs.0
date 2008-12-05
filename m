Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB5465L0032217 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 22:06:05 -0600
Message-ID: <4938A8C1.7030103@sgi.com>
Date: Fri, 05 Dec 2008 15:06:25 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] - set b_error from bio error in xfs_buf_bio_end_io
References: <4938A4C1.9010401@sandeen.net>
In-Reply-To: <4938A4C1.9010401@sandeen.net>
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Tim mentioned something about the code in xfs_buf_iodone_work()
> which detects barrier failures post-mount, as added in commit
> 0bfefc46dc028df60120acdb92062169c9328769,
> [XFS] Barriers need to be dynamically checked and switched off
> 
>         if ((bp->b_error == EOPNOTSUPP) &&
>             (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
>                 XB_TRACE(bp, "ordered_retry", bp->b_iodone);
>                 bp->b_flags &= ~XBF_ORDERED;
>                 bp->b_flags |= _XFS_BARRIER_FAILED;
> ...
> 
> but it seems that nothing ever sets EOPNOTSUPP on b_error, so
> this path would never be hit.
> 
> I think that we need to do something like below, totally untested,
> to ensure that bio errors get set on b_error, if we're looking
> for them by name, no?
> 
> (I'm not sure if we still need the BIO_UPTODATE test, or if
> we can just look at the error we're given and be done?)
> 
> Does this seem about right?
> 
> Thanks,
> -Eric
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1114,8 +1114,10 @@ xfs_buf_bio_end_io(
>  	unsigned int		blocksize = bp->b_target->bt_bsize;
>  	struct bio_vec		*bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
>  
> -	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
> -		bp->b_error = EIO;
> +	if (error)
> +		bp->b_error = XFS_ERROR(-error);
> +	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
> +		bp->b_error = XFS_ERROR(EIO);


I would suggest this:

@@ -1114,8 +1140,7 @@ xfs_buf_bio_end_io(
  	unsigned int		blocksize = bp->b_target->bt_bsize;
  	struct bio_vec		*bvec = bio->bi_io_vec + bio->bi_vcnt - 1;

-	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
-		bp->b_error = EIO;
+	xfs_buf_ioerror(bp, -error);

  	do {
  		struct page	*page = bvec->bv_page;

The BIO_UPTODATE checks have already been done before calling this function
and error has been set appropriately so we can just use it.

>  
>  	do {
>  		struct page	*page = bvec->bv_page;
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
