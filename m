Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB54F0R3000351 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 22:15:00 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4491616B160B
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 20:14:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id ORBSDPQeoyqWSEor for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2008 20:14:58 -0800 (PST)
Message-ID: <4938A995.6040609@sandeen.net>
Date: Thu, 04 Dec 2008 22:09:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] - set b_error from bio error in xfs_buf_bio_end_io
References: <4938A4C1.9010401@sandeen.net> <4938A8C1.7030103@sgi.com>
In-Reply-To: <4938A8C1.7030103@sgi.com>
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
To: lachlan@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:

> I would suggest this:
> 
> @@ -1114,8 +1140,7 @@ xfs_buf_bio_end_io(
>   	unsigned int		blocksize = bp->b_target->bt_bsize;
>   	struct bio_vec		*bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
> 
> -	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
> -		bp->b_error = EIO;
> +	xfs_buf_ioerror(bp, -error);

oh, sure.  I forgot we had the wrapper to set the error ... :)

> The BIO_UPTODATE checks have already been done before calling this function
> and error has been set appropriately so we can just use it.

ah so it is.   yeah, makes perfect sense.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
