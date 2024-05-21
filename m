Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98FC8C13
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 01:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716253553; cv=none; b=Ep7WNa5H8TrSq+bsgJeoxNQFVJXQCDR86JwtSvsookGmK5QQmw62F0ZwLcaYOXeblTZ2a4WgMIrrce5680sGljfHf3veMsfO+N+n00XH8HEBuF0JvE7rD7rN6ZWnuUER0AS0ENwTG0nXqMCtxR1W4oCyuSkroSBLELWrGHCqlP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716253553; c=relaxed/simple;
	bh=sODGnfmKfl05kirINZM0ji46vr8FOdY8tSVDyJHhRbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oSlViAj2Zu5iydgdEZ6xbOk0We9HCXAfFUtbYcIXbOLDzdHxfEbqEsyU3EkmNLpikvfjtqA8Fz0SZXfPZpVovPDsrYRablwES3qGvAVYbhSL+oJO7BM5ZTLu+0cshUMBEs9HPB+UojD+kh5Gf3U+NY3WDfl1SCP5TgJkigwPFX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GEoTHXUr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GEoTHXUr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716253550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p+IRLtr3CD5713sw58Oz9jeFDrRIoC1ExmWuiRLK+04=;
	b=GEoTHXUrhWOQtJe8/gVRXYHEtDMgF/YjnJkK4+cO1Le3JZtxtg7eJzdvC4YiZEgYhi0Es2
	2EYb7qgQICzfgWGMHW83zHpRX5TVrZB+p4bUVuoBBMaaCilNeVkh3ipNvfV2TOMZH3qeGx
	XmY9sOoejEJBz4SYZOlCgLqA1gAws2E=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-KeCRYlUTNsK6up0b_EHx3A-1; Mon, 20 May 2024 21:05:47 -0400
X-MC-Unique: KeCRYlUTNsK6up0b_EHx3A-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a55709e5254so492623866b.3
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 18:05:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716253546; x=1716858346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+IRLtr3CD5713sw58Oz9jeFDrRIoC1ExmWuiRLK+04=;
        b=T8K3lk2/4RO+XV8LhZybLZY8gh/v3IW7i+0axkRtWj7RqQ6VPigknLt+2JmOZpqnM9
         afdlccJArBI722SCoJ5d3BKRd54QM8C50kEIGlvGj3OIXN5xare+BCYV3ZL2meHh9IZC
         zw16wxA1Hfvn3Kw9+f6eSAi6AsVLJ8Vd5KY2W46976tXQmK6AzWUrkUittQOoemqHqSP
         PypG8BhZBmtmHzvFeMMbjaWldCEJcIYfSrFZOACfld5ryR6DNHKlE5BjKVMyDl8mghGD
         FOTzaHgk1nGinfObrYCIzJOSGSkrLIFzLCJvwTVyFd6Q+c6LGYtM+94UcsQiSl0a2Z0f
         B+EA==
X-Forwarded-Encrypted: i=1; AJvYcCX6OagMUPcZGogQNvrKApZQ1mffqawWazoT18kJg9DYGX1Uo5rMgj7d/rQI/hjVH5DDJQf4gbKw0sYwzbFhyBxuCymGumR7a9XB
X-Gm-Message-State: AOJu0YzlDi74M6Q9dRy+5Y0GatmAlKlQGxbFl7CGrHsSZ6T9c7hyNtrs
	/4TqcDRINUyhhGPrvSnBTQsiu7NVkeMs9OKyz5tHKRqWeNW5oB3kxfzbnrmJnb4GiiBPM2KK/Rb
	R4gm+6DGsz7+czkGnURr6UG1+tZdjmy24xAFZaOUv7fopdaIh5WoMI7IHA4lSQoVcr4dhKe5EIl
	P6gNV6aKJywlfvJ/1WSDqkg2X0maQ8Xkin
X-Received: by 2002:a17:906:eb52:b0:a5a:769d:1f8f with SMTP id a640c23a62f3a-a5a769d1fb5mr1326814466b.68.1716253546268;
        Mon, 20 May 2024 18:05:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmLA8Se8SsEJHpWJGihreHRU2FyfqBzUvAldKqKbqZ3YYcBppqSSpDm5brTkI9ODNGufLxUVJm562I8U/37oM=
X-Received: by 2002:a17:906:eb52:b0:a5a:769d:1f8f with SMTP id
 a640c23a62f3a-a5a769d1fb5mr1326813166b.68.1716253545613; Mon, 20 May 2024
 18:05:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGS2=Ypq9_X23syZw8tpybjc_hPk7dQGqdYNbpw0KKN1A1wbNA@mail.gmail.com>
 <ZktnrDCSpUYOk5xm@infradead.org>
In-Reply-To: <ZktnrDCSpUYOk5xm@infradead.org>
From: Guangwu Zhang <guazhang@redhat.com>
Date: Tue, 21 May 2024 09:05:34 +0800
Message-ID: <CAGS2=YqCD15RVtZ=NWVjPMa22H3wks1z6TSMVk7jmE_k1A-csg@mail.gmail.com>
Subject: Re: [bug report] Internal error isnullstartblock(got.br_startblock) a
 t line 6005 of file fs/xfs/libxfs/xfs_bmap.c.
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

yes,
the branch header info.
commit 04d3822ddfd11fa2c9b449c977f340b57996ef3d
Merge: 59ef81807482 7b815817aa58
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri May 17 09:40:38 2024 -0600

    Merge branch 'block-6.10' into for-next

    * block-6.10:
      blk-mq: add helper for checking if one CPU is mapped to specified hct=
x

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2024=E5=B9=B45=E6=9C=8820=E6=
=97=A5=E5=91=A8=E4=B8=80 23:09=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, May 20, 2024 at 07:48:13PM +0800, Guangwu Zhang wrote:
> > Hi,
> > I get a xfs error when run xfstests  generic/461 testing with
> > linux-block for-next branch.
> > looks it easy to reproduce with s390x arch.
>
> Just to clarify, you see this with the block for-next branch, but not
> with Linux 6.9 or current Linus tree?
>
>


--=20
Guangwu Zhang
Thanks

