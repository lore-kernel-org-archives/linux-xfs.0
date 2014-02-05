Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 253317F58
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 17:09:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BEB9AAC002
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 15:09:45 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	SBBKgvNq10y2KtWz for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 15:09:40 -0800 (PST)
Date: Thu, 6 Feb 2014 10:09:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] btrfs: add small program for clone testing
Message-ID: <20140205230936.GI13997@dastard>
References: <1391599009-2402-1-git-send-email-ddiss@suse.de>
	<1391599009-2402-2-git-send-email-ddiss@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391599009-2402-2-git-send-email-ddiss@suse.de>
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
To: David Disseldorp <ddiss@suse.de>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Feb 05, 2014 at 12:16:48PM +0100, David Disseldorp wrote:
> The cloner program is capable of cloning files using the BTRFS_IOC_CLONE
> and BTRFS_IOC_CLONE_RANGE ioctls.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>

Hi Dave - long time since I've seen your head pop up around here ;)

A few comments below.

> +struct btrfs_ioctl_clone_range_args {
> +	int64_t src_fd;
> +	uint64_t src_offset;
> +	uint64_t src_length;
> +	uint64_t dest_offset;
> +};
> +
> +#define BTRFS_IOCTL_MAGIC 0x94
> +#define BTRFS_IOC_CLONE       _IOW(BTRFS_IOCTL_MAGIC, 9, int)
> +#define BTRFS_IOC_CLONE_RANGE _IOW(BTRFS_IOCTL_MAGIC, 13, \
> +				   struct btrfs_ioctl_clone_range_args)

Is there some published header file that these belong to? i.e.
somewhere in the include/linux/uapi/ kernel directory? Normally the
way to handle this sort of thing is by autoconf - if the header file
exists, then we include it, otherwise we use the manual definitions.
This just means that if the public api ever changes, we'll pick it
up automatically in future...

> +int
> +main(int argc, char **argv)
> +{
> +	bool full_file = true;
> +	uint64_t src_off = 0;
> +	uint64_t dst_off = 0;
> +	uint64_t len = 0;
> +	char *src_file;
> +	int src_fd;
> +	char *dst_file;
> +	int dst_fd;
> +	int ret;
> +	int opt;
> +
> +	while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
> +		switch (opt) {
> +		case 's':
> +			src_off = atoi(optarg);

atoi() only returns 32 bit numbers. You probably should use
strtoull() as the offset parameters are 64 bit.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
