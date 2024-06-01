Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1812AD48
	for <linux-xfs@vger.kernel.org>; Sat,  1 Jun 2024 17:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717263965; cv=none; b=GEGZXIG2rSZg2p4UnmEvVXDlpZRG3Cs5t3wPD69KRwbkLZoRqYvgRR53ZX4LQm929lCcbKGv8XouKMaGBOlhm28UnMWJfRa8nrffR1HoriFq2Q5Lg8hGHQ74Bm4+AE+kN1J+coEo/97eGiIUZf1DxTvyyikT1yxxok1hJTPEEzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717263965; c=relaxed/simple;
	bh=5ihamLK5vUUTAIwe7kf7D8EmB9ro2hZIaIFv7Wo334s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nEGJ37GMbjSLD9j4bRhOl6I6pwxmspWSyPvFxbIsax43nCTfV3rsqt51DGpm8HLDCMIaFC0mE1aiHCpuLeN5FjVGLPLp4GOcmNhcl2MqUpgMhAnPWPlZfYkrvGnqAIAn7ZGcORsvk8p9GKlXHdtt70XMpH6cnxBS0S1bDb2DesA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RNXVjjy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RNXVjjy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B470C116B1;
	Sat,  1 Jun 2024 17:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717263965;
	bh=5ihamLK5vUUTAIwe7kf7D8EmB9ro2hZIaIFv7Wo334s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RNXVjjy6Az+lD74JfY7DNyTGwEvsCTslYRu0EoMW2YReYSUEQx1rg5De39cjwyMsN
	 3cEdb4sVh8+lIFpNo5La7kvwlLGJNkxP6swZHBY2JRWLOVFcsNceJ4mi11qZTYj/2H
	 qqPtBSmPBhRSqEemYbJz08++vobW9w0Yes7YIkJVwpJcKLFRC0JdhAGiZ/pp8vua8b
	 5kfcU9Wcr0BrardQaWOxpw1NB39XTemMXOfyRV04QPSwD7bfUsi2uMmAIYWj4uwoX4
	 OJOoC4xA71GXi2Ckz/Z+KT0O+6fAqb9XXM+njVqPt8PqLCLec9zH1er67Ru3TGyFc8
	 Qp3QhJejskupw==
Date: Sat, 1 Jun 2024 10:46:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: make sure sb_fdblocks is non-negative
Message-ID: <20240601174604.GW52987@frogsfrogsfrogs>
References: <20240531182918.5933-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531182918.5933-1-wen.gang.wang@oracle.com>

On Fri, May 31, 2024 at 11:29:18AM -0700, Wengang Wang wrote:
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
> m_fdblocks without any lock. As m_fdblocks can experience a positive -> negative
>  -> positive changing when the FS reaches fullness (see xfs_mod_fdblocks)
> So there is a chance that sb_fdblocks is negative, and because sb_fdblocks is
> type of unsigned long long, it reads super big. And sb_fdblocks being bigger
> than sb_dblocks is a problem during log recovery, xfs_validate_sb_write()
> complains.
> 
> Fix:
> As sb_fdblocks will be re-calculated during mount when lazysbcount is enabled,
> We just need to make xfs_validate_sb_write() happy -- make sure sb_fdblocks is
> not nenative.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

With hch's comment about long lines addressed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> V1 -> V2: add problem symptoms in patch description.
> ---
>  fs/xfs/libxfs/xfs_sb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 09e4bf949bf8..6dc0731e82e8 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1042,7 +1042,7 @@ xfs_log_sb(
>  		mp->m_sb.sb_ifree = min_t(uint64_t,
>  				percpu_counter_sum(&mp->m_ifree),
>  				mp->m_sb.sb_icount);
> -		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +		mp->m_sb.sb_fdblocks = percpu_counter_sum_positive(&mp->m_fdblocks);
>  	}
>  
>  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> -- 
> 2.39.3 (Apple Git-146)
> 
> 
