Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EA42114
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 23:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734131104; cv=none; b=NVQM7kdvy4h2ZK8ko1DQxRFviEmpFXwOgkr8B5N66oMkOwPHLqx90qf2aCtYdrKyarud8zM9P9lS7+ux5iwXE0igURcDEsokmQL5Ya/YGAistMM2jMaHjbetQKcJ/UOYTYVI+kpk1YX086yRvYhgU3d/B+plEFmHSsRrlzJgUpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734131104; c=relaxed/simple;
	bh=Tj5qz4u9+5VswGTsVg9T6tQY3GAEHMb6QHmTNBxZtLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UgSyj9qevuP0FdLb7CjtNVCShZ9R05aQfnsCA8berPBd5KDLucjpVdHpFJRNUI5UIvmYOnSHPpGavw61QHlHJYabLF0wwkw3zUevHFXVd0NBSgLZ2v0ofBrcEmdAPPWamQG4YPLEPvsNwWxrhKorFMTsobUYwt8aAZo6cGAfRlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l4S+jjkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4S+jjkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35CEC4CED0;
	Fri, 13 Dec 2024 23:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734131103;
	bh=Tj5qz4u9+5VswGTsVg9T6tQY3GAEHMb6QHmTNBxZtLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l4S+jjkcKUmN9fPMleeD1zZCyssBOcQh7EEirYeEF/v8cDmBe0Qowq6pJbf+MKd3y
	 opiIUAaiUlcg25cjt9feUu9ZF/ouVeZBDYEKiNhuwWi3BUf/Vw8bRHUK6t1jAw1fQn
	 JkLUz6TwBB7G2bLYcabEG8A8J0I0IrNBtaoCmSu/21RCHwEkxi5t9izDD2S7mnt0jy
	 eWvym6TjIuPYewJ9QYV6BPZUKT0i/0XMMkf+1uUgto0lsYeLXcmQy5idjSumj3oxq5
	 pLd+vs8/QZy5HVZdtwiuPgbg/QlMSbmZX5+EORb6oh073kYU3kyEtYcclPSGaVoPhK
	 QiRWFtFT11enA==
Date: Fri, 13 Dec 2024 15:05:03 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 37/43] xfs: disable rt quotas for zoned file systems
Message-ID: <20241213230503.GE6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-38-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-38-hch@lst.de>

On Wed, Dec 11, 2024 at 09:55:02AM +0100, Christoph Hellwig wrote:
> They'll need a little more work.

I guess we'll have to get back to this... :/

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_qm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index e1ba5af6250f..417439b58785 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1711,7 +1711,8 @@ xfs_qm_mount_quotas(
>  	 * immediately.  We only support rtquota if rtgroups are enabled to
>  	 * avoid problems with older kernels.
>  	 */
> -	if (mp->m_sb.sb_rextents && !xfs_has_rtgroups(mp)) {
> +	if (mp->m_sb.sb_rextents &&
> +	    (!xfs_has_rtgroups(mp) || xfs_has_zoned(mp))) {
>  		xfs_notice(mp, "Cannot turn on quotas for realtime filesystem");
>  		mp->m_qflags = 0;
>  		goto write_changes;
> -- 
> 2.45.2
> 
> 
