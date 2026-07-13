Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B54A241C8C;
	Mon, 13 Jul 2026 22:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783980278; cv=none; b=h2McWNp0tgE/iTrBItVbh8M6SeQajg4168ydQbygfAux3UosqSYtNJ3LakRZliugErARvuIGHPlRyWqp1Qh6h1k03Rq+CbwNAhmV/WNd6/nmsppqdURByPP0oxvuiwg9J9qYb54BcFp/8F9uoiVDX3dGRIVc2KDjlZja4mY2tAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783980278; c=relaxed/simple;
	bh=lOjHHHhHSCk0KlTlcldesAsiR5WMw3Nx33ZhUhrIm7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ANyr5mwzP4t/eb5EFloydCdL+HBsLQmgvb5RbwwbmWLVjUQUZtxeSOYSRppWBGG7R+/X/luzzkeLgNawAf16WIlwc+anebR1hA1TcP8t85+CSib0lxSTUvpoBsAofCzUUGlou0pOrMh8OX1OqMp+qnu/ilHESnsdVat7EXkCAqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAWWY4Si; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAWWY4Si"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7EED01F000E9;
	Mon, 13 Jul 2026 22:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783980276;
	bh=K4w6MBU2HLY5O3DseZreGSBHfkbxmEqw2kSQjXn800A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hAWWY4Si4AejLGuI/Q0JRYmEcAB8++q8Bq+VbnDyIcL+yromTRCGUTV31HqBEScVj
	 XkQON5WsIg2ko4KWxo8cSAKNtWCrTCATMHkS9OvUfkvjYexBlS+juwWnUPJswAlNLP
	 WTF37jUtHyColhdK5gbVcjttOh1uPCnyPzOnh3fX3lHX4RnN2CxCmfbUwtHHWVXA76
	 CkVuCnvyIfHD7p0ROicySwUCS9enhG6jCA5/A3SeSauW0U6nFujduu8hQHNneEpVfS
	 TP8M4TkgjaFMsXKwDv2YgBh88Rl8/hRC8yjdPnEJ1yA53aWVru/DqDE+vSByYm5i03
	 H31ODMWNtXcug==
Date: Mon, 13 Jul 2026 15:04:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: cem@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: don't hold buffer locks across sync transaction
 commit in xfs_sync_sb_buf
Message-ID: <20260713220436.GH7195@frogsfrogsfrogs>
References: <20260713145002.1627608-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713145002.1627608-1-yun.zhou@windriver.com>

On Mon, Jul 13, 2026 at 10:50:02PM +0800, Yun Zhou wrote:
> xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
> xfs_trans_commit(), which flushes the CIL push workqueue internally.
> If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
> lock these buffers to fail them, causing a deadlock:
> 
>   setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
>   CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)
> 
> Remove the xfs_trans_bhold() calls so that commit releases the buffer
> locks normally.  After the sync commit, re-acquire the buffers via
> mp->m_sb_bp / mp->m_rtsb_bp for the on-disk writeback.

Is there a risk of writing out the wrong superblock contents if
something else grabs the buffer lock(s) between the xfs_trans_commit and
the xfs_buf_lock calls?  Can we walk off a garbage
xfs_mount::m_{rt,}sb_bp pointer if the filesystem is being torn down, or
does something prevent that?

--D

> Fixes: f7664b31975b ("xfs: implement online get/set fs label")
> Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 47322adb7690..fbb4505b1e9e 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1471,7 +1471,6 @@ xfs_sync_sb_buf(
>  {
>  	struct xfs_trans	*tp;
>  	struct xfs_buf		*bp;
> -	struct xfs_buf		*rtsb_bp = NULL;
>  	int			error;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
> @@ -1480,26 +1479,28 @@ xfs_sync_sb_buf(
>  
>  	bp = xfs_trans_getsb(tp);
>  	xfs_log_sb(tp);
> -	xfs_trans_bhold(tp, bp);
> -	if (update_rtsb) {
> -		rtsb_bp = xfs_log_rtsb(tp, bp);
> -		if (rtsb_bp)
> -			xfs_trans_bhold(tp, rtsb_bp);
> -	}
> +	if (update_rtsb)
> +		xfs_log_rtsb(tp, bp);
>  	xfs_trans_set_sync(tp);
>  	error = xfs_trans_commit(tp);
>  	if (error)
> -		goto out;
> -	/*
> -	 * write out the sb buffer to get the changes to disk
> -	 */
> -	error = xfs_bwrite(bp);
> -	if (!error && rtsb_bp)
> -		error = xfs_bwrite(rtsb_bp);
> -out:
> -	if (rtsb_bp)
> -		xfs_buf_relse(rtsb_bp);
> -	xfs_buf_relse(bp);
> +		return error;
> +
> +	/* Re-acquire and write the sb and rtsb to disk. */
> +	xfs_buf_lock(mp->m_sb_bp);
> +	xfs_buf_hold(mp->m_sb_bp);
> +	error = xfs_bwrite(mp->m_sb_bp);
> +	xfs_buf_relse(mp->m_sb_bp);
> +	if (error)
> +		return error;
> +
> +	if (update_rtsb && mp->m_rtsb_bp) {
> +		xfs_buf_lock(mp->m_rtsb_bp);
> +		xfs_buf_hold(mp->m_rtsb_bp);
> +		error = xfs_bwrite(mp->m_rtsb_bp);
> +		xfs_buf_relse(mp->m_rtsb_bp);
> +	}
> +
>  	return error;
>  }
>  
> -- 
> 2.43.0
> 
> 
