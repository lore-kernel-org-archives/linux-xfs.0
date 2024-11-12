Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FED20ADEC
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 19:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731440778; cv=none; b=MDX0RLw1OdMWJuXg2jj2fVzRXnhctaKPJa89PsqSIiK7sEZNQ+slDsehJTyKn3oKrFS2fYUcq8Dx2Zp3bsVARwzAA6BrUa99wAAp2qp0jp0pVj8VLluQ4TTGwmMEZCh2bdp6aCZH4ow+yxSQJRPhrPD9T3hdD6Fod29KVaquV6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731440778; c=relaxed/simple;
	bh=bna1DQ543WyJHuuqATngsHU2aVkAWd+Y+jUOxH+XtcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UvtGPfhwof5QsjsRtZu343cSMHENhecedR/g1IWPoepz1SaG+lHZBXzWaILzyIs5fPRSxq0vTTipW9nwoz9jBkVn6Y+968joL5p+7SzDFj5okx7bN/qTg4Z8soHE7OxxNIHBnHzvxtOJpYNt4a3rW6oRcwRdJMYVq8snGNkJzkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lveu7iQI; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lveu7iQI"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-53d9ff8f1e4so80204e87.2
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 11:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731440774; x=1732045574; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JlJJ+zcJgVAM09bT3idZLHPWsiy7qwqX02nyVSrJZ4I=;
        b=Lveu7iQI7eX26SWfzv31kmpJusYUgmyr9TbpHaftVL0EWgProWcfr4eEhWRH5CzsgG
         AN+aazW90Y/uSjWhxEhEhE95BWfK8MwatGvsJD+RfmSLIpN5eDr/UDj2r1l7OrqtNvPt
         DgXPXc1IVEHK8r7OFZMPWvA6F3urRIpL1wiDU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731440774; x=1732045574;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JlJJ+zcJgVAM09bT3idZLHPWsiy7qwqX02nyVSrJZ4I=;
        b=tf8hr7qIZt3CWD0qRNs91RlJ5ilK6vuoyZVUyoCV38i8vXj+l8fpCqxNRHsV/lKQHd
         0bWDllt7MTUsaM/vYOm9gA/x38cRTc6LQvX7BGAnFOmdajqqeG9SewJ9bgNyWfEyvgcU
         gnh1C4gb+d0v0RXViGVcHX0FTPNkV/gppVyNXnR25mAbhZZtsCmyAoHN6uHhFF6TH8e7
         m4Un0wBOQaUKbYYa45rvpSyWdweuU7fmTVhCAnaxqvNRVk6L/1saW9Xjq0ZbIO1hx9DO
         f/C6A8ub0SIvZdkGj3E3hoRS7FmIwmM7qY2lvjzoodjxTnVM1bmiHE6AdaXSNTzfchAT
         3/DA==
X-Forwarded-Encrypted: i=1; AJvYcCWUU8OW/2TdHnkAErZRh8UmJO6mKG/nLq841cBVIp89XZBiYzaZJwJkUlrf8lgZkyiDg0DdQvR4UPE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpAhCajJwXSaoUJYJ2KCktp/RrxO/rZgK3fIQzKOjSLxE0Tdwq
	Y2iuXGozSBaooW+KPHSY7H3MRB6cWlf6yscwrdBNsJ3xWDi6DETNelhHUsLbbnfq1bJqjNGQv89
	oiWwNEA==
X-Google-Smtp-Source: AGHT+IF+g84Dhh/qwmUiqDiT3lA1liQEvtfjRjR1313aHb6iImlD/FivkzoNxc1ZibKeW6dihAMdvg==
X-Received: by 2002:a05:6512:2311:b0:533:43e2:6ac4 with SMTP id 2adb3069b0e04-53d86302e9fmr8219247e87.49.1731440773847;
        Tue, 12 Nov 2024 11:46:13 -0800 (PST)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53d9ff8e03fsm13342e87.120.2024.11.12.11.46.12
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 11:46:13 -0800 (PST)
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53d8c08cfc4so3484302e87.3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 11:46:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU3DZDaRq/7deXHVI8b0UND2irauhcgr4SQXx1Df/Bf8o7cQa3FF1Q0e188UWJB7ldmquD1pBR0yoc=@vger.kernel.org
X-Received: by 2002:a05:6512:3d89:b0:539:d870:9a51 with SMTP id
 2adb3069b0e04-53d86302f33mr8492323e87.48.1731440772062; Tue, 12 Nov 2024
 11:46:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731433903.git.josef@toxicpanda.com> <8c8e9452d153a1918470cbe52a8eb6505c675911.1731433903.git.josef@toxicpanda.com>
In-Reply-To: <8c8e9452d153a1918470cbe52a8eb6505c675911.1731433903.git.josef@toxicpanda.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Nov 2024 11:45:55 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjFKgs-to95Op3p19Shy+EqW2ttSOwk2OadVN-e=eV73g@mail.gmail.com>
Message-ID: <CAHk-=wjFKgs-to95Op3p19Shy+EqW2ttSOwk2OadVN-e=eV73g@mail.gmail.com>
Subject: Re: [PATCH v7 01/18] fsnotify: opt-in for permission events at
 file_open_perm() time
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, 
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Nov 2024 at 09:56, Josef Bacik <josef@toxicpanda.com> wrote:
>
> @@ -119,14 +118,37 @@ static inline int fsnotify_file(struct file *file, __u32 mask)
>          * handle creation / destruction events and not "real" file events.
>          */
>         if (file->f_mode & (FMODE_NONOTIFY | FMODE_PATH))
> +               return false;
> +
> +       /* Permission events require that watches are set before FS_OPEN_PERM */
> +       if (mask & ALL_FSNOTIFY_PERM_EVENTS & ~FS_OPEN_PERM &&
> +           !(file->f_mode & FMODE_NOTIFY_PERM))
> +               return false;

This still all looks very strange.

As far as I can tell, there is exactly one user of FS_OPEN_PERM in
'mask', and that's fsnotify_open_perm(). Which is called in exactly
one place: security_file_open(), which is the wrong place to call it
anyway and is the only place where fsnotify is called from the
security layer.

In fact, that looks like an active bug: if you enable FSNOTIFY, but
you *don't* enable CONFIG_SECURITY, the whole fsnotify_open_perm()
will never be called at all.

And I just verified that yes, you can very much generate such a config.

So the whole FS_OPEN_PERM thing looks like a special case, called from
a (broken) special place, and now polluting this "fsnotify_file()"
logic for no actual reason and making it all look unnecessarily messy.

I'd suggest that the whole fsnotify_open_perm() simply be moved to
where it *should* be - in the open path - and not make a bad and
broken attempt at hiding inside the security layer, and not use this
"fsnotify_file()" logic at all.

The open-time logic is different. It shouldn't even attempt - badly -
to look like it's the same thing as some regular file access.

              Linus
