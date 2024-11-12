Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B0E21C167
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 23:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731455313; cv=none; b=ELowzRpGJukVL/CmXPsx9fO2aJOx3R2R/ELq10wsg95y+ZbA56tMVVSfES4y1TRwe/HkGNKamFNM4CXNdmCObtdRnzBFxtUJ5j3R4hqxw1dtv07Kn1zPzKIs9YxNHlgQxS4/L8lzqFFovfJxsEbXFnw7hLh62mi4qSY/TJmoAg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731455313; c=relaxed/simple;
	bh=PtUR7xHG3XzaDOKNcGaWg+AXTkiClAf7xGs2wsblnAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BLeKsZy3ozUejTnMSamqxuTczrNmXm3b8SVnh1tCPcfsv13V27xvvWWSp98epvsKlEmXnVuFgtukXOZ6jeSf+baexQPBfDMgvqfosBJY6SH80WVGgwYsxwckXaqlbgkT5N8QTPT2ks8QDlcBPNWgpfl2ipYRoXNJPlJkCcYf9rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NUFtFI+7; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NUFtFI+7"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5ceca0ec4e7so7959889a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 15:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731455310; x=1732060110; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cA/tzxVfR0e9vh4jgAsTIRH0TxinS/T5igog/R3JqgY=;
        b=NUFtFI+7lJgzVBqDXkQqDjgRb2wnWKNzv/uKVDPyVvwaXWVshp0MV1qnRXfStKIHTD
         DrRzqfFPpCbPU/pbdzfFeiugMK87+dvVseK+NiKlCrQ6Xv4bUI18nU/AeThre5okzfWd
         W0clNiyBzKvs0mOpWyWwMj0ht+2SbyygBZ+/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731455310; x=1732060110;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cA/tzxVfR0e9vh4jgAsTIRH0TxinS/T5igog/R3JqgY=;
        b=Sp+cTVfFGMzLZY7RMBm2JI+EqK5K3ih+Tt4pTeAGQeOss3Z+3dKt/2AVjICHDH2pX7
         mp0DexElX66CuHpH06ygBI2NGfCTS2VHBEqESOzVgikTNkH1foF1s9kmg48WpcLrANNh
         d3cIXCx21L54s9JPQnn+VcnXpd3B+bFkAQHzczoKRYMVoOtagyLHFOpWjUBeusdwMXZ7
         sVDElEW+lJTwCJLEfIxxNAU5RA6UiU986cZ/lB2mhkzT6w0BR1FHu69Vj5D9ZkInrCks
         lZMvjXtI7nFYcv+I2W+M7M7yT71nNLnB9gwUZYkOAKU1C2lLDBLPIn/msd7+X4OAcgqB
         eeKA==
X-Forwarded-Encrypted: i=1; AJvYcCVHILnbrdZ5Im7KI3GXzOdv94NbvPRkjsAAW1QMaYbqrVu3ftHwHUG+Eyke3fd9rBkSNYn+3viKNe0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz3Lf8GKjyR9BTqHalzLnqYM2DYTw/p3W0pHYkfOf+CLD1sGuX
	WNHYX7YxgS5oGRDL/UgSwLgOG4QHH2OVO5H70ROfJ8Gls4A3am8TvSnPd4fOHGl0Eg59rCAQhDu
	EiPkZiQ==
X-Google-Smtp-Source: AGHT+IEyfxtWtB9dP49OdHObi1BpuETFfIPbvMCmjAoATUCG+7HaSVYKditzVO6mFo1lJryXh7p2Bw==
X-Received: by 2002:a05:6402:510f:b0:5ce:af48:c2cc with SMTP id 4fb4d7f45d1cf-5cf0a43fd2cmr15882853a12.27.1731455309892;
        Tue, 12 Nov 2024 15:48:29 -0800 (PST)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf03c4ed9fsm6536895a12.62.2024.11.12.15.48.27
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 15:48:28 -0800 (PST)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c96b2a10e1so9479551a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 15:48:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWGTOndqmuLKuE7XBazd0XnE98HpGFKgflAnS7GUV6D9qlqulkowYrtLbFChwQ12Tkj0zCUHw9mO2I=@vger.kernel.org
X-Received: by 2002:a17:906:4f96:b0:a9f:168:efdf with SMTP id
 a640c23a62f3a-a9f0169008dmr1114854566b.6.1731455306729; Tue, 12 Nov 2024
 15:48:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731433903.git.josef@toxicpanda.com> <141e2cc2dfac8b2f49c1c8d219dd7c20925b2cef.1731433903.git.josef@toxicpanda.com>
 <CAHk-=wjkBEch_Z9EMbup2bHtbtt7aoj-o5V6Nara+VxeUtckGw@mail.gmail.com> <CAOQ4uxiiFsu-cG89i_PA+kqUp8ycmewhuD9xJBgpuBy5AahG5Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxiiFsu-cG89i_PA+kqUp8ycmewhuD9xJBgpuBy5AahG5Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Nov 2024 15:48:10 -0800
X-Gmail-Original-Message-ID: <CAHk-=wijFZtUxsunOVN5G+FMBJ+8A-+p5TOURv2h=rbtO44egw@mail.gmail.com>
Message-ID: <CAHk-=wijFZtUxsunOVN5G+FMBJ+8A-+p5TOURv2h=rbtO44egw@mail.gmail.com>
Subject: Re: [PATCH v7 05/18] fsnotify: introduce pre-content permission events
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-fsdevel@vger.kernel.org, 
	jack@suse.cz, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Nov 2024 at 15:06, Amir Goldstein <amir73il@gmail.com> wrote:
>
> I am fine not optimizing out the legacy FS_ACCESS_PERM event
> and just making sure not to add new bad code, if that is what you prefer
> and I also am fine with using two FMODE_ flags if that is prefered.

So iirc we do have a handful of FMODE flags left. Not many, but I do
think a new one would be fine.

And if we were to run out (and I'm *not* suggesting we do that now!)
we actually have more free bits in "f_flags".

That f_flags set of flags is a mess for other reasons: we expose them
to user space, and we define the bits using octal numbers for random
bad historical reasons, and some architectures specify their own set
or bits, etc etc - nasty.

But if anybody is really worried about running out of f_mode bits, we
could almost certainly turn the existing

        unsigned int f_flags;

into a bitfield, and make it be something like

        unsigned int f_flags:26, f_special:6;

instead, with the rule being that "f_special" only gets set at open
time and never any other time (to avoid any data races with fcntl()
touching the other 24 bits in the word).

[ Bah. I thought we had 8 unused bits in f_flags, but I went and
looked. sparc uses 0x2000000 for __O_TMPFILE, so we actually only have
6 bits unused in f_flags. No actual good reason for the sparc choice I
think, but it is what it is ]

Anyway, I wouldn't begrudge you a bit if that cleans this fsnotify
mess up and makes it much simpler and clearer. I really think that if
we can do this cleanly, using a bit in f_mode is a good cause.

                Linus
