Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665272FD1B2
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 09:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841025; cv=none; b=JLWpbjZLLpJ5rA3E6de3cB6IgKKGp+qji/Db1LzukLY/QrmDmag71yWLpmMr71BpBYId8qgTs4Gjp8dvCQOJ7GJ26hyhp6TSXcelD4bMVYQ2xUiG+X71tmZnBoYUu7tv0w7Ole9G1lO++u5yXwK6bmRFSWYbDfBAWfBMdwriq/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841025; c=relaxed/simple;
	bh=qeEjzVz7GQk6EpiDzPclRlc2LVPc/X5pecZGz9q1Q90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fL/EomNXC/ObKdbBwwJdgykERUznWrwxNti8ylAHVxSNfi5sNjZHEnMeqC4eefQg6vdtomPx62wSYMTp9bhsCc1hcDwAwq4dn3oR90jplEwUBzIN9X5c3tPXFMiqdTPzdgk3xQVz6YkiJc3NtVO2edpv107H6xaFCa9+ySy0yaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MnrUlk3r; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rVIhqCbY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MnrUlk3r";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rVIhqCbY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764841023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qeEjzVz7GQk6EpiDzPclRlc2LVPc/X5pecZGz9q1Q90=;
	b=MnrUlk3rZ3itfapUBEA90V3po8H4Wu4WwjHa02o7cr42ekaZPN95keGnEapTMn0+PZXlZg
	iwvmOeGCvj32XcNy0S5jA5ZkuhFMwKQIg4bp6r5TxLX9cs58R65H4bjSBrKzo49K9YEX7T
	wRXTajkakiouFcUwsLELzmvaEGEsjR8=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-UzI7E6C2P9GRrw3ekcpirg-1; Thu, 04 Dec 2025 04:37:01 -0500
X-MC-Unique: UzI7E6C2P9GRrw3ekcpirg-1
X-Mimecast-MFC-AGG-ID: UzI7E6C2P9GRrw3ekcpirg_1764841021
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-787cf398a53so8270957b3.3
        for <linux-xfs@vger.kernel.org>; Thu, 04 Dec 2025 01:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764841021; x=1765445821; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qeEjzVz7GQk6EpiDzPclRlc2LVPc/X5pecZGz9q1Q90=;
        b=rVIhqCbYJIshhr1SDoAzl0uxJ3l2OknzAacF5X1A0A8YSzt91sa5gVt2s2Kp2sWJB9
         Hgli5ZUl4CsxXmvL9tdbhsJry4TaLBE1C++twE7VZYk7+QzPkxNO4ooZGrS+nj2wZSDL
         6meyQgb+gtMBIucQ2xdOnMJ7o7G85PNDylK1hou7CxAjlvuRKlt3ve4UZRm9l73ZKBPR
         nf2rxHGK+5fX7U4j75tPudKUs2dYi0ismLtiSgvMKI6Zjz1HWz9U7HIQHsH49JpJEvC2
         GIdg/XBoZgwdsvkaWHa4+lJkRE3yiX1xY3S4HnujXpX6oHd441uW6MMSzVaiXCXoC4mh
         tYrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764841021; x=1765445821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qeEjzVz7GQk6EpiDzPclRlc2LVPc/X5pecZGz9q1Q90=;
        b=aJkgCB+gxOZQr3UmtM5bwKC1iMlu6FR3agqy1G5cHIkBdlJAjEEcdisxSsUVgnFQFW
         gK1fbnha861s1X8Nfbwi/i/62mMaOktM7gIQ9UGBrgbcQ61DFbRTKPj++zjSxbJ6mrgl
         6Kx261IocJeWm40Vt5Lr9joezbLgiURA9J8QPQO0o0ywkkAkBEHFUj1J2J7h4mry5G1x
         5YhX8zULodH7FEQePkFKIbt6RB5YajfoSBYj8XLbLMchH9pKZA1xq5aoLeyn0MqpjmSf
         bKmSsHLComK2DmjkV8cp8TWUQf7kZiwlFFhcT/oYj3l/rfUrY8fISjWRPjPHXGK8e7Hy
         Mhjg==
X-Forwarded-Encrypted: i=1; AJvYcCV7dmRtnPsFBaeIYRbe86bc+Wq051FXGS1YBNX00z9633Vx2FU5AGWgDTPqIFs5h8tLPOyH/CTrTxM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKsFvrF02QC7cu0UUaabjuq0yCorX55z6eghMjFZGGs7JRLIcc
	RAB463p/HFaTeSbKPLGtsvNPryj/SuHhZhsaNZ8yies1v6Dwo0mm2WLRnnZM43hGNfYkXoFGLPl
	l2fw5xHXkqCBJ3Uz0qxGZ8rv9DzWNMu73XvVyqY6VNVg2gZd1bFWd7EIqYCQdSW2GUJOfTg/nL1
	AYQNt/Zt/pDIg+wcVBaxI6aZpI6J8+jiYWFwIA
X-Gm-Gg: ASbGnctpBQN2T7FN1oYi/qsybwCl3vXbxja8mNV/o93OPAKM89EZvFofEAPrdAhsfXM
	dygya17WTr3FU4vUz5u5ShFwMvaF1idkAVXDLPJk3MRBSNRxnzau8SESW8akrF4EAHyA+sVO69D
	MiH+DIl7NOqkr6BcJjQjz9yd/Xlvr7Bako5IS3OgN9wMDPe5eKbDnyu3Av7SzqhWBf
X-Received: by 2002:a05:690c:6713:b0:786:4fd5:e5de with SMTP id 00721157ae682-78c0c210028mr42666197b3.67.1764841021010;
        Thu, 04 Dec 2025 01:37:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHBJRkWOGl554rCJxMS1W+VD+59CzpNDKchBFktxp0UKkP2qgdZoPND338wG5ha+uJ8PPPkfv0dwHOd25ifO9U=
X-Received: by 2002:a05:690c:6713:b0:786:4fd5:e5de with SMTP id
 00721157ae682-78c0c210028mr42666067b3.67.1764841020714; Thu, 04 Dec 2025
 01:37:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-7-zhangshida@kylinos.cn> <CANubcdUtncH7OxYg0+4ax0v9OmbuV337AM5DQHOpsBVa-A1cbA@mail.gmail.com>
 <CAHc6FU5DAhrRKyYjuZ+qF84rCsUDiPo3iPoZ67NvN-pbunJH4A@mail.gmail.com>
In-Reply-To: <CAHc6FU5DAhrRKyYjuZ+qF84rCsUDiPo3iPoZ67NvN-pbunJH4A@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 4 Dec 2025 10:36:49 +0100
X-Gm-Features: AWmQ_blRRqbIFTY0f39yIA51TqtDoPBldWIhSqZwhzNWbMT5aHjbQPCsAOYEw2M
Message-ID: <CAHc6FU57xqs1CTSOd-oho_m52aCTorRVJQKKyVAGJ=rbfh5VxQ@mail.gmail.com>
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

On Mon, Dec 1, 2025 at 11:31=E2=80=AFAM Andreas Gruenbacher <agruenba@redha=
t.com> wrote:
> On Sat, Nov 29, 2025 at 3:48=E2=80=AFAM Stephen Zhang <starzhangzsd@gmail=
.com> wrote:
> > This one should also be dropped because the 'prev' and 'new' are in
> > the wrong order.
>
> Ouch. Thanks for pointing this out.

Linus has merged the fix for this bug now, so this patch can be
updated / re-added.

Thanks,
Andreas

