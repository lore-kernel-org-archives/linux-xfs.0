Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792575407;
	b=pHF2bPikNZOeP06dWHXrjapMmX2vFtVbudp7pLtrenjxsTlIF5zJNyHPkgFH9+55mi1A
	 AgluC792tFzSustlVdqM3geEsbKrvsD8PMy0KfWF+KPtUvpjjArgTztJiCpOnIRFG2Bsq
	 Z6vIH2flHTdvl3D34hBiCieTDJIcIZoGK/Vfd+/iyporGC7NG/8BPstG5r0p2DU4tjZKc
	 FLY/uloifOuWTntJboSDZvhLXN0RRgpTcQEiRKFKoL3w5tVSsNfSQcedu9xJQxsQ9Gguw
	 /6WkOSo1MGFqF2WrhdyKUziNE1dH7guNLjaKsUXjMit42H8ADdJ3sHDEa55W6/m99EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792575407;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=myYPsnDIKAuucBhzxqZdnCPsSN9YAg5Y0A9mk125+Iw=;
	b=1nOeJp77EaYA2ma1Mw60vg2cL+0EiAY4dPg/LvdvALX+ra0U7aoOJEe7JV3tDGrFLDBW
	 hcRRd3OYlMIDp8jCDlJvNjju+pCWZaTmcFxf/NlM2x8LETvPznBEZmuSz79apAOHZpUhq
	 kHvHu8f9BmCT+xvq2Xpck7vgOkTcSv/iDASlHEbig+S68X0tIA0qk2Fwy/nVgth7zSHqr
	 35O2SR55gtRUbNIB91SH/5kG9btWL30zm1AJRvvat74u0v+Y+M2huC8TBMJquRbI05RkN
	 vVhDNuc7w8Z46jnccRa3Az8ZpeXxq8GSDSUHOVV2j15cxxIGfx1owYSN+TbMbZGOn8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oaaCvUwE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C05606A31A;
	Wed, 21 Oct 2026 09:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oaaCvUwE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA831F000CF;
	Wed, 21 Oct 2026 09:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792575406;
	bh=myYPsnDIKAuucBhzxqZdnCPsSN9YAg5Y0A9mk125+Iw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oaaCvUwEvhPO3748dAmOesQd/UtTmpRCmeI5pNh66/sOjI5iYYGO/ImkyTrBcbwSd
	 wRsfRiiP+8ODs4A1hb6TrdftaBDCiGjwI0buzUU0P6njyyHu4IzuMiFCOfzmGDTAsC
	 42QBtICuHECFJkaQsfwM8ndPS8YPWQJ8aG6pWuki5VGUJIwwUuuuS94HO6Qn+jbmd6
	 03yIaQoWkxWbSu2i9yomv4VpVeS1qkmvQBF9D/KU5g+mdcTYa5uiRpRnhgJU2iU3yu
	 pDj+lOkdLNCNSUCm67V+LGtouItZhJQV1ouhjx7jCPo0+C8iefHJbbh4XvrLvCdQkV
	 A6OltY/OcoeqQ==
Date: Wed, 21 Oct 2026 11:36:42 +0200
From: Carlos Maiolino <cem@kernel.org>
To: =?utf-8?B?QWRyacOhbiBHYXJjw61h?= Casado <adriangarciacasado42@gmail.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: add __printf attribute to
 xfs_buf_alert_ratelimited()
Message-ID: <atiHnmKqL2TNNNVm@cronus.toxiclabs.cc>
References: <20261020195628.248878-1-adriangarciacasado42@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261020195628.248878-1-adriangarciacasado42@gmail.com>

On Tue, Oct 20, 2026 at 09:56:28PM +0200, Adrián García Casado wrote:
> xfs_printk_level() and _xfs_alert_tag() in fs/xfs/xfs_message.h are
> annotated with __printf(3, 4), but xfs_buf_alert_ratelimited() in the
> same header is missing the attribute.
> 
> Because xfs_buf_alert_ratelimited() formats its variadic arguments via
> struct va_format and %pV, the compiler does not suggest the format
> attribute under -Wsuggest-attribute=format, and callers do not get
> compile-time format string checking.
> 
> Add __printf(3, 4) to xfs_buf_alert_ratelimited() to match the other
> logging helpers in fs/xfs/xfs_message.h.
> 
> Signed-off-by: Adrián García Casado <adriangarciacasado42@gmail.com>
> ---
>  fs/xfs/xfs_message.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index 811b885f41..bfae8dddc9 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -87,6 +87,7 @@ void asswarn(struct xfs_mount *mp, char *expr, char *f, int l);
>  
>  extern void xfs_hex_dump(const void *p, int length);
>  
> +__printf(3, 4)
>  void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
>  			       const char *fmt, ...);
>  

Seems reasonable.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> -- 
> 2.39.5
> 
> 
