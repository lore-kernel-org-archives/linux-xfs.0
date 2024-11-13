Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196252594
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 00:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731457430; cv=none; b=GsnIt2I4GizeugcpPZt+3YrHC2RFFhOnrp2Fv8saCTCtof2OBqe2gFD9lyZGrK0VrKQZuzQwfUVNVJou4JfKtGQMKeuCkTWJu1PfltA1a3BySRb9249g410k7zCDkMf21l9WhGldJTbOG6TDIjF+dbb9DmfdfAUSu3uhgmhokPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731457430; c=relaxed/simple;
	bh=3EvWd7pwnGEo7dSfx/lB6lTVU0t1HY+pMEl3MV/3ACE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c2Mbx7ft8A87Ualvg04Eki/1Z+9WCQCpV18LWFV/qFyG6XJxJDW9mfPPQnOTo1lfGwYurNCfSdO4eJR8ak1yDkR9NsqBXsqGP0ccbeU5p0Hbk+cSVOAFaqkeijHiYHhVYhIgXwVP4/D1b+W8egsxgWeb7hDfe2k0sAxcwVN0mVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Aro67tLO; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Aro67tLO"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5ceb03aaddeso7459520a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 16:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731457427; x=1732062227; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WupZbUO57pzsyzLIiF16uH4yNUQCRicfvRdbxH31iT8=;
        b=Aro67tLOzP3eQSWGa50i5YyG+88HpyzcwLe24wymxNxGfNBcFa4HIQN/5b/ubbIG/Q
         C5hbLHgl5W1kEnxpL4pFFsKZtBkUYyWn56k1NnX7oJp7S/Neu0lFWUuPAYkovUzcGRV2
         TuiDC3hEGTHsGkVCdwM34EosEW1CWGRWLF7Kc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731457427; x=1732062227;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WupZbUO57pzsyzLIiF16uH4yNUQCRicfvRdbxH31iT8=;
        b=aYGq1a06FnBUtG2JHZcwDg+ClRjCNwc0BxGSqVGxRWNg79OIjA5n/6lpcXnzjbZKIe
         ERm4fnioLyEZm78BJDuvJpGcJFZ5MXWmv3mTa7Esr7dxx+3mPHRlujOJsAdInHY49rGX
         obmivfzD0L0bTtw4B2WOz5nlJfpBypG8xwqFA5iIOdoLdhJyXjkgAZPjTyXNR/Gjzsef
         gZftdAJrjv/NiK/9AtH0wBVlnlYEHJwATG3OO5kk6Kwf7DhOAZ+fuE9yb0ZR2W0i+FyO
         y9wEtJvCNED6kcjP6l0kC4zt5lqR8XyuZCg+I37T1bRfu6ZsKdAOxDWRmuOLhJ8xkhXW
         BXdg==
X-Forwarded-Encrypted: i=1; AJvYcCVQlw49JZAbDwyF43ozkhDKviAIVmO6mxn7OdD4aE4qiP3DdcBsiJ/lDf+K+lN2gAWpalR5ubrwlk4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQcsHm8uiwk/EZ0TdBEjrW3A3iTngc/Y2UEiQwjGAk/pIQtlwT
	oeU2fghU5NfwYE7G1PtOTk5zXNwOD3a/F0yr1YHHJHlcxgi3PXTDMDKvY7g1ixlkWIZmdOL4uPH
	x3sdniA==
X-Google-Smtp-Source: AGHT+IFOQarhv7AEyERNY62fhyazUpRByffWy/Qt9Fk0gRpAZIqZXelp0ujslPtFb4DLhSJ1yaxUzg==
X-Received: by 2002:aa7:dcc3:0:b0:5cf:e43:785a with SMTP id 4fb4d7f45d1cf-5cf0e437b39mr13070928a12.7.1731457427164;
        Tue, 12 Nov 2024 16:23:47 -0800 (PST)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf03bb6a2fsm6791212a12.40.2024.11.12.16.23.45
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 16:23:46 -0800 (PST)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aa1e633b829so183142066b.3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 16:23:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVykRHeaB+MwvIqOfQPyLG/rf4tod/rwf/hjTKmmebfUwsIM1k9CZz0aD8YBrZr8hAkqBY4xd1cEB8=@vger.kernel.org
X-Received: by 2002:a17:907:94c4:b0:a9e:8522:1bd8 with SMTP id
 a640c23a62f3a-a9eefebd13bmr1910160166b.6.1731457424914; Tue, 12 Nov 2024
 16:23:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731433903.git.josef@toxicpanda.com> <141e2cc2dfac8b2f49c1c8d219dd7c20925b2cef.1731433903.git.josef@toxicpanda.com>
 <CAHk-=wjkBEch_Z9EMbup2bHtbtt7aoj-o5V6Nara+VxeUtckGw@mail.gmail.com>
 <CAOQ4uxiiFsu-cG89i_PA+kqUp8ycmewhuD9xJBgpuBy5AahG5Q@mail.gmail.com>
 <CAHk-=wijFZtUxsunOVN5G+FMBJ+8A-+p5TOURv2h=rbtO44egw@mail.gmail.com> <20241113001251.GF3387508@ZenIV>
In-Reply-To: <20241113001251.GF3387508@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Nov 2024 16:23:28 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg02AubUBZ5DxLra7b5w2+hxawdipPqEHemg=Lf8b1TDA@mail.gmail.com>
Message-ID: <CAHk-=wg02AubUBZ5DxLra7b5w2+hxawdipPqEHemg=Lf8b1TDA@mail.gmail.com>
Subject: Re: [PATCH v7 05/18] fsnotify: introduce pre-content permission events
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, 
	linux-fsdevel@vger.kernel.org, jack@suse.cz, brauner@kernel.org, 
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Nov 2024 at 16:12, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Ugh...  Actually, I would rather mask that on fcntl side (and possibly
> moved FMODE_RANDOM/FMODE_NOREUSE over there as well).

Yeah, that's probably cleaner. I was thinking the bitfield would be a
simpler solution, but we already mask writes to specific bits on the
fcntl side for other reasons *anyway*, so we might as well mask reads
too, and just not expose any kernel-internal bits to user space.

> Would make for simpler rules for locking - ->f_mode would be never
> changed past open, ->f_flags would have all changes under ->f_lock.

Yeah, sounds sane.

That said, just looking at which bits are used in f_flags is a major
PITA. About half the definitions use octal, with the other half using
hex. Lovely.

So I'd rather not touch that mess until we have to.

                Linus
