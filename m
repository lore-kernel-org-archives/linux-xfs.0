Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7733340A57
	for <linux-xfs@vger.kernel.org>; Fri, 14 Nov 2025 17:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763143033; cv=none; b=p00nQPoCHXTtDU8gGbhVj+0tOA2BMVajQ2AmPN9vMRU+nGrHSAPYclpOHlfGROjB5o1dk7BHa19+LALTOMun8QupRJjcMQX8/5s/nUZPu75kUBB8qnrLUPj7vb0+uzdAKkSnefnyf0Um6J/0rLKgeYUN/B1yZSXbGKQUwoA9Pnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763143033; c=relaxed/simple;
	bh=so6p0BHVkjQUfy+5X9skc9NOHgaJ9CFjc9wu+7i/eWc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S06t5yBNwhkhyFnpKpvn7MugqueTvKKymV55neC7uRs5opRDHANcN8sufEbE0QC0e1DNf2L9Nm4bXoeGKjeIeX+iBydsxggy0Fe+hHmBotl0lBjNKSroTkaJOLQZ1oXpSA3TXrj2TWXjArn0IJ4JKNl1AoBtQWudmikZJ4FyHPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XOq4Cp9u; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XOq4Cp9u"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6417313bddaso3953873a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 14 Nov 2025 09:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763143029; x=1763747829; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vNklGNQ9bRGgaodQC83USJCDTJzreS5VEwsOUbpJpVw=;
        b=XOq4Cp9u3X/dkIWJkt/EEn4iVYho+yp5+ziTnwHQkq5iJbc5K+ziK6MUz+yhha6FRM
         7HmYV7jHku5mkspyf3kXneWCGLWjTr35qt9ga1I69H3z9a/bZGNRZOHX6nEpFpo0EjzF
         sTcPtjevf3PMwTbgWo6yzQSDxTkbMnltRLh3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763143029; x=1763747829;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vNklGNQ9bRGgaodQC83USJCDTJzreS5VEwsOUbpJpVw=;
        b=GiZCT96fLg3AZ964+OfnHzNxMat5WnWAGVYrPDAKOVab8QC3rDsXwA1eIYmysYnUqA
         ilsVQ7QLFX85yLypPAzlm2M6xfhQVWOfgsG1VM361HWEKgO1MAE9Gjt05GoJwbE/0DW9
         TTiK7N5tZl0vfjhbTxok6FXfiig+aUXz5djN1CsdDtvXnQXmKxvyFwnA5NPnRHKZsNbS
         M8bGR5Sk8NTNeLLc10/7uHT1P04vMobUTt2TFAE+2I6SYFHilozE/YOCZ5kIwSms1N01
         gCIxxsBnZ35Tvq05V1bMh7lTlGmE7u95w8BFkL/sLH/0ovGxhZTtYbDTFL4Edr1dK62B
         3jFg==
X-Forwarded-Encrypted: i=1; AJvYcCVT88aWvGfThkJCy0lVTAWttmegTvoR+aJUqtiNx4n7HJaOkH7GmVae4huKzhRHoWETx5SOYnlVCg4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjgqHzMiIc4V9suz/Imwbak+9vY7mNSuPFgufVsvajntVTWvCn
	BUOqIi0ssQKFviOceSU0r0TXFmhDAt33q5lk/cwlLo9y0VUMto6gLb0F1nf9Oan3RdzNTFRps8S
	SvCKhuPY=
X-Gm-Gg: ASbGncstHOZTNVKOtvZupNUqalypWyP+vw8uwd6j2R8oA7WiNCumpqpeOzH8m71klY0
	kpDJso57uQSB22LbEMNcpKbawvqJ4kH5ILkIrvVMd2Y1N20AwS/xZUf5HzqRijjhXR5PhKcpUdJ
	FprI31X1C/9byROTIfUHEoUeNOsTOgSCUD/0XmYKEbiu95KxW6cDLFj+0kyB4Bv1Z/VBk9VRsgK
	sgv1kRyo4ephILtPKWG7uzqffYViM+21HAeexhZkUvHk9clCd7bEy0Abjv2IrulqLQ9gtOQqTnl
	csGx70+nvrgDzgWpcYH4hpsT8FGbiH60+8gzYGyUYJsKRKF09BStnsOF0jyqpzKv9udiTM8SQZJ
	ggZdjiRNT7cqp7OrrjVt8BJ2wK37rcy6v+TtE6AqW4cFY11Dz6wMG/1zhy4H6Rx2Gz3vX2/BaIK
	AW57GIw8C7vWfykt1QgTQC9dikT134IiS/yHHB4cCiPZreqKFE4Q==
X-Google-Smtp-Source: AGHT+IEHmvX+WKtNVlWqtSbmvurzjZjCYXYJWlGuU5Qkvm8BRsNXagCltDmxCTDEFOG7WDkshWlj2w==
X-Received: by 2002:a17:907:e8e:b0:b70:f2c4:bdf7 with SMTP id a640c23a62f3a-b736793d687mr451654066b.31.1763143028942;
        Fri, 14 Nov 2025 09:57:08 -0800 (PST)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fd809d2sm435137066b.42.2025.11.14.09.57.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 09:57:07 -0800 (PST)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b7277324204so299725366b.0
        for <linux-xfs@vger.kernel.org>; Fri, 14 Nov 2025 09:57:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWQEdzJ2e3vp7RYMie+GH9vPBWQg+CLIEasLhY4LBb7qfCfFpOa/VhL1RH+oyLu1nv7r73L+0Whfd8=@vger.kernel.org
X-Received: by 2002:a17:907:a4c:b0:b73:594e:1c47 with SMTP id
 a640c23a62f3a-b7367829b07mr457884466b.26.1763143027209; Fri, 14 Nov 2025
 09:57:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114055249.1517520-1-hch@lst.de>
In-Reply-To: <20251114055249.1517520-1-hch@lst.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Nov 2025 09:56:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg=B_E6xyFWF0s2mGrRP==7Oo9WAt645x6n+Fb2FAWNjw@mail.gmail.com>
X-Gm-Features: AWmQ_bkAygS1m4gIrLP85OuFDxKOwq2g5_BcgKz10fXDRtXdYrbuz2oWG7iLQkk
Message-ID: <CAHk-=wg=B_E6xyFWF0s2mGrRP==7Oo9WAt645x6n+Fb2FAWNjw@mail.gmail.com>
Subject: Re: make xfs sparse-warning free
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Chris Li <sparse@chrisli.org>, 
	linux-sparse@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Nov 2025 at 21:54, Christoph Hellwig <hch@lst.de> wrote:
>
> this series isn't really a series, but a collection of two very different
> patches toward the result of having no sparse warnings for fs/xfs/.

So I answered the wrong email (because I saw the other email first).

I think making it sparse-clean is obviously good, but as mentioned in
the other email, I think the clang context tracking is the (near)
future when it comes to static help in lock context tracking.

I know you looked at that clang context thing earlier, and assumed
that that is what triggered this work in the first place?

Anyway, iirc Chris Li already at some point indicated that he'd rather
remove the sparse context checking entirely than try to make it
smarter.

I do think that being sparse-clean for the current sparse context
tracking is a "good thing", but not really because it makes sparse
happy: it's a good thing mainly because *if* you can do it, it tends
to mean that the lock context rules are really simple and
straightforward, because sparse just doesn't do anything non-simple
very well in this area.

So when you say about patch 2:

> I actually think this improves the code, so I think this should go into
> the XFS tree.

I heartily agree. But then

> Patch 3 duplicates some XFS code to work around the lock context tracking,
> but I think it is pretty silly.

makes me go "if you have to make the code worse to make sparse happy,
maybe just look at the clang context tracking instead?"

Because I *assume* that the more complete clang context tracking
series doesn't need that?

            Linus
