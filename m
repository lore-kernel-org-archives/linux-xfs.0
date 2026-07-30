Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658F32AEE4;
	Thu, 30 Jul 2026 00:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785369987; cv=none; b=hX8IX7i84x/6MR/I3XxC9V3Z6EWou4VlvOK9JL3t3xV1i5Rk1icWUPqMQW9fWxnMg2Nn19VF3ok+nN5te2uOkuf8qHvuw4I5EZMbSrWT+qyk42RTSgyLvfixCQNugtFW8Mw7929fVBP2KHMHoN5XrYpWVBhdJr7f97UsEE8ygpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785369987; c=relaxed/simple;
	bh=KLwQ1kjaHmes2sFPTpQIBZXLhixZGDYEtcyoJtRKVF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlDxgjs1JgYvqwrsbVxLEVqijv3VyUUmTlEL9TEdgueQYwQiX/UrBiHFGS9fh1/Zwgs9OYj6IerKIidlyn4y+ujOcpnIVVeEDCk44xEBcBqLHugsMTnHEGKdcoLINfWrcc/7xTJ8enSi4/BkHQFxy3kYwjiK0bmwYyC1QehX0X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IqDmq1pt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IqDmq1pt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EA31F000E9;
	Thu, 30 Jul 2026 00:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785369986;
	bh=w3BZrBAq84yWXMxfiN4Xeh/q7nUknhZiTY34sLZBwew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IqDmq1pth6/q81XHAupYVqVJH60Pzmopp/iGqQQmoCiMgdDfmlNtwrdjZzfu1/Z2H
	 lhf2Isd8vgU6yfNfzLK2NqhpWAvkCfoP5cDuXJglWTD5rpHhPI1ewjqwYOVM19yj/8
	 Wl5M04DfTs57jDtf7Sywr+dLpzqdCIrPNxB3wS9codpEuvM0VkE/xGhs8kyg0jhNng
	 PyQYrf3wv0v5qicPQr2wJq0PNf8sqm/af6t8m4qOKUGp/hl8NhjJB15LN0MHQ6xAA8
	 IvGsS0rZk6zTSM1lPWspoutuBMWCxRyECHCDOvfM1nH2Nvnbs2jWis3QYvP49Ks/18
	 f1gvRVe8c8oyw==
Date: Thu, 30 Jul 2026 10:06:06 +1000
From: Dave Chinner <dgc@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kyle Zeng <kylebot@openai.com>,
	Xiang Mei <xmei5@asu.edu>, Brian Foster <bfoster@redhat.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: bound inode buffer log item replay by logged regions
Message-ID: <amqVbjzaEKPZQnLm@dread>
References: <20260729193127.3084301-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729193127.3084301-1-bestswngs@gmail.com>

On Wed, Jul 29, 2026 at 12:31:27PM -0700, Weiming Shi wrote:
> xlog_recover_do_inode_buffer() advances item_index once for every run of
> set bits in the logged dirty bitmap, but ri_buf[] is populated only for
> the regions present in the recovered log item.  A crafted inode buffer
> log item can therefore make the dirty bitmap describe more runs than the
> item has logged regions, and recovery reads past the end of ri_buf[]
> before dereferencing the bogus iov_base pointer.
> 
> The ASSERT() that checks iov_base compiles away without CONFIG_XFS_DEBUG,
> and evaluating it would already perform the out-of-bounds ri_buf[] read.
> Check item_index against ri_cnt before the first ri_buf[item_index]
> access instead, and fail recovery with -EFSCORRUPTED.
> 
> Found with KASAN on a CONFIG_XFS_DEBUG=n build by mounting a crafted XFS
> image whose log contains an inode buffer item with more dirty bitmap runs
> than logged regions:
> 
>  BUG: KASAN: slab-out-of-bounds in xlog_recover_do_inode_buffer (fs/xfs/xfs_buf_item_recover.c:701)
>  Read of size 8 at addr ffff88801387d160 by task mount
>  The buggy address is located 0 bytes to the right of
>   allocated 32-byte region [ffff88801387d140, ffff88801387d160)
>   xlog_recover_do_inode_buffer (fs/xfs/xfs_buf_item_recover.c:701)
>   xlog_recover_buf_commit_pass2 (fs/xfs/xfs_buf_item_recover.c:1130)
>   ...
>  Oops: general protection fault, probably for non-canonical address
>  RIP: 0010:xlog_recover_do_inode_buffer (fs/xfs/xfs_buf_item_recover.c:703)
> 
> After this change the crafted image fails recovery with -EFSCORRUPTED and
> the mount is refused.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Kyle Zeng <kylebot@openai.com>
> Link: https://lore.kernel.org/linux-xfs/20260611212314.4610-1-kylebot@openai.com/
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Link: https://lore.kernel.org/linux-xfs/ajGB9o5Ys6itU3Rh@bfoster/
> Cc: stable@vger.kernel.org
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>  fs/xfs/xfs_buf_item_recover.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 02b95b89d1b5..2c2d4a0027af 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -659,6 +659,13 @@ xlog_recover_do_inode_buffer(
>  			reg_buf_offset = bit << XFS_BLF_SHIFT;
>  			reg_buf_bytes = nbits << XFS_BLF_SHIFT;
>  			item_index++;
> +
> +			if (XFS_IS_CORRUPT(mp, item_index >= item->ri_cnt)) {
> +				xfs_alert(mp,
> +	"Bad inode buffer log item dirty bitmap: more dirty regions than the %d logged, for buffer at daddr 0x%llx.",
> +					item->ri_cnt - 1, xfs_buf_daddr(bp));
> +				return -EFSCORRUPTED;
> +			}
>  		}

Why are you trying to validate this here instead of via generic log
item validation infrastructure? I thought I already asked for this
sort of thing to be lifted to the initial pass of the log items in
the generic recovery code via per-item type validation methods
instead of being randomly distributed through the recovery code.

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
