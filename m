Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEDB3DA5C8;
	Fri, 24 Jul 2026 23:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784937442; cv=none; b=OU9tL6XqJr7wKpBY0AN0Kq+rP47na63K2aE1OKbu6xvhEBBwMFeZITUWbr6uzy3jK29+NJdYMybxT+lauT3LlesdSwza765O/tbWME9E9z/o78WlN/uFSI7NEUX9mAhXbn1L2YQ0ICW1bmKrO30i0Z1vf4+6hlkRZzqFYahcGJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784937442; c=relaxed/simple;
	bh=x4ET0oX5c84OaI7oaJSmZZmMTIK+waQe8b9jZBHKokE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kPJPiexzf+mnMZu/3NWqFOCK9J7AfbnfhSUJVbSKh6P2byvrS6IePH/GqV0C6JUCqiKa/09pl0LnH7AfFQjalzERCt2+2PYdKt9FE/XNwAE7w5WDuG56nqYdIZwpNYFNlyo2nRUxQIE00xWM8XQRGVLJV6UHOmRHnVVQeMbhEDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bCyKY8CI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bCyKY8CI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E051F00A3A;
	Fri, 24 Jul 2026 23:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784937440;
	bh=C0S2kswV9X4RK00vTenlq33sqHknnXJ8l36Z+cCOrHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bCyKY8CIpwOcIVw1Calx1/kJVRmpUX/mI5E/uRHL73C3zvnjGYkeZAaOuSttdlCJn
	 vGtG9tlRK+OIfFnqFI30F55IEOvHX0mgkuGh/wwwos2GzDQgwses019ZV3RUUdxsWg
	 vBwn5mCKUZahVt1K7KzLqBzaMxBevZWGgpvu4KdBwGF491YQbaELDtUN9nKwF3acGk
	 np25i8NMPwSxnVvBjkV9iCbyJ1sJbAMxAssmBpAbdD5PKAWXnxHrSi/t4KU6OdGrqD
	 OJIhZlZR+SapJdQ1a3vASLffq20YPOFz7MqlThxqSOvv6cMuxn51B9VnSaY+qaJyjn
	 Fd1j+SiJ9Uf/w==
Date: Fri, 24 Jul 2026 16:55:28 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v13 06/23] fsverity: don't allow setting DAX file
 attribute on fsverity files
Message-ID: <20260724235528.GD1901@sol>
References: <20260721184346.416657-1-aalbersh@kernel.org>
 <20260721184346.416657-7-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721184346.416657-7-aalbersh@kernel.org>

On Tue, Jul 21, 2026 at 08:40:43PM +0200, Andrey Albershteyn wrote:
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

As mentioned elsewhere, this is actually already checked in ext4, and
the commit message should mention this.

Also, I notice this function already checks conditions on when the DAX
flag can be enabled:

        /*                                                                       
         * It is only valid to set the DAX flag on regular files and             
         * directories on filesystems.                                           
         */                                                                      
        if ((fa->fsx_xflags & FS_XFLAG_DAX) &&                                   
            !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))                 
                return -EINVAL;                                                  

Could we combine those into something like the following so the DAX
enablement conditions are in one place?

        if (fa->fsx_xflags & FS_XFLAG_DAX) {                                     
                if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))          
                        return -EINVAL;                                          
                if (old_ma->fsx_xflags & FS_XFLAG_VERITY)                        
                        return -EINVAL;                                          
        }                                                                        

- Eric
