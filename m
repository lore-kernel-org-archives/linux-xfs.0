Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795448577;
	b=N7HBTrQns6BfZT+KsFdFkd50fgfigO0V69nDDDIm4FDCBSrS0OCTfqK57qSaShQ35RAu
	 hoiCNoN/Cd+Hp1W+L2nou/xpvyrtJHSGPlOnubRdNHk7oVstyiziiArhjRCz1I8u7i7kS
	 YazFAvaNkZ1GSdgij18CFHzMN+aJEAk4Zr8k1/VIEkePEpKBF5h/FrAiMMKLs6PK6fuc2
	 mxPOVrG526R38e+6x0YXs5CsftEru2fJtTX82Rw+bDb8EI0N/i0/x0KRBsWM+c1B7woNZ
	 LFd7/+pbPkPueY/UzMncwqjVtapEElfXJ4ZcL+E7ANLz+FgRRwUw+VZIcSMBgrKuv9g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795448577;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=4hoS7D/yU9yneseDLwIn7QnnUwkm6mFkBGls0/3F3fA=;
	b=V6+akW0DXoDuV+dqR6nk+D66hIN0+QDKj5o3DCbOUzGr6Qlf0iGhWQwBFEWcDXbEh4MM
	 roSqPKTDmJyxwg+WWqcggikv1tiGMExezFgr9SKJwLBwigqng80PfUQ8sPJfw4rXqoZli
	 WcDoRDBrnLUPe3tZNWnH3O4LmrMwwvaX0s3hO3dBP2IFQhwMgoqSEvkCcjLX44GpoOS4P
	 62QX3UYxuzrLssdPTFh8WdXwVOQakH0Ky98VQ4e3OePY0WpidbzVH6OHDIwJnHm229NDy
	 tk7kWvtEgRqL4kAAg1Iy6fyUZp8CAIcyPzH9icfimLhs7jdSjjAQBzqcov63ZaMn2TA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="PIRII+/H";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4407606A32A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 15:42:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4407606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PIRII+/H
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b88d143160so4164333a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 07:42:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795448575; cv=none;
        d=google.com; s=arc-20260327;
        b=cyVVZAK+HiRrbxL8ZYGjz16bqG3jxwMRFfeQQV710lVUjm1e4f2TdXaGe0YVKIGPRb
         hXAPOerS9fBKBVlIs7yytJ7vfsX6YWk0MC9capgzWFJmedHFT339LRyDmo15wubs+mfN
         jXS+GWqBfORXQI7gKxxL6Asivs4/GkBHOESYcTvvK9PwjHwDGd4Pmz8I+Vo1DUjq96ju
         vSUoFLiq8E7S2yubaWzYbBP+ipLofY9wFmWGS9cpTLU8RYl6aSkr0t4TQWechlSLFVM0
         jaetmDKwUpsyJZCm8Or+GQDyF10pPMKanAUEwMx10+DnMM6w0C9aLS0ShInxGakxwCRB
         GEPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4hoS7D/yU9yneseDLwIn7QnnUwkm6mFkBGls0/3F3fA=;
        fh=ZCUbf+F7OrHXQ4ccFbgP6im5wi92h5deLRbFoQR+teQ=;
        b=WVvNis2/dO+6v9JVZA9QVbkBwLCDf8UhUTSmEBFEZW2n/l8/bggXT//x+pURgD9RmY
         4tuFF+MDa9bTF0/wdCQlezEWspbw0RBCr2KsBcViHak9O0eqOWZ9d/lKeufIFrz1XNP+
         HQRDxO/6plDcAI7173W92OAv6Uo7ScDTutcErEw9OMREv08SRHgYEcJr0egIj4uYNbhF
         MzmPm40W2DJR+gvJSJv6trSRPo2i6IOabkEzpndYPeGyjgilvqAoYB+GyR84vVHgSFuE
         Xd7MnOBghbUKCCizj34isamhQX+lSvdk/+bKFv+q2y69UYXSE3XnmSF7C9j8O8Cr2ALM
         HmbQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795448575; x=1796053375; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4hoS7D/yU9yneseDLwIn7QnnUwkm6mFkBGls0/3F3fA=;
        b=PIRII+/HXrrrLYjcS/gKa1rXimBk2LIYjBRkz3pDb7FstlxO+Mj3pWZ7n1JnDyD3/4
         jAHH1m/7TkL3jATZnwL+HJnRyKd6WvKAK10FBqKRUy3NS7EZDqejr7UsUBANL3Zb3ccN
         41Y6a+sv5stq0/ULurG8HIg3qBtdncGz/UYo9joxPTKOAt7tkufxkZT6JioYG+YHaZ3Z
         CxMiSf8HrpxJ6+ISIczIm0VxtkShQyvxzcuabNxJH9//VektmFIBhylxWcp0nC9aKJtq
         pCvxR7OajuImBrYlGQquUAgz5BHjSAf0IkBtMYdFARs9SfS4MavLgQNYePO84GUbnUaw
         JEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795448575; x=1796053375;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4hoS7D/yU9yneseDLwIn7QnnUwkm6mFkBGls0/3F3fA=;
        b=je2Bas+a65BRUhjus4zZ/bxNuJI7EXbNYxWWCmpEEu+AwD7rT2lmR0qsmHgyBC8U5n
         2gk31WOoxg/TbIscReTfZVR1OcLBEThNTGoE4CWmPb8Lxyw3/jYVuAXyABFAgLOTfykW
         upEwehA7zXG6Jo/tbnVdN2ejWIcaYzxt750DTY/U3ZPxZqeZL2sj8/PEYyY+HiyEwsW4
         RqHCg+l9MVziCwdT7dtP6WsVxO+hZWfrjQlpka8cf452jt2R+9stdVNqDD3PiVCHC9vy
         rxJ9ltFmgXqe/NmboTRjqNGI68ya45gqGKHA9xB2jpCxr/+mLlo1V4dMMrtrKHJHMbVD
         bv4Q==
X-Forwarded-Encrypted: i=1; AL+hErH+sYZsQzbAuXWI1KNCEHo49GKOBiOPpEkiVT8vlOqzi2H6NWqOwcxKNlY/M+UQZSZXK6ZHMLKv5FQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z8m880XCTm8szUFGayltijSSh8M27Kn64CaHFky7yhxdfiOu9bE
	/7SJswbFfNwkS0C5TjfvTM8kPHoBZFW5FxHr8+lQGILbJ4eZTr5uZGe5QjzrnvdVkfg/mWrwmWS
	/PK6nIPfsZAxZ7v2yedyxZb8DLg9+ZCM=
X-Gm-Gg: AZFdTZc0ZohBHOFxrI6JJ20/QhlzbDoMynoll7/8RSmxPBZc6W0yp7L0+KliaMGec/B
	vmCWa5MDN1vJf5w37CjSMjKE+XHDSlksFJE22x2YZbpmV870u9LlaWWeg6dMG/mWUKvWKwYeyBX
	WGtWxE5x2oTDcucg0pFMQ7ySNbMTlxfgxQgUxJHduscAdUdgo59M7rn+0vY7ApLwVh8UzfWybNK
	KaZbDVB2M/FAe0fR48Ibc+psY/PqiGN6d4/YIFkBKiCfs0dcpgtSlngVejsuWSyg0+0yro1dKI4
	TZjKtbPE2/jKFvlg7+qa4zCQtHiJnQY/2crlNQ9Tnw3VhJioePEQ4Xe7VnHBooXWa6GH5HunGAf
	2fWR9X48/ovqXNTO/Qnj7sqaWganxYNnvT1YTnZsX6RfQAFDXQ5gdH8gJOLTUSnHlQ2CcHw==
X-Received: by 2002:a05:6402:1e90:b0:6b7:245a:a509 with SMTP id
 4fb4d7f45d1cf-6ba37ebe297mr7495627a12.40.1795448574799; Mon, 23 Nov 2026
 07:42:54 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <CAOQ4uxgf2KE=Ag13EPAu5=KnrFwt7zRH=im-qmLc8+i10Tjd+Q@mail.gmail.com>
 <DN2NFOEO4XGN.1PEF1SWOF7YCQ@gmail.com>
In-Reply-To: <DN2NFOEO4XGN.1PEF1SWOF7YCQ@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 16:42:43 +0100
X-Gm-Features: Aa3M54rfVJcDYHks7IXLbcOSfYk3rl16ClzvXAxdlbzoJ0nkqLtOGzUzvEIPewE
Message-ID: <CAOQ4uxirKKi=uwyiFWev_5h-LBTLjHgw-FHJ9T2X+JUNSEpf=w@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add f*_xflags_{rw,ro}_mask flags to the fileattr API
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

On Mon, Nov 23, 2026 at 3:10=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 23, 2026 at 2:35 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> This is a follow up patch series stemmed from [1] and [2], splitting t=
he
> >> _mask change for the fileattr API into its own separate patch.
> >>
> >> The first patch is a preparatory patch so that the code in the patch
> >> after can be formatted better.
> >>
> >> The second patch is the actual implementation, which introduces:
> >> - fa_xflags_{rw,ro}_mask fields to struct file_attr
> >> - fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct file=
_kattr
> >>
> >> These masks have the following semantics:
> >> - rw_mask:
> >>   * for filesystems: advertise which xflags they support changing
> >>   * for userspace: specify which xflags it wants to modify
> >> - ro_mask:
> >>   * for filesystems: advertise which xflags they support only reading
> >>   * for userspace: ignored
> >
> > Nice!
> > I think this API description is very clear and coherent
>
> Nice.
>
> >
> >>
> >> (ro_mask for userspace was also proposed as a "verification mask"[3] b=
ut
> >> I left out that semantic to keep this patch series more contained, and
> >> can be added later if needed.)
> >
> > Not so easily added later.
> > We cannot change the meaning from ignore to verify without any opt-in
> > later, but we could use the combination of
> > rw_mask |=3D X
> > ro_mask |=3D X
> >
> > to "verify" (set it as long as it is already set)
>
> Isn't this just "preserving"?
>

I donno I am confused let's keep this side discussion for another time.

> > all we need to do now is make sure that the API returns -EINVAL
> > for rw_mask & ro_mask on set.
>
> Yes, the current (v2) code does
>
> if (fa->has_masks && (rw_user_mask & ~old_ma->fsx_xflags_rw_mask))
>         return -EOPNOTSUPP;
>

This is not the check I was talking about
Use should not pass via the new API a flag on both ro_mask and rw_mask
This one is definitely EINVAL and not EOPNOTSUPP.
It is a basic contradiction of the API definition
it is not a specific flag that can be supported on this fs and not on the o=
ther.

> at the start of set_prepare(), I think that is enough, since we assume
> the filesystems return the masks such that rw_mask & ro_mask =3D=3D 0.
>

It needs to be in the vfs before calling the filesystem at all.
It is a UAPI definition.

> >>
> >> This allows userspace to not have to do a RMW cycle when using the
> >> file_[gs]etattr() syscalls, avoiding possible race conditions and
> >> simplifying their usage.
> >>
> >> Patch 2/3 also introduces the missing FS_XFLAG_PROJID flag so that
> >> programs like chattr can leverage the new mask API.
> >> FS_XFLAG_PROJID is kept out of the legacy FS_XFLAG_MASK and so it's
> >> defined as part of a new FS_FILE_ATTR_XFLAGS_MASK group of xflags that
> >> will be used moving forward for any new xflag (like the one proposed i=
n [2]).
> >>
> >> Patch 3/3 converts fs/ntfs to this new API, to show how it can benefit
> >> filesystem drivers too.
> >>
> >> The series has been tested across NTFS, ext4 (with project quotas), XF=
S
> >> (project quotas and extent size hints), and Btrfs.
> >>
> >
> > Judging from the number of bugs reported by Sashiko and by my agent
> > on the COMMON flags change,
> > I think this needs test coverage for the old APIs, especially with old =
binaries
> > chattt/xfs_io that do the get/set cycle and re-built binaries with new =
headers
> > both tested against old and new kernel.
> > Sorry, but the UAPI issues are fragile...
>
> Yeah, I thought about adding some tests to xfstests yesteday after I
> made my agent test the sashiko issues in my test vm, but I don't want to
> make it generate them and submit them with minimal oversight.
>
> It could still be worth to make it generate them to just test locally,
> then clean them up and submit them after the vfs design/code is
> finalized.
>

I think that selftest will be easier to check these backward compact
issues with a C program that can use its own re-definitions of the struct.
Then you can post it as part of the series which is much preferred for
visibility of the test coverage in the context of review.

> > This is one of the changes that would have been very hard to audit with=
out
> > the LLM agents. Hopefully with the agents it is doable, but need to gui=
de
> > them how to review/test for regressions.
>
> Yeah, the amount of edge cases it catches in my code is very high, I
> manually wrote the main vfs code in this patch series, but I took at
> least the same amount of time to fix *some* (considering the amount
> sashiko still reported anyway) of the bugs the robot pointed out.
>

My 2c: prompt the robot how can I make this easier for human reviewers
to verify - keeps it away from being too creative.

Thanks,
Amir.
