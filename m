Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272AC449B3E
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 11:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791460023; cv=pass; b=JrI3Vmr3ePL28WQ99OnNwOd88qyzWIef4KPpNVddJiGu02sZK49w9oxA0UjKF36INB4O6dJaCeHu+bqU7Pzz19iHZGxn6M3XfXpLSi0bxNPNOAdgwgYvvpRhOsH5MOhWJKHoBjtPo2NVMR9KPrVuX8eajL/uf7zpH4lfMjMlvEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791460023; c=relaxed/simple;
	bh=CO8G9SZWedbhi+5xtVQ96NniUgT/5lP/6mxDhdyYfZY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S6inFBiJtr5XNWoTRBue8x5qJdOD4uPvb69dPpIu13Vw9r+cWQ5FRVAXjmuzGsSBDpjRkao3PvguXf9uG6oloE855fAboChxft6RnL6pR0Bt76BU0I+JxkehnEB0eNwsU71X4A7jOwnK4Zb1XDrFgo4O7Ro65AUNZlzYLP85mdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jJ+xJyCe; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jJ+xJyCe"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b167ffd132so630531a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2026 04:47:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791460020; cv=none;
        d=google.com; s=arc-20260327;
        b=U3xtzYQAwzwGzNuq/ZRbHdPfm9a7I3S9lHCOlvNSf0H8FYPXUm7Pk4MwMB2LwvVm9l
         krruIKDzbVODzuAGd0E9ZwK/DvhA8b3r5RcIVKkHOiwdpAxPmwXUbIH+HcCdoDBFMZUR
         kt6I395j+AMm3LDWUJPI4+hz9mua26mgBevbfRv8/t4DTpJagn8/42EqmOWhZ5hxE167
         59EHINdkYyjS94PKzD5cZt2kwJtbqB1j9O7VtHL4LFkh+4cYJtSpPINhk9RAr9m5hXT6
         gSTtOxNJuv87RLCt2e77XOOw979KuDYwkLo7DVyvFfn0WL6lPoz0491W4/Cy5CGuztN3
         NhNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HscJ85yNflaCGUtE9aXyJSmi4cngI9gxLp0qRPoZO+s=;
        fh=RoBGjlzbunbxYiYHeOlGRsnLinqmccxwXMgn1Dk3MVo=;
        b=fVSAMxL8xtzVbdrHHCKQF/ftYRzc7W8Nz0vn7/CKpf/mX/q64U41kCu20NrZ996iY+
         ajhGiSK6wENFAUW+gPDv69Jc7BjnW5NF9pppYt2pmhFwKuBTB+mRRLEYBufs0sYrax3C
         Tku4zoYjB5TKD9Fx5y+FBrWDrJe8WHD5dKfN1I2WJbZmhMa+H1MPjGCxVA+B9ZV3Kp9l
         LNFcELYyC8rmFaQP4Kc8xCH/AFTt+Hky1h3hCxyBwiTXgWsdHUKtz1576N03VS46t/HM
         VwLNP5rRRDvtI7nAGXv87agRtE7dC2TXwnBdxOOULFX56Lh0YwtaEQIEtcRQzF0yNJx9
         Zgzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791460020; x=1792064820; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HscJ85yNflaCGUtE9aXyJSmi4cngI9gxLp0qRPoZO+s=;
        b=jJ+xJyCe4sdFEFE87hvDAcuIjvOOICouw0tpcoas3kR3xM74p1X5mt3F++VUrSowg2
         u6IXFVU5R/d+CxETV9jhxc+ss+XU6Csp0lv0WGciLm/+0DcgYR56hBii8uUF77eOWKkZ
         wpy5Fy27mC3i5BfIdra7036TEXjquXlfLf6FIywDTnMRwMnKDazdbRhDSzRvcH6ppPpu
         2F8KXccxE+j0E9fOikO7mzt3eV4VKOhfRoEx1Vhhty/AN9OTcxlZW/uLl9V1pGikUUCN
         EcYTJZRFMrM0Y/bFru8LcnDABV1zrAn87yc7O2NJQEcchfPdEQyVGa3B0IOqiJ7dknCV
         fGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791460020; x=1792064820;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HscJ85yNflaCGUtE9aXyJSmi4cngI9gxLp0qRPoZO+s=;
        b=2YTZvkpKTktJgwpAIU4ZBVG+15NAu6C2PjZgjnBLcWq/4R3ZMROcHJs2UUwtmndvEe
         FL6AK8jkLgB42eEmARnrfC6OSYZvpejs+yOoDHAt6dM5ak4DzxYf0oGd7dQZx+yTpk3I
         OCtGZNmV2LoY/QLPhIbSJ3NEgRgRe2ocl1Dt5GNwsaLg2MavDriXkpPJNgxB8me/RGfQ
         7EUcKsQeWFRUFtg1lRzj+mvzVy9kQCOgPXm4U+cJUZaEH/qhVOfYYw+7uYZtj7a3jYPQ
         7/zEddk+pYGncIDrjrCWf3/xqkjciDgNCZVtYoy6Osa9299+dlGdGRbWpqbvaVNDQsKG
         9O4Q==
X-Forwarded-Encrypted: i=1; AKwUvBx+VJe68h/IaAkXOS2eSyCpEMQECUTYZwr2qDJPRlPKQ5A2FR55E8AeSHN4pTkBWNTdSsL7Z+td0G4=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ+szOer0PQq6RBRR6GOEq915NjZFexFeyO2s211BESFsMEQSVS
	E6UNjYjElVV3jSsNbjMk5wmuG1MRJZqEo3Cn7pwvhhH8+A3hCu5tV1EVuFnP7na1/FYu4a6ZwJn
	4XHmvi4vYMKx+lD9CDChPIX0gLcowWg==
X-Gm-Gg: AYBFou17/1ejkjIuBS3BXHLv2Pkcj5gcVqHEEjhLNRRuk78HybCbAghsO7rFEsAhIar
	S03BGTrRsjTSm9ALItVmF9hlfpYk0X84dtH4arD2cIBKDoONYyyJgAdRo9bb212GtGn/ENkYP66
	cc6vTIpEqxe2jXnbB4goTDmjKfiryYxNvYm6wGPHmfSjazWvOQqI8LVaw6yQQc4rWp9YsMRRkmR
	m1jY7YJzrGr1/frUYyEAGnDod3BtqA9yCk+OmAsxkw5awL2eTPvN/XiMzDh8do48VTJ5wEt2mV9
	8Rq13jYWlSpYnG9HELXny1RRIKZ2enHWG/PfDybxFrjENy1PIDVikGArBoql6ENqE+S0/hFUFrf
	0c7k3maDOsuxOvOXp+yhTjjD5TfU+wQR5amQkpG2PnopLD/JR0cis3g+pJX+kXDg=
X-Received: by 2002:a05:6402:a0c6:b0:6ac:980f:315b with SMTP id
 4fb4d7f45d1cf-6aff4591ffbmr4517486a12.22.1791460020083; Thu, 08 Oct 2026
 04:47:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-6-hch@lst.de>
In-Reply-To: <20260924100032.2733101-6-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 8 Oct 2026 17:16:22 +0530
X-Gm-Features: AclHuK8vcwC-F7HYofed39vmarIL9j-KUcWwNdTgImZwbLqxh0Xib30p2nmAgMs
Message-ID: <CACzX3AuHPCbqDPV3hMxkE+wZfcPpaydDO1UVnC5Y9WeA7ym-DQ@mail.gmail.com>
Subject: Re: [PATCH 05/21] xfs: introduce XFS_BLI_PREALLOC
To: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> +       if (bip->bli_flags & XFS_BLI_PREALLOC)
> +               *nbytes = xfs_calc_buf_res(bip->bli_format_count, bp->b_length);
> +

The *nbytes assignment here is immediately overwritten by the
unconditional round_up(bytes, 512) below, so the PREALLOC pre-sizing
never takes effect. Move the PREALLOC block after the round_up line.
