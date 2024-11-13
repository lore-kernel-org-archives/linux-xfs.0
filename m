Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88CA18C009
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 23:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731539281; cv=none; b=XG/VK8PofRrI4E+uU6z8bJ8v3leZlp2AwRcIC+5AhMq6vHEgcLAav1itjDiki17lpX0KFK8d3V4E/9igqeWyXGzzrdU41KSfFTqZqwmbEtNblZ44p4PFJjyTm/hYp29+FVRkS838Dn2mttrrkz8atPB21Dd7fvReNoFBTeb729A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731539281; c=relaxed/simple;
	bh=/tltkOoQpP8bcM74mMy2gPuKWTvbxMmV0LsxinTpOwM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iC8OOIV4TIuJ43TcQW92YO7jmGnla4jXVUrCKyLNF0EG35j3IhBfoAiDZH0oHjnsF7k5lzFxkNLuRdtV4qN5Y526EJpAFb/Qvw7k3l+bJwtAEWTQjugZL+0pMao0T9ztSVrMWRzgTQQHEDSxryqQsIAvnvz+kXnYrscZzwdA2F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MNDNP6Ew; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MNDNP6Ew"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9f1d76dab1so14419166b.0
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 15:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731539278; x=1732144078; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3uMAHPF1ytklJO173iJZDrJhJUNgUA50IG0+xtq7Xjg=;
        b=MNDNP6EwcGGMNq5zoNbykwPm4aJxccUHyAT6tfIjsZurINXGCT9l8VXH8fEqDV4QIf
         o9suM2rEZ+yuHxki5GK+3Gpv8iEp6CCyxszWp4yL+jDBC/0EX7NhADgMIL+7lD7dQvV1
         xjQpsJMBrUpya3CA4lqGvTg+YYRWq0z1GpLpc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731539278; x=1732144078;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3uMAHPF1ytklJO173iJZDrJhJUNgUA50IG0+xtq7Xjg=;
        b=rprGKFR2fdgQ7NrMsALpY2htnwEbZB6gazF675ZegY5ANAkIWAJCID5eDF3f3aaHYy
         byUHh2iLA9P3ymDjShLtFI4S2FfowPyRifVgdGOYHxk7mKPSPokUrX9scZEFw5E7qMi5
         OXkgfSoKiOZQGb1kM3zntwoArhKk9ZGx5LRGw+HGLRVM0pJnUGlWqpN2hb38bUFl3y/4
         WItN878GqLf7EKEhyLCD4jSkpavAzaStBEaTVnK0AnK95nPYkBu/d5aCCt5yEPRY8tkU
         jwbTYZmyftt5OwXddN7lFMH4qz3EbJ6JT3um4JK0XnTWNygDPkVyQFEWbEHHAVqt+UKx
         aVuw==
X-Forwarded-Encrypted: i=1; AJvYcCVz+/JUoTsFERQhUo2vQSjrOY2X+hlGQK+AeWLUDCIMsvFZPTtquQkIOZv04wJagGAMr5uG9uETLYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyNoWK0i79Tx4Lsg2Ye2+PvL4qq3t1xyRHplrzvzosJHRybIgY
	j5S/78KKxyz0H0OMlNstWeKeaVnztyLO7lz6H+Ej3SLCY09pHZAepC8lsufNzXaOTNk585NsdbI
	ucgQ=
X-Google-Smtp-Source: AGHT+IEdc61scHyq8et10E+FQZxQWISlzaslpNoBAJIAYqVEnqR7wUDM41kh73jvEJzXNf5gu4ceZA==
X-Received: by 2002:a17:907:31c2:b0:a9e:c696:8f78 with SMTP id a640c23a62f3a-aa1c57ef4a3mr829436666b.51.1731539277946;
        Wed, 13 Nov 2024 15:07:57 -0800 (PST)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf737a1aafsm528503a12.84.2024.11.13.15.07.55
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 15:07:56 -0800 (PST)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5cec93719ccso9604621a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 15:07:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXYcnB19Z7yUMYA/sxvvE1V+is0AAqLD+5Ck+2EPelc8s85H2IWwLTL4D9A/a/4k2/wAhSeLc91SnM=@vger.kernel.org
X-Received: by 2002:a17:907:5ce:b0:a99:5234:c56c with SMTP id
 a640c23a62f3a-aa1b10a372fmr767667166b.33.1731539274832; Wed, 13 Nov 2024
 15:07:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731433903.git.josef@toxicpanda.com> <141e2cc2dfac8b2f49c1c8d219dd7c20925b2cef.1731433903.git.josef@toxicpanda.com>
 <CAHk-=wjkBEch_Z9EMbup2bHtbtt7aoj-o5V6Nara+VxeUtckGw@mail.gmail.com>
 <CAOQ4uxjQHh=fUnBw=KwuchjRt_4JbaZAqrkDd93E2_mrqv_Pkw@mail.gmail.com>
 <CAHk-=wirrmNUD9mD5OByfJ3XFb7rgept4kARNQuA+xCHTSDhyw@mail.gmail.com> <CAOQ4uxgFJX+AJbswKwQP3oFE273JDOO3UAvtxHz4r8+tVkHJnQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxgFJX+AJbswKwQP3oFE273JDOO3UAvtxHz4r8+tVkHJnQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Nov 2024 15:07:38 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiTEQ31V6HLgOJ__DEAEK4DR7HdhwfmK3jiTKM4egeONg@mail.gmail.com>
Message-ID: <CAHk-=wiTEQ31V6HLgOJ__DEAEK4DR7HdhwfmK3jiTKM4egeONg@mail.gmail.com>
Subject: Re: [PATCH v7 05/18] fsnotify: introduce pre-content permission events
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-fsdevel@vger.kernel.org, 
	jack@suse.cz, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 13 Nov 2024 at 14:35, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Sure for new hooks with new check-on-open semantics that is
> going to be easy to do. The historic reason for the heavy inlining
> is trying to optimize out indirect calls when we do not have the
> luxury of using the check-on-open semantics.

Right. I'm not asking you to fix the old cases - it would be lovely to
do, but I think that's a different story. The compiler *does* figure
out the oddities, so usually generated code doesn't look horrible, but
it's really hard for a human to understand.

And honestly, code that "the compiler can figure out, but ordinary
humans can't" isn't great code.

And hey, we have tons of "isn't great code". Stuff happens. And the
fsnotify code in particular has this really odd history of
inotify/dnotify/unification and the VFS layer also having been
modified under it and becoming much more complex.

I really wish we could just throw some of the legacy cases away. Oh well.

But because I'm very sensitive to the VFS layer core code, and partly
*because* we have this bad history of horridness here (and
particularly in the security hooks), I just want to make really sure
that the new cases do *not* use the same completely incomprehensible
model with random conditionals that make no sense.

So that's why I then react so strongly to some of this.

Put another way: I'm not expecting the fsnotify_file() and
fsnotify_parent() horror to go away. But I *am* expecting new
interfaces to not use them, and not write new code like that again.

                  Linus
