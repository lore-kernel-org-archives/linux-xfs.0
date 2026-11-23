Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795454692;
	b=FMKIh++ojKXLe1NN69qYwFRcIFqsuqSnwUd4rkqSdkyfy58Twg1DyfEZvt00HQhkDdyY
	 HXQhh3YInZ4Rq8yxpI4aJpKFXPz/KBL7p2wg3chylwuoUcyLuA1M9+gJcF0XG8BrL+uLF
	 bn0Zkuk9YDDXIql6x+OBCMWsscP5+MAyitKGNyCx79hFIZa0Z+QlfXXGoxuBikLO9s9hn
	 5aSMxC9paX/SIQlCBsXss6MDmwqajjQZStMUYhxFcqB9I4gDWj9dgp0jrQ5g4dnS/xh/n
	 HLVsQUvUL96dPx0TIfgUVpEY2+Q8hyS8LT62F15L/8LqdLXJCuc9FEKM2q5wgIxpPYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795454692;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=eoDSTZe53wuVRCyLceRxiACx+/d1rzfD6YrehQciITE=;
	b=xgtOn1Xzr/lZPIACg5Qy8IV33yOYjv6V7g7V7BDP+Gbupvzfmdn5Fw3lu3EyZ8NHlq43
	 GHWAiwcFiZ0MqFOjgxjvMhL/HJDrO1tnWcxTow4iU88PUv9g7v8ZoHI3DIBWTCYMcjATT
	 KMzsKo8xw41sgiZI4PRIUFuV60uqdH+UmZzRW4xm7rF2wiimdOUYwIezA593EU+EUCa32
	 txbAeOjlxj5BgnZP9whQl+Fp4195SknTlT4VyV9L9+xp4yuI29PJygfRxgTKu4CTFl2YF
	 MQ7475Z59s92VSEQ8aapGhVIM380HITz+s8MjYzNzeSrN5+nTwfICU4/i/+OfvWIDUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=op+ZuC35;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE703606A337;
	Mon, 23 Nov 2026 17:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=op+ZuC35
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449DD1F000D3;
	Mon, 23 Nov 2026 17:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795454692;
	bh=eoDSTZe53wuVRCyLceRxiACx+/d1rzfD6YrehQciITE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=op+ZuC351+ONYtuuLlHO0lsJWkjaMKyvYPMJvVxtYg8e76pOzg2iG8XYXtKleSeZn
	 oEb8ictwuRpPIszasEO8sIHZzqudHZJfqfYOBPdeHXxvOZXT999y59y+y6cxpD0YgM
	 wlPIY+xr5Gtw0udgB2Y1Ci9fpB9Ke8B3nmvrM/SMogTEFNzuiW/muL63/bMF6ubxhT
	 6X16uESC4UhaEQJxa4J+6VIRz0uNRyUyKjt3JgjYcrEFZ76aeU0nSZtcWxF6FJk0L6
	 LtUlz6Qt27seYxm+FAguGf7J9J/4OX2dxsEk3kAayl8rE3zf4mSyREoZmrp5Ot/wbd
	 51rqo7qwrvqfQ==
Date: Tue, 24 Nov 2026 01:24:43 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 01/21] fstests: introduce _require_clone_mount() helper
Message-ID: <awR2y3ibb46JaqwM@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <245314b2efd616b7ecf09f74e2a775e44e10ab43.1791272793.git.asj@kernel.org>
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
In-Reply-To: <245314b2efd616b7ecf09f74e2a775e44e10ab43.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:27PM +0800, Anand Jain wrote:
> Add _require_clone_mount() to common/rc to check whether the filesystem
> supports mounting cloned block devices simultaneously. For Btrfs, it
> verifies kernel support for the temp_fsid feature, while skipping
> unsupported filesystem types with _notrun.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  common/rc | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 3958ac934980..7868e6d311a2 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -6124,6 +6124,21 @@ _force_inplace_writes()
>  	esac
>  }
>  
> +_require_clone_mount()
> +{
> +	case "$FSTYP" in
> +	xfs|ext4|f2fs)
> +		# No kernel-side restriction; always supported
> +		;;
> +	btrfs)
> +		_require_btrfs_fs_feature "temp_fsid"
> +		;;
> +	*)
> +		_notrun "$FSTYP does not support mounting cloned devices simultaneously"
> +		;;
> +	esac
> +}
> +
>  # Test that a filesystem can do writes to a file in place (without allocating
>  # new extents, without Copy-On-Write semantics).
>  _require_inplace_writes()
> -- 
> 2.43.0
> 
