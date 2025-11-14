Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B45233BBB1
	for <linux-xfs@vger.kernel.org>; Fri, 14 Nov 2025 17:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763141317; cv=none; b=kz46mjGeWBQVEK0w/xhbZI0RakaUpUGhFM0I5ONLFA2fKfNfb0V7merNto4tLduQtSeeZLTp4Ho5AiggImjmBnZagtf3pi4C2kWblH5A6E+LfX8/1YN1E+WWRH2sa6UcJXhSdI8gZCzdkvTaw8DMdEHAFGub0nWt6IOnCIX+nP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763141317; c=relaxed/simple;
	bh=0BQJjPCgi1Ks2wufI3U7irPuueJ3BznprLLd2GrrZ84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ygds/kKjlv8OoV1TsQ5B1298sHm1zT3S84TQtHJRsDQfJbcs/WxpRYnv77r30BOZ5V3YGlD7tIzzBdSfVqtqwUCDfrR6I7vKlCrduwj32FsxAWEfMkWgm0RlC0y1PW0PwQioL8WQk/4MBFyA9Coy7hRhBZ6yuR8PAooJ6TA76os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TEJ9waIg; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TEJ9waIg"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so4036885a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 14 Nov 2025 09:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763141313; x=1763746113; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iHdilhx9M0Sn5mPxaXisVhxNAxMfQTLffsrPcjjnXqc=;
        b=TEJ9waIgLzERVE8zl2zorN6cngl52YHVBHML88m0/s7YR+Kk93qt/rwwfrv9Xy25yu
         haBjtY2GNiw52LL/kOIhSh1tTHL1eLDqMlSV1NyasyTdnsapMqu9Cky+3pOcmDcZJSPU
         mtH0+FBUT7PGHFq2O2KdRDjo89q/rHlflBChA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763141313; x=1763746113;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iHdilhx9M0Sn5mPxaXisVhxNAxMfQTLffsrPcjjnXqc=;
        b=YB88A7TXajwR2nHuBIdLrG9QTipHoMup0kFNw9T2bP5xd53pN4wj4vo5a2usiSNEGz
         TSNGyoU+xgT6gTHmuwiLHNlt1/2nwNx3Hc5RSPFfccp4ZJWfdfRNWiiXQ7FPZcLg1Um9
         vZwOLbgJbN1CsMFl3o49QPCebM2LJh8l2NcJNSQprEoefT4ZtHhsb9yddMZuUQTlWJ8S
         kozP1Psv2ot92VzATmM7n+lOrL4YdQkpsIhQjH6unYvNmWAEyVtPRCeEXHW5JT5tU6kK
         /hH+YQzwKphvVaYhNc3Qhz0fuduDGnDElzLDBdl6VabQkUgKcEvHDduutnW4uhMCF3ex
         U81A==
X-Forwarded-Encrypted: i=1; AJvYcCWnhWeX8rF95biE2VjmtLfDtcYGTz+wtG8a7zOO82pLQAz0nml2oyz9GzkqW5VZUF3dW14N/TRzDsU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMSRaf2IX/R3Tk/GJ3JMGdF+xGmK9jEOz1TuMJ9+L6K7dpGeW5
	sj5Wksef7qdojIrHHzc+zAPztSyznAH1EI2ajwXtMuZ0iHNk+CSsOTksiZYay+Bn5ATYFUZNP5t
	q7KALjsQ=
X-Gm-Gg: ASbGnctYiYfeaJ2mMVjkWx3rj/Mn8V2Lq7UCIjKP4VImMqPZJWoxdB4fZAsZw0VaUo1
	tG2saCs7fVKlSRjwo7C33On9TN17mCzoF6bXMJGJydHrDiRwudn5rRumbIeC7hsiCfwC236++84
	1tMQydW/buNrnUJg5oXGNBstZRGYONVEu5Dm9dwFSiJlNUhiVLoCFJSbbBXGCVWjSxcKde+m5uz
	N24nce3WVrZlAHUzNaomA27pT66KNsIrSS0ii+iSXeUA5voYtKAmFM9RmvD0MZtfrAcZElFtkpE
	7O7e+dErgsz9MmKolLqZjPiffqz1snlVeKaVYFeeXRKWivfnKa/W3Vxwc89aGoa4UsSnLrpLR1U
	R7X1w+08FjgY6pwU8CzRXfBqTp5HzNprFr02+PIzYcjmmxaHFTlVgyDSq42jDAVCGbXx7qU3q4M
	aB6ErbLbarFfu1q3WP4XHMBMSwpKGN58nhRhKHlwP3Xq3P7JMtfA==
X-Google-Smtp-Source: AGHT+IFIimHMv3LXebuai+9d5q3KDtT5HMuIWwHSoUXGRNidVgx2jVyol9wnruIvOJDgNt8z/v840A==
X-Received: by 2002:a05:6402:2115:b0:640:ef03:82c9 with SMTP id 4fb4d7f45d1cf-64350e1fa2cmr3187214a12.11.1763141313299;
        Fri, 14 Nov 2025 09:28:33 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a3d87e3sm3991051a12.7.2025.11.14.09.28.31
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 09:28:31 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-640bd9039fbso3868813a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 14 Nov 2025 09:28:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVTo4wdHWMSKVz2HjRZm6KN/aHHNBs9n2Hj/CT5t8qbm1pEz4B9c0ofGXc3qMZhGFe71CrFM2t4mh4=@vger.kernel.org
X-Received: by 2002:a17:906:f597:b0:b73:42e3:e70f with SMTP id
 a640c23a62f3a-b73677ee9f3mr379951266b.6.1763141311414; Fri, 14 Nov 2025
 09:28:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114055249.1517520-1-hch@lst.de> <20251114055249.1517520-3-hch@lst.de>
 <20251114170402.GJ196370@frogsfrogsfrogs>
In-Reply-To: <20251114170402.GJ196370@frogsfrogsfrogs>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Nov 2025 09:28:15 -0800
X-Gmail-Original-Message-ID: <CAHk-=whmYntzyDUOjmoyKR_oyzg9Gddnda447KioykKi3FmzDQ@mail.gmail.com>
X-Gm-Features: AWmQ_bnPyaNFGJboMfVt9LBmNURVdE-jeW-JZAYBUC12bhugNENatC7jxLidgNM
Message-ID: <CAHk-=whmYntzyDUOjmoyKR_oyzg9Gddnda447KioykKi3FmzDQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] xfs: move some code out of xfs_iget_recycle
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Chris Li <sparse@chrisli.org>, 
	linux-sparse@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Nov 2025 at 09:06, Darrick J. Wong <djwong@kernel.org> wrote:
>
> I wonder, does sparse get confused by rcu_read_lock having been taken by
> the caller but unlocked here?

I think we'll sunset all the sparse lock context checks - they were
never very good, but they were "all we had".  It was useful in limited
and simpler places (because the sparse logic itself was limited and
simple), but it never worked well for anything more complex.

Now that clang is about to get context checking, and doing it much
more properly, the half-arsed sparse complaints should be ignored in
favor of just trying to make clang understand things well enough.

Put another way: don't worry about sparse.

                Linus
