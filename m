Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B7E175A1
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 15:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712849498; cv=none; b=M9r8NrYP78pefN/tHekR8FFAen24XPvKgm5Rm8IqoETf7uMHFZVG5Lprjtxjv/B0VlF/GKBaTlPYO34NvRPd3diKIKMceht/z6i9O9JPOXVEzNDPUYGdgzvPEfVgXVOdbmGikj1X+cwoMDNRRuQMZLLourCUChDpG3C3yixPmio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712849498; c=relaxed/simple;
	bh=1F8FDCWi7kV0VWLSz4mlwqNZHS3BzwqFKom/1e6MPAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DhcmkywuvYeReIX9O3w4BFjjBc99jD0kcLrkeDYp1BYmmISbJg8S7eCVsPxoqht1jzXNEIhd0qihVXNN+FfuYPDSg5qEKnqKAC3luvN9ASwjTW9cwIr0Z6TxLUzM/lO6kB+R+vJ/NnOtpYXMPZmgj4UE76UiuRWgC8tXOz4gxeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=R3YY2n/0; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="R3YY2n/0"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e411e339b8so35667355ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 08:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1712849496; x=1713454296; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h26jApcI47a9THxXWamb//DMym3AleVu6sOiT6ZGH/o=;
        b=R3YY2n/0VwUwWve61b5CZ3IBPO30oLs/f2nMFH8EREXjpTHIHlEmK6get3jv1H+7Nr
         LzLwT/KT3I9cYPiTYeAtKbFQ6f901IeroZqNTuKDBaW3EylhQBA8i1SXI31oI+p33vMs
         5VvKi8iWLhGCK22xr7AnHWH+fsEQ0KNWXvrlI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712849496; x=1713454296;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h26jApcI47a9THxXWamb//DMym3AleVu6sOiT6ZGH/o=;
        b=kyjLeVw/VYR6MSIsZtCGL2Hy/Qj0NFsLi5B9QTuv1BZIWHfqcAPDC5hsVrM0N3Xk7B
         WwshtYZGrAMbKsUvKfvx5A+9m2ylkWriQvN0GacetE33mSBEZqQzS1B5HJ996Zda5ovj
         SrWH/9T1AXTJzmxLbhQ7ixb0S5BqNtrSMtCRCoSm43vvBhJZonWxwoxVpki9o0H8vsUb
         iSsTNY6vyGNoidJpwdVau7eVpSAEUtSp014qYj+mXPC7wfDfN74WBWvZv8+QTz5WnpOi
         c8FWyrYfflb0+JvMdA2jdmoKjUA1MxuTPzRvTAQ5ichiS2qF7RDhjfQKTvkrImvqo/jz
         02Qg==
X-Forwarded-Encrypted: i=1; AJvYcCUZq3SRoWlWvo05yMuFWXBLgkcODFpY0nJKn1t8OIU5J3o6qf87zLVbIuXAQSa7h0+N2AaCOtK7ABdNeMmORGoJGR/ufAYRK7mL
X-Gm-Message-State: AOJu0Yx5nZWjkhpul0u8eb6c6jRKt8ZoFybVEg24yd6mBiBp7RpO4HWj
	yjhA/PE8N64qiDYPXyo3bDMAYBIWwEjbwscVBdK4mnAovgM5C+yj7h+pil2D0Q==
X-Google-Smtp-Source: AGHT+IEejten/fI5yIJ4OdU9ANzlh7kmTzwwsMRkhZrYGCJfDgxUgiz8KKlY5DuuhFAg3kagyyJlHw==
X-Received: by 2002:a17:902:e80f:b0:1e3:e0a2:ccc3 with SMTP id u15-20020a170902e80f00b001e3e0a2ccc3mr6911262plg.30.1712849495918;
        Thu, 11 Apr 2024 08:31:35 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id l5-20020a170902d34500b001e26191b9c2sm1304039plk.67.2024.04.11.08.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 08:31:35 -0700 (PDT)
Date: Thu, 11 Apr 2024 08:31:34 -0700
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] xfs: replace deprecated strncpy with strscpy_pad
Message-ID: <202404110829.D3A5A56@keescook>
References: <20240405-strncpy-xfs-split1-v1-1-3e3df465adb9@google.com>
 <202404090921.A203626A@keescook>
 <CAFhGd8pr5XycTH1iCUgBodCOV8_WY_da=aH+WZGPXfuOY5_Zgg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFhGd8pr5XycTH1iCUgBodCOV8_WY_da=aH+WZGPXfuOY5_Zgg@mail.gmail.com>

On Wed, Apr 10, 2024 at 01:45:21PM -0700, Justin Stitt wrote:
> On Tue, Apr 9, 2024 at 9:22 AM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > -     /* 1 larger than sb_fname, so this ensures a trailing NUL char */
> > > -     memset(label, 0, sizeof(label));
> > >       spin_lock(&mp->m_sb_lock);
> > > -     strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
> > > +     strscpy_pad(label, sbp->sb_fname);
> >
> > Is sbp->sb_fname itself NUL-terminated? This looks like another case of
> > needing the memtostr() helper?
> >
> 
> I sent a patch [1].
> 
> Obviously it depends on your implementation patch landing first; what
> tree should it go to?

This "flavor" of conversion may need to wait a release? There's no
urgency on the conversion, and there are plenty more to do for this
cycle. ;)

-Kees

> [1]: https://lore.kernel.org/r/20240410-strncpy-xfs-split1-v2-1-7c651502bcb0@google.com

-- 
Kees Cook
