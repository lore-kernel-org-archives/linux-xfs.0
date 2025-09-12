Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAA030EF64
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 16:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757693450; cv=none; b=R5ZK6U67yRQR8olVaVXn3ViE0+PIQroZ4OmrGjWtXA6FlUruBHqbY2u81uJgc6K6V3jJRDKkm36HMxKm/QsHbUh41vZwZ64O1hR6FQQgsJSDaxA8bGKeOzDCWoZg+Wg8EaeI+C3S3E+mUYs/Fn8yoenlLPM7Q+c+SEi8VP1raNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757693450; c=relaxed/simple;
	bh=0RHe6bpoJIZwIozT53G/9zPYXo1UJgO60j6sIrqFoa0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fL7J8tVDIXvoxo6GewPQeAZk+vWebILdSBgyD5RwKnPlTv6IUfARH0djqdSljr80xpG51/JiNyTLQERWStI8AbyWEOvmmAScg51GLitm+P2yQpPhrVrx7r+vJNsBQ4XdNO+rcSqgKFKLT4QFyo7f1+xwSFXTOVCpCGLRjwW17DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GUnvxo3j; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GUnvxo3j"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b60481d4baso24233681cf.2
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 09:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757693446; x=1758298246; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xwq/iCyIzHWorLG2Ir1bUT1FcNPCbVi//QRArwuSAcc=;
        b=GUnvxo3jTjQ98TYJtZYmV9Kp3cDyGCUaOA8obOqxRXsEfPttuobJObbWJInysARuej
         kLjLgS0Etct9lsAEpxFyFyYWAwSTNhCtVG2HV0uK5nmlk6gS9U/CYggSvD901gFcFaY+
         OiUX5S6iphlgsZOM65rHSx+SDdyhFb7TLmYID66oBiuc0HcegU4oHiLkS89B6pmtCFNu
         GJ/+hpZCA7fjF427b2mXBJ9Ab0gEDtB+IH1trHtrwAtXH4RLDoOFKgGGXpkNRrtjOUf9
         QhRPL1EXYlcYdKLAMZfm+5r3FvzL1gjFl2H8KCHnoKDaldP8pVyzzMpIdjbl7kGIOmnx
         ghyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757693446; x=1758298246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xwq/iCyIzHWorLG2Ir1bUT1FcNPCbVi//QRArwuSAcc=;
        b=UWYjPsNYe0ExUSYmBZTxC00iUsuK5uo6TJZmE62VZXCqs9aAfBb4lWCnNJLMv9VzLa
         ybM2x8hTR8G/BADdpYOUBSBdx72vMdo5XWbIpHMkW3o+9eVgY5YTYQyeuu9bmnPXDruc
         GgFXbcxEymyfnMhmC9N362NToQMbnIKWKwX23Dqy/eseMjN4WpbSRbCyeeMdMhETUtOi
         vGvyOWzwi4wnP+wdwIzn6FxO3MNxNprlliLAQ4QeA8iIA2q3uns9Vjol2fmctyqo3kOz
         QKnDI9A3TUflRvkactr7phfRzUt8eTkl7PoOacUk+uTIM2se9Q3w9mtmNMmkxjzS62Ec
         XPIw==
X-Forwarded-Encrypted: i=1; AJvYcCWVP7e3z3TL2DC57BiyAm1WzCDqWDsVzyIOu3UBp9ZxwyLFJqgI5D7nPJGZ91YMglHSiqxetb61fqo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/aKwNJYAgAZek/6zv7ryhwv8rM0K7exFuLLXGOHEE69ZIAgry
	KN8mD8gv3KvioNzUSuhYfLuWSryHhezGzP2zpHEB2I24lf9I7Rhqjr0Ss7USoH3nyCnXsN9JBWX
	75n9+aavdXgb1ARckz4Desivz9ALoGeY=
X-Gm-Gg: ASbGnctSyLKtq+szj+VM/nyL2wW4ZD9G/Qm8gRQwLOeKuWhEk7jOSOL24R5n8GEStuv
	SadTAe6vPol8DAcUy8t6efEKfw7Hs86JE8cPmpG2E4dO27X33SzzNjOqSgeh5dqAC1UlQk8Bijs
	Pwr8FldtbUaBsJvROuNhkU/tK+79mBY/vV27gvfBinxrGNlkQJbSkx9kPrrrbpfbTSZTqehMJIG
	BA5ICuIbYkAUMNGP7wicEjVmsKWTZXySIt0RpG771S7SBQN+OKe
X-Google-Smtp-Source: AGHT+IEW7Q+2d2hor5P3hr9ksasgPpy8ttcb/zSz69+p8aktjcDEYkFuq3rxTSdGTnR+6WW44n0sCoS+JUh7Itaiy9s=
X-Received: by 2002:a05:622a:4cb:b0:4b2:eeed:6a17 with SMTP id
 d75a77b69052e-4b77d12a30bmr47218771cf.46.1757693446130; Fri, 12 Sep 2025
 09:10:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250908185122.3199171-1-joannelkoong@gmail.com>
 <20250908185122.3199171-5-joannelkoong@gmail.com> <aMKudxVnwafaoqmm@infradead.org>
In-Reply-To: <aMKudxVnwafaoqmm@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 12 Sep 2025 12:10:34 -0400
X-Gm-Features: Ac12FXytydEpN3AbZfB7NDTCU5MSfYzu7GMuXUcwO8TmZQQa1qHB0P4yWy0TUqQ
Message-ID: <CAJnrk1Y6VZUA0g8223cPvmO_FjnKmemVGQck0_9DVcZkw-yGxg@mail.gmail.com>
Subject: Re: [PATCH v2 04/16] iomap: store read/readahead bio generically
To: Christoph Hellwig <hch@infradead.org>
Cc: brauner@kernel.org, miklos@szeredi.hu, djwong@kernel.org, 
	hsiangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 7:11=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> > +     void                    *private;
>
> private is always a bit annoying to grep for.  Maybe fsprivate or
> read_ctx instead?
>

I'll change this to read_ctx. It'll match the "wb_ctx" in struct
iomap_writepage_ctx.

Thanks,
Joanne
