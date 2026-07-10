Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FF9313539;
	Fri, 10 Jul 2026 23:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783727207; cv=none; b=mPzN4TuOuNHGoBE8f8QVuqqanBtdZqIm5T9R3rp/JcHMazejneo77r5lhpOGGu1lDeDGuAMj8AjoO52VQ3I3yrCUc3BvBzZZjqOTX8hJ8FLPhGune8lNaxzoNlvLr7XlhbV8MI8uHV6Shb1i6vcNDWJw7UnzL3DJbhOgpYcCbu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783727207; c=relaxed/simple;
	bh=c1o4i0yMAiQO42ywmir9kBPguDPE+ayMkOeVSpJ5eNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdY5XK5QcnVr7/UV7Pw8FDvft+G+fOq8Z+b67XI9mnh3mpjso8aVV9WMOJGxTpWMxigTjN+ygOrIvhVxupKeC6xPILyO2CR4/KAX200lLrzMhJsc0dpOOSu87AdwjwFYcknXl/nbbRTnGW+KBVsE95H+YVSLzhqbxKLai+DUJII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PWVBCaww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PWVBCaww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492571F000E9;
	Fri, 10 Jul 2026 23:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783727206;
	bh=zAbiTc7SV8WiZhtg1dsCTH30vdfKHqz6tA06wbzCfJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PWVBCawwijQB/x3en5NPn3juXXtN9ssNB2wEo1g8Hl5QS0+9MAwyDUQ8g1GYPbCky
	 GVh7NfQh7RDSfNvhDuENXbffBuPwDUsTlebfZuonKA9vYyts+e3wNy3afdXkTn1cpM
	 ohcgttvVFx1xb2AcGJdSkpCk2DMuLtzRtREuRy8tgZjFz471v0YOjJl/3Nl6/yFZ7X
	 wCc6Q6Y9d1+8qRLgOqHBkMqH6XmuUtc8CgMkqtqZE18+vWI2wIKHzj+Tyjnbx5d5lQ
	 jYllwlbEIDK3xm4CkL+6J114aktvnqw5qfk+3JYcc2ea5fM3idvU08Iq1JtAOlJ5g/
	 J4hKNV5Lc+Z6Q==
Date: Fri, 10 Jul 2026 19:46:43 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v11 06/20] fsverity: don't allow setting DAX file
 attribute on fsverity files
Message-ID: <20260710234643.GF1911@quark>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
 <20260710085256.3464201-7-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710085256.3464201-7-aalbersh@kernel.org>

On Fri, Jul 10, 2026 at 10:52:34AM +0200, Andrey Albershteyn wrote:
> When fsverity is enabled on the file, with FS_IOC_ENABLE_VERITY ioctl(),
> it checks if file has DAX enabled and fails if that's true. However, the
> opposite case is not checked.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/file_attr.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index bfb00d256dd5..5424ec4e3949 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -246,6 +246,11 @@ static int fileattr_set_prepare(struct inode *inode,
>  	if (fa->fsx_cowextsize == 0)
>  		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
>  
> +	/* Can not enable DAX on fsverity file */
> +	if ((old_ma->fsx_xflags & FS_XFLAG_VERITY) &&
> +			fa->fsx_xflags & FS_XFLAG_DAX)
> +		return -EINVAL;
> +

This sounds like a bug fix.  But actually ext4 already checks this in
dax_compatible(), and the other filesystems that already supported
fsverity (f2fs and btrfs) don't support DAX.  So I guess this is really
lifting that to common code?  But the existing check is still being left
in place because it's still needed for ext4 specific flags anyway?

- Eric
