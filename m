Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795676858;
	b=StyhYi/0TJ3I0kv1cePBMlznk+RgQMsG9a8H++yFTSNzceZktk4ka/TJUjs9qP9PP0hy
	 evszJWBZJaXf73Myz545jAxjKxHorbjnLuiO4cctPlRmA5xRr/ULdcLCY2lAreB++d3lV
	 JNr2uTLs0WvU4Q8opjEmEvVQe6GoGBqUeNNN7EDOo47lPtgAvCAUelVJiX5esYlantwIQ
	 n4ySDtjMmYcGUNGV/SN6iYH1EwtBIobRkLLjg4Wvs1sOvyDlw+6ySuUggA55NlfQtSEsq
	 5LdtZ1mnASd5DuuibsLU7I0hWLMRP32FpKQMqM6RWZ78mBTpRNe+Nyuak5TPecMA1eA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795676858;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=vhA0eLnCIevNQ8XZQAJ5drG3uVP2Uo7mZJ7ZmJtYK1A=;
	b=RcbRs5Iwh5udcHq8Eag6aVIPryDLFhv3Lw4jSL98OLThornDS8XuRoepnUrnPRkrsUyP
	 cX8Z7QX4ECSC6/4vHPBnoPiE1orsJFwo+YguXhpqx2xz6IZ5meZjI01u4MKvH9BigcF9A
	 JQvin6Rt5sBu4B6j6ONt4Fy8quC55V37jkybZCNsZKv5LDqaNgShf1ITgUXt1637e43Vk
	 2tI6NXsgI83j1ZF9qkRA1uQMR3YG+4HgQkdeuGe+DBLBGEAWyhRCYJEB1qrBM5YdNmS32
	 eHROdnbJTXfLgYHR97okW7PyhNf4XXpFVyIGPco9ZFztNY/p5eWI7wPVA6dS2BHu8Eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RTwcTpJG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25BC606A32A
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 07:07:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E25BC606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RTwcTpJG
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso8411780a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 23:07:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795676856; cv=none;
        d=google.com; s=arc-20260327;
        b=AgHOwgvj02juPcveX6eaoeZmCcQ6IpWo2+t4VvT5dXL0r5I+06Vhxq0Kbx2TjuetT3
         w/qZIpN4oLglmmdTt0OLRbR5uxuBQ6R7OdiIluFdIKnc9zjGs0XHWKuJzQ0vcLarTd94
         /V+1ugPKHJEemC7S3z+Ei2ZEV7JtI+pWWprnVfSwWLDal9PsE5hAOgLnBGP/Vt4B44D/
         VXF2PMCjb8FOwtl/rxoh2pb2nXX6U2xHpzaLEjrjzR2uwbK/uCU2QkETZtlJlmNr2pHa
         RGWWnnqNt+/+gzzSDsCyL43EhAxaanqXLAa0GlKb/4kwRyhG1CklSEV2Zd3R/RTsOTc2
         3Jnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vhA0eLnCIevNQ8XZQAJ5drG3uVP2Uo7mZJ7ZmJtYK1A=;
        fh=xyepWAv4PlohwoPzP4MNk10qc/+ZS7ACER8GLVer5M4=;
        b=DopKPi4L2Gm0rMOXgWxWOyi0FJSJroYJlNJYKASLGkUAMoEwBNVPT8bcrWHortTi8K
         GT8rXAMtxXc0it0NB/u7DrOXkasmraGPjHeMlKSpyBdoWsnKO0EenweHqa3PoK8jdZI3
         U8hB9VPqovXXoY04vs3W3YV4h4QqgtGegqyni/JDFmy59/DEKsJGba++zNdFIbAgDwH4
         H5fZY0Jh42j6DYoXYkrPL0QDwssBoeow5vpp1j528jqWBttoNWKMn+bbK8yGIArLziDN
         Af6lMd2s7ZBE1fEX0ydbSuSYEDeUl8GB074FVd4Tm1RAQBtTs+A/gp4V9VUlIkFQHKNJ
         zKXA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795676856; x=1796281656; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vhA0eLnCIevNQ8XZQAJ5drG3uVP2Uo7mZJ7ZmJtYK1A=;
        b=RTwcTpJG4bcVbq/Rg5B+ch6/7an5ITR4XEEG+AkvCZaO5S5MK9+7zMbjeu6Tz+z5ga
         CWEO9+8UQSsKxEuAJjVHyYzclJm4+8BzXSBPfAS+XvTldZHcJVfkmJc8wN/rjZ3nOpxg
         Miq4NoFV+gj02QAUl7fITtqlKeaYvoc9VlPZmPPr5AIwSHd/ol2Awrt82R8ritdDQxU+
         vtBQ6qkScxqKeemWLHaVKDSiKHkhUNrNBgbM8bj6CXpmdtW9wuPao4renzSpDZF+J0SW
         7kBNeiclG90SOT+BT+dwAye1ZaJAxc49SpAattBiNnNNGhpE+c629x8oShdkkEm6f1/v
         PL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795676856; x=1796281656;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vhA0eLnCIevNQ8XZQAJ5drG3uVP2Uo7mZJ7ZmJtYK1A=;
        b=dkgDSBaEDs+UPgbsRG4LHcSKFEInnY3XSha4GtgI7l/+SHKY5djAqjwmrO48CrQhJv
         2RrqFc0OBqCQnJUG8g6slL5+NfLdbhLppzZK8gjgEZ9w2x2fMJKuxD4MlF5QH9yXPDXE
         +IOqedoXN4LruLZDeOq00Ms/C8sNAi/Y+WE+QBQwRqY5A3bsWY7Gy/UZoKbclD6UDPcC
         hO1/W/ev6SfdlL/wl0V+cE7CbxtuxwtotkwgRyC4fRDW44KQUGeBSy0vsfTr8aFD1S6N
         /ATXvHLyJW1Bh7uH0zvXgReMxrytzfdxQP4peVkD27pEvBRfqWZQ1Oz5veTv7VPZ4VVO
         ahfQ==
X-Forwarded-Encrypted: i=1; AL+hErE6X6beHyLRDWr1bSTTNgicz1fLcQb1uCFDPSIL98qRpX5d1/BKAv2aGLwmhWkM58g9Ag0D1w/tBMA=@vger.kernel.org
X-Gm-Message-State: APuU4Z+PJ2N79eMxHGKpzca62Gp5XNKF3FJdifZBRz/GkoGr1n1UuOrO
	fI6qySpE9XBbRoObwmo1GdbqodSGgmBYYHm/b+h8Ls03OFYF62/kIi0XwyYcIGnrPpbScPyoWTT
	yBZq5fJJrcJ338Y8Fnj7BF2t2vqzYsc0=
X-Gm-Gg: AZFdTZfpGPFlsRoP8nQzu6rOCoilSxFvUn8QuII2U8PfqRG9GV5Xv0PPhmq2u7Iurc8
	PzYt2yUctefbmiCCfS8yMiR6rNDF7oa7GiViRRDiOBoq/2sxsXOcIkW5G3rvc7Wqkd920lvfkoy
	4KA25+1WdS7wj+vNxJ4mPaX0ltwn7eGJ+F5jPEnpoY7ttawJlJycy0Nsb9N+RMuCqpxYQ0CjJ1B
	82OBWtm9uJLvHGyZsfsimsHg35rnGGZS7Jidnj30BqGAyxVHza1ksYhpd17o19g141us1hxfLao
	3ikIf8BTLCi/CglYDLtSo2A9+1N41N7rhpKVzNltv37DDjpPFsvGzGTVdgMG8YAl18MEE8Q9K9r
	kaj6Jey9S7unX6U//i1G9p1wFlcm2k7R+s5yvOqhXx9QxKTBe+v7KSjZ6qr6AkLbM+XYq8yc=
X-Received: by 2002:a05:6402:42c8:b0:6ba:90b8:6584 with SMTP id
 4fb4d7f45d1cf-6ba90b86c26mr10129365a12.27.1795676855879; Wed, 25 Nov 2026
 23:07:35 -0800 (PST)
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
 <DN4KLSM2OO0K.2C8Q5CPFBVNL6@gmail.com>
In-Reply-To: <DN4KLSM2OO0K.2C8Q5CPFBVNL6@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 26 Nov 2026 08:07:23 +0100
X-Gm-Features: Aa3M54p-xXrArmKFQVXQGyMmIHEH7IQOans_pobuFbiou8Pi118hgiXnigLCYjk
Message-ID: <CAOQ4uxhpJygZH-arLFSUYEEfqFG96Sr3_6CWakfSkdWxEsOxMg@mail.gmail.com>
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

On Wed, Nov 25, 2026 at 9:22=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Wed Nov 25, 2026 at 5:51 PM CET, Amir Goldstein wrote:
...
> >>
> >> My robot proposed 2 fixes: either don't introduce FS_XFLAG_PROJID
> >> (which, eh, not the best imo)
> >
> > Me neither. It's inconsistent IMO.
> >
> > But it is inconsistent in that we want to have a way for chattr -p to s=
ay with
> > the new API "set only projid", so we must have the flag, but we
> > mostly need it for the mask, we don't really care about its value in
> > fsx_flags.
> >
> >> or add a new flag to be used in at_flags,
> >> like AT_FILEATTR_MASKS, which would resolve all our legacy vs non-lega=
cy
> >> problems, but it would be in *at*_flags, so doesn't really make sense
> >> semantically (but it would work well since file_getattr already reject=
s
> >> unknown at_flags, so it wouldn't cause problems for old programs).
> >
> > I think this is an overkill as well.
>
> Semantics issue aside, I think this shuold be the way to go, because
> it's explicit and doesn't rely on guessing based on struct size or mask
> values.
>

Yes this is a good argument.

> > We discussed this before.
> >
> > Attributes that have X_value like fsx_projid have few types:
> > 1. 0 means disabled (all existing values incl. projid)
> > 2. 0 is a valid value but cannot be unset (btime)
> > 3. 0 is a valid value and NULL/unset is also a valid value
> >
> > Only for type 3 does can the interpretation of
> > (!XFLAG_X && !fsx_X) be considered as an "unset"
> > and anyway, this will require support in individual fs.
>
> IMO !(xflags & XFLAG) && (rw_mask & XFLAG) should clear/unset the value
> in all cases, ignoring what's in fsx_X.
>
> And all existing values would be of type 1 for VER0, but of type 1 + 3
> for VER1.
>

I agree that this will be more consistent.

With explicit opt-in to FILEATTR_MASKS API
vfs can determine that
(!XFLAG_X && !!fsx_X) is alway -EINVAL

When fsx_X =3D=3D 0, the value of XFLAG_X does not really matter
so filesystems can decide themselves if they want to act on
an "unset" flag or not.

> > fileattr_set_prepare() already treats the existing values as:
> > fsx_X =3D=3D 0 =3D> clear XFLAG_X
> >
> > And xfs returns EINVAL for !!(fsx_X) !=3D !!(XFLAGX)
> >
> > A simple solution is to fix the flag according to val in fileattr_set_p=
repare()
> (This should be in file_attr_to_fileattr() I think, but yeah)
> > if rw_mask contains this flag:
> >
> > if (fa->fsx_xflags_rw_mask & FS_XFLAG_PROJID) {
> >     /* Possibly legacy chattr -p compiled with new headers unaware of P=
ROJID */
> >     if (fa->fsx_projid =3D=3D 0)
> >           fa->fsx_xflags &=3D ~FS_XFLAG_PROJID;
> >     else
> >           fa->fsx_xflags |=3D FS_XFLAG_PROJID;
> > }
>
> I think this would be a bit too overcomplicated to understand, and

True

> robot says (with the current v2 code at least) it would make e.g. ntfs
> return 0 instead of -EOPNOTSUPP for e.g. chattr +S.
>

I suspected that existing filesystems may have different legacy behaviors..

> It also told me that statx already has AT_STATX_* flags that don't match
> the at_flags semantics (and indeed, AT_STATX_FORCE_SYNC/DONT_SYNC don't
> really make sense for "at"_flags semantics), so my only blocker for that
> solution is gone and I would really prefer that approach since it's way
> simpler and way cleaner.

Git history claims that I suggested making this an official UAPI policy:

b4fef22c2fb97 uapi: explain how per-syscall AT_* flags should be allocated

So definitely no objection to AT_FILEATTR_ semantics.

>
> One more thing gemini told me is that if we don't want to use AT_*, we
> have to choose between (copy-pasted, "ntfs" meaning any mask-aware fs):
> 1. Keep clamping fattr->fa_xflags & rw_user_mask (VER1 masked semantics
>    are clean, but recompiled VER0 RMW tools setting unsupported
>    flags/projid on ntfs silently return 0)
> 2. Reject unexpected non-zero bits/fields outside rw_user_mask | ro_mask
>    (protects recompiled VER0 RMW error reporting on ntfs, at the cost tha=
t
>    VER1 callers must zero or mask fa_xflags / fa_projid / fa_extsize
>    themselves rather than expecting bits outside rw_mask to be ignored).
>
> So I would *really* prefer adding AT_FILEATTR_MASKS and setting
> has_masks based only on that.
> This way we can keep the whole legacy path frozen and not have to worry
> about weird edge cases (well, converters code aside of course).
>
> And personally in this way I can reason about the changes a lot more
> clearly and I can finally take a better look at the whole code and maybe
> simplify it in some cases (probably not, but I'll have to see).
>

All very good reasons IMO.

> (Unless there is something equivalent to AT_FILEATTR_MASKS to filter on,
> like maybe a FS_XFLAG_MASKS (?), but that would be even worse
> semantically I think)

It's an option, but I think AT_FILEATTR_MASKS is cleaner.

Thanks,
Amir.
