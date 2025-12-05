Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D31933A6EB
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 07:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920778; cv=none; b=j4JC+7lNQln98hUUNRVa5RsGB677g7sYoMnyQ8Ih/ltPLT/hSljRwsxFkjG/RXJsNd0umt9PVYonlpDdvWXw2iWwpec+TOR8t3vdlvEgRgUbRbv5ecvZxvbH0OlzVZOWB8St6Yp2wiEPoLAKyC8Q11R6cqXvnBkKJWHBfzp0TzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920778; c=relaxed/simple;
	bh=HXtSwPAI2lC/ImQNYqZw2xOGmU6O3GtB13oXE7vjpQ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RWcg4Kt7mqaVCMXMEIybwXKt4oyQeyj+VctWCVGVP5mdEICB8BHTYvaGdvz8GyAdzQfOdmXcJ4Ob49hRRsfQjQVdbAEQYQ55fArvGchgQUnFh265o+F33kpM4Lw0wpvQoSePdLOkDkvpCeQaB86933uA5L0FGzmxP2Z749PXmuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CIUg0V2J; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CIUg0V2J"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee4c64190cso14862671cf.0
        for <linux-xfs@vger.kernel.org>; Thu, 04 Dec 2025 23:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764920762; x=1765525562; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HXtSwPAI2lC/ImQNYqZw2xOGmU6O3GtB13oXE7vjpQ4=;
        b=CIUg0V2JCjbHzU6ZgNrXL+2mqVIMDpb1IdmtbxtfnZytV22IH7UwGHwoviMMW/F+5F
         mvWYMXJ8iYXTuTkp17az4Tbr3aOdT/tAm0wBsJ71KFdrlf3H6u8UdDzGENzaEIT2J4jQ
         cZvELfdybc8PUSZO+i4HqoEJ/VeNRIRAPdjuizdDzp3BNuvnw0Zv0S/lFHCIywOWnpUu
         uSraOQuqQvStJBboIXJeewQR0mPOs1mkVlXAu+QvtbgfVY2QYsD1xkg+cqvdTc1ZEp9Q
         w2HaXk9ADarjsh1zIszaafX9d35TLjLSbsw3ynNDNJHN9Ej8SU1pn95ZpfPt1mv/XW1m
         3+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764920762; x=1765525562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HXtSwPAI2lC/ImQNYqZw2xOGmU6O3GtB13oXE7vjpQ4=;
        b=oWcKRd8rR04m3mxbz08qTSi03apTb1o4PG7LyeFfS97GTgJc6ZVMugSE8UMX8J+vR/
         cELKC7Apwq+eGp+HcmaCF6bOqHFHm/G81sa4BA88h/kfUx6iCvnG3uIeDs6T4/xNqT/L
         NCX5TlGZgn1vQ1hMu+pt/sWZH6Kab0hIHIvae2XDJa4KtcRRhIUldZgar9s+WHO4P3IF
         wbYr9+TNYGTja4GlltbAmWqa+wbBP9GfM6Ij63UHLDMM2beKFmk1MQ/FskVAeJkokgvu
         COUuuiEXwxmx/Bm6YCIUKfTCyPgHEua2SuH/fJ6WB4yzTHEizlLNJHpkV5dSvP3qfzmJ
         vagQ==
X-Forwarded-Encrypted: i=1; AJvYcCUC2IATWJ2cbNourPO8WjK5YyA0QEeQaOXqZnpTtcaCuAFvLsiylqYbLrO3Rg0XIuAksDKpCX9iQG4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu+5zpxSXgUUbt1LebDz8wvqIQ7bt3uGJlKK3wAdlap9gmEHhq
	3fWyVB/CILp+0R6piCD3zLpmONNMKXs6/gHTzPt9lfpT9GmoGWlzCzo+JN5xyHHopyLLWljAvRO
	tRPlGWYu0CMEnEfBtLe44PClFl4Ir0dg=
X-Gm-Gg: ASbGncuYtZlC7sBIwHQE1Gycj4yX4lAgRdH6zgaONzRl974GOVMoQkLvvzCtLWHdgwW
	rmjR2ChfpAPrlEH5APadZ7eQg8zbGF0T0qdrO62cag0wAcBOnHjKJkOtoo3syI1S+sFLGCZAPm6
	56uk9HhIvrSORb4IJFmLoz2oH3nIv30CO7/d6eaEq1G6zokMKsC3Q52tHXjONfoNoV3mWZIuSAH
	5CS33CDntzGoqqPE0qe73ZFOkvEJBQHBkzZ511sZ9jdavtX9IC3dtr8NoyUVuXl4E3KD1y8pwBs
	nVX+5w==
X-Google-Smtp-Source: AGHT+IGno4YCEk34HtoQAUN6GrFl01k867Kp7tydcNcb8xmuE9aFUTESOSk0G3T3M/y8W6zfCnRmuyMISYmpdGJqEvo=
X-Received: by 2002:a05:622a:5c6:b0:4ed:2164:5018 with SMTP id
 d75a77b69052e-4f01770bf40mr116570781cf.80.1764920762038; Thu, 04 Dec 2025
 23:46:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-7-zhangshida@kylinos.cn> <CANubcdUtncH7OxYg0+4ax0v9OmbuV337AM5DQHOpsBVa-A1cbA@mail.gmail.com>
 <CAHc6FU5DAhrRKyYjuZ+qF84rCsUDiPo3iPoZ67NvN-pbunJH4A@mail.gmail.com> <CAHc6FU57xqs1CTSOd-oho_m52aCTorRVJQKKyVAGJ=rbfh5VxQ@mail.gmail.com>
In-Reply-To: <CAHc6FU57xqs1CTSOd-oho_m52aCTorRVJQKKyVAGJ=rbfh5VxQ@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 5 Dec 2025 15:45:25 +0800
X-Gm-Features: AWmQ_bnqjBxuauDVJJL96EAzZiNCKi7bmfbcq5aA841m6f5U8UUuamAPefRv5L8
Message-ID: <CANubcdVuRNfygyGwnXQpsb2GsHy4=yrzcLC06paUbAMS60+qyA@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=88=
4=E6=97=A5=E5=91=A8=E5=9B=9B 17:37=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Dec 1, 2025 at 11:31=E2=80=AFAM Andreas Gruenbacher <agruenba@red=
hat.com> wrote:
> > On Sat, Nov 29, 2025 at 3:48=E2=80=AFAM Stephen Zhang <starzhangzsd@gma=
il.com> wrote:
> > > This one should also be dropped because the 'prev' and 'new' are in
> > > the wrong order.
> >
> > Ouch. Thanks for pointing this out.
>
> Linus has merged the fix for this bug now, so this patch can be
> updated / re-added.
>

Thank you for the update. I'm not clear on what specifically has been
merged or how to verify it.
Could you please clarify which fix was merged, and if I should now
resubmit the cleanup patches?

Thanks,
Shida

> Thanks,
> Andreas
>
