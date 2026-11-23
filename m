Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795447799;
	b=utdHBaVKpBCIYoTy+wP8Vh7t2hm9jtlRw3qAU4/kBYmC0MAagahRF8jmmSWrkSrSeZR2
	 8EvFS+j3LOCZw7DMpN6MWzkYFz5ZxPfbW78tILegsNOiRpb0VDnwmosc9H10//F0DuFDF
	 tU4w0HLaxaJcbV8Pn2SDl+DMAWoceOh+cA6W66RKheF0AsqXMtjzxoOO9z81Z1W98Pspn
	 XHB+mZc7VHt9M+341th9pQBa/5IGSnspjkRkJ149A6lWQbyQhq24Ot3NCwpjuMANz1xgz
	 YVdF4KF/9XXlOowNwIeNxedBUDUw0NbAA5tkwnEa8TBrKE2Ik3GvGLj5dTg26mMFTwQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447799;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=XTqD3jTsvce7PV4dxiBL4DNg4qThdQn7thVX1pxBbRQ=;
	b=CPfozc+qsjpziKBHI+WtdbLKqW/CaOw+l9T/IHEFIcn7xC/yBzLElDwjFg5ExUtcEyjO
	 KKMusT/SPBUt5tlNUDmW9kworww6pbsTTC2gHHf44Zq92XiCJroLgkpMDnu2+n3EVagMa
	 c4oaATU/x114V/GqVmAtKvM6arVOkI8u9Sx3XmJ9usWV45K6RtVLwLreJ079asHLc5KfB
	 SqTx2LYe9dhC1GnbOqjOnWakicjODgUiNnMtbJx5XRyc7IiWs45Oh5t8l0RRgUOFVX6Ob
	 6D16zoU4vGH49SRR4UPoEl6sbeCx8z6NuRgDyL2H4JXpGHnYiw9775WVSiPYR4AkX7w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U3UavhO0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B40606A31A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 15:29:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45B40606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U3UavhO0
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6ba380cd8dbso4439280a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 07:29:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795447797; cv=none;
        d=google.com; s=arc-20260327;
        b=VihaV03YOT8ovl4WGIc8mPDHW666HUCuUDlLz+I0ps41MDS4eCw0BZLBdqo95R0tkG
         moVzwD7v1mkZRwo93dxipHrXQ3XRGfNVBiBpy1+3gX2/l1JgXx4f+Up5u/BHNST/wVrb
         usHbxUC3vFpTu9sNJSR8OP+WL2KJw646TD+urk+cMh9f2pwVbaLtsRSCLyv2P56WFMWk
         4ZJaMzRJ0E7DXvaiymTWb7aF09bmQBOBUE7zRmJuYs2bi8hk3MV5DbhlBeO0RCrUiDOb
         pZTLPPeyIXYoDxVByrQGyUi0bAWI+dGGk72ZynG59lNrxy53Tgw3JpvFQnZ3MPTgFXSW
         yuLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XTqD3jTsvce7PV4dxiBL4DNg4qThdQn7thVX1pxBbRQ=;
        fh=XMywfMRbf9tXONaWd4+yAiZrwQ9fvsjhBCrm8v++Mo4=;
        b=fFdXXM5dnAlUDS4I3XzRN7LhhkY82u5aeQqZM3Y5iHJ62dHA+NvpRJqtqjOvSD4xvM
         XJNTDAQbkCWVEVYn83DCtP87DM7s7BEAs1cbj4b7CHCTN4PXrIWfmPDqLIhTjubEinwy
         yN5ilE/UNhR7EtoZyoiVM4W3bQNkjYP9YpVwinaqDJyd7CdiRFRv3PjFQPNPhE0n0qk+
         01knSiw4GgyJIbifIij+EJFs2iCkguQcLybxwKmZx3L29oYeU+hjUKgrgJs93dfLrWVM
         eX7QKrk+FFRvuZIFDziZQGVkbYJASoqDKU+KBjeOLcOUSfp3NQpksM/cMOWQPP62Dc19
         Zm+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795447797; x=1796052597; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XTqD3jTsvce7PV4dxiBL4DNg4qThdQn7thVX1pxBbRQ=;
        b=U3UavhO0vHfet44jf/aYXoS79W6o76/gvGmauPo8EJm4ak5yEu10LKFJc+bYM6DlNU
         dCfYYbZo4XhCpeXp62rA0WhWPdxwGSBPkk4yinisKQ/3HfliRazobfQ9a7wzP5P/SNIj
         eY6Fkypy+Iu144S/pfklmW+0egIWItbVB08gm8qw5tnR8zDbFxxrzY0hnU6BZ3IwGmbE
         LsikLplsus57/TtIIXYJNnBuJ+PJ0Bp+wTkqaQckcSlNsFqJe0wHdq3V547JgL9TtAhO
         QOlSChEk/jL5J2GuElsY4mHz8m3/NfdWUNuOhXFy5X6AjFyJdiPpdHYlxE7EGBx26kpc
         vI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795447797; x=1796052597;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XTqD3jTsvce7PV4dxiBL4DNg4qThdQn7thVX1pxBbRQ=;
        b=J8L40V/7HVCRrZJAj9HkKEBg505snJmGmujr2dqnxXleIIBmcTHuatvzFbUx/4strF
         ih09R3EBR94GZln9yCr5/Dqx+l5QUXndtSo9ZSinS0y5p246Le+jiywj5FxFE1TyhP8v
         moH0MZe4oK7YrUs6EXz4sVBJaSMKusL8JxN+18DF+ShjhIkFwoYFTMVdrtQXBWqx/YdM
         8y3nQqJkq1IiFCeATqhYuinJDsdF4x3q2GnVSc3g1tv3mOHYTmqOJhvi3W6+O+hLc1iV
         Hi840eZtMSUfaSfVTalNBJvLntQz3bIE8rNV59kMFfYl/JiQQfp6mVeMwk+febO5xm9N
         AdHw==
X-Forwarded-Encrypted: i=1; AL+hErHcNPPBPBOeHsPkAK4W6vwOhVS4MVni7yBaPUpwP29v62zyg9mjXV2EJ35UKnV12Sa16JTQn63PREk=@vger.kernel.org
X-Gm-Message-State: APuU4Z9CxAq7rquhUFj3J+8e/1WFUS4wrWh0lUO7oUywWT1iC0IwRD8o
	VDI5qt/GM/zQcaHdr6KIXTbTiUy0L8r0wNsOwHxD9YoJw7Lkg6akBWVeAJMEX5ubawiNyTeU1H/
	KJTB4U9gYaeKKlPMuWWWUw24HtTrEOF4=
X-Gm-Gg: AZFdTZdqzL2vfg4ydVg8A1VAuib4tyyXTqyZ/d3DrZNutLhi8iWAXXs+7KVzEog4xqz
	7hTH/ba3Gprs4ZoKbjQ4QwTVIx3Kb2/50Osy2zTVIKsq5DSTYslTH0cCiHi6Bc2vGogwHSnUnDA
	a9rSUyThUUxDQVzyH3AORQC1hLH5QXIs693ycJPjOTGxIgFM76fldr9K3A3Znsxw93sf6ccOiE9
	rTpup0VTFhGAXGlMD+ITTrVSByYD/o8ijCCJM7s07gczeWYZjkxH/qKK4oIGf5TA7umtLlE4ExF
	NrUYCEcCFQUOd1Rpf9eVm7dHwHqNFA+vcmoR72sbo1M9E3E1S6lqcZM/QI3IlA3cBVsVfvbigEI
	q5pXD3PHfkvvLA1Xa92wxcge1izOE39+XZDxM+1OsKilWP2scGtfi5swiMafDRzZlS47sSA==
X-Received: by 2002:a05:6402:e05:b0:6b4:9919:b54 with SMTP id
 4fb4d7f45d1cf-6ba37f04a34mr8166206a12.42.1795447796335; Mon, 23 Nov 2026
 07:29:56 -0800 (PST)
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
 <CAOQ4uxhegn1z=41_MHL1Zu2hXuPtzNhC=x4gd371oaeJE4-weQ@mail.gmail.com> <DN2N6A68PBO1.2QT8ZOARF4I6L@gmail.com>
In-Reply-To: <DN2N6A68PBO1.2QT8ZOARF4I6L@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 16:29:44 +0100
X-Gm-Features: Aa3M54rXlfF1ti3csfwg-SOdn_z3DGpZ_P359TQjfteI3PWichkZOxWgdTC23l0
Message-ID: <CAOQ4uxhDQqEQ3T9NveBFpUmSU032BxrNV5D+_zHj8u9LOQY+qg@mail.gmail.com>
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

On Mon, Nov 23, 2026 at 2:58=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 23, 2026 at 2:24 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> Add fa_xflags_rw_mask and fa_xflags_ro_mask to struct file_attr and
> >> equivalent masks to struct file_kattr.
> >>
> >> Also add has_masks selector to struct file_kattr so we can know when a
> >> user of this API (userspace or filesystem) supports them.
> >>
> >> This lets filesystems advertise their support for specific xflags, lik=
e
> >> statx.stx_attributes_mask does, and userspace can specify only which
> >> xflags it wants to change without needing a RMW cycle:
> >> - on GET: each filesystem that wants to support this new API fills the
> >>   masks according to its supported and read-only xflags, then:
> >>   * for boolean xflags: it fills fsx_xflags with the current on-disk v=
alue
> >>   * for value xflags: it sets the xflag bit to 1 in fsx_xflags and the
> >>     xflag value in the struct field;
> >> - on SET: userspace fills the rw_mask with the bits of the xflags it
> >>   wants to change, then:
> >>   * for boolean xflags: it provides the xflag value as a bit in fa_xfl=
ags
> >>   * for value xflags: it sets the xflag bit to 1 in fa_xflags and then
> >>     provides the value in the struct field; if the xflag bit is set to=
 0
> >>     instead, this informs the kernel to unset/clear that value.
> >>
> >> Since fa_xflags_rw_mask means "I want to change the xflags specified i=
n
> >> here", if userspace specifies fa_xflags_rw_mask =3D 0, only check for
> >> permissions and fileattr support without checking any xflags.
> >>
> >> Behaviour of older programs that already use file_[gs]etattr() is
> >> preserved by checking against FILE_ATTR_SIZE_VER*.
> >>
> >> Also add the missing FS_XFLAG_PROJID xflag, to allow userspace to set
> >> the projid using file_[gs]etattr() by leveraging the new masks.
> >>
> >> Finally, in order to prevent the legacy FS_IOC_FSSETXATTR from accepti=
ng
> >> FS_XFLAG_PROJID, add a FS_FILE_ATTR_XFLAGS_MASK to support new xflags
> >> and use it to validate/clamp both the _xflags fields and the masks.
> >>
> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
...
> >>         err =3D fileattr_set_prepare(inode, &old_ma, fa);
> >> @@ -424,6 +504,14 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const cha=
r __user *, filename,
> >>                 return error;
> >>
> >>         fileattr_to_file_attr(&fa, &fattr);
> >> +       /*
> >> +        * Remove xflags added in or after VER1 so userspace programs =
compiled
> >> +        * against VER0 don't try to write xflags they don't know abou=
t (since
> >> +        * they do RMW).
> >> +        */
> >> +       if (usize < FILE_ATTR_SIZE_VER1)
> >> +               fattr.fa_xflags &=3D FS_XFLAGS_MASK;
> >> +
> >
> > This looks odd.
> > old struct size with new flags should be -EINVAL not silently drop them
>
> Right, and the GET path should strip any new flags, so old programs
> doing RMW will never see them, correct?
>

Yes, I think so.

> >
> >>         error =3D copy_struct_to_user(ufattr, usize, &fattr,
> >>                                     sizeof(struct file_attr), NULL);
> >>
> >> @@ -460,10 +548,6 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const cha=
r __user *, filename,
> >>         if (error)
> >>                 return error;
> >>
> >> -       error =3D file_attr_to_fileattr(&fattr, &fa);
> >> -       if (error)
> >> -               return error;
> >> -
> >>         CLASS(filename_maybe_null, name)(filename, at_flags);
> >>         if (!name && dfd >=3D 0) {
> >>                 CLASS(fd, f)(dfd);
> >> @@ -479,6 +563,30 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const cha=
r __user *, filename,
> >>                         return error;
> >>         }
> >>
> >> +       /*
> >> +        * Userspace said "I don't want to change any flag", so be it =
I guess.
> >> +        * Still check for fileattr support and permissions, also in c=
ase this
> >> +        * is just a probe.
> >> +        */
> >> +       if (usize >=3D FILE_ATTR_SIZE_VER1 && fattr.fa_xflags_rw_mask =
=3D=3D 0) {
> >> +               struct inode *inode =3D d_inode(filepath.dentry);
> >
> >
> > No No this is not what this userspace said!
> >
> > This user space is the same old chattr programs recompiled with a new
> > fs.h header file
> > installed.
>
> Oh, right, I did not think about this case, I hope it doesn't break too
> much of the new code I changed already for v2 :(
>
> > When userspace does not set anything is masks it means "old API"
>
> And so a modern program using masks that passes rw_mask as 0 should be
> also interpreted as "old API", even if it kinda goes against the
> definition of rw_mask right?

Yes, but it is not a problem to describe this backward compat exception:
When (rw_mask | ro_mask) =3D=3D 0, it means "no mask" "set everything"
but then vfs will not accept new xflags that were not supported in v0
syscall.

> And other than VER there is no way to know if it's a SETFLAGS compiled
> against modern fs.h or fileattr VER1 explicitly setting rw_mask to 0,
> right?
>

SETFLAGS with explicit 0 rw_mask is not useful and does not make
sense, so there is no reason to support this in any other meaning than
legacy programs.

Thanks,
Amir.
