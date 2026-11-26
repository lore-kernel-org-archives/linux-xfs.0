Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795683599;
	b=mhKUjLIRWI9lm3sB8mnqRzq4KhAb02/AwORyOT/W1mFfSybo8HPlciS9ZZZR440SO5GM
	 wJFAkqPlJFoyjUyskv2MqxcH26lF+guvFG232a+gqQ/ORq3x+G4C9mp/mrC9xINpZvj20
	 8ZzOFwoYxW9TaGP6tcyZ/p3kVQ+zvJMkwbJKL1j9IfeGhUT5hSDLtPxlIBPBeB46mUtOC
	 gP+10ViKH2Dga3HTUY4Zrm1NopD5F/pVdvzN/vIPJ42duJeCDaVBoBfvdg/usd8OV9GLV
	 sdAT+YFLke17j5s+98rjGDxTICcqDo/W6DIh8ZuA+Qh9TMBCMLS3GIcEFu64gy17Rzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795683599;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:X-Mailer:
	 References:In-Reply-To;
	bh=pdGJ7QlIha01VNcg3cIU0qWH1SN2Mep0wOZrqFLArYQ=;
	b=dIhIgwUfxNj4j1v2r3hm7PIQO6eUICwtdvH3dJ+27ieeNWtL+Y1na+5PNSY6GJ51xcPx
	 40xyQgEwGr9HvAzT25AeHgSuseCe0pvOswLDsJv44JNUxZ0LyvpCvmejrSMte4OZYx4Qt
	 Le5+GUa0vMEwCsJlkwKiEacKJ3zEz2w5Rfe45irxvTz5SYkpkbML1iKThSDjiTILGjoXr
	 I7blc1RNp7/EF0yWNmKEcO9RsM9xtyg5VOoIUMPgysLgbuui9P5FphDZucaB1V47XFj9i
	 /UZGcuZhnxPiNSFa9JThCsZD0MLY0rs/ioN9FBiP+lVe8tEScg3iqffxE+3uj8iRPJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dZ0KjGB7;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3B9606A31C
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 08:59:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B3B9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dZ0KjGB7
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so68663725e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 00:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795683598; x=1796288398; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pdGJ7QlIha01VNcg3cIU0qWH1SN2Mep0wOZrqFLArYQ=;
        b=dZ0KjGB7m+OC1UmDFSULTRyhEh/lwe5llDQbTSjiXuQIrRbnZA5GQZIFeNoMyxZZTH
         z9wSBADwSEaOaOPEe9dp+GusOM8SLT2Ekgm+kOXWdL9czn7bw6aAmC7+P5oOBGesL+Kv
         Qv9RdiHh330ww6BQsURewUOPINjtLJprH6CZhG0zxJoPNiedKjS2G5XLjUuDuVZcQWHZ
         Fw2IG+HrZjpp/SvOEkLONf9jSPdiM8tQZNZK8bDcs4ua8f62ihOMZfXoeGzSk1bpY54I
         2w/okcZYxOXErza9bdcinAFE91q2/OeUPOAoJEbanR47RmrJ/YZpE4u+gnX9Xibflhck
         PBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795683598; x=1796288398;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pdGJ7QlIha01VNcg3cIU0qWH1SN2Mep0wOZrqFLArYQ=;
        b=xy1N5bnXYnGSkQ7d5v/RGn8zSeKXegeuC1O4E/XI2bY8LsaM76YaogwNDHr4mHHJTb
         M22PEwu137M8rqQYmIawRCxeV3NrMUNw8KGHmbjz9ncrAH4/FS6F6uBsMALRAQts/p8b
         K718wxSg56gxnEoz21ch3qSGRwnOZCnlH2JJVralamP8/6CkQ/w0/QDnUygzI4XkqD5n
         NgfKTiQIqg2rYT2pqnrtEzWZ+jeRAUE9eight4uo2WRtwFVBWIq9TQNhUQp8onGOKqaG
         0sqd74ohQYMev52H+cKTrwwdzskgh7doX49k3secteHP5APhZ6ItTF/VT7dRyyY+8i1f
         MSzQ==
X-Forwarded-Encrypted: i=1; AL+hErFvbekybVq0QSVWoY9DKo6SFToKNGZy+ituwdpfTF0rGhH9WRHcXAggDboADh2Q0vIGs46A0YufKEY=@vger.kernel.org
X-Gm-Message-State: APuU4Z/tiRV4nb/ZoSHl0dmDIEDRjvRlvmrqRtTxmYhcA88GayvI8UPb
	wTlP1c5biameV3eYVjFSR47N1OB8PmcD185/NF43qVuURuu3dpc5SoOUTx9BT3h5
X-Gm-Gg: AZFdTZdsTC/ZLkBmmZ6gYNVsJ3e2VJXxODKPB1ywXtJ4E8Pje8DW9C1SYy3Syed0jFX
	3/HGjM7gUP9SX8ylaemkQnZxeAUy29YXisH4YgLaloBjRg8t/JYD0pgN5SL8N8rAegXcvrnvaEK
	d0ZQ+FgknPFUG4o1LUptblEvE2MkqZ8L3rMGZcmxchae0WIFXTGdIBx/AjXslYeoIyBk9ObW+ws
	KlX3J7OheJEBVZGSOsmwHXFt9qZ400QGUuh3hXJKEV2YO+dIAMoxRRRlbERLioZKbtwis2x4To8
	QBMIm/1p8dWkiME+Xn10takr65YJI3vQxDFWN0444z8WgJfc2v5nNE5InhcDS3APvaIVZpktUpd
	nAEzk1/DHBGyNwAQa6CDl0ivPjfpY60aYfe6KDNtiih5draA72RETNY0vwhCfYXv3S2tzMGELZ9
	s1aV3gtlWoRsP2GpIgplZoI68q3C8d5X4koKVaRvxQBbmBHBhbTFPaBenTT4XQl3XwF/1H33dTH
	jFWCwSLSmvox537Biqj8MFcu95eoIvs8GMZdFrOvDFE1AAEgQ8Wc4K1aifuFPU/CJpGY4yiYKA7
	1brxiKeXLfivyU0mH65MCFlF3Tr4FGFRjcKWR5lL+nrtfxA64oDQuHW6yza98HE42oL0wh5Nz9f
	tg/VNYY4MW08=
X-Received: by 2002:a05:600c:4f4c:b0:4bb:8503:69f4 with SMTP id 5b1f17b1804b1-4bb888097a2mr507049805e9.5.1795683597630;
        Thu, 26 Nov 2026 00:59:57 -0800 (PST)
Received: from localhost (mob-176-246-236-25.net.vodafone.it. [176.246.236.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8d4f9aa8sm554122785e9.4.2026.11.26.00.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 00:59:56 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=1bb107e9a21cc29b328dfa80e731d1d8e11a68359f8065fcb2e36792f75f;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Thu, 26 Nov 2026 09:59:50 +0100
Message-Id: <DN50PH7HHSWZ.3H4T25JFPQECY@gmail.com>
Subject: Re: [PATCH 2/3] vfs: add xflags mask to fileattr API
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>, "Darrick J . Wong"
 <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-3-koray.fra@gmail.com>
 <CAOQ4uxhegn1z=41_MHL1Zu2hXuPtzNhC=x4gd371oaeJE4-weQ@mail.gmail.com>
 <DN2N6A68PBO1.2QT8ZOARF4I6L@gmail.com>
 <CAOQ4uxhDQqEQ3T9NveBFpUmSU032BxrNV5D+_zHj8u9LOQY+qg@mail.gmail.com>
 <DN4DRUYPHYMP.20U4DYV5VBN7P@gmail.com>
 <CAOQ4uxg0g+XkPb3-kQS5ez1-rp7Q=BkYDHW0CGOFhpbcf70yMg@mail.gmail.com>
 <DN4KLSM2OO0K.2C8Q5CPFBVNL6@gmail.com>
 <CAOQ4uxhpJygZH-arLFSUYEEfqFG96Sr3_6CWakfSkdWxEsOxMg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhpJygZH-arLFSUYEEfqFG96Sr3_6CWakfSkdWxEsOxMg@mail.gmail.com>

--1bb107e9a21cc29b328dfa80e731d1d8e11a68359f8065fcb2e36792f75f
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Nov 26, 2026 at 8:07 AM CET, Amir Goldstein wrote:
> On Wed, Nov 25, 2026 at 9:22=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> On Wed Nov 25, 2026 at 5:51 PM CET, Amir Goldstein wrote:
> ...
>> >>
>> >> My robot proposed 2 fixes: either don't introduce FS_XFLAG_PROJID
>> >> (which, eh, not the best imo)
>> >
>> > Me neither. It's inconsistent IMO.
>> >
>> > But it is inconsistent in that we want to have a way for chattr -p to =
say with
>> > the new API "set only projid", so we must have the flag, but we
>> > mostly need it for the mask, we don't really care about its value in
>> > fsx_flags.
>> >
>> >> or add a new flag to be used in at_flags,
>> >> like AT_FILEATTR_MASKS, which would resolve all our legacy vs non-leg=
acy
>> >> problems, but it would be in *at*_flags, so doesn't really make sense
>> >> semantically (but it would work well since file_getattr already rejec=
ts
>> >> unknown at_flags, so it wouldn't cause problems for old programs).
>> >
>> > I think this is an overkill as well.
>>
>> Semantics issue aside, I think this shuold be the way to go, because
>> it's explicit and doesn't rely on guessing based on struct size or mask
>> values.
>>
>
> Yes this is a good argument.
>
>> > We discussed this before.
>> >
>> > Attributes that have X_value like fsx_projid have few types:
>> > 1. 0 means disabled (all existing values incl. projid)
>> > 2. 0 is a valid value but cannot be unset (btime)
>> > 3. 0 is a valid value and NULL/unset is also a valid value
>> >
>> > Only for type 3 does can the interpretation of
>> > (!XFLAG_X && !fsx_X) be considered as an "unset"
>> > and anyway, this will require support in individual fs.
>>
>> IMO !(xflags & XFLAG) && (rw_mask & XFLAG) should clear/unset the value
>> in all cases, ignoring what's in fsx_X.
>>
>> And all existing values would be of type 1 for VER0, but of type 1 + 3
>> for VER1.
>>
>
> I agree that this will be more consistent.
>
> With explicit opt-in to FILEATTR_MASKS API
> vfs can determine that
> (!XFLAG_X && !!fsx_X) is alway -EINVAL
>
> When fsx_X =3D=3D 0, the value of XFLAG_X does not really matter
> so filesystems can decide themselves if they want to act on
> an "unset" flag or not.

Hmm, I think fsx_xflags should have priority over the value in this
_masks API.

In my mind, to clear PROJID a userspace program would only need to do:

  struct file_attr fa =3D {
  	.fsx_xflags =3D 0,
  	.fsx_xflags_rw_mask =3D FS_XFLAG_PROJID
  };
  file_setattr(&fa, AT_FILE_ATTR_MASKS);

and have projid cleared (same for EXTSIZE/EXTSZINHERIT/COWEXTESIZE),
while to set/change it:

  struct file_attr fa =3D {
  	.fsx_xflags =3D FS_XFLAG_PROJID,
  	.fsx_xflags_rw_mask =3D FS_XFLAG_PROJID,
  	.fsx_projid =3D 67,
  };
  file_setattr(&fa, AT_FILE_ATTR_MASKS);

and this:

  struct file_attr fa =3D {
  	.fsx_xflags =3D FS_XFLAG_PROJID,
  	.fsx_xflags_rw_mask =3D FS_XFLAG_PROJID,
  	.fsx_projid =3D 0,
  };
  file_setattr(&fa, AT_FILE_ATTR_MASKS);

would have the same result as the first snippet, but not the same
meaning, since this would mean "set projid to 0" while the first snippet
means "clear/unset projid" (but in this case, for projid and all the
other already existing fsx_* it would have the same result).

>> > fileattr_set_prepare() already treats the existing values as:
>> > fsx_X =3D=3D 0 =3D> clear XFLAG_X
>> >
>> > And xfs returns EINVAL for !!(fsx_X) !=3D !!(XFLAGX)
>> >
>> > A simple solution is to fix the flag according to val in fileattr_set_=
prepare()
>> (This should be in file_attr_to_fileattr() I think, but yeah)
>> > if rw_mask contains this flag:
>> >
>> > if (fa->fsx_xflags_rw_mask & FS_XFLAG_PROJID) {
>> >     /* Possibly legacy chattr -p compiled with new headers unaware of =
PROJID */
>> >     if (fa->fsx_projid =3D=3D 0)
>> >           fa->fsx_xflags &=3D ~FS_XFLAG_PROJID;
>> >     else
>> >           fa->fsx_xflags |=3D FS_XFLAG_PROJID;
>> > }
>>
>> I think this would be a bit too overcomplicated to understand, and
>
> True
>
>> robot says (with the current v2 code at least) it would make e.g. ntfs
>> return 0 instead of -EOPNOTSUPP for e.g. chattr +S.
>>
>
> I suspected that existing filesystems may have different legacy behaviors=
..

(By the way I meant ntfs as in "mask aware filesystems" (I said ntfs
because that was the robot's example since it's the only one currently
implementing masks), but yeah)

>> It also told me that statx already has AT_STATX_* flags that don't match
>> the at_flags semantics (and indeed, AT_STATX_FORCE_SYNC/DONT_SYNC don't
>> really make sense for "at"_flags semantics), so my only blocker for that
>> solution is gone and I would really prefer that approach since it's way
>> simpler and way cleaner.
>
> Git history claims that I suggested making this an official UAPI policy:
>
> b4fef22c2fb97 uapi: explain how per-syscall AT_* flags should be allocate=
d
>
> So definitely no objection to AT_FILEATTR_ semantics.

Oh, yes that's the comments I used as docs to add AT_FILE_ATTR_MASKS to
fcntl.h ahah.

>>
>> One more thing gemini told me is that if we don't want to use AT_*, we
>> have to choose between (copy-pasted, "ntfs" meaning any mask-aware fs):
>> 1. Keep clamping fattr->fa_xflags & rw_user_mask (VER1 masked semantics
>>    are clean, but recompiled VER0 RMW tools setting unsupported
>>    flags/projid on ntfs silently return 0)
>> 2. Reject unexpected non-zero bits/fields outside rw_user_mask | ro_mask
>>    (protects recompiled VER0 RMW error reporting on ntfs, at the cost th=
at
>>    VER1 callers must zero or mask fa_xflags / fa_projid / fa_extsize
>>    themselves rather than expecting bits outside rw_mask to be ignored).
>>
>> So I would *really* prefer adding AT_FILEATTR_MASKS and setting
>> has_masks based only on that.
>> This way we can keep the whole legacy path frozen and not have to worry
>> about weird edge cases (well, converters code aside of course).
>>
>> And personally in this way I can reason about the changes a lot more
>> clearly and I can finally take a better look at the whole code and maybe
>> simplify it in some cases (probably not, but I'll have to see).
>>
>
> All very good reasons IMO.
>
>> (Unless there is something equivalent to AT_FILEATTR_MASKS to filter on,
>> like maybe a FS_XFLAG_MASKS (?), but that would be even worse
>> semantically I think)
>
> It's an option, but I think AT_FILEATTR_MASKS is cleaner.

Yes I agree, I also thought a bit about other options, e.g. even having
FS_XFLAGS_HASMASKS (like HASATTR), and stripping it right away in the
syscall (or even using it instead of fa->has_masks) but they would all
be worse options than AT_FILE_ATTR_MASKS.

Today or tomorrow I'll send out v2.

Thanks,
koraynilay

> Thanks,
> Amir.



--1bb107e9a21cc29b328dfa80e731d1d8e11a68359f8065fcb2e36792f75f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCawf1BgAKCRA0bnTtJTDo
OLpjAQDKR/dd73mxIOj/+UMsWX5hqzYCO7wVrdU87VsXoryD2gD7BIDEGqEGAI9o
nVWwXnlKfovOetcDViuUktTHmdBWygw=
=GJse
-----END PGP SIGNATURE-----

--1bb107e9a21cc29b328dfa80e731d1d8e11a68359f8065fcb2e36792f75f--
