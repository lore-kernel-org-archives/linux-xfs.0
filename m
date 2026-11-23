Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795459454;
	b=r+zu6hgqBf0bIAw7Dtm5G9M1Pvp2hdlvi7ZCAoA+OeY2cX4v9XQGxZ0DoT4lqy7iLi4w
	 nbHfNwwN9nM8VWg+JSfejaxAjS27LJJMPmg9yeyb5lnnXr5bgRPx3tD0DrEacr4giazsd
	 AiPRrxxV/J6ffvMNInUsxXnw0HBqATuTFQm56QtaIulaXoP7IuGw/MZp/IRqBgZsxcSad
	 NwmNPfOw+x2MP3nMsO3HfXWgAd6bxsjshNLHd5o8wqjLbAxNQG+LpmuEQCaITHaU/nDME
	 4p629fFlL40i9+y2sna3s87hze30ljAGaQY0zCkTSxLXIDV4UFqnTVjSg1IaDubIMhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795459454;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=ZJOq2+pIeNoBqrSrs+l3wNJ7Cp9nPDVKZV/aaKB+99E=;
	b=ee6fU0jsnKZJ6Jyh40KUQAfG3wl42BRcRjkcAy5EFavqhy9arbdQrmqz5PxElJPJ7ZlL
	 SnC659ja4VFMnoGXv2K8eyGOq2wA0rX+QWoRe2WzJTw8ZM48Zt3g+4SH3dbRGrzuqCJWY
	 hZNWtAW2S1Kte4xuAGMN4oirXuU2Xad3iQcH0u2PbtZfWJ1SJPN84OyvfNQngF0SeSOgn
	 qs2jVIaePd0xiP4+yRQ0K/t5o7d6DcAvMjtTL4Yt33TdNQZd5GzmCicoXLS5Q044iz18L
	 AB5DKdD5uJGUDQ5axpZSExFTOaRGwlFRFTbohlupWQlGZoy+VwTj970b73JfVUawIVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g+BmqYS4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED0A606A688;
	Mon, 23 Nov 2026 18:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g+BmqYS4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B021F000EF;
	Mon, 23 Nov 2026 18:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459454;
	bh=ZJOq2+pIeNoBqrSrs+l3wNJ7Cp9nPDVKZV/aaKB+99E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g+BmqYS4PwR/qb8oDBvH6gzcwOR7BTs4cG6X2DMM79KLuHRqFWAl22guLJruOE+my
	 EuD71jAn1TjU7URQthRPZeiDRX+W48Sv61t82pz0duVIBw7jSU5PxqIum5jSDYmG7r
	 Ct33E3nO8g/CUYNMWfZdyuYX9Gzo4MWPQ1Bu5FMJtPpCqxTTd1VpGjfBRGR7n1nFes
	 s+CmnZaFwXszUxs5odVeEFMWuppKPhoU9sKzia61QI+slLqPUIH+1mjllPTDIHewRB
	 cW4i0QN/NgBU/RBwYz4Wb7CQC+WEpQb4yR7VAtuii4HUAPY1c6Zec+Bxc2HhYnfzis
	 5Lt1BqHYMCeAQ==
Date: Tue, 24 Nov 2026 02:44:06 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 09/21] fstests: introduce helper _scratch_mkfs_uuid()
Message-ID: <awSI5d1ytDLC4nmx@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <5a816f5c76ae3e0761524d53998afd9d0d74f58f.1791272793.git.asj@kernel.org>
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
In-Reply-To: <5a816f5c76ae3e0761524d53998afd9d0d74f58f.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:35PM +0800, Anand Jain wrote:
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  common/rc | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 37b32b498c80..37df780f64ef 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1449,6 +1449,36 @@ _scratch_mkfs_sized()
>  	_try_scratch_mkfs_sized "$@" || _notrun "_scratch_mkfs_sized failed with ($*)"
>  }
>  
> +# mkfs filesystem with a known uuid
> +# Input argument : none
> +_scratch_mkfs_uuid()
> +{
> +	case $FSTYP in
> +	f2fs|ext4)
> +		if echo "$MKFS_OPTIONS" | grep -E -q "-U"; then
> +			_notrun "Config contains mkfs uuid option"
> +		fi
> +		MKFS_OPTIONS+=" -U 12345678-1234-1234-1234-123456789abc"
> +		;;
> +	xfs)
> +		if echo "$MKFS_OPTIONS" | grep -E -q "uuid"; then
> +			_notrun "Config contains mkfs uuid option"
> +		fi
> +		MKFS_OPTIONS+=" -m uuid=12345678-1234-1234-1234-123456789abc"
> +		;;
> +	btrfs)
> +		if echo "$MKFS_OPTIONS" | grep -E -q "uuid|-U"; then
> +			_notrun "Config contains mkfs uuid option"
> +		fi
> +		MKFS_OPTIONS+=" --uuid 12345678-1234-1234-1234-123456789abc"
> +		;;
> +	*)
> +		_notrun "can't mkfs $FSTYP with uuid"
> +		;;
> +	esac
> +	_scratch_mkfs
> +}
> +
>  # Emulate an N-data-disk stripe w/ various stripe units
>  # _scratch_mkfs_geom <sunit bytes> <swidth multiplier> [optional blocksize]
>  _scratch_mkfs_geom()
> -- 
> 2.43.0
> 
