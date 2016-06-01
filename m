Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 13BBD7CA6
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 08:48:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC745304051
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 06:48:23 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id mGDC2igmpFcENkHz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 06:48:19 -0700 (PDT)
Date: Wed, 1 Jun 2016 06:48:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 5/8] fs: xfs: replace BIO_MAX_SECTORS with BIO_MAX_PAGES
Message-ID: <20160601134816.GA20963@infradead.org>
References: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
	<1464615294-9946-6-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1464615294-9946-6-git-send-email-ming.lei@canonical.com>
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
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>, Jens Axboe <axboe@fb.com>

On Mon, May 30, 2016 at 09:34:33PM +0800, Ming Lei wrote:
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e71cfbd..e5d713b 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1157,9 +1157,7 @@ xfs_buf_ioapply_map(
>  
>  next_chunk:
>  	atomic_inc(&bp->b_io_remaining);
> -	nr_pages = BIO_MAX_SECTORS >> (PAGE_SHIFT - BBSHIFT);
> -	if (nr_pages > total_nr_pages)
> -		nr_pages = total_nr_pages;
> +	nr_pages = min(total_nr_pages, BIO_MAX_PAGES);
>  
>  	bio = bio_alloc(GFP_NOIO, nr_pages);

While I think this is a useful cleanup on it's own I think
you'd make everyones life easier if bio_alloc simply clamped down
the passed nr_pages value to the maximum allowed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
