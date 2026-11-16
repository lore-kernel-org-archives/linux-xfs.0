Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819271;
	b=rESEGaHUJDu1wcjSPeSe+yvZbyweQhazyxeToWcGUhrdK1YCLCE/AI3xhaRSMWaoELLP
	 u5H5PSoqsmeot2gNU2xqvfvphHjMjS1ar+nzBC/m2CpWRbCITXb4c/Q0QBiAusJE6L7ZW
	 T3Cvp5vOVOmMoB9R1vJwydaknHJzbmPBViSpBMfeEVx4i/VpNxUY5nOshobcDOjYOYZqo
	 jKjkVYtgX3coD571paA1mwJBiw9DS8ara0H0G1ij3oIHdnGE5YAp3TLfG9M/sw17s4twc
	 I7jfC10gAtwnEqG05HN1Cy8vdsHFWuqAnCm01qGes0WPesM43zI3IORaQrA5lBBu38w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819271;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=d+mXw65c0SE6wEj5pgC38F7l7JItQ/bmLuVhHdw962U=;
	b=Ur9THSnam8iO11k1jVlvy5dMk8E7rZW17kt1xXZ3xY1HYc9rJSaAoLjdnk9uMu3ubkya
	 0CZm/Q3EX2ry8lhGsJkr9pN/TeuixxSxo7myNxXy8Vr7HRMy7mrspfdlAaYt+tvFgu8g7
	 JYZmr5TBO9sriTor29ILGVfl22nznFLhh+7GtGiiIVrBMGfk6Cey3rIJbCuUjiPO692i1
	 lQojZnb/L3dRLZVGa1dgZQU1k46oZ77A14dNsQKPrYEMg+JWTLWcd/6fOMz3wIv4I+Gdk
	 8J6EzX4tvw8dIeVarhjSTV/KHwoUJBWLPUNPYFzulqRVntRyJUN1eHrmEIrtVrRLXhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y7bTbmN2;
	arc=none smtp.remote-ip=95.215.58.137
Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6E2606A329
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 08:54:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F6E2606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y7bTbmN2
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0sRRqe1bUPwNHEpxIAAix2mTeq6VNF5XZiHC5lka8Wg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794819268; v=1; x=1795424068;
 b=Y7bTbmN2A08zQtkW2hNnPOk5NQkOX0MzA0AhNZ1T4Dcevf1eR7SWPPglS/gX/mL4vGJH2/rz
 eMIIsrohjJn9huQQ6RRYrVYI1qMoIzt3CQhLdiq7xi5LINBLp+vPqlEZrMyK1fLIm2a4KoFEENj
 LU53WIfbB/TiOcMpLfmyUy3w=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 053895ab281f066a;
	Mon, 16 Nov 2026 08:54:28 +0000
X-Mizu-Trace-ID: 053895ab281f066a
X-Migadu-Flow: FLOW_OUT
Message-ID: <260c0d7d-39cb-40ca-9a49-2ae8a3531676@linux.dev>
Date: Mon, 16 Nov 2026 08:54:27 +0000
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: do not let tr_atomic_ioend raise the minimum log
 size
To: linux-xfs@vger.kernel.org, Dave Chinner <dgc@kernel.org>
References: <20261113043055.2578595-1-hengyul@cs.unc.edu>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20261113043055.2578595-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 04:30, Hengyu Liang wrote:
> Commit b1e09178b73a ("xfs: commit CoW-based atomic writes atomically")
> added the tr_atomic_ioend reservation and made
> xfs_log_calc_trans_resv_for_minlogblocks() copy it from the running
> filesystem.
> 
> However, the copy has the current log count of tr_itruncate. On a
> filesystem with rmapbt and without reflink that count is 4, while the
> function puts the old count of 2 back for tr_itruncate itself. As of
> now, the minimum log size of such a filesystem is larger than the one
> its mkfs.xfs used, and the filesystem does not mount any more when its
> log has the old minimum size.
> 
> The issue can be reproduced with mkfs.xfs from xfsprogs 5.13:
> 
>      truncate -s 512M xfs.img
>      mkfs.xfs -m rmapbt=1,reflink=0 xfs.img
>      mount -o loop xfs.img /mnt
> 
> Before commit b1e09178b73a ("xfs: commit CoW-based atomic writes
> atomically"), the mount succeeds.
> 
> After that commit, it fails with EINVAL:
> 
>      XFS (loop0): Log size 878 blocks too small, minimum size is 962 blocks
>      XFS (loop0): AAIEEE! Log failed size checks. Abort!
> 
> This patch will use the old log count for the copy as well. These
> filesystems have no reflink, so they never use this reservation.
> 
> Fixes: b1e09178b73a ("xfs: commit CoW-based atomic writes atomically")
> Cc: stable@vger.kernel.org # v6.16
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
> ---
> mkfs.xfs 4.9 to 5.13 give such a log to an rmapbt=1,reflink=0
> filesystem below 1 GiB, or up to 16 GiB with -d su=256k,sw=4.
> 
> Application impact (Ubuntu 26.04 user space): udisks2 2.10.91 is asked
> to mount a filesystem made as above ("udisksctl mount -b /dev/vda"). On
> v6.15, it mounts it at /run/media/root/STICK513. On v6.16, it fails
> with "Error mounting /dev/vda ... wrong fs type, bad option, bad
> superblock".
> 
> Tested on xfs for-next with 45 images made by mkfs.xfs 4.9 to 6.6: 26
> do not mount without this patch, all mount with it, and the largest
> reservation is the same as on v6.15.
> 
>   fs/xfs/libxfs/xfs_log_rlimit.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> index 37712b2f8757..9454c91e9fb3 100644
> --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> @@ -128,6 +128,8 @@ xfs_log_calc_trans_resv_for_minlogblocks(
>   		resv->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
>   		resv->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
>   		resv->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
> +		/* tr_atomic_ioend starts as a copy of tr_itruncate. */
> +		resv->tr_atomic_ioend.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;

I have to admit that I am not really familiar with this log code. 
Darrick was, but unfortunately he is no involved. The change looks sane, 
even though we are partially overwriting resv->tr_atomic_ioend (from 
when it is set earlier in the same function). Dave Chinner may be able 
to kindly help review.

Thanks,
John
