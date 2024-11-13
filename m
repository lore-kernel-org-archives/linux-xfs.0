Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D885D18B48F
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 21:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731532960; cv=none; b=OO74FrkBw1o9J87ywKqXCzHDVx8k5VUFwplPnSJA+nHwD/kWRNSHoVIJ40DHH9JEpwDgbgxWreOXZugjgQ1qM16woaUMsR7ngmX85YnBQeTJyFxkQtsNzJvBP0MQFJGbpxaQ7rKrcd+ew9JPWRJqEiaUTNoPdg7P4t/V4ZFyb8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731532960; c=relaxed/simple;
	bh=Jvfi6gi0QE67lenDTGKJxQmHEYcTqUzyqhTTUKPYxeg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VuY6/Npa5JUAjNnBOtNdNRwGxQ0zEpl5+xqsyNFCqnEvaVuxQh+KPSplr27ZlsgAgimkUcBQdMFyMV/bnYJ6PWR+h/kdlS4JGpXplowbTnmzgxeFsgQSxBCzxut53xUN3zSsfIwf/N1529s3XxCeQB016yYR92Yuo1hN9jSqVao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MT9FFThA; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MT9FFThA"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9ed49ec0f1so1749566b.1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 13:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731532956; x=1732137756; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lgXRlfeexjjlrQuWCwCm2fkGA5K7DLXozqP8RwYmyvA=;
        b=MT9FFThAy+1+1CZtNrOgmO63ZmZvpwlHXOOrxz35mUZcFspVtCqgIw/i9G5/XqgDCo
         eV0t6VhyGI63IrVwQmCuG8DMJtXeXwRR6DQpZjoEpk2hznNLAoe+w0xhpYmqPlfxnVAT
         ICoIs02+xSWHBVB7s7a0xlKt/N79aC5Y/CuS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731532956; x=1732137756;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lgXRlfeexjjlrQuWCwCm2fkGA5K7DLXozqP8RwYmyvA=;
        b=br0Zc9MQHq2294q4jLUHb8UAyZIIQrMTkvZnvtdNyvoZUZbGTJaL8q4LZIKtUTfdws
         S9nPtdg7sBxFzB2WtmesbFKfXuA6/Oai1g8s89gnbDz1KLqCceV9Tt7vZBgqS1fVkmOj
         e3LSZRwZevKzWVwAOOf0BDXC2eXz9Js0L9SR9D1Kxm7VZtehaHudgnoUZ6xE34QxDfIH
         M1D97KoAWWspdButOmP2Wv55dbZU4pXHyCJryX4t91vRqgr9SdNALCxCLe1ALI4KQy07
         ju35yfnKX6FBQ7itFABGnclkCwZ2sdFf2wNDj6K+XUlwcmK4mLRW/Qn4umMnlKmJvsnW
         uoCg==
X-Forwarded-Encrypted: i=1; AJvYcCUJllwk49iWSueUMo/fRc2ghYB0G+bQScZKP5lEHLxjhW4RB9CfkPx2xMLdgcca6V0J4PU0/PRJ0Js=@vger.kernel.org
X-Gm-Message-State: AOJu0YwocEEzzD7Zfi5Vnx4PfJ97Vl7WSJXHR96Z0kWFROjVW76nBVX6
	7wkOYV4NjborCx+BC1t5KI745hy1vJKn4rnKKwaT2truAiRO4mUBtkR9SxJLJNeICPCALAHQtHZ
	Y7A0=
X-Google-Smtp-Source: AGHT+IG7DkemtNKHNSUIXuH2KmxH8/FC7Fxr62graJI81WjicTf93vpT/2wyYvKVlqOjNeNpy6linA==
X-Received: by 2002:a17:906:fe07:b0:a9d:e1d1:bf95 with SMTP id a640c23a62f3a-aa1b10a20cbmr854820666b.25.1731532956006;
        Wed, 13 Nov 2024 13:22:36 -0800 (PST)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0dc49cesm928867566b.126.2024.11.13.13.22.34
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 13:22:34 -0800 (PST)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a99f646ff1bso366466b.2
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 13:22:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWzGEAnM3xT0cZHBM/rD/BxRfCUZWmzo9e7Ogb4IJAFCTpKhY/vH1TRZkLDU8Da6iQpRapEG/HU4WI=@vger.kernel.org
X-Received: by 2002:a17:907:2dac:b0:a9e:c341:c896 with SMTP id
 a640c23a62f3a-aa1b10a4500mr814204866b.32.1731532954269; Wed, 13 Nov 2024
 13:22:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731433903.git.josef@toxicpanda.com> <141e2cc2dfac8b2f49c1c8d219dd7c20925b2cef.1731433903.git.josef@toxicpanda.com>
 <CAHk-=wjkBEch_Z9EMbup2bHtbtt7aoj-o5V6Nara+VxeUtckGw@mail.gmail.com> <CAOQ4uxjQHh=fUnBw=KwuchjRt_4JbaZAqrkDd93E2_mrqv_Pkw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjQHh=fUnBw=KwuchjRt_4JbaZAqrkDd93E2_mrqv_Pkw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Nov 2024 13:22:17 -0800
X-Gmail-Original-Message-ID: <CAHk-=wirrmNUD9mD5OByfJ3XFb7rgept4kARNQuA+xCHTSDhyw@mail.gmail.com>
Message-ID: <CAHk-=wirrmNUD9mD5OByfJ3XFb7rgept4kARNQuA+xCHTSDhyw@mail.gmail.com>
Subject: Re: [PATCH v7 05/18] fsnotify: introduce pre-content permission events
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-fsdevel@vger.kernel.org, 
	jack@suse.cz, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 13 Nov 2024 at 11:11, Amir Goldstein <amir73il@gmail.com> wrote:
>
> >
> > This whole "add another crazy inline function using another crazy
> > helper needs to STOP. Later on in the patch series you do
> >
>
> The patch that I sent did add another convenience helper
> fsnotify_path(), but as long as it is not hiding crazy tests,
> and does not expand to huge inlined code, I don't see the problem.

So I don't mind adding a new inline function for convenience.

But I do mind the whole "multiple levels of inline functions" model,
and the thing I _particularly_ hate is the "mask is usually constant
so that the effect of the inline function is practically two different
things" as exemplified by "fsnotify_file()" and friends.

At that point, the inline function isn't a helper any more, it's a
hindrance to understanding what the heck is going on.

Basically, as an example: fsnotify_file() is actually two very
different things depending on the "mask" argument, an that argument is
*typically* a constant.

In fact, in fsnotify_file_area_perm() is very much is a constant, but
to make it extra non-obvious, it's a *hidden* constant, using

        __u32 fsnotify_mask = FS_ACCESS_PERM;

to hide the fact that it's actually calling fsnotify_file() with that
constant argument.

And in fsnotify_open() it's not exactly a constant, but it's kind of
one: when you actually look at fsnotify_file(), it has that "I do a
different filtering event based on mask", and the two different
constants fsnotify_open() uses are actually the same for that mask.

In other words, that whole "mask" test part of fsnotify_file()

        /* Permission events require group prio >= FSNOTIFY_PRIO_CONTENT */
        if (mask & ALL_FSNOTIFY_PERM_EVENTS &&
            !fsnotify_sb_has_priority_watchers(path->dentry->d_sb,
                                               FSNOTIFY_PRIO_CONTENT))
                return 0;

mess is actually STATICALLY TRUE OR FALSE, but it's made out to be
somehow an "arghumenty" to the function, and it's really obfuscated.

That is the kind of "helper inline" that I don't want to see in the
new paths. Making that conditional more complicated was part of what I
objected to in one of the patches.

> Those convenience helpers help me to maintain readability and code
> reuse.

ABSOLUTELY NOT.

That "convenience helkper" does exactly the opposite. It explicitly
and actively obfuscates when the actual
fsnotify_sb_has_priority_watchers() filtering is done.

That helper is evil.

Just go and look at the actual uses, let's take
fsnotify_file_area_perm() as an example. As mentioned, as an extra
level of obfuscation, that horrid "helper" function tries to hide how
"mask" is constant by doing

        __u32 fsnotify_mask = FS_ACCESS_PERM;

and then never modifying it, and then doing

        return fsnotify_file(file, fsnotify_mask);

but if you walk through the logic, you now see that ok, that means
that the "mask" conditional fsnotify_file() is actually just

    FS_ACCESS_PERM & ALL_FSNOTIFY_PERM_EVENTS

which is always true, so it means that fsnotify_file_area_perm()
unconditionally does that

    fsnotify_sb_has_priority_watchers(..)

filitering.

And dammit, you shouldn't have to walk through that pointless "helper"
variable, and that pointless "helper" inline function to see that. It
shouldn't be the case that fsnotify_file() does two completely
different things based on a constant argument.

It would have literally been much clearer to just have two explicitly
different versions of that function, *WITHOUT* some kind of
pseudo-conditional that isn't actually a conditional, and just have
fsnotify_file_area_perm() be very explicit about the fact that it uses
the fsnotify_sb_has_priority_watchers() logic.

IOW, that conditional only makes it harder to see what the actual
rules are. For no good reason.

Look, magically for some reason fsnotify_name() could do the same
thing without this kind of silly obfuscation. It just unconditonally
calls fsnotify_sb_has_watchers() to filter the events. No silly games
with doing two entirely different things based on a random constant
argument.

So this is why I say that any new fsnotify events will be NAK'ed and
not merged by me unless it's all obvious, and unless it all obviously
DOES NOT USE these inline garbage "helper" functions.

The new logic had better be very obviously *only* using the
file->f_mode bits, and just calling out-of-line to do the work. If I
have to walk through several layers of inline functions, and look at
what magic arguments those inline functions get just to see what the
hell they actually do, I'm not going to merge it.

Because I'm really tired of actively obfuscated VFS hooks that use
inline functions to hide what the hell they are doing and whether they
are expensive or not.

Your fsnotify_file_range() uses fsnotify_parent(), which is another of
those "it does two different things" functions that either call
fsnotify() on the dentry, or call __fsnotify_parent() on it if it's an
inode, which means that it's another case of "what does this actually
do" which is pointlessly hard to follow, since clearly for a truncate
event it can't be a directory.

And to make matters worse, fsnotify_truncate_perm() actually checks
truncate events for directories and regular files, when truncates
can't actually happen for anything but regular files in the first
place. So  your helper function does a nonsensical cray-cray test that
shouldn't exist.

That makes it another "this is not a helper function, this is just obfuscation".

                 Linus
