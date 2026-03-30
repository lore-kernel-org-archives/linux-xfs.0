Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67790346A0C;
	Mon, 30 Mar 2026 16:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774886681; cv=none; b=Peezow10//N5ukJs75NErSfw2vfUXUfJA5pT9JnQjxZDmJnEQ5R8njBmmEyyg7SgNsyyU3+UFJONaewjtaHMJ6Io7wZHdj20qgmMsYYRo+PsA/y4BUO/B5g2eHYB8uuAb2X73er5ss+KZ0lDY/7YPPGMoChMTDXSpwOgMVPaELs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774886681; c=relaxed/simple;
	bh=yVFBi+DzchKAKYmrxoYixWw07bl3TILTJazdOgkwmgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETVLSLo1e+kTOZBWrOn48rgBEWAjEpToc14GrmRZeCYdkRBsrXvprpn7ZrxYIahHtwmUND6uOelgeBrrau7pqq7F4XOjKC70Ov2FG33ZnfZvqEAcx9UTDe+ETcT6nvjNr9AX8ECybq+/M3siB7oH3knIxD5wLxK6kCKTY9DTX64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eci1rery; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eci1rery"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ACDC4CEF7;
	Mon, 30 Mar 2026 16:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774886681;
	bh=yVFBi+DzchKAKYmrxoYixWw07bl3TILTJazdOgkwmgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Eci1reryhkv/wF0IWVdaHrsIirTSrKi1kGkvmX3U5ej3t7bQ0E7B27EzujKt04YaX
	 xzUuuOOVMFUHGGQjc1+Li1glGvnscKa2Yrpq9ORK+ivqTLfBQSe3k0VVIWfBQ2N7Pz
	 gRPcFLEpMrOaiRl3Rj2PaAClas6nAHopYgrkUmy6MV9eJ86vuuep2vDUQhEBCxGou1
	 SUAejxFPu1etRUQklyByUROFUOF9y8wa2E63Qd5O0AltLK4PTBNyc07EHCG8SZbr2j
	 6wJqX3sHRu6ixN3StjynXhX12KP58k3/YcseFTBLdydSApjnxB3zJAMMfJqSLK7xT6
	 ZYfK/sWNO9Nig==
Date: Mon, 30 Mar 2026 09:04:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ravi Singh <ravising@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger@dilger.ca, jack@suse.com, cem@kernel.org, hch@infradead.org
Subject: Re: [PATCH v3] xfs: return default quota limits for IDs without a
 dquot
Message-ID: <20260330160440.GQ6202@frogsfrogsfrogs>
References: <20260317065947.306954-1-ravising@redhat.com>
 <20260330061414.1190802-1-ravising@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330061414.1190802-1-ravising@redhat.com>

On Mon, Mar 30, 2026 at 02:14:14PM +0800, Ravi Singh wrote:
> When an ID has no dquot on disk, Q_XGETQUOTA returns -ENOENT even
> though default quota limits are configured and enforced against that
> ID.  This means unprivileged users who have never used any resources
> cannot see the limits that apply to them.
> 
> When xfs_qm_dqget() returns -ENOENT for a non-zero ID, return a
> zero-usage response with the default limits filled in from
> m_quotainfo rather than propagating the error.  This is consistent
> with the enforcement behavior in xfs_qm_adjust_dqlimits(), which
> pushes the same default limits into a dquot when it is first
> allocated.
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Ravi Singh <ravising@redhat.com>

I think it's an improvement that you can now see the (default) limits
for an otherwise unused qid.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  v3:
>   - Return -ENOENT when no default limits are configured
>     instead of returning a zero-filled response (Darrick)
> 
>  v2:
>   - Moved fix from VFS (fs/quota/quota.c) to XFS
>     (fs/xfs/xfs_qm_syscalls.c) per review feedback
>   - Return default limits on ENOENT instead of granting
>     unprivileged access to ID 0's dquot
> 
>  fs/xfs/xfs_qm_syscalls.c | 43 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index d50b7318c..21a784986 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -391,6 +391,38 @@ xfs_qm_scall_setqlim(
>  	return error;
>  }
>  
> +/*
> + * Fill out the default quota limits for an ID that has no dquot on disk.
> + * Returns 0 if default limits are configured
> + * and were filled in, -ENOENT otherwise.
> + */
> +static int
> +xfs_qm_scall_getquota_fill_defaults(
> +	struct xfs_mount	*mp,
> +	xfs_dqtype_t		type,
> +	struct qc_dqblk		*dst)
> +{
> +	struct xfs_def_quota	*defq;
> +
> +	defq = xfs_get_defquota(mp->m_quotainfo, type);
> +
> +	if (!defq->blk.soft && !defq->blk.hard &&
> +	    !defq->ino.soft && !defq->ino.hard &&
> +	    !defq->rtb.soft && !defq->rtb.hard) {
> +		return -ENOENT;
> +	}
> +
> +	memset(dst, 0, sizeof(*dst));
> +	dst->d_spc_softlimit = XFS_FSB_TO_B(mp, defq->blk.soft);
> +	dst->d_spc_hardlimit = XFS_FSB_TO_B(mp, defq->blk.hard);
> +	dst->d_ino_softlimit = defq->ino.soft;
> +	dst->d_ino_hardlimit = defq->ino.hard;
> +	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, defq->rtb.soft);
> +	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, defq->rtb.hard);
> +
> +	return 0;
> +}
> +
>  /* Fill out the quota context. */
>  static void
>  xfs_qm_scall_getquota_fill_qc(
> @@ -451,8 +483,17 @@ xfs_qm_scall_getquota(
>  	 * set doalloc. If it doesn't exist, we'll get ENOENT back.
>  	 */
>  	error = xfs_qm_dqget(mp, id, type, false, &dqp);
> -	if (error)
> +	if (error) {
> +		/*
> +		 * If there is no dquot on disk and default limits are
> +		 * configured, return them with zero usage so that
> +		 * unprivileged users can see what limits apply to them.
> +		 */
> +		if (error == -ENOENT && id != 0 &&
> +		    !xfs_qm_scall_getquota_fill_defaults(mp, type, dst))
> +			return 0;
>  		return error;
> +	}
>  
>  	/*
>  	 * If everything's NULL, this dquot doesn't quite exist as far as
> -- 
> 2.49.0
> 
> 
