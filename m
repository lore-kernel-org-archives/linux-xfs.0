Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA34924466F;
	Mon, 30 Jun 2025 08:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751272744; cv=none; b=KnbMNBIP+qJ14gXeAf+/0bDjXvgM2E4APfpKzoJglCFGVZa6SMOSMLh2ijt+y6DyNgX8hS9Ex7cr6rHOJyRlriCcFBOS1zLonh/HCcqLgbtSPiz6NSPq/V0bfBQBYgF9l5NBICvAIHbbYNOENBeITSySP/n1rABW+clwLLST9is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751272744; c=relaxed/simple;
	bh=dXeTuzcgcqEB0p+KJUY9jWL49qMbSvHNlA+EHsWxX3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXhRdl6eKI/Oq3DW5OajA1Oabjt/PUisJkqSFCP0UDttNYa0SVSZ+8hHDOCnEk0zYgRt7OMwu5uZrlOHvnfpydXVl6C6sv1yFP8zZer/oAIDJ8KhNIZfj3teGb66ZL6X99CtFSjnmKuXvKN7J7+kfVFsmC5bB5smxMppWuZ+3+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s3aweSNK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s3aweSNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA1BC4CEE3;
	Mon, 30 Jun 2025 08:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751272743;
	bh=dXeTuzcgcqEB0p+KJUY9jWL49qMbSvHNlA+EHsWxX3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s3aweSNK50ehyIVaU33NZusDCONXpWb2aiAYnt4ufTSqdzqs7WetkbH3QfCmCfawH
	 zvm7sb0KbzUocbZKOdEUotb7GavVcNjIbDb6PaDE5n6AfWLvtjILd7scwmUkrtUXIU
	 5GRFBsp36BLCkqs/YK4Gv+smuEhmw+linY++VYeF92ydNUO6CrLNkyrY5cFET0ex83
	 xKIJJzQr6DLpcifTLnwfqEtxENxUM7C7RR54vePZT7sxpeMw0ni+q69CH9l0MsvUOq
	 5YMF64EW7Sr6sWaZjnnOhM+A22byK8MLSUj42XuiLhoX+xhjQHTwVJf26msZZ+IQbe
	 CHVP+SaBbMwQA==
Date: Mon, 30 Jun 2025 10:38:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/xfs: replace strncpy with strscpy
Message-ID: <qlogdnggv2y4nbzzt62oq4yguitq4ytkqavdwele3xrqi6gwfo@aj45rl7f3eik>
References: <BgUaxdxshFCssVdvh_jiOf_C2IyUDDKB9gNz_bt5pLaC8fFmFa0E_Cvq6s9eXOGe8M0fvBUFYG3bqVQAsCyz3w==@protonmail.internalid>
 <20250617124546.24102-1-pranav.tyagi03@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617124546.24102-1-pranav.tyagi03@gmail.com>

On Tue, Jun 17, 2025 at 06:15:46PM +0530, Pranav Tyagi wrote:
> Replace the deprecated strncpy() with strscpy() as the destination
> buffer should be NUL-terminated and does not require any trailing
> NUL-padding. Also, since NUL-termination is guaranteed,

NUL-termination is only guaranteed if you copy into the buffer one less
byte than the label requires, i.e XFSLABEL_MAX.

> use sizeof(label) in place of XFSLABEL_MAX as the size
> parameter.

This is wrong, see below why.

> 
> Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> ---
>  fs/xfs/xfs_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d250f7f74e3b..9f4d68c5b5ab 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -992,7 +992,7 @@ xfs_ioc_getlabel(
>  	/* 1 larger than sb_fname, so this ensures a trailing NUL char */
>  	memset(label, 0, sizeof(label));
>  	spin_lock(&mp->m_sb_lock);
> -	strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
> +	strscpy(label, sbp->sb_fname, sizeof(label));

This is broken and you created a buffer overrun here.

XFSLABEL_MAX is set to 12 bytes. The current label size is 13 bytes:

char                    label[XFSLABEL_MAX + 1];

This ensures the label will always have a null termination character as
long as you copy XFSLABEL_MAX bytes into the label.

- strncpy(label, sbp->sb_fname, XFSLABEL_MAX);

Copies 12 bytes from sb_fname into label. This ensures we always have a
trailing \0 at the last byte.

Your version:

strscpy(label, sbp->sb_fname, sizeof(label));

Copies 13 bytes from sb_fname into the label buffer.

This not only could have copied a non-null byte to the last byte in the
label buffer, but also But sbp->sb_fname size is XFSLABEL_MAX, so you
are reading beyond the source buffer size, causing a buffer overrun as you
can see on the kernel test robot report.

Carlos

>  	spin_unlock(&mp->m_sb_lock);
> 
>  	if (copy_to_user(user_label, label, sizeof(label)))
> --
> 2.49.0
> 
