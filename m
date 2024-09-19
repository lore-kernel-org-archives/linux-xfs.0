Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDE8125DE
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 03:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726715027; cv=none; b=iZXYtFGqjNs0/iHen4PAR5GDIAWWHlap53Kx2NYlSL5LSOy3Z0gPZ4sPiQ8ymA+Q6IPVidHbymrwBOGqZ5xZ1igzoxeqm1LxfVDU6DQ5U6K9JM+1OLMdVhbDC97ej2HFz4oZWL99tzPtvMDFvp3b+DVmCWTSVe5BCxUUi2l/qcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726715027; c=relaxed/simple;
	bh=0MvubnRoO2thymcr3IM6P8f7dqwINBUBTCZ/gsgv40A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W1ne8jh1EtSvPv7TvZoNBWQYcZdgtiirtXnxUCxeZjJDBbjAYc+e41yqnEagZwg5bENC/ZPfrutNzCn2D9EhobZJSxScejy6hyoEJu3msTZ/hdaeouStl6nq1OqDhmxPaOZN5EJ4xdkqRf8q7+9Svw0DdoYWBinkMVJXDKZySms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V1j9Ny4w; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V1j9Ny4w"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f759688444so2470851fa.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 20:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1726715024; x=1727319824; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tyPRcAS13dyaq/sXSJCfCLBh5tay+9ZOU9JDC/uil9A=;
        b=V1j9Ny4wUjYE2HQ3yI/mrOlNflvB1huJWFX9h71KCEsUa1tfHxBoXpZLGD0sc33Ic6
         ibp6BprRXYKrjGgfMqkSoHT+8f+wZ02PszCddoKBDbDwYhfbKofucDtIHPSo8cRtozqk
         YgBNnFBO0XN1FUf8cz0kw/UdJfB3bRzMmwN0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726715024; x=1727319824;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tyPRcAS13dyaq/sXSJCfCLBh5tay+9ZOU9JDC/uil9A=;
        b=KFneDJg1KXzOKg7nfHjVluP8ZGowNBixIQluGL8tLCoKCYNP6avtsmNV/EjFewSlMT
         G5Me9JagR5uFLNtihwVzbYFGdnwF2hz7ynoSmI1VeF5rIGiw4bpn1O5baom8ap4Y+05C
         0spmSmdcXGiLY+q8wpgZnhc4xF4UM4gmWJnE/3pbIFrO1Abx3/4n8rbPCjLSiU8BB7Vd
         O7XSwuxr5YzMsgAiW1F04YGR8gQjxXLZqSb6cd9XixY/zEFFG9g9v8ZRLi4W3h/y4Eob
         /i1lr92WeoJI/Nvl5MwMueqYW0xtUC43YvqyMF6dNKMPtYSv77mJs1TIbJol/rWLRbVK
         Ke5g==
X-Forwarded-Encrypted: i=1; AJvYcCU3WekIStLpmA1zX0MxopOjkyHyGTrd63doedXncgVviKXN7Kz7QxYX79V0rXImAPJ9HRJMO8ywsv8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVkCXCtLOkyjx/0deZDYglsAeVBbI6o61c3KCAtKa7Pelkykqr
	Go+FgGcRVE2K6TDm5c48oVwjiiEg/Ec15smJhVPdUbccwrmVuvXJpS1dTZZjuSf0ybBRNtKefdB
	KCp/Mlg==
X-Google-Smtp-Source: AGHT+IHpJRumGaCBnvTzq+/9dffXBH6rTuHxnfD1v+ePeV3IDzpFl2mtZ+4Yd7hp8HXQfu/JUR5UsQ==
X-Received: by 2002:a2e:bea6:0:b0:2ef:22ad:77b5 with SMTP id 38308e7fff4ca-2f787f447c9mr128379231fa.29.1726715023760;
        Wed, 18 Sep 2024 20:03:43 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2f79d37f52bsm15170181fa.85.2024.09.18.20.03.40
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 20:03:41 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5365aec6fc1so406661e87.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 20:03:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVdbudoC31ZMiubl8UySwJ4Zd4HZw06+DOakaja2t6xcPjIeah7GRkY5o1ExlYYzRTpZkm10mRmOjo=@vger.kernel.org
X-Received: by 2002:a05:6512:220d:b0:535:6a75:8ac8 with SMTP id
 2adb3069b0e04-53678fc24e6mr13825268e87.23.1726715020071; Wed, 18 Sep 2024
 20:03:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHk-=wh5LRp6Tb2oLKv1LrJWuXKOvxcucMfRMmYcT-npbo0=_A@mail.gmail.com>
 <Zud1EhTnoWIRFPa/@dread.disaster.area> <CAHk-=wgY-PVaVRBHem2qGnzpAQJheDOWKpqsteQxbRop6ey+fQ@mail.gmail.com>
 <74cceb67-2e71-455f-a4d4-6c5185ef775b@meta.com> <ZulMlPFKiiRe3iFd@casper.infradead.org>
 <52d45d22-e108-400e-a63f-f50ef1a0ae1a@meta.com> <ZumDPU7RDg5wV0Re@casper.infradead.org>
 <5bee194c-9cd3-47e7-919b-9f352441f855@kernel.dk> <459beb1c-defd-4836-952c-589203b7005c@meta.com>
 <ZurXAco1BKqf8I2E@casper.infradead.org> <ZuuBs762OrOk58zQ@dread.disaster.area>
In-Reply-To: <ZuuBs762OrOk58zQ@dread.disaster.area>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Sep 2024 05:03:23 +0200
X-Gmail-Original-Message-ID: <CAHk-=wjsrwuU9uALfif4WhSg=kpwXqP2h1ZB+zmH_ORDsrLCnQ@mail.gmail.com>
Message-ID: <CAHk-=wjsrwuU9uALfif4WhSg=kpwXqP2h1ZB+zmH_ORDsrLCnQ@mail.gmail.com>
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@infradead.org>, Chris Mason <clm@meta.com>, Jens Axboe <axboe@kernel.dk>, 
	Christian Theune <ct@flyingcircus.io>, linux-mm@kvack.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, 
	regressions@lists.linux.dev, regressions@leemhuis.info
Content-Type: text/plain; charset="UTF-8"

On Thu, 19 Sept 2024 at 03:43, Dave Chinner <david@fromorbit.com> wrote:
>
> Should we be asking for 6758c1128ceb to be backported to all
> stable kernels then?

I think we should just do the simple one-liner of adding a
"xas_reset()" to after doing xas_split_alloc() (or do it inside the
xas_split_alloc()).

That said, I do also think it would be really good if the 'xa_lock*()'
family of functions also had something like a

        WARN_ON_ONCE(xas->xa_node && !xa_err(xas->xa_node));

which I think would have caught this. Because right now nothing at all
checks "we dropped the xa lock, and held xas state over it".

               Linus
