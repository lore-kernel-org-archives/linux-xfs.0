Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213222AD32
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 08:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764925029; cv=none; b=EbUf9HvcflWR/ZXHtp3W+nHa+ggB9mwb4YnVcvpENWsyidmTKIXQJyYRfyAh5BcolSiyFrAO7d1+6/o3Z8dFFborN7uYBmNNEeaKarVvLrs2s/Qh2zaLbhtYP1t2rnu4uz8bO6/nRubUJcW/OWtuV3gOm260jULYQ8rVi63FN4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764925029; c=relaxed/simple;
	bh=kI/BmZknfJEnMAoux6UNqNWZZavATt2Ci9CEQ2NFztc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A3X5eVAn+icmnwrgDBmOmkxUqNBUZUKexBtaSbS6DScv2CyrABHsL1gchJhINtRm3tt9bWM0jk8T1SKuqg392HIMBklossmMi8Lt+vqzEqYZvgJlCMv01Bu41WnrlBycnBC6GDpmCRsnrYuT6jBGYb3vs32CCxdU1r7sHKUKmwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xlnz3tOy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FCUaHuew; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xlnz3tOy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FCUaHuew"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764925022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kI/BmZknfJEnMAoux6UNqNWZZavATt2Ci9CEQ2NFztc=;
	b=Xlnz3tOyAvnzTEu5P5xXFQGUu8B4tZ+K3kVdrmQIrDEjMbzfP+WZ62DQRlKWZ8k9jgt13A
	GBW/4PrNYEaaS8eaA95OMcWzNb4bnB9Nwrd7gegUFJgQsh3mcB9kUT5Cmdh9j9z0MzdgB9
	8gR0B9N1u/1ZU83koUKjuA/d2oxwSxw=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-4pyYc-AOO1ifoMwWrzB9aA-1; Fri, 05 Dec 2025 03:55:51 -0500
X-MC-Unique: 4pyYc-AOO1ifoMwWrzB9aA-1
X-Mimecast-MFC-AGG-ID: 4pyYc-AOO1ifoMwWrzB9aA_1764924951
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-787e19a09c3so34090767b3.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 00:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764924951; x=1765529751; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kI/BmZknfJEnMAoux6UNqNWZZavATt2Ci9CEQ2NFztc=;
        b=FCUaHuewzJr0ItO7Uo5L86Nrwo8aqenxBPuUb4bOmmHTFVJq4vye7IGq70AzxJQPQJ
         MHpqO0Zv+YzfSv64JvUgkD68IQ4Lkc3wos/W+YYRiElerTTNXTrXoq1Rr4p+jAYZfsbN
         JreJtV1czwU96ygq6Q3u1xVnllUdIFs5eTJ3oPH4q/Gl1S2E39PLAL7pqzwTE7QeJN3F
         kOSWg7rR2muJhZo3iZDiEnVMnXG5DxGVVep0O/oH1ge1SlzgsDukPDMk7dO98luRVhk3
         3mS9L5Vt/N5sLgAR7b6aKv45HjlhCO9tzMcrE4fkXJyB6ntno3MmvwVqbPvQSmo+eGT9
         jLag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764924951; x=1765529751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kI/BmZknfJEnMAoux6UNqNWZZavATt2Ci9CEQ2NFztc=;
        b=k1enwY2ii1HPh2pUtB0940Hc2dYNFurEczUH+DV0wPj+pa3YCCqJk2r5bzP9PnXJEm
         PGkJvfrs3uLP1TpQ6GirUum6TMFpyZfAG2JzgMSykFzqgizN9IWuMjr5+Jrrv3MyRyhg
         XZM8ZMUJEKFoWfCL4XiAOSz4fG44GkS0Hj3LMhQmByE7r4dHt6A2/HhEVj12gbuBVcwB
         72mDfDCoFhVmAzCU7XoId3TETbyBkFWOcvS/ihGa4XOVqZHjeLu8pWalKfSn/g0YXIve
         pFDOmS4ltwKRcKEGR1l2qkM2KNrHrgslS2kjN/o6Mj96G2sF01eYH6+lNvdDeFsYpNdO
         UPoA==
X-Forwarded-Encrypted: i=1; AJvYcCXiw0H1HMKN47iMpm+P7LLcdZdn93ee2TVutXS5gTcViI/Oe3Vl4mcPIyJ6Di9q6HFpocPzWcLr7d4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNwC3nZQN1+MTGG6F+dKE+C6cDofZ4sO9yf0RGifhMN45KnMf8
	ekOVZiAdhpyLQze0fndoxBgIJOAtTKtsrTdzj9Pz4yX16zOYkLlXInkVwoaOC4ZyI5uwzUisFVN
	674K5Pj1oJt+IbAOqRh0+zVUvkYat6VypjyWGi/0LRVIyxl/LAt4llHJz1zwsIikcnywv4xD1Fy
	955UCV9i+GWRvRKjvuNM0y264+hCEwT8Moy0YF
X-Gm-Gg: ASbGnctLN3MzKUZixLqTllQv7bduV/I7fE5NuQIaZtf4/fUSX0bS1b2066mEw6+tthB
	UaUgtPpq4H7N7+P1vMd6V4XIFmi4kKwh+qCI7DC+5AE1vbKjMv7pJHr+sWEppDDuWLMoQ2UHs0q
	8SxrBXkGrIyba0FfDeJpJDdVxhRUjAwcYxrAKCKRgBbtYqW/ZfyTMrbOGjGxhCCgBw
X-Received: by 2002:a05:690e:11c7:b0:63f:a876:ae58 with SMTP id 956f58d0204a3-6443d6e683bmr5035621d50.9.1764924951053;
        Fri, 05 Dec 2025 00:55:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH06t5ScTL3/41cXQ9/KNdNBUKke6bRZRDIIsDOJI/s90MmtU+OELXMsXOy8CKQ41Y5BIrK12B8cMtyqGUq3aU=
X-Received: by 2002:a05:690e:11c7:b0:63f:a876:ae58 with SMTP id
 956f58d0204a3-6443d6e683bmr5035612d50.9.1764924950709; Fri, 05 Dec 2025
 00:55:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-7-zhangshida@kylinos.cn> <CANubcdUtncH7OxYg0+4ax0v9OmbuV337AM5DQHOpsBVa-A1cbA@mail.gmail.com>
 <CAHc6FU5DAhrRKyYjuZ+qF84rCsUDiPo3iPoZ67NvN-pbunJH4A@mail.gmail.com>
 <CAHc6FU57xqs1CTSOd-oho_m52aCTorRVJQKKyVAGJ=rbfh5VxQ@mail.gmail.com> <CANubcdVuRNfygyGwnXQpsb2GsHy4=yrzcLC06paUbAMS60+qyA@mail.gmail.com>
In-Reply-To: <CANubcdVuRNfygyGwnXQpsb2GsHy4=yrzcLC06paUbAMS60+qyA@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 5 Dec 2025 09:55:39 +0100
X-Gm-Features: AWmQ_bn5nYIfNoOVXdPvu9TIQvwvBK4TRvGDwrtrakvgOSxNJSsbjWkIZFSXMho
Message-ID: <CAHc6FU4G+5QnSgXoMN726DOTF9R-d88-CrfYMof0kME6P_o-7w@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 8:46=E2=80=AFAM Stephen Zhang <starzhangzsd@gmail.co=
m> wrote:
> Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=
=884=E6=97=A5=E5=91=A8=E5=9B=9B 17:37=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Mon, Dec 1, 2025 at 11:31=E2=80=AFAM Andreas Gruenbacher <agruenba@r=
edhat.com> wrote:
> > > On Sat, Nov 29, 2025 at 3:48=E2=80=AFAM Stephen Zhang <starzhangzsd@g=
mail.com> wrote:
> > > > This one should also be dropped because the 'prev' and 'new' are in
> > > > the wrong order.
> > >
> > > Ouch. Thanks for pointing this out.
> >
> > Linus has merged the fix for this bug now, so this patch can be
> > updated / re-added.
> >
>
> Thank you for the update. I'm not clear on what specifically has been
> merged or how to verify it.
> Could you please clarify which fix was merged,

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D8a157e0a0aa5
"gfs2: Fix use of bio_chain"


> and if I should now resubmit the cleanup patches?
>
> Thanks,
> Shida
>
> > Thanks,
> > Andreas
> >
>

