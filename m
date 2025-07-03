Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7340C223324
	for <linux-xfs@vger.kernel.org>; Thu,  3 Jul 2025 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751559084; cv=none; b=PBdYlqg5Gu0/mBnRxnAjwGWpuKH/RTY78U9fcPzTfC+WduyTT9Y9OudguzPwmRNyXHTDFfve99MnUh0ND1naoghBiyERra/3f9Tv9v7EFw2Nm+36C0D8EscDSy8mBZZM7oA6Tv8cJwj0+ikJenl+3D9YhZMftB56dxAYDOc3eXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751559084; c=relaxed/simple;
	bh=5Q15mTl7zXDjGUybgjZSm2naXG4wk8u3Td0vuFWnnhE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DN/CFQniweeOkzL1m5jsFYoZdMAf86SCuLQa36KMVLPZWN9eUWcFZ7PFSHud2rd2eMxP7HZH1lW7pBIMnveBRKUsqiWhGiMpmHDMe9gWDaCQy+hGPLfs7sSZO8dv+UzhUyAvFcJvvVLOLQqbqeHWsyD3cNakN0Sjt04hnbvNdlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AJgSJ86f; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AJgSJ86f"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ae360b6249fso10046166b.1
        for <linux-xfs@vger.kernel.org>; Thu, 03 Jul 2025 09:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1751559080; x=1752163880; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VsY1evypvVJJ4XOG81Dwk+h0yBxzTVC3dQW0NAq6kj4=;
        b=AJgSJ86fSivHF95x79mU+TYnKnGHgtzCiFBLi8TfksB89ESQHoYRMRyZh5RQzaoHKG
         cGQo7AY0j8RhDi3vrMjci4v4JKy06/+kwrIXqUFg02gzNG5Kli8x4Cee9uFn1MnomKl1
         0avNfvDy9YC5tjwx2Goex5OU+yQ4V/8KHEJsI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751559080; x=1752163880;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VsY1evypvVJJ4XOG81Dwk+h0yBxzTVC3dQW0NAq6kj4=;
        b=BswzwJpK1ETfVu/0ryy9SEScH693Lws5mv2acIjG8UYZLhRBLOdQqKB8pj56aCUcuk
         EA7/N0LxIN45c2Daul8D5M9RyTOP4SHGFuthsZzj7JVqKnLw02XCJCMXUwr8bZqQ4Gm7
         tTe6IloWPveFixmPGPPzsEKFp7kapemhJ0gOHuKvTL7ipxz/tox8/1e0troX19P6mmRH
         rQF+J8pdxZarPs+jeNQ/zpvPd5QnrRyA5hFYXMkqoB27XPHNApdgv8itARXU47McB2dk
         ev5ku6+PgQzTBMhPsf7bkCnpwts2mBYga/QxYQkd0BYixOri0l0vOaWnpF7b9c81i3T0
         VQUg==
X-Gm-Message-State: AOJu0YxpojhW57ElY08aNLRGoXezPkF11ViUlmTH5Oa/gBpdfsb3v02D
	xtJ73xro77aUhf3f5uo58kigN9bjZUBUUiQANIlrx6qO50G8ONbibuROCSIlBNWELqxa/i2mGEI
	FHkfMXko=
X-Gm-Gg: ASbGncv2ka2Ee4InlzNUdpiuvVkFxx1K3zIyZCp6fmzs2OPgTVg/3NRvTKV3n/Jihnw
	OzS9+xq1W3kueM7hXo3Q0rmYChD0dXwQsz3+nSg6jUQjVUtUB/oOymCe5oxuyaoWWAYdN6ICHLz
	r572KPWJg9277a5YeHfoTd4ptn5Zidz2Tvwg8tsqZZJe43tyKLr4n6F6hvqKLcxLWhcr39J9zeT
	EQmSav2lwiEEndayvGyeDXaUbBvwxdye0jy1G4LcM9e5jg/YLy5MGxwCRiUSGFQdio4cNZ4sXOx
	D0NJqXtUxSj8HlmS8AZ51clWbm8eEjuNBbnN5V9R4PhHeVk7zAcvnmW9t/zXc2boU7XL8eP9Mf1
	LHfe1hH2mWXNrL5dI51wV1YDdY7yH9tyCIjMT
X-Google-Smtp-Source: AGHT+IF2pY9lwSuWAm/gN+x6gZerm7uEVCquNRK0be/li4e5NMTItHYYiXd2ODs7/lMgbxGp4XkoBA==
X-Received: by 2002:a17:907:9724:b0:ae0:b22a:29b4 with SMTP id a640c23a62f3a-ae3c2ce80e6mr720266166b.39.1751559080379;
        Thu, 03 Jul 2025 09:11:20 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353ca20a0sm1299585266b.177.2025.07.03.09.11.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 09:11:19 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-60780d74c85so12414823a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 03 Jul 2025 09:11:19 -0700 (PDT)
X-Received: by 2002:a05:6402:1d4f:b0:60c:3d54:4d2d with SMTP id
 4fb4d7f45d1cf-60e536053b8mr7263788a12.22.1751559079433; Thu, 03 Jul 2025
 09:11:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <fy5upmtfgiuzh55xaghv3w3vqqsbgszlraw6hv23a4qycirsg3@qzbwz5m2q7f6>
In-Reply-To: <fy5upmtfgiuzh55xaghv3w3vqqsbgszlraw6hv23a4qycirsg3@qzbwz5m2q7f6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Jul 2025 09:11:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj=uUjzNAnAdZ-XpaU-GB9E4fH3tk0CST6W3m3vvObruA@mail.gmail.com>
X-Gm-Features: Ac12FXzW_sJ6UZrTioISauqQe0s7M0GJyi2BqWAkz77eEdkS8RSJ9j4tX4AxwSs
Message-ID: <CAHk-=wj=uUjzNAnAdZ-XpaU-GB9E4fH3tk0CST6W3m3vvObruA@mail.gmail.com>
Subject: Re: [GIT PULL] XFS fixes for v6.16-rc5
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 3 Jul 2025 at 00:27, Carlos Maiolino <cem@kernel.org> wrote:
>
> An attempt merge against your current TOT has been successful, and the
> merge stat is at the bottom.
>
> The patches have been cooking on linux-next for a while, with exception
> of the last one which is there for a couple days only, it includes the
> FALLOC_FL_ALLOCATE_RANGE as a supported flag to the flags mask, but in
> practice it adds no functional changes.
>
> This pull contains the addition of a new tracepoint which has been used
> for debugging of one of the bugs fixed in this same series, I don't
> consider it as a new feature and it seems to me ok to add it into an
> -rc, please let me know if you have any objections.

The only objection I have is that the explanation of what the fixes
actually _do_ was entirely missing.

I appreciate the "metadata" explanations too, but for the merge
message what I need is the "what do the fixes actually do".

I made up my own explanations from looking at the commits, but please
don't make me do that in general.

              Linus
