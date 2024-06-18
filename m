Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A228C22626
	for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2024 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718731008; cv=none; b=kOO92/LEYm++eARKtUdQqdBME66HfOCA+V6hc4i4Ag5BsM6UQIgruc1CFKBz7vQnaa9aB7WFpH7P+v98ap8mykQNpw0i8QhHwrQBLCuiOEHLT9dEh3zvtOM53YYzQ827flyZAwLslaP6StvToIVnwZEulp6rxYq7UyjD8bzq8No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718731008; c=relaxed/simple;
	bh=sb/MhxOFMhdBTswDvfuqri3gtgFGGleJuDnWyEWiG0g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NZksONO/Z+JSFqlrRUDiLMesH0dN003gkqdwlxqj3DuIM4UeYgKN4SCsTh9Qsc1fJUHUH/slQFEbmGAlYqsujZF+8aDwjKcSuNQBidps1muwKX8R0wyeB99qyfSXucyxJgnMuA1sq/YHHAEnq2D4jf9Vtph/BuhQ/cS9+vrEu5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nr3MDcor; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nr3MDcor"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-57c68682d1aso6575467a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2024 10:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718731005; x=1719335805; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfAkfZA5VnXWGio9CD0FJiNc1ypCeQAbWwg3+Ldyb7g=;
        b=nr3MDcorgvhrydMG1aiRs4pKMIssOOkof9GRq9hMfp0bZTfxfG5BOiGx/r6zn4BFCN
         26aHMaFOS0vIAL/32P8Ycyt341EgtoRfHmDZTdBlFlYvhD3HL3bH5w4u3lOJUb5/Rmmv
         wPEX/VsKHNWnQBgCfnhrIa7vjmeENhNgoxZGBFxCBKgZGXajnS4/uyQ/HJUSVm6ZbAu8
         WIENaZVRJzLzdJQmQqoDJ5/PQy2GdP4qGPU8oqdaPcsFiTb+kpYT44jJ5898UT9XQhVt
         zqHj1a5GTnfnxpwhJFIiTq3Vy/O8nkEYAeJPijB5D4yOyaJMjlwyV5E7E7+6GoR04PaN
         +Ukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718731005; x=1719335805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dfAkfZA5VnXWGio9CD0FJiNc1ypCeQAbWwg3+Ldyb7g=;
        b=PYu9gAsK01wk+P7gnAjw7gu7yttkRko4k6DVfjMME/YCDL5C37fq7Giss6hb1jz/R7
         K/HvORZgSRr5ALdZ5bcotgL0zayiggmoJgSGp1DO3PmLNXCa8RADEHP+UZCDUn//q5cz
         L7RdmMyIIFuSpcNECRf2aEv0XCd2/f9mqoXNb8Q4j1KvoDmcXKNIeRhTw8uX0Mezadmz
         V2gUDcj99Kxt6TnDB+ITFmClwKiFf62+7ZX14CFvJjG3QXfi8QjxE3KT+1Wn4TLdNmF2
         jr9uyAdB7pdKy6R7jO50QYzqwng9JBeYy6kKqY1YoSZHiRczTteJoF8ce4q6iNInhaIr
         LlUA==
X-Forwarded-Encrypted: i=1; AJvYcCX/eh9EEKO9CDOC3ITGvfYZwb71VwcEA+F7RpNzhUMdjIZxo+gVa1DgOZe89hWiE5/Iy6IT/RPgavqEdghva5IofwFHSn09W0aD
X-Gm-Message-State: AOJu0YyUarLTZtIVVgedJowGIqzfCmb1grPLHRDXpGCa+oolcG2rgtVK
	c0QvBDKU0Tmme+nPCLvbN1tO2kFaZHGaifMn1u9jmcfMepKin2MgeKPAL8b3cpnvueHU5OL+N2V
	yClrgzT4X9/+XTKJlbwmzagRjshX1xhDUzKw=
X-Google-Smtp-Source: AGHT+IEKdWWfqV9vDK94jXAHcrV4ADipVfWNmoym5XrtxDDDzJntB8NNhCauTlbj2qeKohukV9QnqX59po2jbtFF+nc=
X-Received: by 2002:a50:c358:0:b0:57c:7486:3f7d with SMTP id
 4fb4d7f45d1cf-57d07e66a64mr86611a12.19.1718731004532; Tue, 18 Jun 2024
 10:16:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240618113505.476072-1-sunjunchao2870@gmail.com>
 <20240618162327.GE103034@frogsfrogsfrogs> <CAHB1NajUvCmPK_fTVgpdXz--Qn69Ttx5W4k9Xbq18MbarzUfVA@mail.gmail.com>
 <ZnG7DJrVov5n6O5m@casper.infradead.org>
In-Reply-To: <ZnG7DJrVov5n6O5m@casper.infradead.org>
From: JunChao Sun <sunjunchao2870@gmail.com>
Date: Tue, 18 Jun 2024 13:16:33 -0400
Message-ID: <CAHB1Nah2cJ9Pp+CVizN9r-ZhmUM7mCt6zHfFYqHJTDr5hrpmUw@mail.gmail.com>
Subject: Re: [PATCH 1/2] xfs: reorder xfs_inode structure elements to remove
 unneeded padding.
To: Matthew Wilcox <willy@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Matthew Wilcox <willy@infradead.org> =E4=BA=8E2024=E5=B9=B46=E6=9C=8818=E6=
=97=A5=E5=91=A8=E4=BA=8C 12:51=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Jun 18, 2024 at 12:40:23PM -0400, JunChao Sun wrote:
> > Darrick J. Wong <djwong@kernel.org> =E4=BA=8E2024=E5=B9=B46=E6=9C=8818=
=E6=97=A5=E5=91=A8=E4=BA=8C 12:23=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Tue, Jun 18, 2024 at 07:35:04PM +0800, Junchao Sun wrote:
> > > > By reordering the elements in the xfs_inode structure, we can
> > > > reduce the padding needed on an x86_64 system by 8 bytes.
> > >
> > >
> > > > Does this result in denser packing of xfs_inode objects in the slab
> > > > page?
> >
> > No. Before applying the patch, the size of xfs_inode is 1800 bytes
> > with my config, and after applying the patch, the size is 1792 bytes.
> > This slight reduction does not result in a denser packing of xfs_inode
> > objects within a single page.
>
>
> > The "config dependent" part of this is important though.  On my
> > laptop running Debian 6.6.15-amd64, xfs_inode is exactly 1024 bytes,
> > and slab chooses to allocate 32 of them from an order-3 slab.
> >
> > Your config gets you 18 from an order-3 slab, and you'd need to get
> > it down to 1724 (probably 1720 bytes due to alignment) to get 19
> > from an order-3 slab.  I bet you have lockdep or something on.

Yes.. Sorry for that. I will change the config to debian release and
then take a look again.

Thanks for your review and comments.


Best regards,
--=20
Junchao Sun <sunjunchao2870@gmail.com>
