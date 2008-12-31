Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBV40ups029385 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 22:00:56 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EA961799B65
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 20:00:51 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id heG5Fli0a4f1Odrn for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 20:00:51 -0800 (PST)
Message-ID: <495AEE51.9030805@sandeen.net>
Date: Tue, 30 Dec 2008 22:00:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] xfstests: test 197,
	add a testcase for d_off truncation
References: <20081230230810.986105000@bombadil.infradead.org>
	<20081230230913.619447000@bombadil.infradead.org>
In-Reply-To: <20081230230913.619447000@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

> Make sure our directory offsets fit into a 32 bit value.
> Based on a report by John Stanley.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

...

> +struct linux_dirent64 {
> +	uint64_t	d_ino;
> +	int64_t		d_off;
> +	unsigned short	d_reclen;
> +	unsigned char	d_type;
> +        char		d_name[0];
> +};

...

> +		for (bpos = 0; bpos < nread;) {
> +			d = (struct linux_dirent64 *) (buf + bpos);
> +			/*
> +			 * Can't use off_t here xfsqa is compiled with
> +			 * -D_FILE_OFFSET_BITS=64
> +			 */
> +			if (d->d_off != (long)d->d_off) {

So can this test only fail on a 32-bit arch?  I haven't paid enough
attention to the original bug... sorry if that's a dumb question.  :)

-Eric

> +	                        fprintf(stderr, "detected d_off truncation "
> +						"d_name = %s, d_off = %lld\n",
> +						d->d_name, (long long)d->d_off);
> +        	                exit(EXIT_FAILURE);
> +                	}
> +			bpos += d->d_reclen;
> +		}
> +	}
> +
> +	exit(EXIT_SUCCESS);
> +}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
