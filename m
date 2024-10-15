Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28E31D0492;
	Tue, 15 Oct 2024 11:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992708; cv=none; b=H0N2whwwDQo8KYAbMA52ShQtocyHCeiP3TTGTURyyESK7zIWQJ/pCAnx2dOGMSiLIhgj4glbgOM/bAOBRSwfXqrpv+lAoyVF4y2fcgqsTA6JxeYJl5W4ReGeKShSXpLZuhVg4Ox9hVJNEhKa82hjWAOZXkifIV+d8zkjWr+YgeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992708; c=relaxed/simple;
	bh=qDnN+9sFVp1ympUrl8q+Xipza+DS9UyTtxBZmOF13qo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Syz0MjJOMNS3kjmaH9OVPiNmwrdRzG9/YF69lUVFh0ZGMY10BfOmB+s7a7oyMeQFRXjmfi014oAP9BTn//V2PwuF8Ovnh6+LaMqD9HU3Lu3bkj+SBbSwu6AGEmpijvKc/9g44T9BHeJaRHxSqyUUmuaCPi/lwt6ExLA1uu0NiZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UA145G1k; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UA145G1k"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2e2b9480617so4091668a91.1;
        Tue, 15 Oct 2024 04:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728992706; x=1729597506; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6SEsqNRu8ReCYgE9RoE9bWgK9OSOtDQmduKqHpiYwas=;
        b=UA145G1ktyHdbb/CkpcOkjAkDeeNqYWnXVbOLquBbimMC1L737l1KNXJI8YDc3QD8B
         N7y8XX7fXqwhJTWAoLTRTgtYW0v0QLK807tRjDlsIHE8mdMX2GbvdMgh3aZudNKm2zAs
         QEyhCdW4u3QXrNTqs6u2A+wFsIj43iq3tyf9k3uQCvA6E09Z5Oy2QU0unfqMefOsKdeT
         p6zoIrG7gNF8HHba2M/H2mqIpXQKqNSWE0guqFLgqf3doTqXQYF/3IqthkkDS6Mr+dQe
         9CCq0FzwEWl+Kw3kw/NC50EkX3HBcUbGXH9dsAA4zqTLguO4WwMouAHl1TngG5ct11jk
         atIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728992706; x=1729597506;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6SEsqNRu8ReCYgE9RoE9bWgK9OSOtDQmduKqHpiYwas=;
        b=X9EIxf6W4+0IBkPxqQoWFNCX3rwYRUDWpUkYgUI8oiw+2SNTEKAHRAyQVZG/lCZevt
         XazgyU6Pgtyo5keDOK++xm7lzRR0Zqa34xfqtEH3wy8vTNVZKuesLfop1WmBM9U2xW9m
         dAM04/q4HHY5LlZcd5fysNTHvYSGhYPynFvETlGWeE1T0Zjc2Z3DbOEDJs6bw34z0QDU
         HnFIN55Wn+iLTRAARVojMkaLGiEXS1TY5qi0tXDykYxhxn/iCNG1SbRvXwEj7jZge9F1
         kri3KodRtnyqlymedXJVMPzazVL1ORTy+UTj45UvDNySKidVfrlvk4VCOMKIWjc56uFd
         UEBw==
X-Forwarded-Encrypted: i=1; AJvYcCVzDrgbvMTcfzoVsZrCF6Drus07DKmdpjnRwRdEDRHcRZWKEzQ5HY+xWK5XAbmE0RsoojZMY3fGwA+dYrL0WQ==@vger.kernel.org, AJvYcCWkQozH3hH/eYX64uicfQmQL9CLt/1DgEzQe3kthfXl3T2bu1ouYqjzO6eWXamJro+eCZaJozllx1O0@vger.kernel.org
X-Gm-Message-State: AOJu0YxuuKOaXFnxOXxpnm5FynuXzBbYWXjKniL7bIZJqBr/M2mTo0GE
	HTZH43eMfGxuBW152k3k9c29zkYnf3gwr8MgjroyoqHvGV4QCsTR
X-Google-Smtp-Source: AGHT+IHBbfb6u7wGKC6NAR2T8qY93+SwBnusMttNz152qyGzpiTWmgUTfzC/BDydFGVquA9jDEEDJg==
X-Received: by 2002:a17:90b:3c49:b0:2e2:d1aa:e11c with SMTP id 98e67ed59e1d1-2e2f0db264bmr14854933a91.34.1728992705760;
        Tue, 15 Oct 2024 04:45:05 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e392f0394asm1503952a91.30.2024.10.15.04.45.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2024 04:45:05 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: Libmount bug ?
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <iipuwlnf73x3zjj4kgpgqqvu4u5t4iefg3qawqgzvl546rrbz5@w7tvj3jr5h2v>
Date: Tue, 15 Oct 2024 19:44:51 +0800
Cc: util-linux@vger.kernel.org,
 linux-bcachefs@vger.kernel.org,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Hongbo Li <lihongbo22@huawei.com>,
 "Darrick J. Wong" <djwong@kernel.org>,
 xfs <linux-xfs@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <51D94B19-1D8F-480C-8BA0-ECB114B6D29F@gmail.com>
References: <14ADF290-5B46-44D5-83BC-9AE3732B192C@gmail.com>
 <iipuwlnf73x3zjj4kgpgqqvu4u5t4iefg3qawqgzvl546rrbz5@w7tvj3jr5h2v>
To: Karel Zak <kzak@redhat.com>
X-Mailer: Apple Mail (2.3776.700.51)

On Oct 14, 2024, at 23:57, Karel Zak <kzak@redhat.com> wrote:
>=20
>=20
> Hi Alan,
>=20
> On Sat, Oct 12, 2024 at 04:57:39PM GMT, Alan Huang wrote:
>> The bcachefs has the helper called mount.bcachefs.
>=20
> do you mean the following script?
> =
https://evilpiepirate.org/git/bcachefs-tools.git/tree/mount.bcachefs.sh

Not this one, but the Rust code:

=
https://evilpiepirate.org/git/bcachefs-tools.git/tree/src/commands/mount.r=
s

>=20
> I believe that if you call the regular mount(8) from the script, then
> it's probably fine to not worry about the options. mount(8) will be
> able to ignore them.
>=20
>> Currently, there are users using fstab with nofail/user fail to =
mount,
>> we would like to know whether other filesystems using similar helper
>> properly handle this.
>=20
> The mount.nfs command uses libmount internally to generate the
> mount(2) syscall flags, so it is not affected by any additional
> options.
>=20
> The mount.fuse command has a list of unwanted mount options:
> =
https://github.com/libfuse/libfuse/blob/master/util/mount.fuse.c#L318-L326=


It seems that no other kernel filesystems are using similar helpers.

>=20
> Please note that the "EXTERNAL HELPERS" section in the mount(8) man
> page describes which options are ignored.
>=20
> Also, if your mount helper is setuid (like mount.nfs), you still need
> to parse fstab to obtain mount options from a safe source. This is
> because options from the command line should be ignored as they are
> considered unsafe.

Good to know.

>=20
>>=20
>> This is like commit 06e05eb0f78566b68c44328c37d7c28d8655e9df=20
>> (=E2=80=9Clibmount: don't pass option "defaults" to helper")
>>=20
>> Or would you like something like this? This might be incomplete =
though (e.g. owner, noowner etc.)
>>=20
>> diff --git a/libmount/src/optmap.c b/libmount/src/optmap.c
>> index d7569a0f0..c13b9ba19 100644
>> --- a/libmount/src/optmap.c
>> +++ b/libmount/src/optmap.c
>> @@ -152,11 +152,11 @@ static const struct libmnt_optmap =
userspace_opts_map[] =3D
>>    { "auto",    MNT_MS_NOAUTO, MNT_NOHLPS | MNT_INVERT | MNT_NOMTAB =
},  /* Can be mounted using -a */
>>    { "noauto",  MNT_MS_NOAUTO, MNT_NOHLPS | MNT_NOMTAB },  /* Can =
only be mounted explicitly */
>>=20
>> -   { "user[=3D]", MNT_MS_USER },                             /* =
Allow ordinary user to mount (mtab) */
>> -   { "nouser",  MNT_MS_USER, MNT_INVERT | MNT_NOMTAB },    /* Forbid =
ordinary user to mount */
>> +   { "user[=3D]", MNT_MS_USER, MNT_NOHLPS},                          =
   /* Allow ordinary user to mount (mtab) */
>=20
> This may cause issues with certain helpers (e.g. cifs) where "user=3D"
> is a standard option. However, this is something that needs to be
> addressed in libmount, as it already handles this use-case for cifs.
> The use of MNT_NOHLPS may override this.

Yeah, I was worried that there might be helpers using these options.

>=20
>> +   { "nouser",  MNT_MS_USER, MNT_INVERT | MNT_NOMTAB | MNT_NOHLPS},  =
  /* Forbid ordinary user to mount */
>>=20
>> -   { "users",   MNT_MS_USERS, MNT_NOMTAB },                /* Allow =
ordinary users to mount */
>> -   { "nousers", MNT_MS_USERS, MNT_INVERT | MNT_NOMTAB },   /* Forbid =
ordinary users to mount */
>> +   { "users",   MNT_MS_USERS, MNT_NOMTAB | MNT_NOHLPS},              =
  /* Allow ordinary users to mount */
>> +   { "nousers", MNT_MS_USERS, MNT_INVERT | MNT_NOMTAB | MNT_NOHLPS}, =
  /* Forbid ordinary users to mount */
>>=20
>>    { "owner",   MNT_MS_OWNER, MNT_NOMTAB },                /* Let the =
owner of the device mount */
>>    { "noowner", MNT_MS_OWNER, MNT_INVERT | MNT_NOMTAB },   /* Device =
owner has no special privs */
>> @@ -180,7 +180,7 @@ static const struct libmnt_optmap =
userspace_opts_map[] =3D
>>    { "sizelimit=3D", MNT_MS_SIZELIMIT, MNT_NOHLPS | MNT_NOMTAB },   =
/* loop device size limit */
>>    { "encryption=3D", MNT_MS_ENCRYPTION, MNT_NOHLPS | MNT_NOMTAB },   =
/* loop device encryption */
>>=20
>> -   { "nofail",  MNT_MS_NOFAIL, MNT_NOMTAB },               /* Do not =
fail if ENOENT on dev */
>> +   { "nofail",  MNT_MS_NOFAIL, MNT_NOMTAB | MNT_NOHLPS},             =
  /* Do not fail if ENOENT on dev */
>=20
> Could this option be usable for some helpers?
>=20
> I believe the best solution is to follow the Fuse way and define a
> list of options to ignore in your fs-specific helper.
>=20
> The ideal solution would be to implement a better libmount (perhaps
> libmount2) where the /sbin/mount.<type> helpers are replaced with
> dlopen() modules. This way, the library would handle all the details
> such as command line and fstab options.

Agreed.=20

Thanks,
Alan

>    Karel
>=20
> --=20
> Karel Zak  <kzak@redhat.com>
> http://karelzak.blogspot.com
>=20
