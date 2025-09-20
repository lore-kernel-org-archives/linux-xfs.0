Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748537081A
	for <linux-xfs@vger.kernel.org>; Sat, 20 Sep 2025 05:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758347283; cv=none; b=Cz4prKr4cySuilpl5BB+K2hR4QiwSx6SQJDV3MW2cSCbHIMny83NVzV31F6hzvx3W8Y3rKKCvelty+hp1E+6RVPclk1YOa/2hAEChxBmepMEBqKZEEKy/e7bJrUE3IJSFjZMDHhG2m1M4caXtuTztsms5vdYJ+yDRbzAdhcrHDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758347283; c=relaxed/simple;
	bh=o437aCkcf1xCxm+rv0mPwnGQtCoz+9QjMvmAbd5CG3k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jsIF7sXnC6FETL2g8z29+vnEEVF/6RwQxElBRjjlMuPIzewgWusbINMMQussUydzx2HP0rEw+cN9Ng9KZcXL7JWNmR37OYmq0DMKFlPz5azbToDQNVZFhIhho1ZCxzmT7hcJz33uIoySUfHWQPlP6ni0JzGoAnxv4s1kDLpnKS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jvFQtz/e; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jvFQtz/e"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-62ecd3c21d3so4199557a12.0
        for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 22:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758347279; x=1758952079; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fyN9RcfnRhBee1hQgE+lsezNr/j9kdfLGgOBZcxycjE=;
        b=jvFQtz/eYM+NLGU5wKQz8AH8+J1N6i7yiK70ybgHeyj1Nqt3MpUnt0ptB0V5rqNNdx
         y9FCHiVC4NzIj4m/dqvUSDf5Ay7MA6YPbem+VbXf2aZ0NWpkzKgfjdRZZx0qc+lJjsEw
         KAvK+Pum6jWrqeQMgjhX+xnQz8SaKlMj3bdzaQ4YFGLqThdG8cQMiriMz9AX/WwdePxH
         VSIt6PWxgmFAwad3XxwSL0FMZB4cr8xZ/cdU8oBWLpOix39fJYgBXTFjH1sNNnLsowm1
         lNDp+A1teDRrWiE+un0tv30D/PKCul57wt6iJ+dl+oycDfEYGKivtfb8s8kpAJb7b/vY
         vowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758347279; x=1758952079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fyN9RcfnRhBee1hQgE+lsezNr/j9kdfLGgOBZcxycjE=;
        b=uMQnLE9FAbV9C4lActkssVcTV5OMaQONMOlKK5rTlLov37ylXqrty2ZJol0gv/L+0F
         V1/JbYGKsHPWuuaxymvY8TPKaH8FRE/7pEobr7wtgqmVpPlBQ3xLlviysEvDSwEkSIkx
         UBxUz9FIxeIWGXXy0mr5lK41Y2Lce9+RrRVOpxreFCX2FzsDYReYNUNLrBiJGy1cIEBH
         0fyI0LnTYdq47kND60V/Uz/K3itwHu71J9sWx+3NkWnZbnGoP0/ZA0s7/exLhrAAFsUe
         BldqOqoBhZzi+o9bvdo3oWvmIlU881d3lHJhmUP5LVK4mg6+eweQlwGlXLcQksOS/sBa
         GwSA==
X-Forwarded-Encrypted: i=1; AJvYcCV7hOztZ7tSSweBo6nkmmyTlz42qhgbgjSQXV8MKfzaKSt5cQdSJI3YiATeO1lsWlkoGV7SlFZ7LRk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRLBQao2yPx+1CDFP9/bYTyJAP5/h0VvxrJl1CF7UTaTzdXbEx
	CDRDql8CA51t2toyaqMC03gkIGWPZ5s/uEMu+oRsiEpAf4ScCCsoNVDtHrq+CN6fRnBtO8F/HCb
	8oGDeyO/fm1wnTIVmc4WmF3uLoEiGrV4=
X-Gm-Gg: ASbGncszCfpEP+/fU+hIIvUMA+4I63hrMwYNBaTT1GDoW/VmDn2ogJ1RedduMNyn2w/
	2MCUQwPzn248o0s8XUgLFXsBMTzdf3es9UXEkoColz0UzUABE0/BkzQz+IrzybmcfEGU2ZMALbW
	eo/oko34ZA53XAqLl9+P1LptAmSksZxmX0iIJh6ASgyETjMEAmnBY9jVzwOclgZ39gtHOtAunK0
	e3NHO//LE4DG7giaeroCw9bcs54An720KuCW5Q=
X-Google-Smtp-Source: AGHT+IGXjKiqqwRe65Vudg38Ap/YqUkQCp5A7+RF7b7HLmhZNE/B/g21D2F70GxNir3tx2mYIaHz6z79YrnZKfqUJP8=
X-Received: by 2002:a05:6402:23d2:b0:62f:9cfb:7d76 with SMTP id
 4fb4d7f45d1cf-62fc0a8376bmr4633977a12.37.1758347278669; Fri, 19 Sep 2025
 22:47:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919154905.2592318-1-mjguzik@gmail.com> <73885a08-f255-4638-8a53-f136537f4b4c@gmail.com>
In-Reply-To: <73885a08-f255-4638-8a53-f136537f4b4c@gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sat, 20 Sep 2025 07:47:46 +0200
X-Gm-Features: AS18NWCzvbrmV0HH3sAfFvM4WSZtLcuzJvUuWZCgEFT-KVn1SkU22A6rQ1aMITw
Message-ID: <CAGudoHHnhej-jxkSBG5im+QXh5GZfp1KsO40EV=PPDxuGbco8Q@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] hide ->i_state behind accessors
To: Russell Haley <yumpusamongus@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	josef@toxicpanda.com, kernel-team@fb.com, amir73il@gmail.com, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 20, 2025 at 6:31=E2=80=AFAM Russell Haley <yumpusamongus@gmail.=
com> wrote:
>
> On 9/19/25 10:49 AM, Mateusz Guzik wrote:
> > This is generated against:
> > https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=
=3Dvfs-6.18.inode.refcount.preliminaries
> >
> > First commit message quoted verbatim with rationable + API:
> >
> > [quote]
> > Open-coded accesses prevent asserting they are done correctly. One
> > obvious aspect is locking, but significantly more can checked. For
> > example it can be detected when the code is clearing flags which are
> > already missing, or is setting flags when it is illegal (e.g., I_FREEIN=
G
> > when ->i_count > 0).
> >
> > Given the late stage of the release cycle this patchset only aims to
> > hide access, it does not provide any of the checks.
> >
> > Consumers can be trivially converted. Suppose flags I_A and I_B are to
> > be handled, then:
> >
> > state =3D inode->i_state        =3D> state =3D inode_state_read(inode)
> > inode->i_state |=3D (I_A | I_B)         =3D> inode_state_add(inode, I_A=
 | I_B)
> > inode->i_state &=3D ~(I_A | I_B)        =3D> inode_state_del(inode, I_A=
 | I_B)
> > inode->i_state =3D I_A | I_B    =3D> inode_state_set(inode, I_A | I_B)
> > [/quote]
>
> Drive-by bikeshedding: s/set/replace/g
>
> "replace" removes ambiguity with the concept of setting a bit ( |=3D ). A=
n
> alternative would be "set_only".
>

I agree _set may be ambiguous here. I was considering something like
_assign or _set_value instead.

I'm not that fond of _replace but I'm not going to really going to
argue about any particular variant.

The good news is that whatever the naming, sed indeed can be used to
adjust the patchset. :)
