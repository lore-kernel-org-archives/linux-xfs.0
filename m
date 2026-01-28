Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862C6314D15
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 11:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769601001; cv=pass; b=pq1WnVkiJWBxdoj/lQWpBr9BBrwNIcytZOIN/hFs3Xra2h1MCTdnNy835oY2Uw3bTnARfv3vqqSnlGm19moj2XDMA/u723+VW/pg6VEx9mR6gjxfp2cjJ9mDH9ufKr0zFB5IA4sEa+2fQ9OXz6PVwAtrM4rMUHXL38kcBDwuJrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769601001; c=relaxed/simple;
	bh=hSMXOh0Oo+nPWIXGNy6Xy2ffhiMjw7bfObWyXyyTRFw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p98cJlynBQFcnBzEo/t2uZC6OcO0rLhBQrXwKxpzfHBocq3dfCsHLHxuYr8lvP3t7kiEr7oO3O3ffPV4UgkbcPUwy7CpFbeJIz11Ze08TxyY5R2hURyyM1+ifBYBnB94XvEiKAwsItqls37EaJw/ZvUOXjbAFHcj8zEmO+M3rDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FR8mdWDW; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FR8mdWDW"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-658b9e95990so931973a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 03:49:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769600998; cv=none;
        d=google.com; s=arc-20240605;
        b=L2lNrfLb5AroLjcd1L87QtmmEHKsQG6hcL+j1yIwX+jGnADVm+m0s5bk6lxmY+JjP7
         tDtCvl9fmBtEyVw5FMvIJEKEP80b6a64TymDfGza9RShlwVsrO9Q+jYb7kEItKspGcXi
         rSSIFsns8K5NvLG8NfPckgkbItfeaHPj440YqGxlWENJYMCvDsTV3U2sHxWEmFzNMkvG
         ujtlEZpp0UvOpOG151jQQje0BB/lGDMQNHloAdCnWFc/tpMPNfXKJI3EYzAftDD929PZ
         9MYVVCBv+90PMPmQkG0sym9Kn+bxaP235sq9zCWQD06nmUND7Q57UYgJz+naWYIdrIM+
         7N/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OOBXUmD9goqwIlvz3iQRg+SdG5i2nFccs0lUKwf+dUE=;
        fh=L+mdccTMNigvh44TUxdWa1iMwkmjDi9mIW0uMZUqQGc=;
        b=VbXiE8D54sr6hQVN+G3nULO3nxPGqY6qvKOD137NQ/X5vQqODRL1mZQdaqb5wmame+
         v2uCSGKTUtoqGN3en8wZlBnKSG6AKifUkCZTHbaUt24DbQCog9Vhrbskz/W//eQ/SaDR
         nXDHcBZ1mT+sPE3BlIFG9npYX2SlbQ54x+7w1CGRzqJTZL4xEbZG0fOobRs+CjNfbeuJ
         TxKMEhxybH+fquz0C7hwYueCIxfcB2dHT6PYuMKOdHf8z1Cw4xjooHLTL00H8RPaG2U6
         X7U2WiDyoz7m5hK5Gwr/yhF2Bzj9RupR1uTzMd9S40dPCgPysCv7Rp030EsbC4OnOTN4
         bpfA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769600998; x=1770205798; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OOBXUmD9goqwIlvz3iQRg+SdG5i2nFccs0lUKwf+dUE=;
        b=FR8mdWDWBW61A+py/5HoKRuev9mIZIpSmqKtTdkiRzhJx4yurwTyHJqiayDAei1JJV
         D8rE15bAbp4yruitOxN9ghocp5wUSHwvtzUpipos6frHL91+9nHe4nsGR8VxAuGxJkQY
         tnIovD3EuXHOfvTUV81DwMwIcNnJFeO2rPKJTX5gK5nMutc6lAxKlRsr0kF9eQb13l1F
         xQMfKXrVAS1lxlIvk+4hGHrRSlVu7uUqk3G2YfvExfFWKiyZE0qMJQgnaSXieYTrDUCR
         0hHT05bTTVJeGqZ/a5iyA5Rp/Ex6gwYwk1F7BGNNHEbliXytUdSPaj5GtEEG8G+yy+Bx
         714w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769600998; x=1770205798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OOBXUmD9goqwIlvz3iQRg+SdG5i2nFccs0lUKwf+dUE=;
        b=utbK/N9hnpLVYshkyX3+YIj0MH58uIeDkg64J7onYuW6hLMrcSaz+waW3YAR0iqBFH
         q+UP+UKmDDkIgdgPdPQ6ILTLQ7Hq4rFHYGqvoXBCUSVa0de6SUkljrMSQ0hn65r2cTw+
         idkAmw+UrfUbcmFeqK9VYxchnyAKW66KCqtFV69akS6Vuv8QvGpsYwIv2HtekzNfRqY7
         aXlruZPuxr5+AnIDadqX4M7MyL9DRlwnhHBq97le2K8/XBG7VBx4S9CY6pA9NQxIjonh
         GqOHKnREyPR//EQYFE8BtuL6lNfNIz3Rcab8bTgzVpJJ0AiybtwrtCdFWtT8XP9scQn9
         UEnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhb4UJTet9eyrw3zNjfpOIVVyy60eWCfTNaT+B6TkgnhpNJYhTCUYnTjO83ORjFEDLnoKd+M5Oh+0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTxpK6HR7cSRF2Uxo/sX4Lo4m76rhoTtXGaoDduCLAouyiPLEL
	W+5G4geycR35V1t5b4eop7s6IeZmddsQRRggsx1YmFwZrffub+IkgMovVQ4TGSoBeyiwQlkQsx3
	H+7CrlJkHTlTLArue0gA8UNjbPFhPyuA=
X-Gm-Gg: AZuq6aIKqLSoDQBHiHZNQoo2wITlpdw701Bx1FGQoc+37kl+2KCrtoyrRphdmVBpe1m
	J3F+mdLwAqCyvmUlXuUNV24BwUxug3us5x0kEjOUrSK5WyEbXM7QW7aMHAmxb+5egd++t5Bc/0U
	+pD2v24jHqz4hitWYEb2atBp9ASurYgkVH2UCnY4Bg8v1FY9QkDuCgedXrIbE8Z2HRMDJhV8vv7
	I2Wy/5451UCAeDAJyRs2P2bZt8qbEltj5LLAmS1LgN4ungWshgTVlMnsVapitq7+V7+MnVjEUMu
	uJr7Q+aKf7w1/35xMTGh+ujyX8xIjg==
X-Received: by 2002:a05:6402:35c1:b0:658:2fd1:b0ab with SMTP id
 4fb4d7f45d1cf-658a60b78d2mr2846925a12.29.1769600997470; Wed, 28 Jan 2026
 03:49:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260114-tonyk-get_disk_uuid-v1-0-e6a319e25d57@igalia.com>
 <20260114-tonyk-get_disk_uuid-v1-3-e6a319e25d57@igalia.com>
 <20260114062608.GB10805@lst.de> <5334ebc6-ceee-4262-b477-6b161c5ca704@igalia.com>
 <20260115062944.GA9590@lst.de> <633bb5f3-4582-416c-b8b9-fd1f3b3452ab@suse.com>
 <20260115072311.GA10352@lst.de> <22b16e24-d10e-43f6-bc2b-eeaa94310e3a@igalia.com>
 <CAOQ4uxhbz7=XT=C3R8XqL0K_o7KwLKsoNwgk=qJGuw2375MTJw@mail.gmail.com>
 <0241e2c4-bf11-4372-9eda-cccaba4a6d7d@igalia.com> <CAOQ4uxi988PutUi=Owm5zf6NaCm90PUCJLu7dw8firH8305w-A@mail.gmail.com>
 <33c1ccbd-abbe-4278-8ab1-d7d645c8b6e8@igalia.com> <CAOQ4uxgCM=q29Vs+35y-2K9k7GP2A2NfPkuqCrUiMUHW+KhbWw@mail.gmail.com>
 <75a9247a-12f4-4066-9712-c70ab41c274f@igalia.com> <CAOQ4uxig==FAd=2hO0B_CVBDSuBwdqL-zaXkpf-QXn5iEL364g@mail.gmail.com>
 <CAOQ4uxg6dKr4XB3yAkfGd_ehZkBMcoNHiF5CeB9=3aca44yHRg@mail.gmail.com>
 <ee38734b-c4c3-4b96-8ff2-b4ce5730b57c@igalia.com> <8ab387b1-c4aa-40a5-946f-f4510d8afd02@igalia.com>
 <CAOQ4uxiRpwuyfj_Wy3Zj+HAi+jgQOq8nPQK8wmn6Hgsz-9i1fw@mail.gmail.com>
In-Reply-To: <CAOQ4uxiRpwuyfj_Wy3Zj+HAi+jgQOq8nPQK8wmn6Hgsz-9i1fw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 28 Jan 2026 12:49:45 +0100
X-Gm-Features: AZwV_QiAes4F6-nhL9J4dFPbEOm7D7xrxYRKJxjry6rXeIbQy7RViH-qtuWr0fQ
Message-ID: <CAOQ4uxhHFvYNAgES9wpM_C-7GvfwXC2xet1ensfeQOyPJRAuNQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: Use real disk UUID for origin file handles
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: Christoph Hellwig <hch@lst.de>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, Carlos Maiolino <cem@kernel.org>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	kernel-dev@igalia.com, vivek@collabora.com, 
	Ludovico de Nittis <ludovico.denittis@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 24, 2026 at 11:45=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Fri, Jan 23, 2026 at 9:08=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@i=
galia.com> wrote:
> >
> > Em 23/01/2026 10:24, Andr=C3=A9 Almeida escreveu:
> > >
> > > Em 22/01/2026 17:07, Amir Goldstein escreveu:
> > >> On Tue, Jan 20, 2026 at 4:12=E2=80=AFPM Amir Goldstein <amir73il@gma=
il.com>
> > >> wrote:
> > >>>
> > >>> On Mon, Jan 19, 2026 at 5:56=E2=80=AFPM Andr=C3=A9 Almeida
> > >>> <andrealmeid@igalia.com> wrote:
> > >>>>
> > >> ...
> > >>>> Actually they are not in the same fs, upper and lower are coming f=
rom
> > >>>> different fs', so when trying to mount I get the fallback to
> > >>>> `uuid=3Dnull`. A quick hack circumventing this check makes the mou=
nt
> > >>>> work.
> > >>>>
> > >>>> If you think this is the best way to solve this issue (rather than
> > >>>> following the VFS helper path for instance),
> > >>>
> > >>> That's up to you if you want to solve the "all lower layers on same=
 fs"
> > >>> or want to also allow lower layers on different fs.
> > >>> The former could be solved by relaxing the ovl rules.
> > >>>
> > >>>> please let me know how can
> > >>>> I safely lift this restriction, like maybe adding a new flag for t=
his?
> > >>>
> > >>> I think the attached patch should work for you and should not
> > >>> break anything.
> > >>>
> > >>> It's only sanity tested and will need to write tests to verify it.
> > >>>
> > >>
> > >> Andre,
> > >>
> > >> I tested the patch and it looks good on my side.
> > >> If you want me to queue this patch for 7.0,
> > >> please let me know if it addresses your use case.
> > >>
> > >
> > > Hi Amir,
> > >
> > > I'm still testing it to make sure it works my case, I will return to =
you
> > > ASAP. Thanks for the help!
> > >
> >
> > So, your patch wasn't initially working in my setup here, and after som=
e
> > debugging it turns out that on ovl_verify_fh() *fh would have a NULL
> > UUID, but *ofh would have a valid UUID, so the compare would then fail.
> >
> > Adding this line at ovl_get_fh() fixed the issue for me and made the
> > patch work as I was expecting:
> >
> > +       if (!ovl_origin_uuid(ofs))
> > +               fh->fb.uuid =3D uuid_null;
> > +
> >          return fh;
> >
> > Please let me know if that makes sense to you.
>
> It does not make sense to me.
> I think you may be using the uuid=3Doff feature in the wrong way.
> What you did was to change the stored UUID, but this NOT the
> purpose of uuid=3Doff.
>
> The purpose of uuid=3Doff is NOT to allow mounting an overlayfs
> that was previously using a different lower UUID.
> The purpose is to mount overlayfs the from the FIRST time with
> uuid=3Doff so that ovl_verify_origin_fh() gets null uuid from the
> first call that sets the ORIGIN xattr.
>
> IOW, if user want to be able to change underlying later UUID
> user needs to declare from the first overlayfs mount that this
> is expected to happen, otherwise, overlayfs will assume that
> an unintentional wrong configuration was used.
>
> I updated the documentation to try to explain this better:
>
> Is my understanding of the problems you had correct?
> Is my solution understood and applicable to your use case?
>

Hi Andre,

Sorry to nag you, but if you'd like me to queue the suggested change to 7.0=
,
I would need your feedback soon.

FWIW, I think that this change of restrictions for uuid=3Dnull could be bac=
kported
to stable kernels, but I am not going to mark it for auto select, because
I'd rather see if anyone shouts with upstream kernel first when (if) we mak=
e
this change and manually backport later per demand.

Thanks,
Amir.
