Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B27B2DA750
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 13:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769174602; cv=pass; b=GqfnSpZyUgChqlPBQ1rJjUpQrdhN/89TU5CZWlKvkjVCZG0IGiuNKKt6BNsEakHoBnsh2WsQGAL8VCfBcNCTrNENmBmZPTYksd3IWgLeIe43y5qksV0aiDsHWiVLjj/63+TLfyxVnJzZN0FMqts3s62hVmK59ysfQ9XmnOZ9mto=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769174602; c=relaxed/simple;
	bh=2yMX4KMIacTi5G1FaT6jVtT+6BVY1UFvsXDRT1eQCDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=MWQOoQqUS9gE7/J4rleJrBwWaZSpr63rO83Sc7hwJ0OXwzzPqrt76odrAiiLKqrtkzt2y3IVqr6AhApFYx2avFteVynHqWttHX2Kq6koELdhlwhuZPyQ5I12fw51u0lvjYkWxEVRMjH8c6S2K6zGSrAB3Avj7o5yPT4bnsUfSkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NkoyQRiZ; arc=pass smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NkoyQRiZ"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-93f573ba819so682695241.1
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 05:23:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769174599; cv=none;
        d=google.com; s=arc-20240605;
        b=f4IVOviOVc4aPHVUZNwnCu6roXfbxBi4mIpCJdNy3WJjmT50GaGz5XGWBLahdnL0+2
         tfkF+n80OSzPcfvgoyQdnd5Sgz+k8YWR4raXEJI5DF/1L7CZfMakZRNPVq20vl+JkWxi
         9SXB4ka3kwMnfKtRgwfX8h5Wo0Pew/LiZXexPCxqKg3/p1aPew5UVOPcykkQxmU8EpbL
         a75zIfM3qozoLY+VGpKPcnDdR0wz0sQa0TcyT0zb/m9/y0b5FvG3y0OHOuxrKCoHkE4v
         OCW5eCA6Zh2jBlEa1fTXdyufovgF5Y8FMtrch7fe9aeN3ExgIHtZLzydFD9i/jFGOzHW
         h+zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=an5pupjXgIQPeCf/UmDnIpSea/cRkdaOPzIbp8qXmEc=;
        fh=Db3JiawPL9Nhx/L08x38jP26+HOJUcgbxe8z9wxW+Wg=;
        b=b6rZJbgSnezQT6ySs7CLmAbN/mvBD92A9mk0WA7IzHYKcVRJFmybyv1i+MA0XurbiF
         NBWi5WsXEoL5Y1YkLB+0knvgO+x4fz96htxnkrdyNtkjSYwKSfYaqUMg4ohuQonsTpxk
         RtG/stbwZ/Fi5r3FwMdhlIQB76e3u5BpRfZZsTd3CQqKvVZaWS7CESWA3+WWAUIzEY8H
         /98Sa6k+x5N/lL20L6meofHwQkZ74w23A2kuM16Tz9lXFWywxsFA//UyEaoFQZAZF338
         Rryf9zSIbolcFDkDCgyBl/W6i+P62IQIOEMItASzG8Z1NNTDthuL2Q3xbtQ9o004a3zU
         BTRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769174599; x=1769779399; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=an5pupjXgIQPeCf/UmDnIpSea/cRkdaOPzIbp8qXmEc=;
        b=NkoyQRiZO9++ahzHH1OJ5cCT3E2o0WVv3qA2Qem70FoCG8ghW61cHe4bSRBatgsOm5
         A9UVv1hPLOdqS7Om0j7zlcMFFBFxVAx1uBlswhWJlXn3OASJqKNdFhdsiFhkTqg9kX7H
         xjegM32LrT1LO+E+NmFwksOsoU/PioZNNfbxLms6YJ73QwTqql0xy6uHu8v6t5HbKdX1
         i9yLP0dUZ+jNxtpqiNPKX3OTx+CZM48wY44I/D/1o6pVuDZ/7wY+Jlkug/UcX9Oi+mCW
         OqBmRXD2GC/fp3HrUbK+h4svEPIprnXIEdwdawESvoKrh/ycipkVN9urALaU/ZPu6A9e
         gyBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769174599; x=1769779399;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=an5pupjXgIQPeCf/UmDnIpSea/cRkdaOPzIbp8qXmEc=;
        b=VtZG0Vff86ROk5VP1+R7ZbQp3WGrmGaDGSYiLOSzmOYWMZQ+ydfyAHSG24bPxHofaE
         zt9DsQQpQ47pTPfEam9kSdKSEUx3SW8GgO0NAnewp2OVbgE8N5oIW4d4FpfBrGWO3Mnd
         /F8W56qA/pPQOYISXCLW/Sm0v/9Zb8B3fQWnZ7+burusMekPWA8t8nPdqjogYVegaRbe
         4I28sSzZhPdp93ITFi44RKtYtNGULAx/H7SQP/vMfkGPiovtbdTsSCjIqpjmljHRXbOF
         lSethdBiYD+/FB3p1aWzpq5joG9VBOls6Tfbm84i+vMzetEzupuT9DO7MNYaIUyrmEV1
         p80g==
X-Forwarded-Encrypted: i=1; AJvYcCX1KtcIGsaH0GIZfXtDMC+7Nsdb5AuSf+kJh4x/1k29UJps1qX8BMvzG1V2dDcUbcww9h0vX5cNhDU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFKOr9oRfTh1iHuoFmMnpUooP9ZRqnv4G++BDe1N03cR+HeljS
	fxzyaT8TNx1ZboR12exFjVLnCcmJVgQzjeZRHYC2nVBVqc2HsR+Ph6cYGfzeAWOzJAWeAGG52mn
	7s8hCVy5dnJYkcZ0ZRzjGKNlyXX1+aTs=
X-Gm-Gg: AZuq6aKKN5DYSzmf2LsbFHtACFX+7pT5bv1qxFOAUYv6S0hGjj4pWqY7SozptZ9EEW/
	dFm/jUIllAEy7F8/plIjMSLy1Av0E11XvmWEodrDLyNpMgdDskkddCChnEiO8dpFbEMYDzXt0PX
	EfDE4qKJpBFyIj/9spoflM2Swtt/6g0ClB2mxInO950loPI3AaDNg2A9YDm1kVcpML2UhdSVN/d
	kNtUY4U0+lctrdBih3vMNC8+J+mS5dcvGwewkKo6UtOoKUKXa1KBFLXGvviimQWnVUto0U=
X-Received: by 2002:a05:6102:38cb:b0:5ef:7220:bca6 with SMTP id
 ada2fe7eead31-5f54bcbc2c0mr848495137.33.1769174599222; Fri, 23 Jan 2026
 05:23:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120142439.1821554-1-cel@kernel.org> <20260123-zwirn-verfassen-c93175b7a1ee@brauner>
In-Reply-To: <20260123-zwirn-verfassen-c93175b7a1ee@brauner>
From: Cedric Blancher <cedric.blancher@gmail.com>
Date: Fri, 23 Jan 2026 14:22:43 +0100
X-Gm-Features: AZwV_QjeaJNq0W-Cpcx_JErnCmrcMqvA53IgZ6NSy4KMyZ7YPDQ4CrxDdLy3saQ
Message-ID: <CALXu0Uc3gkrCmFApP1xswew9AmfotgZXR4uZXr_RetyEtC2pPA@mail.gmail.com>
Subject: Re: [PATCH v6 00/16] Exposing case folding behavior
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 23 Jan 2026 at 13:12, Christian Brauner <brauner@kernel.org> wrote:
>
> > Series based on v6.19-rc5.
>
> We're starting to cut it close even with the announced -rc8.
> So my current preference would be to wait for the 7.1 merge window.

My preference would be to move forward with 6.19 as a target, as there
are requests to have this in some distros using 6.x LTS kernels (Bosch
for example).

Ced
-- 
Cedric Blancher <cedric.blancher@gmail.com>
[https://plus.google.com/u/0/+CedricBlancher/]
Institute Pasteur
