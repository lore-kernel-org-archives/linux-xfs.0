Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8132E3EFFB8;
	Fri, 15 May 2026 16:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861888; cv=none; b=ATZkXIynC4yzS4fH0b4OMzjHIQ8GsEj1KCVkdopGloWbP73WV/voVn4SRjoYiBazCAtwFBiFcK4eCZ+lC3ZPr2VBowGENRXGhpMRchrRI2/p9G6bfbheARdAmAvBAm5O5Y0nu8tMNVvy+TuUVBBvD4PnGVAxmnW1Qom29fkOpk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861888; c=relaxed/simple;
	bh=w59zBbstMl6Tk3zg+4TmT/x6E5g1Zhr0wsvNMkfsehE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=exhgdlnrZwRrlOLUQTXXPeLSDU1LHvcMKAapd2tueNQd7vORLw8HwzCMQNZDC+MEITz+ZaChQ1jc1bNjzrzWjn/+uj+u7xfvFKOOxgDikxUrGDq3UCPBNQQfBR6u1bDax2Cp6wTKXilzl4KHzL7gsDgC7L1YrjlcQhH11fT5w0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IBpuFKkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBpuFKkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288D6C2BCB0;
	Fri, 15 May 2026 16:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778861888;
	bh=w59zBbstMl6Tk3zg+4TmT/x6E5g1Zhr0wsvNMkfsehE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IBpuFKkxU4QoGh/G3KBZgdE6AsaGGn96X6gM1RJKlsZ1bFVW6lYp5skmd+JPetL8P
	 pKfqsTadEy57mDeQcmIU4KzMhY1POAsDgXYrB6T5ZdDx91yhVLYK7QvQYa4Ok0fRPE
	 q3QTR5MM+PY+cD+kfT2pbH++uoGMED05nNpcDjpXEfE60BITzo7xE3OCPCZwR+pAl8
	 fjBcsh8S44v6PtJM2EBAXoPOU2AAOiIhZ6t7gwcon1AUJfX4y+l74LqKVYNiuRFaNa
	 Hacenk1cwEOyDGwmdMhtidwjsB4cd9AdILFmJ5Mbc21jYQuGFRJ3LESrqFg7tSATgM
	 FWb7QMc6LaGPQ==
Date: Sat, 16 May 2026 00:18:00 +0800
From: Zorro Lang <zlang@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: djwong@kernel.org, fstests@vger.kernel.org, 
	xfs-list <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] xfs/21{6,7} Use default -l concurrency=0 on
 mkfs.xfs that supports it
Message-ID: <agdHA0DP8-Yrg1xy@zlang-mailbox>
Mail-Followup-To: Lukas Herbolt <lukas@herbolt.com>, djwong@kernel.org, 
	fstests@vger.kernel.org, xfs-list <linux-xfs@vger.kernel.org>
References: <20260514113910.866888-2-lukas@herbolt.com>
 <20260514113910.866888-10-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514113910.866888-10-lukas@herbolt.com>

On Thu, May 14, 2026 at 01:39:15PM +0200, Lukas Herbolt wrote:
> The XFS concurrency optimization breaks the log sizing check on
> systems with non-rotational disks and high amount of CPUs. Default to
> the old behavior with -l concurrency=0 and with -d concurrency=0.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  changes v2:
> 	use default mkfs.xfs for scratch device
> 	remove the double check -l/-d as those were introduced together

This patch is good to me, thanks for fixing.

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/xfs/216 | 6 +++++-
>  tests/xfs/217 | 7 ++++++-
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/216 b/tests/xfs/216
> index 091c11d08642..0148e7f4de3e 100755
> --- a/tests/xfs/216
> +++ b/tests/xfs/216
> @@ -22,13 +22,17 @@ _cleanup()
>  
>  _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1
> +if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> +	loop_mkfs_opts="-l concurrency=0"
> +else
> +	loop_mkfs_opts=""
> +fi
>  _scratch_mount
>  
>  _require_loop
>  LOOP_IMG=$SCRATCH_MNT/test_fs
>  LOOP_MNT=$SCRATCH_MNT/test_fs_dir
>  
> -loop_mkfs_opts=
>  $MKFS_XFS_PROG 2>&1 | grep -q rmapbt && \
>  	loop_mkfs_opts="$loop_mkfs_opts -m rmapbt=0"
>  $MKFS_XFS_PROG 2>&1 | grep -q reflink && \
> diff --git a/tests/xfs/217 b/tests/xfs/217
> index dae6ce55f475..23aae842d1fb 100755
> --- a/tests/xfs/217
> +++ b/tests/xfs/217
> @@ -21,6 +21,11 @@ _cleanup()
>  
>  _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1
> +if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> +	loop_mkfs_opts="-l concurrency=0 -d concurrency=0"
> +else
> +	loop_mkfs_opts=""
> +fi
>  _scratch_mount
>  # 16T mkfs requires a bit over 2G free
>  _require_fs_space $SCRATCH_MNT 2202000
> @@ -34,7 +39,7 @@ _do_mkfs()
>  	for i in $*; do
>  		echo -n "fssize=${i}g "
>  		$MKFS_XFS_PROG -f -b size=4096 -l version=2 \
> -			-d size=${i}g $loop_dev |grep log
> +			-d size=${i}g $loop_dev $loop_mkfs_opts |grep log
>  		_mount $loop_dev $LOOP_MNT
>  		echo "test write" > $LOOP_MNT/test
>  		_unmount $LOOP_MNT > /dev/null 2>&1
> -- 
> 2.54.0
> 
> 
