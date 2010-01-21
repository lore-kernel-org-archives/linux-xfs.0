Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LLsbo7095302 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 15:54:37 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [help] project quota information incorrect over nfs ...
Date: Thu, 21 Jan 2010 15:55:26 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A69B3@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100121111720.GA20641@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>, "Guk-Bong, Kwon" <gbkwon@gmail.com>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Thu, Jan 21, 2010 at 01:12:06PM +0900, Guk-Bong, Kwon wrote:
>> nfs client "nfs_server:/test/111" Size is correct..(100M)
>> 
>> but nfs client "nfs_server:/test/111" Avail is incorrect.. (500M)
>> 
>> "Avail" is big than "Size" ...
>> 
>> this stat is normal??
> 
> No, it's not.  The patch below should fix it, but I'm not sure how
> easily backportable it is to 2.6.27:

I'm going to take this as a [PATCH] and say it looks good to me.
It will probably not be difficult for someone to port it back
to 2.6.27.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: linux-2.6/fs/xfs/quota/xfs_qm_bhv.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/quota/xfs_qm_bhv.c	2010-01-21 12:13:51.397003969 +0100
> +++ linux-2.6/fs/xfs/quota/xfs_qm_bhv.c	2010-01-21 12:14:14.290009571 +0100
> @@ -59,7 +59,7 @@ xfs_fill_statvfs_from_dquot(
>  		be64_to_cpu(dp->d_blk_hardlimit);
>  	if (limit && statp->f_blocks > limit) {
>  		statp->f_blocks = limit;
> -		statp->f_bfree =
> +		statp->f_bfree = statp->f_bavail =
>  			(statp->f_blocks > be64_to_cpu(dp->d_bcount)) ?
>  			 (statp->f_blocks - be64_to_cpu(dp->d_bcount)) : 0;
>  	}
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
