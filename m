Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700153;
	b=zXOfB5cefVG8nSNwBhj3pJpRlY0X+949rVkGUlbQ6IxMLui2S08uKFeNokTvVCIRYvl+
	 hNbvvzlkrEcnNmHVZqR5uAgGzU76NFt76WXdIDHwfkhcC+Ne9EWFgEXjRT1fbOU6JIz8Q
	 VwkWkzUycxIpi/IIVFihsmSbhugenGtH48Bl/hMfeWT4hz5N5oxtay+A1g7q8mpTh6Ymd
	 +PYZ4vzAEJqFk29Sdpsilf5qeUwrMElxYMvEfTKc83gHG0DAvPLpK3sfkMya9FFS8niXi
	 mLn4JSxITZPO8dZdsGKOHrZK+Nz6KZrP3q5l4AOMU77O5cvgOf0jNA1GraVFUxUSHFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700153;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=ULJ2TWBBVlC7sChbQAFH+ZA6jDL8UwnJ6JcCVc9Wk4o=;
	b=w6KKvZ/vR7stIZZ4t9XkIl/h/d93kncqz/jKA30JzUdRguGWHCq/xTDI/GeK84JOkutd
	 +W9XBWPJ3a2q7VI1IzBFTet1TzbqRxti3g2dpWkCG5sB45RTj9ksJfwz5YRSwqBMtk8MB
	 Vvl3GYYT4LbrhgRLlEcxgHRjhd6hgm4rdiuTPOITndaQjQ4+T+pLjcynJ8pcX8pnQOXBO
	 z/ig3uZAj1eeU+xa8GZhdLwl6YzLSOVne6tnE4GRzmh2xm0z6yNRFpIYNxapFI538Qf+t
	 UQy3OodsHZAfrUCFr81L6LD7XbAU5Nh70J5OXpfTgdB3x7bpXtdv0BLogISYnm1csIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dZxQBwCK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F54606C527;
	Tue,  3 Nov 2026 10:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dZxQBwCK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6110F1F00919;
	Tue,  3 Nov 2026 10:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700153;
	bh=ULJ2TWBBVlC7sChbQAFH+ZA6jDL8UwnJ6JcCVc9Wk4o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=dZxQBwCKZp6ENatcmC1DY1D9wMFFWbEFBEmtWBGwt1Bh4pIJyemJPIVxhRA/pvLNn
	 e8999By5yf9gfHjMSwmLD9MRakff6Cd2BTqtibM8niq6J0Vq33XEEYCSi3QPnsMVVb
	 DX6quUR7P3TlwKtCRYGdlrLvlmyDwDkLP9UWZ6DWc7SEHDhoeT+w2cQD0iiDK42ymP
	 D/MA51dapZWmc6DCioEWFkj5BcfmyPgmYDf7TBajcoMx9DSQqAQuO8TA8ZoTLIMOXG
	 1KPphhMXhoAFrlBiNuRg5hvh1WwqOu8rpq4ieEZ5WYqZvlvAMziBPMoz6ykn48WAlz
	 nI0nH5+26OASQ==
From: Carlos Maiolino <cem@kernel.org>
To: =?utf-8?q?Adri=C3=A1n_Garc=C3=ADa_Casado?= <adriangarciacasado42@gmail.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261020195628.248878-1-adriangarciacasado42@gmail.com>
References: <20261020195628.248878-1-adriangarciacasado42@gmail.com>
Subject: Re: [PATCH] xfs: add __printf attribute to
 xfs_buf_alert_ratelimited()
Message-Id: <179370015211.413123.4983220960926610415.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 11:02:32 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.14.3

On Tue, 20 Oct 2026 21:56:28 +0200, Adrián García Casado wrote:
> xfs_printk_level() and _xfs_alert_tag() in fs/xfs/xfs_message.h are
> annotated with __printf(3, 4), but xfs_buf_alert_ratelimited() in the
> same header is missing the attribute.
> 
> Because xfs_buf_alert_ratelimited() formats its variadic arguments via
> struct va_format and %pV, the compiler does not suggest the format
> attribute under -Wsuggest-attribute=format, and callers do not get
> compile-time format string checking.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: add __printf attribute to xfs_buf_alert_ratelimited()
      commit: 976d3cd5b0a307881a0772f2fb8d4557c2f4994b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

