Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB62EB665
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 00:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731459510; cv=none; b=NofRLaRBtN0WZYMpXxKz56bxwZUImKHT0SQy04/+FjMEOUfeCGJYmati8ujyVh5s6eRO0kGqiE5cqtSknyIeimR54lz5yc2UN1YkrTAX3afoLZoW3d6p6gbJ71/t3gAziW/28ubZZBFRgZw76hTYgLYbCdEMLDhcZ3YTcqkHC9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731459510; c=relaxed/simple;
	bh=n3j6hYJca3iK+8w4R60+GpDVT4tBx8PgHWEo86e/9FM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gjHEcYPAoMTPmb1+2/NElaDemPEZ9sW0RgxCMjBFEetWm77pjRTcznX23m8NNeX20grGRbgXf43QJ9+m5TEdoLnww7iDE4fe+znhMBRiCmjfEXkISx3ecSp/PGbJQpWKNIHzbadxeZVoOOJWuw2gG0zyfJxbJm7umsmCStbD6Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RMChi8OW; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RMChi8OW"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9f1d76dab1so503112466b.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 16:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731459505; x=1732064305; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5tJ813zBq+G2Ew0iXW8JEVhQMVvtnrBGzEzzKoVgMoc=;
        b=RMChi8OW/1Vy6bsK3yi0qk7kBNFAd3stwE+DcWK8limrrf5Nh45ka1cI3GyawVGg1Z
         EIge1O+lRa5eZoqvK/ofELDWi7Kxc511tDaS5rDvRzX3wmumibbrfxyQ2j67lK8kIIr0
         0KQUW+VSIV0EPBnHG2yKdX2NvQPGVc/o4qRIc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731459505; x=1732064305;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5tJ813zBq+G2Ew0iXW8JEVhQMVvtnrBGzEzzKoVgMoc=;
        b=Jx2FGmKnzPWUWyXW3qU+t0hydqVl3xGGD/ZPuAH33ENO9v7jow8V/BapaJLeTUiry4
         6c07su9KlXl4Ruv7SATdWXarx3m6aIUTW9pf/S/QqCk7L2IoUgB96taxEjnrx21eR55+
         Q6/a8CTXqqlUL10KWsRD0tqWI0vqWEvXReIL1R8u3q6Jp5Ygd8cnrfRQe9GFENC+n+CQ
         Oh5qhaCM28V5IKrvk32y1MmFcGXQa9XPpQehNrlLg/b7/4YETcNHQN+dhwl3qSxMq2S5
         tTGDsgsmZa3lLlj61Ez50pECBHNVLEY/eT62CVv2vPx/mzgBGyBF/85dCqo5xxJ7uSM2
         mi1g==
X-Forwarded-Encrypted: i=1; AJvYcCWtjrvAlOTBpWVDtJGENxEVF5KK6MIwDMlxv8LYwc6SmbEnCBR/HA+dyIGrVqYSwLcenZ+yRr7ENyM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdklEEKEDb6qXlBjkOasDHRd9n7FLXk6GY7iio46E8RhGxwhIe
	RUv2Fyk4Fzjunujxh8BfQ4wB5rZyo+WfDPmL1eJJTPbt1T/OtmaHY3I0jDPwYNbQ0Y6PxlLG8xo
	lvXIrmg==
X-Google-Smtp-Source: AGHT+IFLY74zypmEF8wyLocnsvDg7PTsRhthgYj93tvgYpAG3b595NxZ7F0ANqDK5tXeBP/uE4UzCw==
X-Received: by 2002:a17:907:2d07:b0:a9a:29a9:70bb with SMTP id a640c23a62f3a-aa1b1055795mr408620666b.14.1731459504786;
        Tue, 12 Nov 2024 16:58:24 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0dc5db6sm785057066b.119.2024.11.12.16.58.22
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 16:58:23 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5ced377447bso8848210a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 16:58:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUf9DRWDQ5j2QyfB0gJqF+Y4JNdpRRjHKpBPsGHQqmjuNdZieg4sFMEwrmLYzqjFGhcU89VpApeYDU=@vger.kernel.org
X-Received: by 2002:a17:907:1c11:b0:a9e:b08e:3de1 with SMTP id
 a640c23a62f3a-aa1b10a9779mr425956266b.36.1731459502310; Tue, 12 Nov 2024
 16:58:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731433903.git.josef@toxicpanda.com> <60a2309da948dc81e4c66b9e5fe3f1e2faa2010e.1731433903.git.josef@toxicpanda.com>
 <CAHk-=wgNFNYinkWCUvT2UnH2E2K_qPexEPgrm-xgr68YXnEQ_g@mail.gmail.com> <CAOQ4uxgakk8pW39JkjL1Up-dGZtTDn06QAQvX8p0fVZksCzA9Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxgakk8pW39JkjL1Up-dGZtTDn06QAQvX8p0fVZksCzA9Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Nov 2024 16:58:06 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiMy72pfXi7SQZoth5tY9bkXaA+_4vpoY_tOhqAmowvBw@mail.gmail.com>
Message-ID: <CAHk-=wiMy72pfXi7SQZoth5tY9bkXaA+_4vpoY_tOhqAmowvBw@mail.gmail.com>
Subject: Re: [PATCH v7 07/18] fsnotify: generate pre-content permission event
 on open
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-fsdevel@vger.kernel.org, 
	jack@suse.cz, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Nov 2024 at 15:41, Amir Goldstein <amir73il@gmail.com> wrote:
>
> You wrote it should be called "in the open path" - that is ambiguous.
> pre-content hook must be called without sb_writers held, so current
> (in linux-next) location of fsnotify_open_perm() is not good in case of
> O_CREATE flag, so I am not sure where a good location is.
> Easier is to drop this patch.

Dropping that patch obviously removes my objection.

But since none of the whole "return errors" is valid with a truncate
or a new file creation anyway, isn't the whole thing kind of moot?

I guess do_open() could do it, but only inside a

        if (!error && !do_truncate && !(file->f_mode & FMODE_CREATED))
                error = fsnotify_opened_old(file);

kind of thing. With a big comment about how this is a pre-read hook,
and not relevant for a new file or a truncate event since then it's
always empty anyway.

But hey, if you don't absolutely need it in the first place, not
having it is *MUCH* preferable.

It sounds like the whole point was to catch reads - not opens. So then
you should catch it at read() time, not at open() time.

                Linus
