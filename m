Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795780980;
	b=h4D14ShCTBbkqeypVKyANBRzN7iC5yiAmaEbFUXOxHuT/hlhw60oyfnre90JyDQ/qWSM
	 8pNLTRb03KZ6zm9yyARwCRNJc1rWYhjZS0ZEk/Ivbj1+pT44wnfqEJ4CQ+TJe7aukUa84
	 5z1tf4j+XP9IcLeFBH23V5/PLV8dSIGr8Qn7PTfvj5q8Nb95brreFSVcAkM+fod4UTObG
	 glG8bHPD7uFMpMDWNMMpOr7OVCXyFKi//c+mz3i1c4FJ/g229u00wsueUAnJ6MbqgWeEp
	 ojCvxNEqTmzYg2Oh+TqDLAl3vGa7hS4a+9oR+v1HdR/Jpbr4rJX5tp1DyS1NZibnjJQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780980;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=sKBAqoHb6dKCB8lGd+jVvxodjbVVN2AMGRa9Yq/Mby4=;
	b=4duvnGZLi3bLUUasl4bPuUSfIYvxlis3Ugy/T2sRk2ERCOR5eJtHYELw0IZqC/G41QvO
	 /vZLjOX++yzLuz3TCcd4XOe3RY2LdG4P63q1KfzVX8ehkiBCoiXt7uvFWGJ6o1IzDgk/E
	 6pifO+bdEdhXfFw6oXddF+O4aHjbMCVZzsjCc5RmVsX+RD25JLexX2hQr/jGLBaSEsgrv
	 h9k9sNVD8ZSDlfOfTLXo3IqvHzO0hh/Vhzyk0hlex/2vwh46T1Mf9LuVc6nI45Y0y0MzK
	 TyXlknH0y504NOXjGpnv11tyliCK/rWJUwA6rx1lKVo6Ut3D3sDm/hvpY4clc6bgyfA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SnFA07cx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.171
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD61D606A31C
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 12:02:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD61D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SnFA07cx
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3ae25dcbd81so74695401fa.3
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 04:02:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795780978; cv=none;
        d=google.com; s=arc-20260327;
        b=Ik/s7gVIIF3K8J1lsoNTuuL6KqiOvOCA2m7TRn8kX1H4TDwFtyqvMpXm/tKmIyFrRZ
         MhrIaX05JcT5c9P3L1jGZOVvUiPlpikhgKS5jSpJhnO8r8BcJ7FnokIqLj0WUl8VXpqt
         UgAAXBv6U94zDakePxePXB8hqpxB0KKLBqGrTm10sslRqdJwaApNYX+BOI9W06268Bq0
         o2SYNw/UIt2fZPCcKm9Ttl/rc++KxYey/kxfomTl1GND+vhydKRvrJnUgqziaIDr11Bc
         LTGC61C6Wev+A7OszzNiqlZ3ov8pATdQoFVGJ9LFXLSDPyLC9RDkrAzv11X3I22ZvCj6
         Ft9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sKBAqoHb6dKCB8lGd+jVvxodjbVVN2AMGRa9Yq/Mby4=;
        fh=oWa3aEdChRq4qHtcpvwu/OeY2oX9FKWQRAHRFq1K+jM=;
        b=XgPQjea8GAF1X3kpdgE+/o2VpfWZkCp6/79t8dCta2xWEaiOxQWUMNXIkFsD4Begsf
         hdLXKmV15D50V4pTYjZlfywQFlIz2xpXn+DIoTpWp0ROGRPjfI2WsbiHNg5l+3pB3yFa
         cm8Y6TNLw4qHfGb3z5C8KzLeaJxp3A+LkwlB2YA3ubsQ6S7zROUeim4nFamw/+e6chDC
         zppfB46FW4/TP071nxvnDcFeg9bIfhxoScCoEhT6R6+O/akWpw600Z09eRjyakBO56U2
         oCDDbFGrSNMxc5xltgxLXAZONfCSP00uLwKK01qk0WLfsUAOIlkXK7krq8ovNPgthFRC
         0/TA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780978; x=1796385778; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sKBAqoHb6dKCB8lGd+jVvxodjbVVN2AMGRa9Yq/Mby4=;
        b=SnFA07cxVyuwSSQ2WlqVldYscrENhFj8PVisFe6EUr/u+zjaGcOlyf+NO4/VeKXXX7
         4E5nqOC+Z3I662UCySIHIiaMwrjJK+ZjK9X5FK/V848T+A65ClvPxk5bvJvrsV+MWdo/
         JIM89r7vSI7FFB67/tWpYnfwZs9/cVksgSfXEE4llKDhqleU1ZWfSy+N4AE/zsZMEKkf
         FXtLBubySwAUA91pvO8XAdbubi6E7QFc7BDt/+z27xlpQGmIW0sbpzCnfaiUYkOVUtJK
         S6zwuiZQCA+1rzhAC+jCChTTNWgaEmMmc18deOG2Q+9ze1ubEHLrjAXDP7U1S018fipI
         jn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780978; x=1796385778;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sKBAqoHb6dKCB8lGd+jVvxodjbVVN2AMGRa9Yq/Mby4=;
        b=s/uRm3CjsKnjonGoyEnhHcX+OiDvBYq+nVn5/x0NPyAEk7/ukrB6NZWm7nhb+LfrFS
         3X5sjcqyKI1v49XlFsFSohpv13EKPthjN7QiDkLGAkmvXumfxY4Ial1UBsHgravVd3e0
         AOTm6CAzr6eScLFbygM1FC79IQsKZ6qcA2GPQa/v4EDO116h+kXbKtcrSrlyn8P+Ewbf
         vCenXhd7/rXrgG2f4kGt7bHN0A4Zk4fIlq0tPM8f3/Ve/qohrzDveAflWkYYy41iGfgL
         cL296b2AcoE/1rFSCJwRo1LO5rV7My6Nz28Pc+7LRF+da4Mb80+apM0RQai9jfZqXS08
         EaFQ==
X-Forwarded-Encrypted: i=1; AL+hErH9y6EFICW9VujNgDlPXuTtsQQ92krZV+c00316ZEMeq9CtFYlI+8mK+5g4AoiE+JdYrJDKPTugPx8=@vger.kernel.org
X-Gm-Message-State: APuU4Z9E4fMlRrnyOqHYPuufGIkydWtZVgZjc6hVRN29sJbU6Xbxgpyw
	FlsM1wQi/srbH1HG7xW4nMzPHaq11+rHqfRLtNCI79huL0Jq9crNKDjTJLGMifw+c4FnS1voNin
	NFi428NYML7nXwsgNDvYqWnnVCivMf8Q=
X-Gm-Gg: AZFdTZfxRtQ+Jd2ODJcmLa4Wr2r+EwDXCKl3QBucnyOvgrNH+y7riiZMN/4PKjajR9i
	tx+5MnXMNQKfPhoklYkPhvRZKFqWxHMp+n7d8Jw5rtsyrgW4RV8KY3eR2Cdv3VrBZaC0d4kZ6rN
	pZfEuKDwgiQTT8YcybDs7KKBS6rHL3NVMO+/N75aCRovkq9k3uAe7raOX7WQ+aAgIhzma38fLIr
	WYsyYb+Ub8lZA8PyjrYTbOc1C33wqibDVxst2L4oP1u3JGl+Ydf1OHrncM6cFm/U9LCbs0lAetr
	i57Jl9VqAphk5mnH+dmdJ2MUpXVhgXWuAdNs3oOHg1exr/elheYhpBMT1cl/fKkxd93FHMx8SUt
	YM4ZGD+jV8DbvHxvL04GkiBN4U8Pz7u4MmqPfcIYFW3HTcAljk9JA+/yyjTHpZwYsbwrXkg==
X-Received: by 2002:a05:6512:1148:b0:5bc:cc46:1849 with SMTP id
 2adb3069b0e04-5c1bc874b3cmr6981033e87.54.1795780976912; Fri, 27 Nov 2026
 04:02:56 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126163114.403846-1-koray.fra@gmail.com> <20261126163114.403846-3-koray.fra@gmail.com>
 <CAOQ4uxjGLfuZMFABCwMvdXwnU+P24G_aTJLudWbjeSmWwyDF6Q@mail.gmail.com> <DN5YPR39J7QI.1S1LCFLNUCZNL@gmail.com>
In-Reply-To: <DN5YPR39J7QI.1S1LCFLNUCZNL@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 13:02:44 +0100
X-Gm-Features: Aa3M54ohq34732gC99y698hjwvA-0NF3EsaW7G0zij4KAugMs04c_-FFLASygdQ
Message-ID: <CAOQ4uxgzmB0dEpQCVGKOc8reJ6OFV=BxDMgRW81aKiCMwDSn_Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] fscrypt: update fscrypt_prepare_setflags() to use xflags
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	Alexander Aring <alex.aring@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2026 at 12:38=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>
> On Fri Nov 27, 2026 at 12:35 PM CET, Amir Goldstein wrote:
> > On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> Update fscrypt_prepare_setflags() to use FS_XFLAG_* xflags instead of
> >> legacy FS_*_FL flags.
> >>
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
> >>  fs/crypto/hooks.c       | 10 +++++-----
> >>  fs/file_attr.c          |  2 +-
> >>  include/linux/fscrypt.h |  6 +++---
> >>  3 files changed, 9 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
> >> index 149498bdab94..52d6a33fc9e9 100644
> >> --- a/fs/crypto/hooks.c
> >> +++ b/fs/crypto/hooks.c
> >> @@ -182,10 +182,10 @@ int __fscrypt_prepare_setattr(struct dentry *den=
try, struct iattr *attr)
> >>  EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
> >>
> >>  /**
> >> - * fscrypt_prepare_setflags() - prepare to change flags with FS_IOC_S=
ETFLAGS
> >> + * fscrypt_prepare_setflags() - prepare to change xflags
> >
> > prepare to change the file attributes with file_setattr() or one of
> > the legacy ioctls
>
> Ah yes.
>
> >>   * @inode: the inode on which flags are being changed
> >> - * @oldflags: the old flags
> >> - * @flags: the new flags
> >> + * @oldxflags: the old xflags
> >> + * @xflags: the new xflags
> >>   *
> >>   * The caller should be holding i_rwsem for write.
> >>   *
> >> @@ -193,7 +193,7 @@ EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
> >>   *        another error occurs.
> >>   */
> >>  int fscrypt_prepare_setflags(struct inode *inode,
> >> -                            unsigned int oldflags, unsigned int flags=
)
> >> +                            unsigned int oldxflags, unsigned int xfla=
gs)
> >
> > This here is a backporting landmine -
> >
> > Changing the semantics drastically without changing the helper name
> > or signature.
> >
> > Please rename the helper something like fscrypt_prepare_fileattr_set()
> > so that backporting mistakes will be caught at build time.
>
> Yes, though, would it maybe be better to just use xflags_to_flags() in
> the vfs patch instead of changing the fscrypt function at all?

Yes, much better. I agree.

Now looking at the /* initialize missing bits from old_ma */
hunk my reaction is to look away its huge and it should be
using helpers probably called from within fileattr_set_prepare()
itself - because if this is de-facto preparing for a set.

Thanks,
Amir.
