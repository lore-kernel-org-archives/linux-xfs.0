Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4BE6f6R029517
	for <linux-xfs@oss.sgi.com>; Fri, 11 May 2012 09:06:41 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NKkVit3FgLIaR4Wu for
	<linux-xfs@oss.sgi.com>; Fri, 11 May 2012 07:06:40 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] bio allocation failure due to bio_get_nr_vecs()
References: <jognqm$o21$1@dough.gmane.org>
	<4FABF01E.7080303@itwm.fraunhofer.de>
	<4FAD18D4.3090102@itwm.fraunhofer.de>
Date: Fri, 11 May 2012 10:06:30 -0400
In-Reply-To: <4FAD18D4.3090102@itwm.fraunhofer.de> (Bernd Schubert's message
	of "Fri, 11 May 2012 15:49:08 +0200")
Message-ID: <x49sjf6vml5.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Jens Axboe <axboe@kernel.dk>, sandeen@sandeen.net, linux-xfs@oss.sgi.com, Tejun Heo <tj@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>

Bernd Schubert <bernd.schubert@itwm.fraunhofer.de> writes:

> diff --git a/fs/bio.c b/fs/bio.c
> index e453924..84da885 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -505,9 +505,14 @@ EXPORT_SYMBOL(bio_clone);
>  int bio_get_nr_vecs(struct block_device *bdev)
>  {
>  	struct request_queue *q = bdev_get_queue(bdev);
> -	return min_t(unsigned,
> +	int nr_pages;

Looks like a corrupt patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
