Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB15E552;
	Sat, 23 Aug 2025 17:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755970915; cv=none; b=W6Wmu0MC4vqcpOt2zRUllI6e314qZjg8NobbfrKcYNdbJXXUV5hfc6zRXCURtuf38xvIu1cfHsbLiU3ZOIsJC09KqYfbmBckvjsy2USjYT92KYOC8EhZD7xBTVDm8T3qFI13yIo9WTxxlhl7Xm2aE0c/QG8hHFyBSspHJK7HvsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755970915; c=relaxed/simple;
	bh=Vqsur2y8RSmKY5nLbktYvL+6enfobV0AVZknVfAmh40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fqgz7L4cSXERZQvMK9HP4cJsK36KCKgCPWq/G7USLADcaklFgOkQTAztFt8JrvIkfq8AnY2xWmjnSxd6vDnQudXOrCailuw0mAejXEOPE4CvGUeE8BuMmwZ87WvIZre1R6bk38uexfTdaztcg326LxiprVZzNxn1IrHq8sfuGZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=di46d+5c; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="di46d+5c"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-61bd4e002afso999652eaf.2;
        Sat, 23 Aug 2025 10:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755970912; x=1756575712; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ITqdo3Ifd8N3LbhIbwmmh+G/PmOUjB4de9aY4Vzo3DI=;
        b=di46d+5c/rnMywhS6qPT3o06me8AnvefOfouRZoLJvR8xmCeR672vrkIS/posc2kRG
         A9mH0e0CSQ/t0K/tl+Aez0VHQeTvbeXhnoIAR9pxYa3Tj2K1hHDeDbX3vdZE0uObHpHm
         1J4dLBZtUyIETrxmRMWGsXptbf9a6cu6YsYrY7ueVLdjK/mj5OU0VwFPIhGTsYyNrXfk
         m+t9AhjGv39kzd327Guf+GB1SSBDtRDsj77Xsj8CCrYPfvzYCCihN/VW1up2nsASbbN7
         d2TiuUZ0L/XNcSpHffdDf+jtHQs6x2VABOxjQW/IiYpaCoWk9hOsqMKXW0lnnOKng7UB
         m/xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755970912; x=1756575712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ITqdo3Ifd8N3LbhIbwmmh+G/PmOUjB4de9aY4Vzo3DI=;
        b=DRl1N2N7o1K6Rhz/nf3Rp3BflLpDodS2vxSTJjnpEOzsuj7hI9ZYTCJIPolP6Oxjb3
         V6xclLMr30nN54RSrTlmFz7ddvezWGaTpcInnX+f7ZeeL4efqKsHJZtavUHbk5KsU4rc
         /cIRNaXGhj+yexwQkQEIpgXsFM1CXiKhoHNZHPuQJQsQZD5Tud6JdNFXyLH8sZa2Gzp3
         KYAfOd0zj8ElgjauctMCOxFfLyNl1rUVOJKBnlsl9CYcVCLTn2pJ+vs3RwmdXEuvqbu+
         nKVLTZ2FLNwQGPkwY9fdFCweuBB7DuQ2nd4QxNCDaNqSy4rDS7anTj3rrGlESnH//Nk0
         EOfw==
X-Forwarded-Encrypted: i=1; AJvYcCUA/YIA7Lf46zyIhPmdEDgmcjCFq1Dl3RJFntAUnV3vXbNI8mRV+Jo+x7d6uaCKa2azzpzfGyviI1cYSDw=@vger.kernel.org, AJvYcCV5at2ZNyI9J5B9ZZ8aEux2kJZM5dnpIaZ17L7dBD36dBSvmOpBlB15J6oNfDtYrATHjZcYndvLcl6g@vger.kernel.org
X-Gm-Message-State: AOJu0YxgEK4fGJjqc7UsXidfy8eREJiq5zkJSSDyOCo5EqHZ0pWrgCuq
	86yO76T0HhVqg1VgVkPUmrnebESPR/MMOch2CLy1z5dG6Cx6CrQTVPaOCITfMhBC7LrG06AD3th
	hX45hS6yYt9yRKV3zzCIVrlBaEJ12gMc=
X-Gm-Gg: ASbGncvfY+x9udNbixbAb7hu0tPwyQeajMtJo1+l5o1ceT0xrh1I8l4zizcuZbT3rPt
	kzZocnFdsxII0R8i/qe1g/5CgzQuwAQzKttz7IwFVrBXd2JtfYXLrNywMslmC4d9teT7Mo//S/R
	f0Jh3T5l87zuqyQi3C0DiORtwnAWsWLCFxcBA4cot4gzU2HWQ8fkOif8F6eUoQiE6hh8RElNWn9
	+lvtQUtrn9csSB5AG8=
X-Google-Smtp-Source: AGHT+IGzZeNIqe9P5PGqgBcOWCG/DtxycER6I/XwHnz+4/6S9/11ldzzr2W81ivO38l/U5UWp3jfUPRuWo6itDksOMY=
X-Received: by 2002:a05:6808:1907:b0:433:fd1b:73f1 with SMTP id
 5614622812f47-43785261777mr2782955b6e.6.1755970911987; Sat, 23 Aug 2025
 10:41:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250817155053.15856-1-marcelomoreira1905@gmail.com>
 <aKKvjVfm9IPw9UAg@infradead.org> <CAPZ3m_g+KcJt_wxBjdmvyW+FqXAcEfVDUuHkp8iZ6XiUZ+6x-w@mail.gmail.com>
 <aKbdFONDSYp0FxSg@infradead.org>
In-Reply-To: <aKbdFONDSYp0FxSg@infradead.org>
From: Marcelo Moreira <marcelomoreira1905@gmail.com>
Date: Sat, 23 Aug 2025 14:41:40 -0300
X-Gm-Features: Ac12FXxOrdRfL4gdqoXJWo3pkqhcKRZcNxkx1s5GRciO1CYupAllcGOQWi05-dw
Message-ID: <CAPZ3m_gdi5Mo_N-L-M0nQoGy99m=krv1R=nb2ucj6mbcRJXTig@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: Replace strncpy with memcpy
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em qui., 21 de ago. de 2025 =C3=A0s 05:47, Christoph Hellwig
<hch@infradead.org> escreveu:
>
> On Wed, Aug 20, 2025 at 10:47:17AM -0300, Marcelo Moreira wrote:
> > Hmm, I've sent the same link to other people, and none of them
> > reported any issues with the SSL certificate. In my case, I'm using
> > Let's Encrypt. It could be an outdated certificate in your Firefox.
>
> Turns out I was connect to a corporate VPN which had some man in the
> middle thing checking for "bad" websites, and they somehow considered
> your bad, and their redirection didn't work.  Sorry for the blame :)

Oh, ok haha, don't worry :)
>
> > Regarding sending it to the official xfstests README, it would be a
> > good idea! If anyone here is involved in the xfstests project and
> > thinks the post is good, I can send it to the official README :D
>
> I think for the README itself it's probably a bit too specific.
> But I'd love adding it as a new HOWTO file linked from README.

Hmm, cool, I can submit a patch to
git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git adding this new HOWTO
file :D
Thanks!

--=20
Cheers,
Marcelo Moreira
