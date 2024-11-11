Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A599838F83
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 21:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731361926; cv=none; b=Gwc2920myf2B3L5rT06RWtB0pD1eUJgU7U2edmQt6X7+j34p2ehqRvxqnxjl6I6X23tBKV9k0ufsDHATODljdiMJ9cKFMb6b63AwmymXALc07Tayvdzc/Y2qRSIGivj/MQXbzAYFlcrzGwtR4PKD+H5WnGkMojKLXAS/W3KwUfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731361926; c=relaxed/simple;
	bh=q/zqChwYsrx4Zy33qGdG8SBhmqndzWb5CoC2UrWb3jQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pqnVZpZUA+P+NsM9KAwcfDWIgVru+qqSoEFIA30H22N255jFTcg80PsfF17MGWja2voWYBpq2GGXIU8nlrAojVZIgStAw4JQWVFNlHfP+x1X/YRs1nZOkotk1r+udPEgmmBteQdCeuqA2qQv72oxrUWmmd6M8ihOfHHh7joMkbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YFd6xClp; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YFd6xClp"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a93c1cc74fdso848340466b.3
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 13:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731361923; x=1731966723; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L24fLxFCjFl/hQH9TQaBFKqNsNfJNVwL6H3wGfP4DSE=;
        b=YFd6xClpm5Z/rzg6DadchCVqpv8DOwXHjqj7Ko3l56u5zz1yKHyyRc++0S8eIDO4YE
         PrJNVpOWHb9kX2FZ1dN3np/6q828VkOeD8J08UZorF8kSUuiqZs0hPz5hgC93h5Z4Foz
         tq762Jj4K6vCkVxZIif89KrBNQm8lDNWnrgNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731361923; x=1731966723;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L24fLxFCjFl/hQH9TQaBFKqNsNfJNVwL6H3wGfP4DSE=;
        b=Cbx8nCHLAz1kPEnEwqUbR384dwN2FbRVblaOFITzTvwmfM3332g7TCuVQ74/aNrROS
         69QFZLcN8vzpUHm0G7LksEb24A7NKFHP2pLLShCztlvMqH7yf5xeiLiTjJYVA9F7IYEk
         lWfdq0XHsSdD7804/tIZCXcv2AZITOCurlQOAkAccCXJbf5Bm3iZOH98nZYfwyFesTgS
         K0bEB+wB9p45eJI1RnN10qVu2goMo/h3YKnVW6Kt7UIczeYX+JdB1ITw8VReQ3ZCMS/h
         5Kzu5PenJKWKr8FkRz3xQKIMMvksLTOv50P/W37TZh4mkUr1/hs96/TQHEcDGzj2whsS
         Qe8A==
X-Forwarded-Encrypted: i=1; AJvYcCWPePPm1buhbmkxG94YIdfvk7rT1iKBe3EXJwlmSVIHwCjL0NJWv/3G20LBtGGVwvTrd+B2j9HAkZU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIQMZ7lZcC4+Ufp1lO+nBZ60pdKGa5XrlD8n3zCdLmX0hrrNTM
	btF/EnHOREY67Ol3EgpzBU5kr6eG/GRrVwxpQC0oFD4SMmyRUW4rd+0VVnIDy8G8EvcW/KB5LP8
	3a2E=
X-Google-Smtp-Source: AGHT+IHojEC2h853vKqolykwdkLmfjwaE9KygNscvjtq3PWRDoB+/sMec4heq3H/hrjE8cc4UWBUsQ==
X-Received: by 2002:a17:907:9611:b0:a8d:439d:5c3c with SMTP id a640c23a62f3a-a9eefeaf02bmr1448696466b.8.1731361922895;
        Mon, 11 Nov 2024 13:52:02 -0800 (PST)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0a17678sm634085266b.10.2024.11.11.13.52.01
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 13:52:02 -0800 (PST)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9e8522445dso882334066b.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 13:52:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUzRPDNplxAspLWhj6abIi7eVXpID6W0bg8dCVgZ9Q+pwIpGxhXlpCmmTXj+FRNFJYkNjyHKTwvqQs=@vger.kernel.org
X-Received: by 2002:a17:906:730d:b0:a89:f5f6:395 with SMTP id
 a640c23a62f3a-a9eefeade4cmr1373427066b.1.1731361921497; Mon, 11 Nov 2024
 13:52:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731355931.git.josef@toxicpanda.com> <b509ec78c045d67d4d7e31976eba4b708b238b66.1731355931.git.josef@toxicpanda.com>
In-Reply-To: <b509ec78c045d67d4d7e31976eba4b708b238b66.1731355931.git.josef@toxicpanda.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Nov 2024 13:51:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh4BEjbfaO93hiZs3YXoNmV=YkWT4=OOhuxM3vD2S-1iA@mail.gmail.com>
Message-ID: <CAHk-=wh4BEjbfaO93hiZs3YXoNmV=YkWT4=OOhuxM3vD2S-1iA@mail.gmail.com>
Subject: Re: [PATCH v6 06/17] fsnotify: generate pre-content permission event
 on open
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, 
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 11 Nov 2024 at 12:19, Josef Bacik <josef@toxicpanda.com> wrote:
>
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3782,7 +3782,15 @@ static int do_open(struct nameidata *nd,
> +       /*
> +        * This permission hook is different than fsnotify_open_perm() hook.
> +        * This is a pre-content hook that is called without sb_writers held
> +        * and after the file was truncated.
> +        */
> +       return fsnotify_file_area_perm(file, MAY_OPEN, &file->f_pos, 0);
>  }

Stop adding sh*t like this to the VFS layer.

Seriously. I spend time and effort looking at profiles, and then
people who do *not* seem to spend the time and effort just willy nilly
add fsnotify and security events and show down basic paths.

I'm going to NAK any new fsnotify and permission hooks unless people
show that they don't add any overhead.

Because I'm really really tired of having to wade through various
permission hooks in the profiles that I can not fix or optimize,
because those hoosk have no sane defined semantics, just "let user
space know".

Yes, right now it's mostly just the security layer. But this really
looks to me like now fsnotify will be the same kind of pain.

And that location is STUPID. Dammit, it is even *documented* to be
stupid. It's a "pre-content" hook that happens after the contents have
already been truncated. WTF? That's no "pre".

I tried to follow the deep chain of inlines to see what actually ends
up happening, and it looks like if the *whole* filesystem has no
notify events at all, the fsnotify_sb_has_watchers() check will make
this mostly go away, except for all the D$ accesses needed just to
check for it.

But even *one* entirely unrelated event will now force every single
open to typically call __fsnotify_parent() (or possibly "just"
fsnotify), because there's no sane "nobody cares about this dentry"
kind of thing.

So effectively this is a new hook that gets called on every single
open call that nobody else cares about than you, and that people have
lived without for three decades.

Stop it, or at least add the code to not do this all completely pointlessly.

Because otherwise I will not take this kind of stuff any more. I just
spent time trying to figure out how to avoid the pointless cache
misses we did for every path component traversal.

So I *really* don't want to see another pointless stupid fsnotify hook
in my profiles.

                Linus
