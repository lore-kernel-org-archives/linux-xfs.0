Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 114EE7CA0
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2016 11:04:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7DB04AC001
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2016 09:04:26 -0700 (PDT)
Received: from mail-pf0-f196.google.com (mail-pf0-f196.google.com
	[209.85.192.196]) by cuda.sgi.com with ESMTP id
	CLwIaiaX8OJTQuof (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Apr 2016 09:04:23 -0700 (PDT)
Received: by mail-pf0-f196.google.com with SMTP id r187so17512717pfr.2
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2016 09:04:23 -0700 (PDT)
Date: Tue, 19 Apr 2016 01:04:15 +0900 (JST)
Message-Id: <20160419.010415.105960685033839882.konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH 16/42] nilfs: set bi_op to REQ_OP
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1460747777-8479-17-git-send-email-mchristi@redhat.com>
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
	<1460747777-8479-17-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
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
To: Mike Christie <mchristi@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

On Fri, 15 Apr 2016 14:15:51 -0500, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> This patch has nilfs use bio->bi_op for REQ_OPs and rq_flag_bits
> to bio->bi_rw.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> ---
>  fs/nilfs2/segbuf.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)

Looks good to me.

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Thanks,
Ryuske Konishi

> 
> diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
> index 7666f1d..7b13e14 100644
> --- a/fs/nilfs2/segbuf.c
> +++ b/fs/nilfs2/segbuf.c
> @@ -350,7 +350,8 @@ static void nilfs_end_bio_write(struct bio *bio)
>  }
>  
>  static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
> -				   struct nilfs_write_info *wi, int mode)
> +				   struct nilfs_write_info *wi, int mode,
> +				   int mode_flags)
>  {
>  	struct bio *bio = wi->bio;
>  	int err;
> @@ -368,7 +369,8 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
>  
>  	bio->bi_end_io = nilfs_end_bio_write;
>  	bio->bi_private = segbuf;
> -	bio->bi_rw = mode;
> +	bio->bi_op = mode;
> +	bio->bi_rw = mode_flags;
>  	submit_bio(bio);
>  	segbuf->sb_nbio++;
>  
> @@ -442,7 +444,7 @@ static int nilfs_segbuf_submit_bh(struct nilfs_segment_buffer *segbuf,
>  		return 0;
>  	}
>  	/* bio is FULL */
> -	err = nilfs_segbuf_submit_bio(segbuf, wi, mode);
> +	err = nilfs_segbuf_submit_bio(segbuf, wi, mode, 0);
>  	/* never submit current bh */
>  	if (likely(!err))
>  		goto repeat;
> @@ -466,19 +468,19 @@ static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
>  {
>  	struct nilfs_write_info wi;
>  	struct buffer_head *bh;
> -	int res = 0, rw = WRITE;
> +	int res = 0;
>  
>  	wi.nilfs = nilfs;
>  	nilfs_segbuf_prepare_write(segbuf, &wi);
>  
>  	list_for_each_entry(bh, &segbuf->sb_segsum_buffers, b_assoc_buffers) {
> -		res = nilfs_segbuf_submit_bh(segbuf, &wi, bh, rw);
> +		res = nilfs_segbuf_submit_bh(segbuf, &wi, bh, REQ_OP_WRITE);
>  		if (unlikely(res))
>  			goto failed_bio;
>  	}
>  
>  	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
> -		res = nilfs_segbuf_submit_bh(segbuf, &wi, bh, rw);
> +		res = nilfs_segbuf_submit_bh(segbuf, &wi, bh, REQ_OP_WRITE);
>  		if (unlikely(res))
>  			goto failed_bio;
>  	}
> @@ -488,8 +490,8 @@ static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
>  		 * Last BIO is always sent through the following
>  		 * submission.
>  		 */
> -		rw |= REQ_SYNC;
> -		res = nilfs_segbuf_submit_bio(segbuf, &wi, rw);
> +		res = nilfs_segbuf_submit_bio(segbuf, &wi, REQ_OP_WRITE,
> +					      REQ_SYNC);
>  	}
>  
>   failed_bio:
> -- 
> 2.7.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
