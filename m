Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9E1287CB0
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 12:19:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E12DAC001
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 10:19:41 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id zWEphgXttGzA0wfm (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2016 10:19:38 -0700 (PDT)
Date: Wed, 30 Mar 2016 10:19:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 2/8] block: make 'struct bvec_iter' not depend on
	CONFIG_BLOCK
Message-ID: <20160330171927.GA13320@infradead.org>
References: <1459354637-17415-1-git-send-email-ming.lei@canonical.com>
	<1459354637-17415-3-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459354637-17415-3-git-send-email-ming.lei@canonical.com>
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
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Jens Axboe <axboe@fb.com>, Boaz Harrosh <boaz@plexistor.com>, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

On Thu, Mar 31, 2016 at 12:17:11AM +0800, Ming Lei wrote:
> We will use bvec iterator to implement iterate_bvec(): lib/iov_iter.c.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  include/linux/blk_types.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 86a38ea..fd8527b 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -26,8 +26,6 @@ struct bio_vec {
>  	unsigned int	bv_offset;
>  };
>  
> -#ifdef CONFIG_BLOCK
> -
>  struct bvec_iter {
>  	sector_t		bi_sector;	/* device address in 512 byte
>  						   sectors */
> @@ -39,6 +37,8 @@ struct bvec_iter {
>  						   current bvec */
>  };

I didn't catch this earlier, but shouldn't this also move to
bvec_iter.h? Or maybe just create a linux/bvec.h for the bvec, bvec_iter
and bvec iter macros given that those are the types used outside the
block layer as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
