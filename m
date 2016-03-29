Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C4D777CA1
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 02:26:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 827A9304032
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 00:26:27 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Hzoz92WBKMGXdye7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 00:26:24 -0700 (PDT)
Date: Tue, 29 Mar 2016 00:26:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] block: move bvec iterator into
	include/linux/bvec_iter.h
Message-ID: <20160329072617.GB18920@infradead.org>
References: <1458627149-12988-1-git-send-email-ming.lei@canonical.com>
	<1458627149-12988-2-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458627149-12988-2-git-send-email-ming.lei@canonical.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -31,6 +31,7 @@
>  
>  /* struct bio, bio_vec and BIO_* flags are defined in blk_types.h */
>  #include <linux/blk_types.h>
> +#include <linux/bvec_iter.h>
>  
>  #define BIO_DEBUG
>  
> @@ -40,10 +41,6 @@
>  #define BIO_BUG_ON
>  #endif
>  
> -#define BIO_MAX_PAGES		256
> -#define BIO_MAX_SIZE		(BIO_MAX_PAGES << PAGE_CACHE_SHIFT)
> -#define BIO_MAX_SECTORS		(BIO_MAX_SIZE >> 9)

I see no reason why these should be moved out of bio.h.

Otherwise this looks fine to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
