Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A9626A1A7;
	Fri, 30 Jan 2026 09:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769766066; cv=none; b=UY86coW/RMO0f0XU1THWagLAYV2rg55enMk/sfNsRdST67ZzePXb/Kva53TiduPEuGsOW6KwE3zOP2BcSeepUQsxGLtBHQDB3DacPd4b+c6I3aJoHBMwXjKcrIEJzNCE9JJCM+t0etI/7aeTD3pd7PaUDl3zPANEFaMZ7v0HQew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769766066; c=relaxed/simple;
	bh=dYHaZkBLggTPLTTyqf2GxcTaarr6B+pwc6XFhS0pvk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kctCmIbqP5wkCG2tCLwp9JkRv7hbh/ydAN+AFugdbOkKUDe/M66XO9SezZJzgDQETjxNsXRDl8Nucg5FNB8xI5ZEWF+uGyMnpHHgqWP1LecnkXwMtcYwfgWcEZrg+cRzKIRrpJB7ecZx35PZmjRgzpJz19CDYiO/PvwQFq5tMXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AXt704i3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXt704i3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77021C4CEF7;
	Fri, 30 Jan 2026 09:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769766066;
	bh=dYHaZkBLggTPLTTyqf2GxcTaarr6B+pwc6XFhS0pvk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AXt704i3T8C3/lZrfGyzZDXNb3YsSDVxbJsdalK1Y+sElBMBUyKBtzkWBlVKqwCkX
	 Kd8soCzq25mGaAW+JznkNRJ4s5/YJnWMU9r53i54V+LnQShtTTxmlkK8s7U8JPTnS1
	 mSYhY3eClC0rD+O1q3z3VNkDq/LJ6gUZvWG0uV9owMPGx2ziIH4ipcHTh3JlfifF3i
	 IXqOfqJwxTmpxUhmj2msqPiB0apaJkjciOZrcOyi300TtLgfUyHOnHhD1Rv+EvANZK
	 A0JysKWC0AJD6dNRNZ5D5gpsrBXoSId8Xua/+HcpFboOH8974vA6pdvAr3DioxeRQE
	 hFJBLK5q2z4Ww==
Date: Fri, 30 Jan 2026 10:41:01 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Cc: chandanbabu@kernel.org, djwong@kernel.org, bfoster@redhat.com, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6] xfs: validate log record version against superblock
 log version
Message-ID: <aXx8D1uT-Tj87y6z@nidhogg.toxiclabs.cc>
References: <20260129185020.679674-2-rpthibeault@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129185020.679674-2-rpthibeault@gmail.com>

On Thu, Jan 29, 2026 at 01:50:21PM -0500, Raphael Pinsonneault-Thibeault wrote:
> Syzbot creates a fuzzed record where xfs_has_logv2() but the
> xlog_rec_header h_version != XLOG_VERSION_2. This causes a
> KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
> xlog_recover_process() -> xlog_cksum().
> 
> Fix by adding a check to xlog_valid_rec_header() to abort journal
> recovery if the xlog_rec_header h_version does not match the super
> block log version.
> 
> A file system with a version 2 log will only ever set
> XLOG_VERSION_2 in its headers (and v1 will only ever set V_1), so if
> there is any mismatch, either the journal or the superblock has been
> corrupted and therefore we abort processing with a -EFSCORRUPTED error
> immediately.
> 
> Also, refactor the structure of the validity checks for better
> readability. At the default error level (LOW), XFS_IS_CORRUPT() emits
> the condition that failed, the file and line number it is
> located at, then dumps the stack. This gives us everything we need
> to know about the failure if we do a single validity check per
> XFS_IS_CORRUPT().
> 
> Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
> Tested-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> Fixes: 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
> Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
> Changelog
> v1 -> v2: 
> - reject the mount for h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2
> v2 -> v3: 
> - abort journal recovery if the xlog_rec_header h_version does not 
> match the super block log version
> v3 -> v4: 
> - refactor for readability
> v4 -> v5:
> - stop pretending h_version is a bitmap, remove check using
> XLOG_VERSION_OKBITS
> v5 -> v6:
> - added Reviewed-by tags
> 
> It seems that this patch has fallen through the cracks, so I have
> resend'd with the Reviewed-by tags.
> Link to original thread:
> https://lore.kernel.org/all/20251112141032.2000891-3-rpthibeault@gmail.com/

Yes, thanks, please avoid sending new versions "In-Reply-To" old ones,
that tends to hide new versions.
Also I had issues with my (now old) email provider.

I'll queue this one for 7.0

> 
>  fs/xfs/xfs_log_recover.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 03e42c7dab56..e9a3e21af34a 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2953,18 +2953,23 @@ xlog_valid_rec_header(
>  	xfs_daddr_t		blkno,
>  	int			bufsize)
>  {
> +	struct xfs_mount	*mp = log->l_mp;
> +	u32			h_version = be32_to_cpu(rhead->h_version);
>  	int			hlen;
>  
> -	if (XFS_IS_CORRUPT(log->l_mp,
> +	if (XFS_IS_CORRUPT(mp,
>  			   rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM)))
>  		return -EFSCORRUPTED;
> -	if (XFS_IS_CORRUPT(log->l_mp,
> -			   (!rhead->h_version ||
> -			   (be32_to_cpu(rhead->h_version) &
> -			    (~XLOG_VERSION_OKBITS))))) {
> -		xfs_warn(log->l_mp, "%s: unrecognised log version (%d).",
> -			__func__, be32_to_cpu(rhead->h_version));
> -		return -EFSCORRUPTED;
> +
> +	/*
> +	 * The log version must match the superblock
> +	 */
> +	if (xfs_has_logv2(mp)) {
> +		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_2))
> +			return -EFSCORRUPTED;
> +	} else {
> +		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_1))
> +			return -EFSCORRUPTED;
>  	}
>  
>  	/*
> @@ -2972,12 +2977,12 @@ xlog_valid_rec_header(
>  	 * and h_len must not be greater than LR buffer size.
>  	 */
>  	hlen = be32_to_cpu(rhead->h_len);
> -	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > bufsize))
> +	if (XFS_IS_CORRUPT(mp, hlen <= 0 || hlen > bufsize))
>  		return -EFSCORRUPTED;
>  
> -	if (XFS_IS_CORRUPT(log->l_mp,
> -			   blkno > log->l_logBBsize || blkno > INT_MAX))
> +	if (XFS_IS_CORRUPT(mp, blkno > log->l_logBBsize || blkno > INT_MAX))
>  		return -EFSCORRUPTED;
> +
>  	return 0;
>  }
>  
> -- 
> 2.43.0
> 
> 
