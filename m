Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8353217F31
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 19:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731441278; cv=none; b=n4wmxiG0Q6Wygnl40olAG2XAP+jrbxf7lxCVutumHEBZ9YoQ+4OMDBDL3BqwDuYCIlESEmCgXVAUgkRoKHircjvm6lMJD6UlIW6ympd6Eh8HDskZq94FHlgYIbtuMiYQGtZVkfrNYtEAbWLukkfwkPYIpcCsKp0aa6L/i5Rh7kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731441278; c=relaxed/simple;
	bh=w5M4DdbV0JDQqGXDCjJMEXFd24rwLm/qJCT5r02ClmE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d2lVoSMGa+/4ufw6aSe2n+9+2sT3dNAszOQ1EdyEKFXcAtVJEp5MqIz9Oi4Px/Leu28KCLj2cmXRpJBfTdQg/t/Gq6fDI0z3paOLkAcSo3IudIK+lgQTUliOF/cjt5NncnkIvj0azA+RoQ0xUD8qg4wG8JHFPGCUdv5D/DdewJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RhxEt9Fm; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RhxEt9Fm"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a99f3a5a44cso811289366b.3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 11:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731441274; x=1732046074; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5b0rySYUL4FjfsS4jGUX3HJrYE8uK75+UecupTqejZA=;
        b=RhxEt9FmPo8St2zCKzhQ/hGs1H7OKOBkXI4LLWLqNbiuCswZA6ZThLG/JuI/Rr3u+5
         b7fyF8esgW9xVh2qbjES17yqj/GUbC7VYr8oSnipbmVLTHvegIjed6O3xNEWX6odCBgw
         gwb5N2SiyhBpBwCBrOl99QOtXWsttlJierXy8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731441274; x=1732046074;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5b0rySYUL4FjfsS4jGUX3HJrYE8uK75+UecupTqejZA=;
        b=Hcy/jw6e+1YwwXJjC4jSvqxRszpqqX3myJcfnin2ON2WYKMC0cBGJDPQXI5HEqW71v
         hDrPHWYkKSdmZIp+ehiw2jQPyKe0dOX7WYPajpfA2rAosRvwuTAcbNn02ZWLL0iQ6f16
         /5r6DybnM+9jF06kxMNbOflB8+QXP7cREuOcB+wot1sVVtD9xi9bjrfc+U+16t9Kh8WX
         kqRYXZ5I3qvkfylaOD+eW39/1K/JRv87jh9SVfprd7cJ7TIbZfmHPbjpgr1sQ6VsChYd
         ryfFl58uMNDU5z7ovR3hn2Je1yctgAZYEu+RChT46FtR4kIhb8AXvy/7QTeP+Q9bKA7k
         l2tA==
X-Forwarded-Encrypted: i=1; AJvYcCULm/K0MzbIYoS37hQcHESDDa26VQkqFpo7RKpib1qNLwuvWDdi69SSHfCKOk6pkmTLPTYPmqBA4yc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfL8Qfl/dUNBjnkMsydqkXMatbZb/Ha0q0Araii9L4YrVhgVBP
	Fem4jW9zm+mt1zDUF0AIKivN3d4Uezv0QcgtluHVyb9t3ymrq79PAbQTc6VagjF5p6VxeYXj8II
	5uuzZjQ==
X-Google-Smtp-Source: AGHT+IGlGw95EGWhFTG9TfUHkbrRze87Ii/nAtVGjGZxlTOxhY2jdgsH+yDv134g7n5+Lmt7Mf9/KQ==
X-Received: by 2002:a17:906:d542:b0:a8a:58c5:78f1 with SMTP id a640c23a62f3a-a9eefe9bb2fmr1619742266b.11.1731441273891;
        Tue, 12 Nov 2024 11:54:33 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0e2e3ffsm770058366b.183.2024.11.12.11.54.33
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 11:54:33 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9aa8895facso1118660066b.2
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 11:54:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVN2WuYWCD1R3fk2G9V44zlqH3kmnMLQ7RSMcxh+SPjNys9Rbo6/AV43jgivFDS8WGwYar+INdpIlk=@vger.kernel.org
X-Received: by 2002:a17:907:1b21:b0:a99:ff70:3abd with SMTP id
 a640c23a62f3a-a9eeff25d17mr1761977066b.31.1731441272860; Tue, 12 Nov 2024
 11:54:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731433903.git.josef@toxicpanda.com> <60a2309da948dc81e4c66b9e5fe3f1e2faa2010e.1731433903.git.josef@toxicpanda.com>
In-Reply-To: <60a2309da948dc81e4c66b9e5fe3f1e2faa2010e.1731433903.git.josef@toxicpanda.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Nov 2024 11:54:16 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgNFNYinkWCUvT2UnH2E2K_qPexEPgrm-xgr68YXnEQ_g@mail.gmail.com>
Message-ID: <CAHk-=wgNFNYinkWCUvT2UnH2E2K_qPexEPgrm-xgr68YXnEQ_g@mail.gmail.com>
Subject: Re: [PATCH v7 07/18] fsnotify: generate pre-content permission event
 on open
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, 
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Nov 2024 at 09:56, Josef Bacik <josef@toxicpanda.com> wrote:
>
> +       /*
> +        * This permission hook is different than fsnotify_open_perm() hook.
> +        * This is a pre-content hook that is called without sb_writers held
> +        * and after the file was truncated.
> +        */
> +       return fsnotify_file_area_perm(file, MAY_OPEN, &file->f_pos, 0);
>  }

I still object to this all.

You can't say "permission denied" after you've already truncated the
file. It's not a sane model. I complained about that earlier, it seems
that complaint was missed in the other complaints.

Also, this whole "This permission hook is different than
fsnotify_open_perm() hook" statement is purely because
fsnotify_open_perm() itself was broken and called from the wrong place
as mentioned in the other email.

Fix *THAT* first, then unify the two places that should *not* be
different into one single "this is the fsnotify_open" code. And that
place explicitly sets that FMODE_NOTIFY_PERM bit, and makes sure that
it does *not* set it for FMODE_NONOTIFY or FMODE_PATH cases.

And then please work on making sure that that isn't called unless
actually required.

The actual real "pre-content permission events" should then ONLY test
the FMODE_NOTIFY_PERM bit. Nothing else. None of this "re-use the
existing fsnotify_file() logic" stuff. Noe extra tests, no extra
logic.

Don't make me jump through filve layers of inline functions that all
test different 'mask' bits, just to verify that the open / read /
write paths don't do something stupid.

IOW, make it straightforward and obvious what you are doing, and make
it very clear that you're not pointlessly testing things like
FMODE_NONOTIFY when the *ONLY* thing that should be tested is whether
FMODE_NOTIFY_PERM is set.

Please.

              Linus
