Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2DE2FBDEC
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 23:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764803248; cv=none; b=fJ1Wvq2Ou7AlWcJA4fdlLYsBfhfKwU6jbZKZiHXqS2g9P4tG7XgJWaYvUttOKug4hYShzad9ERvbYt7LLY/RgqvqcxT8YjHGCOeT8hZr4bYqP69j9tD1dJ7WubGeou5vS8k570iaFyKfqUM/qzrvLxO9BDLRnr0WIVzU1CDhMEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764803248; c=relaxed/simple;
	bh=ARjBU24hBcskgb7NtDM1BJQCy1LB2oT4dOF6omBJasE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cTeXxI2YSVh5pO14HHlRCWezka4P/1jzv6yPLyjZMWYAbGw1pMqAHxHpc4pa3QPiq2TQd8dOpyZSdMIS4m/nk4MHGzI5Q9oCVb6CQ7jurcdAHsyiHqczx1kZdwgvlWuSwmPJrmFHkn/1A3mg8zm0MVyXyQKycoPe0ReKL2hBMEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OY4K88Uz; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OY4K88Uz"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88054872394so3415516d6.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 15:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764803244; x=1765408044; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ARjBU24hBcskgb7NtDM1BJQCy1LB2oT4dOF6omBJasE=;
        b=OY4K88UzxcvkONG26+JORFBUO2QDasetSxjwW5bSA0nRRXZ92JS7pMr2Q8g7aK9o3+
         MD51NDs34S6ZwVGm9X7VVRcTeRcFlQw1utEkK7ib3kCI2L5YclEtuIE0VsjbFysXXxwG
         LXhbeR2/iSxRjg7hgD7iTaCi6S/JgO6O4tETbrTcXL/DVxDgR1ZxfgqxVpcYaKtmh0VH
         ChgpRRHdlKeIyNeyraFTeVuF2QS87oOAIh0yhQHEmdXhZhnxuhRk2Kq5iv1bEiqUk3RZ
         o7jGyGzHZYnQ0huRw9/C1NR7JuLEXdfIi4W8s3rYn7c+HoJfgVhYv5PooXsc/rhVVRwq
         +KOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764803244; x=1765408044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ARjBU24hBcskgb7NtDM1BJQCy1LB2oT4dOF6omBJasE=;
        b=QtGmXgbKOt7G4LHotzTgJHMZPbnJ2oDFZGfMiCOlwhPKuG+cx39hCeibYJlmDBGjtZ
         u3hLl0lMoM3wHRa/h4maxp7RYmZrjsvMOQTVa529Hu1A/aQqE4qx/+efms/0TeHhyMJH
         ovVAFostoYjFm7xrQFtOzn+IAs0GvpWQJokx05TzNcvGsmJJk3Qk/edSqHo1DXMxQaEx
         zxCVufcJEgdmxMrxnoJfxPuBx7T5xu9f9yJY+yQ8oxIOdbICIJU0qmStJHUrijdoAa56
         dgxi2Z2b0XArio76IFRUKfN7EXn4yZHdbkYl6hR1hCz2Vb/ERN9a3K2lezHI/GAMCW3k
         fYdA==
X-Forwarded-Encrypted: i=1; AJvYcCUVIJsrjDYkJuT/OLmPM9SC/FgKaXz0b6u4TdCOrUkKv02WNCFyOJq//IB1MQrKO5Wb2zc/1LOvn2o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/F9+2G8yeu3d93TQgSmsw2pZTcRuyUzCMvgYEq0dMZvMOUsbd
	WGXUMZUpU6qerUwJty5KOTOczIJkkR+3VSYmhONXbtwiXEp9pF0ndhjgZkq4tuC9KMDTlRDj0IX
	qgE6pgY323P2FCEH+sKsz5bkLs6gQLGc=
X-Gm-Gg: ASbGncsl8WKrrHdkd8vLraMYMDqXVEAuzuCV1ALEASy2v2OqSGO88dagB4GE2TMEcDK
	ztn6I1Sbm/OJcdPV25awzaMADvegkkClw8Ow2tZl08hn9puEoOEJ7ljpWxEHBjRid5rcRYW0H+N
	qcgGZuK2ahrrxw7J82oKLO4QfvgdD7o2v2SLiCRq8aKpX1aju90cEb7AcD2BmtOfZgsBfQ4c+a0
	TZegyglxzQbI8oO9aduBVKo9AM1zdJ/rvrDs8/MtZtfEyXGhh2nnroQGwESf2xGDxA5KPg=
X-Google-Smtp-Source: AGHT+IHeXlWltuajJrx5d5zaBmOs+3Uu+5HXat5Ce2MX4X5ZPI8oXVau0JJuFiDWUeYCCz9yKCjgfAUsfswBi07X5PE=
X-Received: by 2002:a05:622a:3cc:b0:4ee:1b0e:861a with SMTP id
 d75a77b69052e-4f017592726mr59846181cf.13.1764803243439; Wed, 03 Dec 2025
 15:07:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203202839.819850-1-sashal@kernel.org>
In-Reply-To: <20251203202839.819850-1-sashal@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 3 Dec 2025 15:07:12 -0800
X-Gm-Features: AWmQ_bmqhNk5StWxxmTMDLwKPZbVHBIiLQfZnv8DcnlEQfJufs1LWeozSv_ldNk
Message-ID: <CAJnrk1aSf+bTiRE40BSM72y8p_0CZjeJ4AHF78QbxxPicmPMXw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.18-6.6] iomap: adjust read range correctly for
 non-block-aligned positions
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com, Brian Foster <bfoster@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 12:28=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
> From: Joanne Koong <joannelkoong@gmail.com>
>
> [ Upstream commit 7aa6bc3e8766990824f66ca76c19596ce10daf3e ]
>
> iomap_adjust_read_range() assumes that the position and length passed in
> are block-aligned. This is not always the case however, as shown in the
> syzbot generated case for erofs. This causes too many bytes to be
> skipped for uptodate blocks, which results in returning the incorrect
> position and length to read in. If all the blocks are uptodate, this
> underflows length and returns a position beyond the folio.
>
> Fix the calculation to also take into account the block offset when
> calculating how many bytes can be skipped for uptodate blocks.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Tested-by: syzbot@syzkaller.appspotmail.com
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>
> LLM Generated explanations, may be completely bogus:
>
> Now I have all the information needed for a comprehensive analysis. Let
> me compile my findings.
>
> ---

I don't think any filesystems had repercussions from this. afaik only
inlined mappings are non-block-aligned and the underflow of length and
the overflow of position when added together offset each other when
determining how much to advance the iter for the next iteration. But I
have no objection to this being backported to stable. I think if this
gets backported, then we should also backport this one as well
(https://lore.kernel.org/linux-fsdevel/20251111193658.3495942-3-joannelkoon=
g@gmail.com/).

Thanks,
Joanne
