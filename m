Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795685018;
	b=Ch1Ceapa+1AT2JRdzsEKsbqkvR5k8fkMRbLTvm68YhQCNFCXtL4Eto5SUTosArpg+VVP
	 0PDvOUkqhYkqP4vA2RFCQnKhHdWgFT1kxW3LFyGNM/HVwhnLx/cu19Q6S5LW/4ZvOsSrQ
	 MNetCljsEPH/UfKELTiQuSewBsZOv/Xs4diO1WPS7HH54UW3S0r+Xy864mYjuntL5Ld48
	 A1O9AXbD1V91rNIJ9xQFaDEI575eB7P2p3/O4QB1R68VmUlqNhCZFfMiERCNGHU1LC70O
	 3iVrvviaDWuf/JXxfI2Gnjd8XAHk6l+8kibhymPWk5SbDrm4lihlMirZyqHBE1PL0HA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795685018;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=xckR6blDjDVAhqTSlG7y2c/dJk+7MAk3ZiUn44VZKcw=;
	b=ZeTQrO7+oD2QBAT2FtDuem86Qnhufga80Kyc43IulhrSixD0Rd25JcKx7y0nDp8aOWlq
	 BYx9Q7U9Eebv8OwUG0KUrQv00QcWRQPvhURRGto3EubDNsz5GBVqAACaUJuiKfivtB5rk
	 flvVTYW9jHUZGFoYYGEcugZbpM01MF7xXp2mWJW23RQcuabwhSMu6yTertpWLx8sgVgo5
	 6PmzoMqBSNsUL9I7eDtdnpGGAYp+Q3p243rXSC0QJYEw1pXEWaKf3frYeoYe9DWOPY/in
	 u5TDouPNPkQrpoe108d3yGo2bV1iOhkWaMipdUsjEJ98Ku+uNDjsph8PD79b54s7U3g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=htZC86Pa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4332B606A321
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 09:23:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4332B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=htZC86Pa
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso8555353a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 01:23:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795685017; cv=none;
        d=google.com; s=arc-20260327;
        b=IcPcWxgp3m/pdru/Gvz8TaeRRaVrXl5QTDnPgpmy2C42ifa3vypUhe0s+wSLC9qNpv
         pkAfN453nFwlLbYMQWYJp59XUpAs2BrLX7VJpYeyTpKSWB87hVIhSKU6g6yrSSZdB1Bf
         m1QCRYbbfPGyB2MW0JcsnYW4Ivc98gZQR9R0qdJkKq6rNQ0gbyXXTUpGTuTzzQuLKKLo
         8C+ZwsI0ecuLrHQ43HZzSwBIxKwRUq3DuTcI4GSpgpUjOXv7nWK69bCbjDb4G4gdKMpm
         2npX2OqSgkWynyivyY4APMFBZnbyJJtoMZhHFsz+R8e9V+EfLJPEcAh24B5KU/FXHTCh
         NjnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xckR6blDjDVAhqTSlG7y2c/dJk+7MAk3ZiUn44VZKcw=;
        fh=SaPKVVWubk/qYNF+3iDk8hgCSROiWppP4nBwyY5Kul0=;
        b=Hzs41tHgLY3rn0JMqvdRM06dU+RT7Lqq8Io5y6cYD/csT/i4PzOMzVSSXid5Ncove3
         x1Itr23M9Upsf0Fyh62RxGJpq8qj6Twst70RcfU/tcGnQQaRWg0DKKHJ+gH8Za4iY3rg
         FJzuYaD4Dc5D0xyf9WFQoA1SeBl5/ym3rizOjnVfVlynhKLEJYNKP8O3XRHfi59sopAg
         f7hrXTPyIcCYfAo+QKuWB1yppVLxGlS97iIHPh/YNwVs1flrxUro48PI4fPuc8pY2etj
         r9GWcj/vRUjmoAg46gWZyaFfqnxA3V1iIPUDUtPkpPvEOyDpPXag2y9v+zzcTvAWDQb+
         Otcg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795685016; x=1796289816; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xckR6blDjDVAhqTSlG7y2c/dJk+7MAk3ZiUn44VZKcw=;
        b=htZC86PaPTG34kYWAisdWcgHJD1UzaMIQvA1regyq5nViPY53KsD3NsllAndQX1evi
         Ni4eoDAvoFkwSVjRH2aLo8DK1It6q5/8NfVeByru4dF9S6/VEXj+TZJ5U8mChY30w0Uv
         jcCx/2OSR9wIj7x8YmXDsxOsBKo6p3Q3ujwy/4TdmbIF5u+YX04R1Bv1QF0hLopIVtio
         PngI5fpJQ1uCiosc+uFsN8S0QqiNZJdqLTNdOL6uay7GyqwBy7ErG/e7G5Nk2oTVO/wr
         64NWwOk7mZ5vgAa+kdjPvHzrMIdBU6PYX15ePP1qntAbHhcwn6ZQtcGoRW3QJj2GibeU
         nxqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795685016; x=1796289816;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xckR6blDjDVAhqTSlG7y2c/dJk+7MAk3ZiUn44VZKcw=;
        b=jKK0+FBpoDUxKY8YoCm6+ThoYEZx3DZax3YJfzdb9z5hW9JExv1qE/388SmiL/8gLR
         SA61ToaR1aCMq0Q4JyUQnALwBWh59s2IXx1U0JghHrR5SUuKICD7eFsDIJlT4UcaMXCK
         S8AEZlnWsYs4lPYbsIFcg3piQvSTgde38PWnBJ6u6Dm2yE6HrKKNlz3/PGhoglY5jOoM
         hRImp/gDbTmhOFgH9Zy9Q7JQKqHqjcDhzrMNu09jQFgj/e/zJmy8+7lw8HgVyA6ndAjZ
         WDO0fv3idm63s3bA3hEkmd6ped8TbxZgzYtcbh2pysofHSrxA+VSQIcBtWJXh3loHhQZ
         uDlg==
X-Forwarded-Encrypted: i=1; AL+hErHBzB0D0XaCllP+ad/NHSl1uJmoszpEMw5UoIjxscjlDmBu/8l5ycnT7/ek8yTZgm33dg9aP31S2ZM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+EWuBnIO9q0sDfyGmyxwALUiXoxqdx1sSBdqsh8lB+AZRu2QLM
	6F7F4Z3dkJ9N9kokcfWbZH1js7WXA7jkUpduMqdBj5Mya7E/snUzEBppqSo7fCoah9/aAbYMshA
	AQtAToIepshLO1cuApLdQKFOgQzoveTZbQRzxZEU=
X-Gm-Gg: AZFdTZf+4cvlZ8HjqTXGiCMdH5shQ7XA1K5zpi6fTg2idzUnDxdqKAfLs1d2+v2b9H/
	XxGCEO90Oy+LaG73Hq7yUYLVDdOqxLBDtlxsIyRoMJMvmRfNE11JQvggmDZPn3sE4EFW9kBwND1
	k+Wq4mFSwsaa5E1XgxnBiU5KrYiIt79IRo5lkGoVtDVOpNrHNoyq0Nu1HWtDF6/cordISmCJSys
	rZ+hxMBAyBKd3vO4mKbEuiVKQj0XZUtHEZWxH2AFIvbvgejtwiEjDiCJhmzQ6Pk+YtZhDn5YbJt
	pMVLA8D964eVkuNXKxxVTrDGPgA4655BrwKQLRszCJNC4SCTs5EhS/XK99l7Zh6LIa7827SEx3q
	bNIfqtkGfpMniThr4fFs0EbcmSgyUYcw71fePd2UismVx7meUuYcFKsF237pWQBLHyUHkkQ==
X-Received: by 2002:a05:6402:1501:b0:6b7:182c:5d4e with SMTP id
 4fb4d7f45d1cf-6ba37c7c3a6mr11134218a12.5.1795685016112; Thu, 26 Nov 2026
 01:23:36 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-3-koray.fra@gmail.com>
 <CAOQ4uxhegn1z=41_MHL1Zu2hXuPtzNhC=x4gd371oaeJE4-weQ@mail.gmail.com>
 <DN2N6A68PBO1.2QT8ZOARF4I6L@gmail.com> <CAOQ4uxhDQqEQ3T9NveBFpUmSU032BxrNV5D+_zHj8u9LOQY+qg@mail.gmail.com>
 <DN4DRUYPHYMP.20U4DYV5VBN7P@gmail.com> <CAOQ4uxg0g+XkPb3-kQS5ez1-rp7Q=BkYDHW0CGOFhpbcf70yMg@mail.gmail.com>
 <DN4KLSM2OO0K.2C8Q5CPFBVNL6@gmail.com> <CAOQ4uxhpJygZH-arLFSUYEEfqFG96Sr3_6CWakfSkdWxEsOxMg@mail.gmail.com>
 <DN50PH7HHSWZ.3H4T25JFPQECY@gmail.com>
In-Reply-To: <DN50PH7HHSWZ.3H4T25JFPQECY@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 26 Nov 2026 10:23:23 +0100
X-Gm-Features: Aa3M54qgNadyHP5LQf6BsvKupVU6AY9XgOmNRBH-yAFSYibTS_3xHgBMtDNHcI0
Message-ID: <CAOQ4uxgJTSspRJqRFaSJxKUShVULaJpMv8UhBFR-DV2kUe1sXw@mail.gmail.com>
Subject: Re: [PATCH 2/3] vfs: add xflags mask to fileattr API
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Darrick J . Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2026 at 9:59=E2=80=AFAM koraynilay <koray.fra@gmail.com> wr=
ote:
>
...
> >> > Attributes that have X_value like fsx_projid have few types:
> >> > 1. 0 means disabled (all existing values incl. projid)
> >> > 2. 0 is a valid value but cannot be unset (btime)
> >> > 3. 0 is a valid value and NULL/unset is also a valid value
> >> >
> >> > Only for type 3 does can the interpretation of
> >> > (!XFLAG_X && !fsx_X) be considered as an "unset"
> >> > and anyway, this will require support in individual fs.
> >>
> >> IMO !(xflags & XFLAG) && (rw_mask & XFLAG) should clear/unset the valu=
e
> >> in all cases, ignoring what's in fsx_X.
> >>
> >> And all existing values would be of type 1 for VER0, but of type 1 + 3
> >> for VER1.
> >>
> >
> > I agree that this will be more consistent.
> >
> > With explicit opt-in to FILEATTR_MASKS API
> > vfs can determine that
> > (!XFLAG_X && !!fsx_X) is alway -EINVAL
> >
> > When fsx_X =3D=3D 0, the value of XFLAG_X does not really matter
> > so filesystems can decide themselves if they want to act on
> > an "unset" flag or not.
>
> Hmm, I think fsx_xflags should have priority over the value in this
> _masks API.
>
> In my mind, to clear PROJID a userspace program would only need to do:
>
>   struct file_attr fa =3D {
>         .fsx_xflags =3D 0,
>         .fsx_xflags_rw_mask =3D FS_XFLAG_PROJID
>   };
>   file_setattr(&fa, AT_FILE_ATTR_MASKS);

If the program (e.g. chattr -p) internationally sets rw_mask =3D FS_XFLAG_P=
ROJID
what do we gain from not requiring the program to also set fsx_projid =3D 0=
?
I just don't see any wins for anyone from this design choice.

Maybe I am missing something.

>
> and have projid cleared (same for EXTSIZE/EXTSZINHERIT/COWEXTESIZE),
> while to set/change it:
>
>   struct file_attr fa =3D {
>         .fsx_xflags =3D FS_XFLAG_PROJID,
>         .fsx_xflags_rw_mask =3D FS_XFLAG_PROJID,
>         .fsx_projid =3D 67,
>   };
>   file_setattr(&fa, AT_FILE_ATTR_MASKS);
>
> and this:
>
>   struct file_attr fa =3D {
>         .fsx_xflags =3D FS_XFLAG_PROJID,
>         .fsx_xflags_rw_mask =3D FS_XFLAG_PROJID,
>         .fsx_projid =3D 0,
>   };
>   file_setattr(&fa, AT_FILE_ATTR_MASKS);
>
> would have the same result as the first snippet, but not the same
> meaning, since this would mean "set projid to 0" while the first snippet
> means "clear/unset projid" (but in this case, for projid and all the
> other already existing fsx_* it would have the same result).
>

As I wrote it could matter per attribute and per filesystem
whether set to 0 or unset is different.

The man page language should be flexible enough about this point.

It only needs to document the invalid combinations.

When proposing an UAPI change I often included a man-page draft
as a proof that the UAPI can make sense to human readers.

Thanks,
Amir.
