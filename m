Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDF87347F
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 22:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717714529; cv=none; b=ikntIj0MBtc7O00tD1oXwfFhWh0urza9UEgv49VCvFVvJDboLnnZDpMeIi2GYa/IHL8cus+3dOVuUzzGgC0BC/7E1p0GE4q4QRfN5uyjSQluf775bgTZaZQC6N0wkZfVHlq1NmG0WGmvP6CtpJNIbrr99a8+vaUwKF3MhKPG2qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717714529; c=relaxed/simple;
	bh=LlL9ySvgbQ7LNKW0skHyARbXcYmvl7vJYRiAY1O5mqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2K+xFlJMAugieyJam/F3UVCI/tZ+grvxESomQNFXdNI8pEujrUiBsIM4HCK5fY/G1b2uX9nOX75JCSF2zkEz1Xe0GCfwKRp+x8rsI6xzQ3wWc8gB/M/jn1Mp2p8dR7wsL1+s+SZAzcgy4OcS1FyhexLHzfLXWtg+n2RazFLZEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=deLoZS7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="deLoZS7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB13C2BD10;
	Thu,  6 Jun 2024 22:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717714526;
	bh=LlL9ySvgbQ7LNKW0skHyARbXcYmvl7vJYRiAY1O5mqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=deLoZS7UpaG2jTrkpvfbjnB71R1/pVa7jEl9Bbab+rybhGQa7e4JD9Etn/S76vWNb
	 +dvGfr78rqA1Gwy0ReSQmh8Ove6ftcrCJUZr6rnlUSGfhtFA+j4DtZBsshwojWQcIu
	 nshYfogM0fUDtNhhVNSK34BveUIlV4UAVM9rBSI5ar0H09btS7nXf23JO6kH2cNn+Y
	 NtW8wHgeH1rxpQag2x32nMVrdv/DcJjDZW90mEkC/d+fzabNXoalrCSHng7nQdCZtz
	 4vf7GjXEJBGhYXHfsSAtxdTGAiTJvTiCcS2o8oTgJi7DDw/0XcpJadNKlURHUmWAd/
	 sW0iUwIV7BRRw==
Date: Thu, 6 Jun 2024 15:55:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH V4] xfs: make sure sb_fdblocks is non-negative
Message-ID: <20240606225526.GQ52987@frogsfrogsfrogs>
References: <20240606181157.23901-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606181157.23901-1-wen.gang.wang@oracle.com>

On Thu, Jun 06, 2024 at 11:11:57AM -0700, Wengang Wang wrote:
> A user with a completely full filesystem experienced an unexpected
> shutdown when the filesystem tried to write the superblock during
> runtime.
> kernel shows the following dmesg:
> 
> [    8.176281] XFS (dm-4): Metadata corruption detected at xfs_sb_write_verify+0x60/0x120 [xfs], xfs_sb block 0x0
> [    8.177417] XFS (dm-4): Unmount and run xfs_repair
> [    8.178016] XFS (dm-4): First 128 bytes of corrupted metadata buffer:
> [    8.178703] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 01 90 00 00  XFSB............
> [    8.179487] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [    8.180312] 00000020: cf 12 dc 89 ca 26 45 29 92 e6 e3 8d 3b b8 a2 c3  .....&E)....;...
> [    8.181150] 00000030: 00 00 00 00 01 00 00 06 00 00 00 00 00 00 00 80  ................
> [    8.182003] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
> [    8.182004] 00000050: 00 00 00 01 00 64 00 00 00 00 00 04 00 00 00 00  .....d..........
> [    8.182004] 00000060: 00 00 64 00 b4 a5 02 00 02 00 00 08 00 00 00 00  ..d.............
> [    8.182005] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 17 00 00 19  ................
> [    8.182008] XFS (dm-4): Corruption of in-memory data detected.  Shutting down filesystem
> [    8.182010] XFS (dm-4): Please unmount the filesystem and rectify the problem(s)
> 
> When xfs_log_sb writes super block to disk, b_fdblocks is fetched from
> m_fdblocks without any lock. As m_fdblocks can experience a positive ->
> negative -> positive changing when the FS reaches fullness (see
> xfs_mod_fdblocks). So there is a chance that sb_fdblocks is negative, and
> because sb_fdblocks is type of unsigned long long, it reads super big.
> And sb_fdblocks being bigger than sb_dblocks is a problem during log
> recovery, xfs_validate_sb_write() complains.
> 
> Fix:
> As sb_fdblocks will be re-calculated during mount when lazysbcount is
> enabled, We just need to make xfs_validate_sb_write() happy -- make sure
> sb_fdblocks is not nenative. This patch also takes care of other percpu
> counters in xfs_log_sb.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

Seems fine to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> V3 -> V4: takes care of other percpu counters
> V2 -> V3: break the line to ensure it isn't overly long
> V1 -> V2: add problem symptoms in patch description.
> ---
>  fs/xfs/libxfs/xfs_sb.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 09e4bf949bf8..6b56f0f6d4c1 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1038,11 +1038,12 @@ xfs_log_sb(
>  	 * and hence we don't need have to update it here.
>  	 */
>  	if (xfs_has_lazysbcount(mp)) {
> -		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> +		mp->m_sb.sb_icount = percpu_counter_sum_positive(&mp->m_icount);
>  		mp->m_sb.sb_ifree = min_t(uint64_t,
> -				percpu_counter_sum(&mp->m_ifree),
> +				percpu_counter_sum_positive(&mp->m_ifree),
>  				mp->m_sb.sb_icount);
> -		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +		mp->m_sb.sb_fdblocks =
> +				percpu_counter_sum_positive(&mp->m_fdblocks);
>  	}
>  
>  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> -- 
> 2.39.3 (Apple Git-146)
> 
> 
