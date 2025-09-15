Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF532E11B7
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 18:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757960737; cv=none; b=gB0H0Ro7rts+53xmx8zWNGmQ9zOOuWt71acKGkC0HbhLtbzzUL71j6sNGEuLGiuGiAdC9iAZ3ZzuCLYpthM+vVaTGTqqVbNvahGwLLT9gY+FesAthvA38iJHWL5Fxcy0vyskUaWLtf9k+qqhJIlkoWX8BQaUnOO7S0++Nv3x+8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757960737; c=relaxed/simple;
	bh=80GPD0Ql7mQsw+Er3ohLI3CnQPOxvFCmqgF+thEbFHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OvGZjVzHNx2EEVxwrPiNEZsjd0T5cjTZyqpaDEuYaublSVdP2QS+Mu+ULbWn89FwR3+k2Z5op81Fa+Mp22sDGiFMBdQZdfgnVLvVLv+iIsnTAB1pgoSVSqMuFVZjKtFs3slHX/HhhtXt6jWYorW09a24+waBkH42SNEb18h804I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzjYJkZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzjYJkZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF26C4CEF7;
	Mon, 15 Sep 2025 18:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757960737;
	bh=80GPD0Ql7mQsw+Er3ohLI3CnQPOxvFCmqgF+thEbFHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VzjYJkZYP+bSw3nrIs3UG+PUgNTEGmUbjQayUmfq2+5Ff9ptoDpDMK85Ys1D3+BGb
	 hkbTsIfm8sOy6CTetoyLixZmOt7dfyW/iwwaeJrHIAQHOrQ0YPAn8acmAEtjGFj9Lm
	 Nv1EmLQb3L8iQQldINeywOxJiZsGDVT6drq1IWPzVgNBJZ0TyPirXVWxce1oj2w8VQ
	 ZmCds3rHrI1HVsNTaFMwZ4J3WvtM1LvySXcSekfDALGvrTU5LIWB5XVF6gjdZ9CTGh
	 XzpKGAJR29NpldZJY1o8s7LhkvyVGDWJXY4DAsZSalBx48hPa8LTvxnMZJ3diMQCY6
	 YR4g0QzyRpRxA==
Date: Mon, 15 Sep 2025 11:25:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: rename the old_crc variable in
 xlog_recover_process
Message-ID: <20250915182536.GQ8096@frogsfrogsfrogs>
References: <20250915132047.159473-1-hch@lst.de>
 <20250915132047.159473-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915132047.159473-2-hch@lst.de>

On Mon, Sep 15, 2025 at 06:20:29AM -0700, Christoph Hellwig wrote:
> old_crc is a very misleading name.  Rename it to expected_crc as that
> described the usage much better.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Pretty straightforward so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_recover.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e6ed9e09c027..0a4db8efd903 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2894,20 +2894,19 @@ xlog_recover_process(
>  	int			pass,
>  	struct list_head	*buffer_list)
>  {
> -	__le32			old_crc = rhead->h_crc;
> -	__le32			crc;
> +	__le32			expected_crc = rhead->h_crc, crc;
>  
>  	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
>  
>  	/*
>  	 * Nothing else to do if this is a CRC verification pass. Just return
>  	 * if this a record with a non-zero crc. Unfortunately, mkfs always
> -	 * sets old_crc to 0 so we must consider this valid even on v5 supers.
> -	 * Otherwise, return EFSBADCRC on failure so the callers up the stack
> -	 * know precisely what failed.
> +	 * sets expected_crc to 0 so we must consider this valid even on v5
> +	 * supers.  Otherwise, return EFSBADCRC on failure so the callers up the
> +	 * stack know precisely what failed.
>  	 */
>  	if (pass == XLOG_RECOVER_CRCPASS) {
> -		if (old_crc && crc != old_crc)
> +		if (expected_crc && crc != expected_crc)
>  			return -EFSBADCRC;
>  		return 0;
>  	}
> @@ -2918,11 +2917,11 @@ xlog_recover_process(
>  	 * zero CRC check prevents warnings from being emitted when upgrading
>  	 * the kernel from one that does not add CRCs by default.
>  	 */
> -	if (crc != old_crc) {
> -		if (old_crc || xfs_has_crc(log->l_mp)) {
> +	if (crc != expected_crc) {
> +		if (expected_crc || xfs_has_crc(log->l_mp)) {
>  			xfs_alert(log->l_mp,
>  		"log record CRC mismatch: found 0x%x, expected 0x%x.",
> -					le32_to_cpu(old_crc),
> +					le32_to_cpu(expected_crc),
>  					le32_to_cpu(crc));
>  			xfs_hex_dump(dp, 32);
>  		}
> -- 
> 2.47.2
> 
> 
