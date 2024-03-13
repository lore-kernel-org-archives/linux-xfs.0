Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FDB51C33
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 21:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710364543; cv=none; b=Wd53gRoUnQQGdZvKaqX0f2tmx9Ak6VKPZFa4kUKmC7MYISFRo9fMvs7FrI5WTcnixbkV5++wNTt2jZ8d1wD6uf5oMDryTh7z+VWOx75CMSIiOyeEbaGqAb8csWqxJBL51OgxNLfWXHAjirCrSUN6tG0WQQ8Mtdwm+3PdNQd0oe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710364543; c=relaxed/simple;
	bh=ugrjwLUhJosYkEtgIGhX/p/DQALok5E+Ftx7SV2UNOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XPoy/IxrNeFxyhj6EBbsaKb173aJHmAjBEsJg6SWMACHCmWAT0V0uQMhSFRQZPvuNz4Cm+57v77GF7T6h8AHRjU5FPQUdvtulwkqVFTveYzjj0uNg5nsbA8dJkyTTb+XwY3dmMgHEqGPW4gylstEGeKaqJudCOqL1jV654YTqEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UwDz6jw7; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UwDz6jw7"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-56890b533aaso299333a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 14:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1710364539; x=1710969339; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RMHYHzIzTJ3BOt9w5/3bQTbxdRDqrqqEs+aJX8SVdWU=;
        b=UwDz6jw7tx+SfQK5O9TRElRVr8xUwxRGn3uZDwwqZTrBkRjaqUmSJIdo6cGJGJA++5
         sZTMnvwI98Adx6wuiKlPP/T2qMB8bv4/KtsYdS8X5kCIcRJY2JQDzhHR+FzmUz1H77fq
         yxmFlruM4E5Ca8HldNAlAA1h7u5Gcayn83/vw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710364539; x=1710969339;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RMHYHzIzTJ3BOt9w5/3bQTbxdRDqrqqEs+aJX8SVdWU=;
        b=i4gfgKDnTtNQipximPDZ5xF6AMP7EKZT/IEq/vy1Jvf026LEG3JCYqCyeQUaotWorS
         OMjxYBR+U4/qrMCrgUwLH+5X0dJGU3O08zBFOqdq8dMxB7cZvT6iCuPxlyWIhZBJPlNh
         Qk/yOhE89wWTCJsItC5SA3/CE54zINzD7fHcc5JlmgP5XT0T+8sXnEXbVvkcax4ALjky
         tkVKXtL7rGDFnasIct/HkczQVdfgCCiHmFkbDB2FWnc7LBm1n+rkYSs9lw5Iuj+tnbHU
         8XpLUwGJ9o9yQ2hpT+u1IIQlE07I3J7oLUP/w1TnKKZ1ynY9ftkDxD3HbZ1lz7LIIhYq
         4iRA==
X-Forwarded-Encrypted: i=1; AJvYcCXt0ERih5ZkJFbCzhKMT+cmb6KGGsEuy5m53Rb6fWHEdFEe+OAR1ObDt4igNXmo4U3suIIBmDq8b93YZxeE8elRez2ti2ENzMp5
X-Gm-Message-State: AOJu0YxmEKJX3AuDCkBDJIZi4AhJsREJX1p2GpXSrj1GXqQ8Z/IAuesx
	ONYnGYlwkSbAgDGIBs5nl+i1llKrQpz10nXWsehmfXUfKWR83mwtptfGZNwe70pxHOFYK93qWAD
	VRHlsGw==
X-Google-Smtp-Source: AGHT+IEkfQTzgZvDcelILGZeajDA6py6GZ1cQbbBjueyppA3JieqLtV2GgmGgf2hqwCcn6tj7+Bh1A==
X-Received: by 2002:a17:907:7b06:b0:a46:5f03:7d00 with SMTP id mn6-20020a1709077b0600b00a465f037d00mr1538205ejc.34.1710364539484;
        Wed, 13 Mar 2024 14:15:39 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id c19-20020a170906341300b00a462736feedsm23369ejb.62.2024.03.13.14.15.38
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 14:15:38 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a466a27d30aso36035966b.1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 14:15:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWNNiAcDOro0fDtxAaTW8rIp03eWSf3KAhAhZvziMOhmppAnA83I3TRkcN3J3zXx3LJFDjxishugmcjHZxa5mv4oYANwXn8pNUh
X-Received: by 2002:a17:907:6b88:b0:a46:6f89:5585 with SMTP id
 rg8-20020a1709076b8800b00a466f895585mr52537ejc.23.1710364537834; Wed, 13 Mar
 2024 14:15:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <87sf0uhdh2.fsf@debian-BULLSEYE-live-builder-AMD64>
In-Reply-To: <87sf0uhdh2.fsf@debian-BULLSEYE-live-builder-AMD64>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Mar 2024 14:15:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgtRUwd+9aAJ1GGq3sri+drsfArbtsrTuk9YxJU+ZGO5w@mail.gmail.com>
Message-ID: <CAHk-=wgtRUwd+9aAJ1GGq3sri+drsfArbtsrTuk9YxJU+ZGO5w@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: new code for 6.9
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: akiyks@gmail.com, cmaiolino@redhat.com, corbet@lwn.net, 
	dan.carpenter@linaro.org, dchinner@redhat.com, djwong@kernel.org, hch@lst.de, 
	hsiangkao@linux.alibaba.com, hughd@google.com, kch@nvidia.com, 
	kent.overstreet@linux.dev, leo.lilong@huawei.com, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, longman@redhat.com, 
	mchehab@kernel.org, peterz@infradead.org, sfr@canb.auug.org.au, 
	sshegde@linux.ibm.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Mar 2024 at 23:07, Chandan Babu R <chandanbabu@kernel.org> wrote:
>
> Matthew Wilcox (Oracle) (3):
>       locking: Add rwsem_assert_held() and rwsem_assert_held_write()

I have pulled this, but just wanted to note that this makes me wonder...

I think the "add basic minimal asserts even when lockdep is disabled"
is fine, and we should have done so long ago.

At the same time, historically our "assert()" has had a free "no
debugging" version.

IOW, it's often very nice to enable asserts for development and
testing (but lockdep may be overkill and psosibly even entirely
unacceptable if you also want to check lock contention etc).

But we've had a lot of cases where we add lockdep annotations as both
a documentation aid and a debugging aid, knowing that they go away if
you don't enable the debug code.

And it looks like there's no way to do that for the rwsem_assert_held*() macros.

I looked around, and the same is true of assert_spin_locked(), so this
isn't a new issue. But I find it sad, because it does actually
generate code, and these asserts tend to be things that people never
remove.

              Linus
