Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E9C2AEE9;
	Mon, 23 Sep 2024 12:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727093675; cv=none; b=nnrL3iNxmrGuDjU8NMyvp7iC7O2Az0Hi1/qnHmOJn3te4rFiQrwTDz1IV3W9UWhP+qvzC3rcHl7fBDBhSmlvV3RCJ5ywh2WKF2vqk4GlSO+o+CWBDzlGC9mpc3dnKlXSpibVz/lCttqmv42XH4+dt1jJypNFXkLOe72cl6ZbiMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727093675; c=relaxed/simple;
	bh=7tFRooMwvhSQ1C5tTJ3kfsNLv6ZDjFqNjKIByKZmZGM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M+dE+LaAtp9zpTvm23/C++yKdBeeSTi+BHPUq8sBQjVV7YVOVNNBUQ3w9MeAnvVcLewtgcYE4mSyF9QRnie20MA+YO6Z8K2CCNzeIoaOoPPgArUD8Z7OPYiGf6Hj8QAT05rJtEFupeAiYQi6luzhh0q0BLx/6IezYcYU9fxGhzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I4dNZ1Xn; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I4dNZ1Xn"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2f75d044201so41713641fa.0;
        Mon, 23 Sep 2024 05:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727093672; x=1727698472; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SnE3GCtdZIP3PgPg9d/MYT/TgGMiVsqBiZ5RwjuhM6s=;
        b=I4dNZ1XnZjYepgOvv86wwO6bZgdbCdKokvE+EnARQmIEGZYi7Rtq/8VdaDrgM/dRWg
         emWp0MuW2G0Yd/2W0uMYuYDW5OOKtSiN/L04NCbf+MPgTnEZ1b6pphvERHAWjL3HqTBL
         eRMe7qvEaIzhKlFDkjzoWfHzs+gI9fMEE5nrubjzpH7p8lk1DZYxVk+DrcGON8Jt1b7M
         +DgYMHRtfCdVQz0MStZ7diJvE0exZxBFtsXStrHWctZ/s76ht4ln1ourx15q+xGEVenW
         62o5NUjytx8E7tzBkYG6erAOEdxXE4NfW+y4rHmDlna9/6rzBNt3Iq0r9SlI1S5bDsii
         9T0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727093672; x=1727698472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SnE3GCtdZIP3PgPg9d/MYT/TgGMiVsqBiZ5RwjuhM6s=;
        b=OJm0D6vgAQQjlLlE/7xSeGi/e5dHd24LCu8EMvBr9CSX9uXtyOiBaq/Xt79VXzwyc0
         wNiqnszqlnE5du2Un28Zdh96UMv+nUehrEDqXh0PqggWM1gyNTgonEeKfoy78/w8R9Ey
         YMCOeMkoJpURBHshAlkZLtcDVMjqRjHDM1Tcaff1mYdhzMxP8Oh+5oVeOkRUzDLCdJGZ
         vKY/fA/G1wSjD9q16H3/jjziBsdnkUSSVDPSF/VACv/HzL1CNzDZ+mKFI3YApOLiAjNA
         Sm86yXhUClM0OB/zndkXbO/wbIsIPhFT5IPtFecBKe6OfVxmc1eJmNrifiIoXfYIQqXp
         0pGg==
X-Forwarded-Encrypted: i=1; AJvYcCVH3LCgdvcobBrCy4MqTRfRJOCVNq1l++OFCMBQTPR4q/N9GdHflcHnEB/7pxqquib6wvDUcnLYe/AP3G4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9SeUqfifJEp0VnARKPoN/phQAwaDnoU+idJFvS31udXMAZNwk
	m4A8daJ8Yaf3xuObrBLJzyIVHAq/GbZezIMSF528azermpsZ2V2wciinYkDlbsf6tVo/G8xE9y5
	YYViKrL2IykssA1Y/79cZ1jbAJi8=
X-Google-Smtp-Source: AGHT+IG2bOpCahYBND6tZQy4Vj3ylQm89SJvF2ilXzzMrJ7zyRoC7WK/6wtLdtZOKt/iZIrPfaC7I4Cbpkz28B//PUg=
X-Received: by 2002:a2e:bc13:0:b0:2f7:cac8:9e38 with SMTP id
 38308e7fff4ca-2f7cac8a1a3mr39467431fa.18.1727093671382; Mon, 23 Sep 2024
 05:14:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240922170746.11361-1-ubizjak@gmail.com> <ZvFZLKMVMMig4ZCh@infradead.org>
In-Reply-To: <ZvFZLKMVMMig4ZCh@infradead.org>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Mon, 23 Sep 2024 14:14:19 +0200
Message-ID: <CAFULd4YgN+BKNNHjC=814iQAzZb1T3hVScg-BLqmR8bP_4jnBg@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2024 at 2:03=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> >  {
> > -     struct xlog_cil_pcp     *cilpcp;
> > -     int                     cpu;
> > -     int                     count =3D 0;
> > +     int     cpu;
> > +     int     count =3D 0;
>
> This should not be reformatted, but maye Carlos can fix it up when
> applying the patch.  Otherwise looks good:

I'll just send a v3 with your R-b tag.

Thanks,
Uros.
