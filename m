Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795447127;
	b=L7JlVBFmtl94oEPiF4+jbr9IiX+hUHuoKY78d89CCv+nmBzZxV4+S+ImmMwgv1yiLDlb
	 Ak8erB1pf1U+4MnoDEddVPk+isj6ENtpK6dCLltXwG13+cNyabRTXK0fb6nCU+wcXIPcI
	 lPqPw/diOcrWKGOYKXZzvqv3oFx0acUIg3WDI3RqjMkHIT2SFcJG9ZTE+VSSvoS+dE56v
	 TQa5a2u8tFYn0JcjeZ+pwgVR1Crom3o2Fy7YnzVcwcVKlKmJiuLJB9kS4ojSMRs7w37Zz
	 QCYulVnhUPWXIpH3i4fnPg2fkXr3oP0eSM5Z6I2FwaWXD1K+AH9+iTb6NVdaR3df2Hw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447127;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FQauslTrJye8WtEKr4/uMYFLXtDrCWIYYsnNnENx50w=;
	b=ZRM00KXKmLitSSb7ByI9zMCb8bSSIDvj4HWoj6NUQ/4Tv/SzyZmsXdtxPl69DE7gE2YR
	 8553QVUjAzvDx8Pmn11V1R+lKsveChgaFPAG9EN+JulK5TOdEkUlazJDCe6v8uJYCm7gG
	 VZvTK3shp3JuWXk8gT3cDBesRNdzrVNyuKMoBgxaBmqyt3pIEibM1YitVl2CeNi/Z6q4L
	 1QlES9RKZomRzMWpQaASoLQ7hkU7gugxvpf622kNIzIiaqCBe2LxxKz3War6XQZbcKMI/
	 B6Af9dC6aQICv0+8PK9JZKPrqfjJx8gLF165ZL+++YQ1kzh3iZkOcVr9BVwaMBpuUPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tnOVRIK8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06B3606A32D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 15:18:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C06B3606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tnOVRIK8
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b88bc47e23so4203696a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 07:18:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795447125; cv=none;
        d=google.com; s=arc-20260327;
        b=AQmmgdO3Ck4gtCKlgfrhQlUCLmOyfzfRLVtNGzpt5KW+mfbZvhfVLOB1CAy8Bs8uAb
         /jwiw/jtQcrZp3bpAeZZR0FYYy+wOtup75YIroZ1l6+SWZJucDXIRtm+gRMbS2/aU94u
         iiGGfxzdkvUVNGmN43n5zaEVMAtH5iIdqQ9wq/lNiIz1UT3rffHWp2m0/EVzh577o8Ti
         ohgAuh4osTebZMUvhqodYyufPHDiuJEOcQFsbNOgn2RLgXR4sD7InQAjbNSRyssYwgGp
         AzxzC7w7lDQ6auoPvfu4V8U3hvd2o2hQrXjCKeybf2PivVYEzuC+CBSNobW8JXoLVFsy
         PGqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FQauslTrJye8WtEKr4/uMYFLXtDrCWIYYsnNnENx50w=;
        fh=hbjgFyt0aAgLH9W4HB2aG+2JwdaZYj9IMAkHFPid7ko=;
        b=NFf2Bdyi+nPjwr4bQCoObcu6pmbHKFd1dyRo3GcdfuWQuvMWnG8lfHliE8m4VsqE7b
         XabwpV7pc+EgeMDSovFFjvPbZHQO1mw+kEOcSdfKJRG+56GyVIKwDEdHMwKWJU07xzTn
         D0WfZNQhQA7LR2xukBgE4W6DUc0t6Dj5XQ714uW2dMVR8JQb9PF+ziOuQsfgU2DB/hSS
         M1mJVaE7f63a45JgQvHKT5pcwovHTPb6vQ7m7xaX2iMpw3jHSKBfMs8rJlj+pROd4FfS
         WEFnGLpKm3ldlYB4x3UxDsoD9w7rvXFBoziq9StUTAXe6C8NGe6X/FlBW9J9XEh8xAIQ
         iJKQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795447125; x=1796051925; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FQauslTrJye8WtEKr4/uMYFLXtDrCWIYYsnNnENx50w=;
        b=tnOVRIK872Am/h1zBxtrm624YwtnAaM1ODFpUf4BIJQhjvNzDIVKPp0Tc0+kuNgK+T
         P6zbEiDvzhGQMmXVnvEgssD5Os9Kxz71/UfuvuNfnMWhsGjmbEY+8raprIJ9X6wrs9+P
         t+n4QGoPL0En++2BIFCjCTfGW7tcR93V3ClOyWg2gSS8rvl/rQevnj+NbA2pmKoegUTq
         wAOmepamNX26KktT8XanGPaaDNNp/wDvhl8maLDsDH89HC5UHE/TdVVYvF0O7DiHJyEN
         CZVx9d478DNjHDgR4foo1kre37sD3glA5umfoInRNznQIrbXZtcPjA2+5t6yJceHDFpe
         Nzlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795447125; x=1796051925;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FQauslTrJye8WtEKr4/uMYFLXtDrCWIYYsnNnENx50w=;
        b=tAr11pWpnlrPDITqxzM+NIelK+bo/7YSfnC7gWoyl0yv9qyBcPcENy2vgEYIr+N6NE
         Cv4kOnOyO0X8QutsOU7xYwF5yYUfzyCa08qXhGs9iSbjrl824lsi368qwHVSLcOsFscd
         +4ED3+lJJx+hPq8U/6N/L/ddUmV4UdHSL8OBc8zuFLAv3uZeWBjWSnUIaV1wQfycdP0G
         BFSgOP5jb5E3MNDrOSqjlHAC1cBmgICjJLNAGE/98IPbHJmBQlANc2peD6v99S7mzGpx
         8wUZkrx49VGgEDfWcawdtHrmH6SPleeCPK7zzPgD8LZwqD7/MJ7PIcn7QA89e9iYwDhT
         72nA==
X-Forwarded-Encrypted: i=1; AL+hErHya8c5KNugvjTL+8rFn9gX+hxGR8/6WZwmqpJeweLlLjkzNLih/EclYr1bk4YmD5fqlKp4e8+aaJQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z9t9DujACoQMbY8DgPyer3FBShY+sPZekh0A+oYoC9LTicD5C4b
	CZO2L1QpeDjj6Q25Mq2GymQ4xOqKp33MyTgE0NMBJvC+fjvDXU+Cc3LiF5DdyeEwleeA8x8bt5B
	zTVJTVIDICRQOZeFLYwaN0t+I8bxLZ2A=
X-Gm-Gg: AZFdTZcUHcNCL/nrqeHsTG0b6GgNyw+eboy96hD1jfeVXnvywM0wmqEFqKDA/D5WiBI
	aKNlTeQ8SHJ3bEkv5Tmv4q6oRfbLM9W4v9YM5Ft+GrEUTxdds1p2Xx+QVURE7xBx8CXiNUSTEtz
	o1EbIMvhuWa/gOMzvowivWf+RIoZwbCwe713TOO6S2kuTfNSjdP8a2H6im19NCvGnJsz8wtpjhr
	hUYGaOoDkeUs+juaVyPYu+sEnJwUTp8/VqRiqFK8HWZSL+tTVS0D0yF9pu1UtDXAq98KX/8uiVX
	/tOee4mK/WGNXHNCOYH/SGbSkhwqejMNiXnLyqCQ61giPaViGRGBfxxbcFKkVoBCL2/Uw2H1tiJ
	rNtWhMlwaiGnYKh/BDQAV4Twl7clYEopm2SUHm+XD+61eEL4yNQWdcx3Qr7KOQLvNCeyR+MM=
X-Received: by 2002:a05:6402:23d0:b0:6b1:b97b:744 with SMTP id
 4fb4d7f45d1cf-6ba37ec18e4mr7070716a12.32.1795447124603; Mon, 23 Nov 2026
 07:18:44 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-4-koray.fra@gmail.com>
 <CAOQ4uxgc6pP+_xvJMbqj6wOdGzS75Vn6x6i_vUfCJDD46DAA_Q@mail.gmail.com>
 <DN2N0BY83OY2.1OV3ZAZFSWCDG@gmail.com> <CAOQ4uxg9O-R_SUPAZ75ESGB99-4Z4EEUKGMkCF2f-sXkGPq1GA@mail.gmail.com>
 <DN2NVGUNO0GA.89JAB2PVI0LA@gmail.com> <CAOQ4uxjuAN0FdxGr_-OccO5qnUuLF5oxOq7L_545tG3+36EKFw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjuAN0FdxGr_-OccO5qnUuLF5oxOq7L_545tG3+36EKFw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 16:18:32 +0100
X-Gm-Features: Aa3M54oObGzmT9EyX7FArFQpCHBYwqipULgBnYau0_-PZcRo8HGalO_VEERbt3I
Message-ID: <CAOQ4uxgyKcB8GjE5_S9fgMv9oC_dKKaypDWEf-eXEkFeo5e89g@mail.gmail.com>
Subject: Re: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
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

On Mon, Nov 23, 2026 at 3:55=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Mon, Nov 23, 2026 at 3:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
> >
> > On Mon Nov 23, 2026 at 3:14 PM CET, Amir Goldstein wrote:
> > > On Mon, Nov 23, 2026 at 2:50=E2=80=AFPM koraynilay <koray.fra@gmail.c=
om> wrote:
> > >>
> > >> On Mon Nov 23, 2026 at 2:00 PM CET, Amir Goldstein wrote:
> > >> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmai=
l.com> wrote:
> > >> >>
> > [...]
> > >> > Rule:
> > >> >
> > >> > You cannot add a flag to common without carefully auditing all
> > >> > filesystems that support the legacy flag.
> > >>
> > >> Yeah, sashiko pointed out a problem in f2fs, and I could reproduce i=
t in
> > >> testing, where adding COMPR to COMMON makes f2fs crash, it also need=
s
> > >> NOCOMP in COMMON.
> > >>
> > >
> > > I don't think this is correct, or at least not enough.
> > > My agent said that this breaks or changes things on  f2fs/ext4/ubifs
> > > I didn't bother to check if all of them are true - I doubt it
> > > bottom line - need careful audit and good testing.
> >
> > Yes, definitely.
> >
> > >
> > >> > FS_XFLAG_ENCRYPT can go into common but must also
> > >> > go to FS_XFLAG_RDONLY_MASK because it's read-only for
> > >> > all existing fs.
> > >> >
> > >> > COMPR is rw for some fs and ro for others.
> > >> > As with CASEFOLD, you cannot make it COMMON before
> > >> > converting all casefold fs to new API so that each can say
> > >> > whether it wants RO or RW.
> > >>
> > >> How's CASEFOLD currently handled? in the v2 I'm drafting, I added
> > >> fileattr_mask_to_legacy() and fileattr_legacy_to_mask(), which conve=
rt
> > >> between the old format (filtering by FS_XFLAGS_MASK) and the new mas=
k
> > >> format.
> > >>
> > >
> > > Good question.
> > > Need to check this.
> >
> > Can you do that? If not, I'll check tonight, no problem.
> >
>
> CASEFOLD is set in FS_XFLAG_RDONLY_MASK and NOT set
> in COMMON
>
> Therefore, doing set with the old xflags API for the common flags always
> preserves the old CASEFOLD.
>
> This is kind of ugly and works but its hard to see the design there
> so hopefully all the new helpers and masks will sort this and make it
> more explicit.
>
> IOW, ENCRYPT can use the VERITY RDONLY and COMMON
> precedent because it is read-only across all fs (via this API).
>
> COMPR (for the purpose of ntfs patch) can follow the precedent
> of CASEFOLD of RDONLY and ~COMMON, which somehow works.
>
> Note that for fs that were converted to the xflags_mask API,
> COMMON should be irrelevant.
>
> COMMON is only used in SET to do GET and preserve the ~COMMON
> bits of the "other" API flavor.
>
> With the xflags_mask API, unless we adopt the "verify" feature
> there needs to be no internal GET with user SET and then COMMON
> is not used at all relevant at all for those fs (e.g. ntfs) only the
> _fill_ converters are important.
>

The statement above came out too strong

The internal GET is still needed for the permission checks (immutable, etc)=
,
and for converted fs COMMON still matters for the legacy ioctls, but it is
not used when the new xflags_masks API is used.

I would love it if we could get rid of the internal GET, by moving the
IMMUTABLE|APPEND checks to the fs fileattr_prep_ helpers.
But this can wait, you should not be distracted by this now.


Thanks,
Amir.
