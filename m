Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17494 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932339AbdJZQZW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 12:25:22 -0400
Date: Thu, 26 Oct 2017 09:25:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: Issue smaller discards at mkfs
Message-ID: <20171026162518.GW5483@magnolia>
References: <20171026144131.26885-1-keith.busch@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026144131.26885-1-keith.busch@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Keith Busch <keith.busch@intel.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 26, 2017 at 08:41:31AM -0600, Keith Busch wrote:
> Running mkfs.xfs was discarding the entire capacity in a single range. The
> block layer would split these into potentially many smaller requests
> and dispatch all of them to the device at roughly the same time.
> 
> SSD capacities are getting so large that full capacity discards will
> take some time to complete. When discards are deeply queued, the block
> layer may trigger timeout handling and IO failure, though the device is
> operating normally.
> 
> This patch uses smaller discard ranges in a loop for mkfs to avoid
> risking such timeouts. The max discard range is arbitrarilly set to
> 128GB in this patch.

I'd have thought devices would set sane blk_queue_max_discard_sectors
so that the block layer doesn't send such a huge command that the kernel
times out...

...but then I actually went and grepped that in the kernel and
discovered that nbd, zram, raid0, mtd, and nvme all pass in UINT_MAX,
which is 2T.  Frighteningly xen-blkfront passes in get_capacity() (which
overflows the unsigned int parameter on big virtual disks, I guess?).

(I still think this is the kernel's problem, not userspace's, but now
with an extra layer of OMGWTF sprayed on.)

I dunno.  What kind of device produces these timeouts, and does it go
away if max_discards is lowered?

--D

> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  include/linux.h | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux.h b/include/linux.h
> index 6ce344c5..702aee0c 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -132,10 +132,17 @@ static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
>  static __inline__ int
>  platform_discard_blocks(int fd, uint64_t start, uint64_t len)
>  {
> -	uint64_t range[2] = { start, len };
> +	uint64_t end = start + len;
> +	uint64_t size = 128ULL * 1024ULL * 1024ULL * 1024ULL;
>  
> -	if (ioctl(fd, BLKDISCARD, &range) < 0)
> -		return errno;
> +	for (; start < end; start += size) {
> +		uint64_t range[2] = { start, MIN(len, size) };
> +
> +		len -= range[1];
> +		if (ioctl(fd, BLKDISCARD, &range) < 0)
> +			return errno;
> +
> +	}
>  	return 0;
>  }
>  
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
