Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793720447;
	b=Kr52gGH4Tik8s6vjPwrdJQ07agBM7TBDtft6h48FTsdUc4nxQ0b+1opSU6jrm1vYYwI9
	 SGHKMkJh505BbHFPKCsHLcU5Rtziuu6HC+F95Nk9MGEwJd+DKGRXjg4XEe0sHI7JS5Z2u
	 l4K/AhujhnYpqal74q8OZhIx+gx9I/UVFeCOiVc3pSlcXnJNWD+JSB8EYpeO3HlYVevE7
	 AL1gYjMW/XW1us/SOVZFoQlZPHjj/stEKb8EMO9rloq6ns5oeC2hV+kADUNUs2S4C7yTE
	 ix8OvJ8BBHEmnsdOHLuJ26AraZ2BPay+WYaTR+hqCFphDicWbdUKw570w9i/V7mpQRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793720447;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kU+Az3c/ndTwoHKdBiYYkVt0/JCAhtrjqA8dCA9gkAI=;
	b=Ese2Fpzgw6xp/TeyhJ1h+djI6OiS0/ivLh9AKoLAUeCaJG5VqwS/2NR8avwWkxQ1EHI5
	 aeC3CDYfe5IFJjuL93/a17HNOexmlhg45iGc1SPzQtldg0FDanw7kyn8s06L4XT1/n0FJ
	 DBJQGG5SEguEHcDw0Y7A/4xHrNfLDV5WyHtIkMZJpZGw2jrlcUzzAsSsO6/decBcnTJHX
	 iWVKRks6sEgF0wrAgP5ZG9fNf0hOxwDTtfIKYGkhWf6aHmwWp1II8myb7xQ1ykOuxDTq+
	 edGnTpfOEBimdHs6I3VAgy+RT2kfWM+14BED4mdOdi48OvfL9fwEMl5OleKpqXbkH/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtCiv3kk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38272606A327
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 15:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtCiv3kk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B035D1F000C1;
	Tue,  3 Nov 2026 15:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793720446;
	bh=kU+Az3c/ndTwoHKdBiYYkVt0/JCAhtrjqA8dCA9gkAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gtCiv3kkDTbrqbIPncNNvf/zOG++MIwwS4RtJhpXucvIeKJ3bLKw3Sp6nCDrlquS+
	 u1Or+lRVBR6PsxwS8DfjZOAEq267aiGN9ZhQo1xIKOLlhqvxggHl4MX2nAV1+a/GWk
	 pAdDnRy7x0LtQRBjp0GM1WB6wzP83HZP77Xgqx9RgLdIG1qZEfQC4TuRGwWNUDABDg
	 BEIJKG6OnoazJQBz+sNBzT6S0B36eFoA35fm7wSeniOfkeXAPSZQTsk0a0zZMMvQKx
	 /NUXfthNEgLcQcmVbUAP4FjCdY4wV2r9ty1F8Mdbeujlgy8BdR13qwafyMOk2TuEYm
	 nYvWWwqVSqkFQ==
Date: Tue, 3 Nov 2026 16:40:43 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, 
	Wilfred Mallawa <wilfred.opensource@gmail.com>
Subject: Re: [PATCH] xfs: always call xfs_update_stable_writes in
 xfs_ioctl_setattr_xflags
Message-ID: <aun_aTX5_EOFhl2d@nidhogg.toxiclabs.cc>
References: <20261103140809.3794376-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103140809.3794376-1-hch@lst.de>

On Tue, Nov 03, 2026 at 03:08:09PM +0100, Christoph Hellwig wrote:
> Currently xfs_update_stable_writes() is never called when the RT flag is
> flipped because xfs_ioctl_setattr_xflags() updates ip->i_diflags before
> comparing the rtflag variable to XFS_IS_REALTIME_INODE(ip), and thus
> the stable flag can be set incorretly when flipping the realtime bit
> on an existing file.
> 
> Fix this by unconditionally calling xfs_update_stable_writes for regular
> files.
> 
> Fixes: d528a6c1d4b6 ("xfs: data checksums require stable writes")
> Reported-by: Wilfred Mallawa <wilfred.opensource@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index f81b6e52ac40..36ba609a2593 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -595,7 +595,7 @@ xfs_ioctl_setattr_xflags(
>  	 * Make the stable writes flag match that of the device the inode
>  	 * resides on when flipping the RT flag.
>  	 */
> -	if (rtflag != XFS_IS_REALTIME_INODE(ip) && S_ISREG(VFS_I(ip)->i_mode))
> +	if (S_ISREG(VFS_I(ip)->i_mode))
>  		xfs_update_stable_writes(ip);
>  
>  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
> -- 
> 2.53.0
> 
> 
