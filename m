Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795457944;
	b=m7mKSw99wmxmnwWuJuMNc95vk74Cl8o0+FjqpXZctcwv5j4RbOp/05vuiwKGI+AQ5X1T
	 ljLEh26ah+40Zrct5I/yQUM8yLnCTiFMVSTPytv7IlzTg6QCNiWwdm1SgAMPm9hK3+ENb
	 fOx4DFpLuKRPJ6c8891IkhlbeFhLnkqp6JJSAWIsyxqx5r4VTwyloZ6YRh9B472Zz74ZI
	 rUs+n6b0dqqhV/404wue1lWVhlyDqleMEE/XCjYQAweQnk4c3X+KCxS2mNY8w7Tk4Uux2
	 q/ATczSgbAfW5q+/AdFPDqpZOFvQuXeHrDX4c74tLQ0U0pbUXo6Hjjg0CS9Qhpnb6pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795457944;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=u6X2E0XUgIO+iKoQD/SNiDFffgouosxGaFf5DehOZNA=;
	b=Gf4nXGu4vkp+ecpY1GjendJmqadboxF5DjH/acNDUTx9JqPypQ71J952L3MrFgZ2mA5w
	 gk56zSpyaGSf5CdzhdzGWFuU61oewNYQoefuyCfLYQVkNYJjF8gHAMwLYeMdzhqS+4a1d
	 sp7tcLmKyK4uMcmnlOX0w2cm/H0jMFWf5xGdukodAx4+GbTukoviGy5aBZinq8yQGSGB2
	 jjG/6opLTnTsHHzvw3IdIwd/aP45HiWgr4yswQtLMf5DWYrbsQgJqY4OD8gcgpO8P3UQJ
	 b1zzsTrpAqERNVSNajzMcoO+zF4NKncF9waQnTor6ZLEbJhmUJeyIOQ5iVAMmH7CW8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hpgz6uT0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC65606A32D;
	Mon, 23 Nov 2026 18:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hpgz6uT0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920321F000C4;
	Mon, 23 Nov 2026 18:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795457944;
	bh=u6X2E0XUgIO+iKoQD/SNiDFffgouosxGaFf5DehOZNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hpgz6uT051pI6IVUFBVPt8R6H8+PpzR3cnm0zJA+v6SfGXeqaZX07vaJ5GdRfxOO0
	 BkxyCMegj0h+sItLamcfEhVOtQOFYBgtkhNEoL8HQiG/g9JrjbsAQMfizgSj/gdrFB
	 xXGE9/AkzkLYJrtiGZb792MoBGuZM6uG9Vu8ztK7CZ/fG+qRJuvfFUxp1wWI4yR6VR
	 amgNmgoPblLRxAhSZu6IciIAXVQjIx9MCHZFXfVFHXeUKll2kcwyfZnG1Gm/NwY3G6
	 hpmeJyuuqfP8zVqSOgN0UBb5f9XuaOXM21e+Fij4SQHoHQbWwaDaBky1mvpdHrvBUF
	 qKAf1PdrqRYPw==
Date: Tue, 24 Nov 2026 02:18:53 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 05/21] fstests: add _require_fanotify_function
Message-ID: <awR6WGcokCWeZVal@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <16d1b43e27ee01742eb6a431d99a738c0696a94f.1791272793.git.asj@kernel.org>
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
In-Reply-To: <16d1b43e27ee01742eb6a431d99a738c0696a94f.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:31PM +0800, Anand Jain wrote:
> fanotify support may not be compiled into the kernel. Add
> _require_fanotify_function to skip tests when fanotify is disabled.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index b9481ba8ab55..0fcc1a614ad1 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -6384,6 +6384,13 @@ _require_max_file_range_blocks()
>  	esac
>  }
>  
> +_require_fanotify_function()

I'm not sure if fanotify_function here refers to any specific function.
The name makes it sound a bit like "a function named _require_fanotify".
Could we simply name it _require_fanotify, or perhaps _require_fanotify_enabled?

> +{
> +        if $FSNOTIFYWAIT_PROG 2>&1 | grep -q "Function not implemented"; then

What if there's not fsnotifywait command? Maybe we should call
  _require_command "$FSNOTIFYWAIT_PROG" fsnotifywait
at first? Alternatively, you could check this in src/feature.c by calling
fanotify_init() directly (so we don't have to rely on fsnotifywait).

> +                _notrun "Need CONFIG_FANOTIFY and CONFIG_FANOTIFY_ACCESS_PERMISSIONS to be enabled"
> +        fi

This function uses 8 spaces for indentation. Please use tabs instead.

Thanks,
Zorro

> +}
> +
>  _require_fanotify_ioerrors()
>  {
>  	local x
> -- 
> 2.43.0
> 
