Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08B21D540
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 09:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740389511; cv=none; b=j4YoWNgQNz2OqmYCYt12U/TSLr4rXbbnkqtciu7H0bhK8Q+rAR0XfmZOYa9To+xcxRY9tSxFwPhsUBoTfFjgXD33BLh7vRRJNYWY3GC9dxsiUhz/iAw+Nq31xmS2kBEA2Z/2wDvDxsOUuuJnHUPRMTI1/y0YL60KFS/fiKlK4dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740389511; c=relaxed/simple;
	bh=xF5oiosf6GwA0WI36ooh7OtTEvTg28RBNQWa5YVRfjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jcyFYEbTvZdHVGu7U2ngxRhX23QdfFWBP/5bjLEBEKcj2sqggR8I3lR6Ceu/qnPMTeQtM3C8whwkk+ecpaPCXCSN1GaNRopdEjFYS8jEnjHFlO/42njXJqmwG0EW9aI/ltG2+tmaM4gH0jNy2IHtdrKB3JxdWAjEGA0wljKFiEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kANNGPvQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kANNGPvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C042C4CED6;
	Mon, 24 Feb 2025 09:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740389511;
	bh=xF5oiosf6GwA0WI36ooh7OtTEvTg28RBNQWa5YVRfjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kANNGPvQV+YmI93TmWmzjPHbrIWwwzM9dsnua4Fn+UPMALeDm1TujXAwen7JRdNyq
	 WyLw7gRGOLEPuT2Js+Poq6rzHOXMgRzp+3wy7vccHM7G05s4FE5MaXkc3MksbcGIqG
	 4VhEYSWn2A/RW/oQAeKU4AHlyxAptL3wmot8WfbY63RfGR166WggVzXPBfvwo+6Gz5
	 7HS3gI1uL/GyPezVbFHgamQ3/zNKsOvQPXi2kLrUBB4HFvkoS5icu7LR2Jvsl15dGF
	 HdJvvi+I+GhZTQiI5XEStbxxdvoJWx+cY6I4MCszrS7tXPhHH7PPsbRx+b8vloHLDC
	 sd63+JgsDMTlQ==
Date: Mon, 24 Feb 2025 10:31:45 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Bastian Germann <bage@debian.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: Correct filesize declaration
Message-ID: <27ku6hjtu52wy4cfixper3k6npozxceouvped5ragjk6vbuquh@2xbib6mk2mmu>
References: <AC2xTDvxLrb9fDp2I7P3JDsI4ZBtGzO3sE-QruF5E6XnVkYJTWianMNi0rLM0B5_2Y5vXfzx1ayh1klhTNOu5A==@protonmail.internalid>
 <20250223141658.5257-1-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250223141658.5257-1-bage@debian.org>

On Sun, Feb 23, 2025 at 03:16:54PM +0100, Bastian Germann wrote:
> The filesize() implementation was changed to return off_t.
> Its declaration still has long. Fix the declaration.
> 
> Fixes: 73fb78e5ee8940 ("mkfs: support copying in large or sparse files")
> Signed-off-by: Bastian Germann <bage@debian.org>

https://lore.kernel.org/linux-xfs/20250217155043.78452-1-preichl@redhat.com/T/#m90c87f94c6f85445432f403c57e8eeb8cf0c92c6

> ---
>  mkfs/proto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 6dd3a200..981f5b11 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -20,7 +20,7 @@ static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
>  static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
>  static int newregfile(char **pp, char **fname);
>  static void rtinit(xfs_mount_t *mp);
> -static long filesize(int fd);
> +static off_t filesize(int fd);
>  static int slashes_are_spaces;
> 
>  /*
> --
> 2.48.1
> 
> 
