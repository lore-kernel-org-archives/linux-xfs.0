Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEF52AEF5
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 04:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721229; cv=none; b=IcxeE6tQyHc6XUnhYSkhZP2FW5ygQLKIwE8qbIaKDq6N/do9us5QMb8JiXhoo9+20/pLiYJy2K6nbSe8OvhYEuN/WtK4ronAGy2FWdRaWJ23H7POAyK9bT+wmiM/p8Rtcv2Kx0rX1MgTyNGOiSnAAu6WtcMrFDn+R9O9haoUw7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721229; c=relaxed/simple;
	bh=0x90BrRaLqj/i8vH0YC0E0hwcTLNOAmqTSYD3JcCxfY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BotdnvTsecpA8ZwYw/gGk2c1LfUAw+xzQUhYXE8+hBO+Kt0u75L5Ic9bRRnR+Fx21GWm59L38DQk3TAfK7aWYRjSSDLrDSY7dFmy2kfhdyjlHPRNSp7eW9F1J3+u2MXIjW61ckgfmTm3hN9NCIOeJlV3Qoo8+nluiezOmeneZxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gQpSkQJ6; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gQpSkQJ6"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a8d4093722bso52696766b.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 21:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1726721226; x=1727326026; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v5K6WdNxpXbbHrFkTCJEcTGagR1i25Nnb2d6KDOnxQ4=;
        b=gQpSkQJ6vqQ1y97z7BQjKHYP1LBMTb/TP32/OFGANn63TxesWuhpyPL9/5CChtK8cW
         aXjTpoMAknDFKn9bnJUlOLvzuQrxaarRypMk8Igz+vRlkOB45sSj/LAAwK8qfCNyaoiW
         YpNSlKcsXyY041Xz9Kdw68pvlPXCykqdVHl/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721226; x=1727326026;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v5K6WdNxpXbbHrFkTCJEcTGagR1i25Nnb2d6KDOnxQ4=;
        b=O09neNqYFcwAlXNCrSlBU4WTiL5sYy72/xlL3/FxubN2QHLohgG0zQPlFHbGx4qNNQ
         2A1tdeG5r7m5aw937Db6GKL7+W26MypIKKmnP+pHSnykzm0WIYCKkDxbo5W0PhkwNmmw
         kwqTiM8nDrAaFA+IO1x+k8SfQegiXChVV+GTtg1jV9l7WG4J18Z/fjIVPbr8m7GT6fTA
         dE4c2vSMaZbqiTgh6iOHgy2LMWOsdytaff95SMI4h+/XuCe44HMNs2BFdGTO3mI4/3KY
         Dji5PeJXbuf4PkLUObmLuTFjxUjGgDODL+zA91PxKCyXXQewfPquqE3EcgQQtJnVQxGS
         jAdg==
X-Forwarded-Encrypted: i=1; AJvYcCV0WWSYzLtOJT+7PNicr7r8kEa/Xx2foUsFN6bSx4DnNAGJAsffqYx+WMy6PbArhYlOS2nOemuokSM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhJX9XIqShZKLEfjlEerwNGKAA8+PPSLr3e3SLjqYoyChsdvZE
	oSKdsVxpqZaJmy6tWbYkYoVxMrq374F2COh5RFHZQDAjdXp4zOnNtx2uEx5rEUPZOcrLPLe0T0x
	KfaCNYA==
X-Google-Smtp-Source: AGHT+IEluLFkZ9SxKtGf934fMPJzAdchgX4mBR9X6AQnyBMvGC702nLf0+nzjrhw4irvqJBTdajUxA==
X-Received: by 2002:a17:907:7d9f:b0:a8a:7b8e:fe52 with SMTP id a640c23a62f3a-a9029679634mr2664467066b.59.1726721226099;
        Wed, 18 Sep 2024 21:47:06 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90612df525sm661062466b.159.2024.09.18.21.47.03
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 21:47:04 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a8d3cde1103so47653266b.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 21:47:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXPCtuY+LdQ6HuLhaYqNobhPRkoYeN41cSvE0LnRU9OPtpjXOcEz/2gehOu91Qru8O2aBjcTcfR6p4=@vger.kernel.org
X-Received: by 2002:a17:907:efc6:b0:a86:9c71:ec93 with SMTP id
 a640c23a62f3a-a9029438edemr2426724866b.24.1726721223112; Wed, 18 Sep 2024
 21:47:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZulMlPFKiiRe3iFd@casper.infradead.org> <52d45d22-e108-400e-a63f-f50ef1a0ae1a@meta.com>
 <ZumDPU7RDg5wV0Re@casper.infradead.org> <5bee194c-9cd3-47e7-919b-9f352441f855@kernel.dk>
 <459beb1c-defd-4836-952c-589203b7005c@meta.com> <ZurXAco1BKqf8I2E@casper.infradead.org>
 <ZuuBs762OrOk58zQ@dread.disaster.area> <CAHk-=wjsrwuU9uALfif4WhSg=kpwXqP2h1ZB+zmH_ORDsrLCnQ@mail.gmail.com>
 <CAHk-=wgQ_OeAaNMA7A=icuf66r7Atz1-NNs9Qk8O=2gEjd=qTw@mail.gmail.com>
 <8697e349-d22f-43a0-8469-beb857eb44a1@kernel.dk> <ZuuqPEtIliUJejvw@casper.infradead.org>
In-Reply-To: <ZuuqPEtIliUJejvw@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Sep 2024 06:46:46 +0200
X-Gmail-Original-Message-ID: <CAHk-=whPYGhCWOD-K2zCTwDrCK27Y0GST-nt+cb9QPzxO-iSHw@mail.gmail.com>
Message-ID: <CAHk-=whPYGhCWOD-K2zCTwDrCK27Y0GST-nt+cb9QPzxO-iSHw@mail.gmail.com>
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Matthew Wilcox <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>, Chris Mason <clm@meta.com>, 
	Christian Theune <ct@flyingcircus.io>, linux-mm@kvack.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, 
	regressions@lists.linux.dev, regressions@leemhuis.info
Content-Type: text/plain; charset="UTF-8"

On Thu, 19 Sept 2024 at 06:36, Matthew Wilcox <willy@infradead.org> wrote:
>
> Probably xas_split_alloc() needs to just do the alloc, like the name
> says, and drop the 'entry' argument.  ICBW, but I think it explains
> what you're seeing?  Maybe it doesn't?

.. or we make the rule be that you have to re-check that the order and
the entry still matches when you do the actual xas_split()..

Like commit 6758c1128ceb does, in this case.

We do have another xas_split_alloc() - in the hugepage case - but
there we do have

                xas_lock(&xas);
                xas_reset(&xas);
                if (xas_load(&xas) != folio)
                        goto fail;

and the folio is locked over the whole sequence, so I think that code
is probably safe and guarantees that we're splitting with the same
details we alloc'ed.

                Linus
