Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7305A202C3E
	for <linux-xfs@vger.kernel.org>; Mon, 26 May 2025 20:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748290371; cv=none; b=MrqZjB87+P6bTtI/4GNx8nvoqCKtnWST1iuFeS1L/oAqgB5jew4xHOZjhMTbp6sakWrDkG4dEX4VD1W3AtMWzbOmwprI9z0JfL2rOPfixkrHTDjQ9Orqw9csJaSDzx5mumfXhljvcDu/JUhNlEJKlwTLXsnRi2gdbyDAyMGXSG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748290371; c=relaxed/simple;
	bh=sKO6H+DwrusoGVu0xtfVa8lrv0aeD3QqH/CjBqX/eho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X1XNcAVcoQzAcpC8J2EhqBBwGOanz5LPcFRBs5eVAaxek4TSTuhKKpALKMk4MMkXuy5l+HSgAPYhKy0rDauR9V4gyVCfmurlxsNGPisTz6J71dwloeiY/AN05/GefNAJjN/HKeJAAueJ5DYbcQSPldG+MVCZAVEKgdTAjVBpilQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DWlDaPYD; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DWlDaPYD"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-601f278369bso5380293a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 May 2025 13:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1748290366; x=1748895166; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gP6QUuvUwuV5rP3Qdfm2opkRTuTH4hvMluvVyOr/l/Q=;
        b=DWlDaPYDb8p4JRso/EPMi3ZO2BsIt7XdSG/oGRwcpP3oCioEirGaHM3Z3Q5KsKclHX
         1B451QKy9kSUiGEENCZjZQiVfKN0u97AI+P8ailInR17nSDDc0Waz2+S5QINrGiJfP8q
         iivv23HVjUFhE52pcwLojpAqrEtQIBNCMuQfk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748290366; x=1748895166;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gP6QUuvUwuV5rP3Qdfm2opkRTuTH4hvMluvVyOr/l/Q=;
        b=eYbczIJDJVlM7vkpZUAMrzDyGrB6Pj33hENXtkGtFt41oLa8YUsIz+lrB7TmksbByX
         UGEnsY5eCNVr7YThiKcO1ENKF4AMcLjtLOUUgYpsVv/BcapbjmkpHPnJ4kAUe9sa0gRu
         Lc9nOxDoPudXmEZ0jC6DYgoXeJeHkSgBgN6lSgSQ2LruZV3tkResxmRDZm5NhPOPqsX3
         KjpkCaG9XV57yV+uik/MoHfSfuYoqFXTSrEYRB0NDXDP2Caau2sZfT80KzX3zsmUasH2
         XlCJCigLIpjiggjK854zz5ZXilmED63nbUyHzfXcycXedLx9K4X87Wki1Iay9Wu7id1b
         sDUg==
X-Gm-Message-State: AOJu0Yx7S7Tw5ivjQofOqrP+GFOGQub+KdHBQmG+9lRuNcbqmF2vEMkU
	TPKyZ29FPH3eLVKz0yPsA/iW0adHjQJG35xMHQwOHz20x7VUlX51He8QnksT926Rr3o0330ydqu
	JNpzDUIY=
X-Gm-Gg: ASbGnctefvuLbFPkGu4PXgCRPj0Cj9JXL9A10vYwVdX53RD/7Zwht8WPVwFQ2Kokyqk
	xjkAqydKYLZjYUtCk3q4sz1/Y7eo36TPUs2qWe0lE0fkxkhb+SYnt5nHjRafP0I3BSo2L0bfkCj
	W17Y0PDhnqZ5Vc21gZvqJDHE31ELM7f2YHoI48bHWcESTOWqfIyqwsFApYMwNmhG9z3zz7D4NRg
	d8azNcYowZ6naAk2z94MhVeYQrr3C6yepQI5uPUcHLmgvux7QDZflosh94wRVUnoqEy9XfYYgwn
	uRHpdJbi24V/oqDm0k0pROkSUMBg0mpLIe2j0Pp0P+5FUnOcxnnScn9QmYafnHJosgHs4f2e+76
	VuO0hxh98D64gy91wWtdjonez9w==
X-Google-Smtp-Source: AGHT+IH+TNrlXqyoVY9XPHCE5HacmW1231YKcSelIZF42c8khQ5k1iaMbGGzqkXbcuxyINN8eK302g==
X-Received: by 2002:a05:6402:13c9:b0:602:1061:5ebb with SMTP id 4fb4d7f45d1cf-602daebbb94mr8098956a12.32.1748290366261;
        Mon, 26 May 2025 13:12:46 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-604bec52dc1sm1477119a12.23.2025.05.26.13.12.45
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 May 2025 13:12:45 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac2bb7ca40bso468579266b.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 May 2025 13:12:45 -0700 (PDT)
X-Received: by 2002:a17:906:dc8a:b0:ad5:7732:675b with SMTP id
 a640c23a62f3a-ad85b255080mr1003525266b.40.1748290365296; Mon, 26 May 2025
 13:12:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5nolvl6asnjrnuprjpnuqdvw54bm3tbikztjx5bq5nga4wuvlp@t7ea2blwntwm>
In-Reply-To: <5nolvl6asnjrnuprjpnuqdvw54bm3tbikztjx5bq5nga4wuvlp@t7ea2blwntwm>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 26 May 2025 13:12:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjhJ7FTM-Go1zJWK=Swy5MPcoQaZA3=McPXr8F7=igj+A@mail.gmail.com>
X-Gm-Features: AX0GCFvdHZuXRAAmxjPlvIYAnKTto5xtKyztrGXXiv2bWQKRuz6VK28E9WeBdN4
Message-ID: <CAHk-=wjhJ7FTM-Go1zJWK=Swy5MPcoQaZA3=McPXr8F7=igj+A@mail.gmail.com>
Subject: Re: [GIT PULL] XFS merge for v6.16
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 May 2025 at 02:21, <cem@kernel.org> wrote:
>
> This is the first time I'm sending a pull-request with a conflict, let me know
> if you need any extra information beyond the one I added.

No, this is plenty fine. The main thing is the heads-up, which I want
mainly just as a sign that maintainers are aware of - and are tracking
- what gets reported in linux-next.

But also partly because it can then make me take those conflicts into
account when planning pull requests (ie I might end up delaying merge
conflicts that look complicated until I have more time to look into
them, although honestly, that kind of complex merge conflict is _very_
rare in practice).

So typically all I really want is just a "you'll get a conflict in
xyz" heads-up, although I do appreciate any details on what happened
and what the resolution is.

That said, I do note that your diffstat is also very messy. That's
"normal" when you have back-merges, and it's not some kind of fatal
thing, but when it happens I do tend to like seeing the result of a
test-merge.

IOW, those messy pull request diffstats only happen when you have
non-linear development, but that also indicates that you know how to
do merges.

So if you notice that your pull request diffstat is messy, and
particularly if you did a test-merge anyway due to known conflicts,
I'd suggest replacing the automatically generated diffstat with the
one generated after you've done the test merge.

In this case, the real diff summary (modulo differences in diff
algorithms) for your merge was

 48 files changed, 1521 insertions(+), 188 deletions(-)

but your pull request ends up containing the diffstat for this horror:

 1621 files changed, 14176 insertions(+), 7549 deletions(-)

and that is generally a good indication that "Oh, I had a back-merge,
so my diffstat shows the diff against some random upstream state that
contained lots of other changes too".

                  Linus
