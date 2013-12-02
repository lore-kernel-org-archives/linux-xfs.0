Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8855229E05
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 11:24:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 64C0C304051
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 09:24:42 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id jfe2Apkv2gBJuvIv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 09:24:41 -0800 (PST)
Date: Mon, 2 Dec 2013 09:24:41 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/15] mkfs: don't treat files as though they are block
	devices
Message-ID: <20131202172441.GF28630@infradead.org>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385689430-10103-16-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>  void
>  platform_flush_device(int fd, dev_t device)
>  {
> -	if (major(device) != RAMDISK_MAJOR)
> +	struct stat64	st;
> +	if (major(device) == RAMDISK_MAJOR)
> +		return;
> +
> +	if (fstat64(fd, &st) < 0)
> +		return;
> +
> +	if (S_ISREG(st.st_mode))
> +		fsync(fd);
> +	else
>  		ioctl(fd, BLKFLSBUF, 0);
>  }

Given that fsync does the right thing for device on Linux aswell
I'd suggest we make this function call it all the time and get rid
of all the ramdisk magic.

Should probabbly be a a separate patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
