Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC8513E059
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 16:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712679737; cv=none; b=q4r7NV4ZCAHOBUo/1NNgrsoLefzFH97JAi4gxSgw4/72A1d2QKezqAStKPh5u5kQQUI6m7jttdpZn9SbzSNVmcX9Eb1N7TahIrrre8djCgMzU3eIsaODwCwX9/gq0OqbViPvE8JM0aaRCPmc2y42bPSRP8vmxRRkMJ/409eQ7rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712679737; c=relaxed/simple;
	bh=oFFzmkQFjem8Slp5pGsd7lw06I6XKAmgxLiAx7XwO9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Omq9jjelIj5586mciaehsVpeQa5lvNMwrGuhrkhxw1kw9cQwGSmOcDkdIdi5QG39w3lDqGoZJnXi43yRL1OS6p+yI0MgSK/e/udhyPlLlh+4Ol83dBvfOE9BNgLnkYxdSoJnKbo9x3l8UoWbjeOZ6bNTA8ynP30W9iIqO7wvBQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Z7SCVjTW; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Z7SCVjTW"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5aa1b7a37b3so1684135eaf.0
        for <linux-xfs@vger.kernel.org>; Tue, 09 Apr 2024 09:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1712679734; x=1713284534; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ESgWP/mXe1bk3eSSg55Zmh/raASjeDKKtmwp4/lqxgE=;
        b=Z7SCVjTWzGrLp5pMAf1WmKQdPO3YNr7lEywWo4dLGTELvYTyKBHINF8tPQvsZpOneQ
         dJmTZE5k6/o39v+fD0DzQt5fa8pFnQu3D81wfIC7vPxP37hKrexK8ifWm6irzOLM6yvB
         qAXnlsWPT3O4A2W26fuBW2YcZHv86di57MteE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712679734; x=1713284534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ESgWP/mXe1bk3eSSg55Zmh/raASjeDKKtmwp4/lqxgE=;
        b=tKrAALme2MdmdhmNI5faCA38wvMmp4p6UT6OpE3i/7UGFm8gLQUOsFCMaTcylzEXup
         2xwnmwXTF4D8FZD9nU9G7jqDE+ujrZ1yHOyNaiHfV2/4rpRHZ8u2s0GP77CcVYj/CeiU
         2/gMOZ8K/1pUO122fjaw2HN4f0d6Og7JW0ROraCfid42nezm7XbEmZHKpoHP1VHgIwgh
         ND7JN9+/5F8/fWX271DYpljpUvg9WVNYQdjhJlzTfN8TTrrwHT0wtk/48yZKJfHdsQUW
         rc4xVewJKADFH06p/N15U+FxnkNUIOQkgXjOb9g4Eew/H7CDyhU0TNFpZ9RO9xU6kyNB
         OMhA==
X-Forwarded-Encrypted: i=1; AJvYcCVRl4nljqGVmVPVQG68vS6uSQ5KuwCaG3MHp0RQom8AmeVm5fk6ryb3sXraLSzBZrMWVkw7xWfOMHwhMnvv9eun9v85QqvgRHyx
X-Gm-Message-State: AOJu0YxqLTjzvcjML9zd13b06Gww5ALb1s6Rqffi+yhCP3/vK740kvxj
	g454ogLzc0+GdY+PEX9+V3InZZ8QkcXR6UD14ndbGHw/19mqsafGO4cvT7cCsA==
X-Google-Smtp-Source: AGHT+IH+ThkTK2969Ez6Dj2+W99kQzkH7mmsmVKS7EpvhvBpgbL/Drf9WpykDBO7NmDp/3SLAhuS4w==
X-Received: by 2002:a05:6358:5bd4:b0:183:f636:8a46 with SMTP id i20-20020a0563585bd400b00183f6368a46mr350390rwf.27.1712679734649;
        Tue, 09 Apr 2024 09:22:14 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id h11-20020a63210b000000b005dcc8a3b26esm8129675pgh.16.2024.04.09.09.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 09:22:14 -0700 (PDT)
Date: Tue, 9 Apr 2024 09:22:13 -0700
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] xfs: replace deprecated strncpy with strscpy_pad
Message-ID: <202404090921.A203626A@keescook>
References: <20240405-strncpy-xfs-split1-v1-1-3e3df465adb9@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405-strncpy-xfs-split1-v1-1-3e3df465adb9@google.com>

On Fri, Apr 05, 2024 at 07:52:27PM +0000, Justin Stitt wrote:
> strncpy() is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> The current code has taken care of NUL-termination by memset()'ing
> @label. This is followed by a strncpy() to perform the string copy.
> 
> Instead, use strscpy_pad() to get both 1) NUL-termination and 2)
> NUL-padding which is needed as this is copied out to userspace.
> 
> Note that this patch uses the new 2-argument version of strscpy_pad
> introduced in Commit e6584c3964f2f ("string: Allow 2-argument
> strscpy()").
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> 
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> ---
> Split from https://lore.kernel.org/all/20240401-strncpy-fs-xfs-xfs_ioctl-c-v1-1-02b9feb1989b@google.com/
> with feedback from Christoph H.
> ---
>  fs/xfs/xfs_ioctl.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d0e2cec6210d..a1156a8b1e15 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1750,15 +1750,14 @@ xfs_ioc_getlabel(
>  	char			__user *user_label)
>  {
>  	struct xfs_sb		*sbp = &mp->m_sb;
> +	/* 1 larger than sb_fname, for a trailing NUL char */
>  	char			label[XFSLABEL_MAX + 1];
>  
>  	/* Paranoia */
>  	BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
>  
> -	/* 1 larger than sb_fname, so this ensures a trailing NUL char */
> -	memset(label, 0, sizeof(label));
>  	spin_lock(&mp->m_sb_lock);
> -	strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
> +	strscpy_pad(label, sbp->sb_fname);

Is sbp->sb_fname itself NUL-terminated? This looks like another case of
needing the memtostr() helper?

-Kees

>  	spin_unlock(&mp->m_sb_lock);
>  
>  	if (copy_to_user(user_label, label, sizeof(label)))
> 
> ---
> base-commit: c85af715cac0a951eea97393378e84bb49384734
> change-id: 20240405-strncpy-xfs-split1-a2c408b934c6
> 
> Best regards,
> --
> Justin Stitt <justinstitt@google.com>
> 
> 

-- 
Kees Cook
