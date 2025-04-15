Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5026FC5
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 00:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744677247; cv=none; b=rBwjFVENsE03U4pzmXrQDBCIaUxyQ1GYuiTVteZ96ah0MZnm1kQHGJDmnm5rA8tx9PhmNnvvYc78OQ4ooboMWnE/SR5yk0INIXrWmdtWmDTQCJ2WPWGWOjZdSeYttksXYqOBDPBC3tEs62mKGBjViTOpSEh1C9mhptTTaUwJUhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744677247; c=relaxed/simple;
	bh=MGJ1LzqciOtjdSzz/1zI2/md3oox9Fi9aZKw4/XLzKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R1f4NcSfVaU0hUrZcq020DoPabVAk5mfpyvlMrRg/KzG6RM6jQy1A0W5LFfzvf+djBzRwV+sEQDGIrmkpeCmKAqO8rugc2HNHznMz3hn6P7rLpk3D6+p0nx16Q9c4D69y4+GmJg/fbTe08s39e4X3beTe4ZQYOy06jzjP8HHqEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OROGZQ4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OROGZQ4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2AAC4CEE2;
	Tue, 15 Apr 2025 00:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744677246;
	bh=MGJ1LzqciOtjdSzz/1zI2/md3oox9Fi9aZKw4/XLzKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OROGZQ4lPSbduxNKk85OqrX4VOM65z4+t5/iloa17T/uuLT4lM996ErCdl1sT/1ZX
	 MEpZTxbfKVI4sjFWoWYKrpeLoT+i/wWHV6kd+R/yjdjhCBMIupXOIoDmHHwaS24VUI
	 Z6vA43NGMk4OOyQ3a3/5DDmgVg8C5Hbncibvfm4F4QY/KByQjdFXFZooUzm6DiQ04L
	 Fo8WFaCKofwdCRT7o+k1H/xGAMGNxvNKhqtWrjyBXXshIB51a57HvmL2/PSCrl4fBq
	 z+KGHwNYKdWpc9Te8kHjFh6FWsGJ2TJQNgQ9qZzwPt3GpwbfEGaaYslb+nNoTrfj6f
	 zzWorME7FuMTw==
Date: Mon, 14 Apr 2025 17:34:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/43] xfs_repair: fix the RT device check in
 process_dinode_int
Message-ID: <20250415003406.GG25675@frogsfrogsfrogs>
References: <20250414053629.360672-1-hch@lst.de>
 <20250414053629.360672-29-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414053629.360672-29-hch@lst.de>

On Mon, Apr 14, 2025 at 07:36:11AM +0200, Christoph Hellwig wrote:
> Don't look at the variable for the rtname command line option, but
> the actual file system geometry.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  repair/dinode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 7bdd3dcf15c1..8ca0aa0238c7 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -3265,8 +3265,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  			flags &= XFS_DIFLAG_ANY;
>  		}
>  
> -		/* need an rt-dev for the realtime flag! */
> -		if ((flags & XFS_DIFLAG_REALTIME) && !rt_name) {
> +		/* need an rt-dev for the realtime flag */
> +		if ((flags & XFS_DIFLAG_REALTIME) && !mp->m_sb.sb_rextents) {
>  			if (!uncertain) {
>  				do_warn(
>  	_("inode %" PRIu64 " has RT flag set but there is no RT device\n"),
> -- 
> 2.47.2
> 
> 
