Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E192938F83
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 21:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731362154; cv=none; b=ZEwlSgwMQmhlzohb0rbQ/4Y5k1h4sYPvln2bNa/4RKPrl8wgA79YKa9XHm82iAPPKalujz9tKeAfsgctwKMcLkr3OicPfL6Xezfo5scYUknGf8D0qR08GkQU1hiNbIN+sh/4ahN5Ij44qauD0DNW8HXqF58qZRdEI50OL2KhOe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731362154; c=relaxed/simple;
	bh=SZIQDa8NLYM1ipFkY+LfWhNba2RshbH0DPtK6JH9h1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F8am7JszG0cH7DW1TNnLkJvm1xzDThXmLGtZBovk2qZ3dL9b5fYsi+hXZYXFCsGGpV7C49dHvwRqyusqcII1fimAhRWBcgQNZspJeTkh275lwfG4CFTunTVYrvh9X3FFu+9v2rOp2Kk/hiGiLnnupy0biDgEcNG16jV9PBhXMxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TI/eJjQY; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TI/eJjQY"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9a628b68a7so899019066b.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 13:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731362151; x=1731966951; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1yUAbMKFGFD+r6n6bBm/WiyB3YmOPXFQ3bg8vJC1p2Q=;
        b=TI/eJjQY5n2/fQZ+6DoN02J4woFPIMbfzepQLualFan0DIqJvbYUew91nP+OLv7o//
         wBR4vPUvB8vRcSBirxL+GfPWQ/5PKKWcYhxy1nVmcc4uo2pF4A+G9ogbN5S9WFwBaOaM
         7ubNNrv9DwD/ClPeLpLmbxuNw4brv9+owu34c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731362151; x=1731966951;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1yUAbMKFGFD+r6n6bBm/WiyB3YmOPXFQ3bg8vJC1p2Q=;
        b=APtXiWTC8D+eX2zzLyXZALDCSx3w3jpC3lICi5vd70+Y558RPqDhRDHkMOCQcNZE1B
         pL4IdBz8BCpJUQXGljkScTKNQrZ0hDoCIA+Zg5k5SLe90y5OCVavwTfTuxDFVCpmgYIS
         kah0KrN9YyJwXscETG8aAwQThRPMN8GHuXA7hUzr35a/nN+P1fEbJQfYpsmYJHOcWr73
         /QFfRy3SAUpmpsZquj3yFawG3gFwwtv4Iquw9jYCrT0IiJ2Xk3ZoyedhREPSCThy2cvY
         5Q53C1cq1GxwrdhvTB3D+uj6OsBIYj5XiKGPPF8i2lAXSRS2x44hDqJsX3AHomche8gp
         bIzA==
X-Forwarded-Encrypted: i=1; AJvYcCXghfSmnNHh5rLsokuJewkg7TSEo3Bnjo4wZC91kNylho47d7tq55yQW/1/t1Gc13P1ZWFSTH9GQ5c=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywbx2g8u7P6VCyGhUylTji66qZI5Kore07sqHq5LDJFXvZjDGTc
	d3kfeFPSoj7pFd2MkrpoQRWSPa9CC+po1rQJlUKdSvxA2AxiX53N6Rkz1BbZp+TLf4fuwfHR/12
	Gx7s=
X-Google-Smtp-Source: AGHT+IHp6kkxfVnm7P7DHSKoLO+s/wI5+7PgjdNFI4YX7N3V99nMo2krM5hoeQVH6dei9jTXsmeKag==
X-Received: by 2002:a17:907:3e82:b0:a9a:1115:486e with SMTP id a640c23a62f3a-a9eeffedd22mr1407133566b.45.1731362150952;
        Mon, 11 Nov 2024 13:55:50 -0800 (PST)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0a17635sm635736066b.17.2024.11.11.13.55.49
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 13:55:50 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9a628b68a7so899016366b.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 13:55:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVJyOjydK7rYTJ/STGqTcflN+pkoOq05rlVD5QYPawM2u/ogS0g+gs/mnsacPU9H8eJ5mb7N1Du6xU=@vger.kernel.org
X-Received: by 2002:a17:907:eac:b0:a99:379b:6b2c with SMTP id
 a640c23a62f3a-a9eeffeee33mr1449197766b.42.1731362149380; Mon, 11 Nov 2024
 13:55:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731355931.git.josef@toxicpanda.com>
In-Reply-To: <cover.1731355931.git.josef@toxicpanda.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Nov 2024 13:55:32 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjUDNooQeU36ybRnecT5mJm_RE_7wU4Cpuu7vea-Tgiag@mail.gmail.com>
Message-ID: <CAHk-=wjUDNooQeU36ybRnecT5mJm_RE_7wU4Cpuu7vea-Tgiag@mail.gmail.com>
Subject: Re: [PATCH v6 00/17] fanotify: add pre-content hooks
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, 
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 11 Nov 2024 at 12:19, Josef Bacik <josef@toxicpanda.com> wrote:
>
> - Linus had problems with this and rejected Jan's PR
>   (https://lore.kernel.org/linux-fsdevel/20240923110348.tbwihs42dxxltabc@quack3/),
>   so I'm respinning this series to address his concerns.  Hopefully this is more
>   acceptable.

I'm still rejecting this. I spent some time trying to avoid overhead
in the really basic permission code the last couple of weeks, and I
look at this and go "this is adding more overhead".

It all seems to be completely broken too. Doing some permission check
at open() time *aftert* the O_TRUNC has already truncated the file?
No. That's just beyond stupid. That's just terminally broken sh*t.

And that's just the stuff I noticed until I got so fed up that I
stopped reading the patches.

             Linus
