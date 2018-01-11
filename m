Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34710 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750782AbeAKXZA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 18:25:00 -0500
Subject: Re: [PATCH 06/27] xfs_scrub: create an abstraction for a block device
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520352472.2027.8375038586822233334.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a4228240-76f6-5f43-cecf-5bd7d572bfcb@sandeen.net>
Date: Thu, 11 Jan 2018 17:24:58 -0600
MIME-Version: 1.0
In-Reply-To: <151520352472.2027.8375038586822233334.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/5/18 7:52 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>

...

> +/*
> + * Disk Abstraction
> + *
> + * These routines help us to discover the geometry of a block device,
> + * estimate the amount of concurrent IOs that we can send to it, and
> + * abstract the process of performing read verification of disk blocks.
> + */
> +
> +/* Figure out how many disk heads are available. */
> +static unsigned int
> +__disk_heads(
> +	struct disk		*disk)
> +{
> +	int			iomin;
> +	int			ioopt;
> +	unsigned short		rot;
> +	int			error;
> +
> +	/* If it's not a block device, throw all the CPUs at it. */
> +	if (!S_ISBLK(disk->d_sb.st_mode))
> +		return nproc;
> +
> +	/* Non-rotational device?  Throw all the CPUs. */
> +	rot = 1;
> +	error = ioctl(disk->d_fd, BLKROTATIONAL, &rot);
> +	if (error == 0 && rot == 0)
> +		return nproc;

I needed

+#ifndef BLKROTATIONAL
+#define BLKROTATIONAL _IO(0x12,126)
+#endif

to make this compile on my not /that/ ancient (?) rhel6 box ;)

-Eric
