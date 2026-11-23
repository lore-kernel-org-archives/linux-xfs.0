Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795474038;
	b=rNIQo1MWahjBc2i/lOG3AUbmFHGRQWY/eVldAL9/aOui1lPGTQjaq7gs0KRW/O5KbcGW
	 J7yVH3X+QFdipO+JnbON6UvsdanMFJY6cNf+AjwhPtx3DYfV0cNqEfHJOdZlBXYJu3f61
	 kS3r/Jww986DZcba1bbH1aqgWg1c2Qxt5XYbm9M8c+tV7l9YXc5p4n/mrXy/h4fPDgsi7
	 nv+KXRCBHZWY0i7rOEbqI9xo5Mj6MgCcblX9bE+ftov5cuMkZYIA0zAZRKpb5uSYGBNdG
	 Qgn0a/GLLFoTty39Kihlk5u2bqLGd0K1rrBF0nohB/E93Q9gntJcIQ9/LmH9zgSeFnQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795474038;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=prDmnot/bOxVS2gCc8v9HfYcjzpcvwnB8HRgvfXYsr0=;
	b=nArs6b4vRtDP2ahwAAsovQk2U9pX/YxfxnMcHBEJ46cRPWYGBE0RIDdcEwgtbr7U5lqO
	 MFsv21YpUa25ScitofX8c4LAhtU1eT+JeIknoso42vxBDsxAuFutM+BRiT/H+eJWXizd4
	 kGSLdrTHQvTc205b1KRHQagRYfOaES9/ie2US38DTaQXxqenSKV2NZCyH632R35NGwojG
	 JaZcNAEaItPb1r8b2vUW/ejyZ0cGjqOoeDI/Mlar51J8zlE6/fDcEmQctVnADsEhrzA8z
	 2kpL7HwKc/BjZvqW7H445r5GSVyiBwYGsT7hgfsjsN4BPvQ5R3SzlyrbqKG8V9pcPPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e9TlTdXc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0F3606A321
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 22:47:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE0F3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e9TlTdXc
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b8627e0eb2so5036444a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 14:47:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795474036; cv=none;
        d=google.com; s=arc-20260327;
        b=DZqatAlEBDMHkdbe8Q+qUv0QWeVnQ+/sdn7Gw7gsa13JMHJ/fb6tSe86V1gDnt85ls
         gH38Lp9w16jbIBz+HVuwoHp008bF9KmKYitOd6+F0MAbmNhPJAZBVi8QbffQyPef5Akz
         uHLZ5QXiWUhuao4cahAiKlYtzeLPq4UvgTlTb/99IzXvztAJNM3znjmBgGRh1gkenFn6
         9N4CL3dxCa3NoPdcK8Xv9KHInQgKeVCnk8oAy1w5XkWBzIAmnoqXKnbsvEJUsDelzgtN
         4kxI4wBEX9vgIinU/lvy3JIl+j/A+3WOA7g8HZVwreD59yQJmCx4W0NMs4Tly+xqjfvc
         Bevg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=prDmnot/bOxVS2gCc8v9HfYcjzpcvwnB8HRgvfXYsr0=;
        fh=dqPSZ3+r3aBw98fmgJf32QgNsvvSDrEz79TojwqGB7U=;
        b=rFeIdG12KtPVVEL1B+IP/zwX07V5OQxC3SPb14a9Kt9Y2x5VYqnnB16Sdo+uDxQ0Tk
         VDyISLYHJgTaMmhJe0hcTofhZs1SpU+6vcIDLtVYL4hKxMMSammLgddo9mpVzlTiY493
         NrIpHpm9vZaPC/NGmaxm4x8LyUq8E66Ohb5ZaCZJP65pPdQ/Q4V9+c2zk7m5VDHbpjge
         JSN6bSk5GbqQ1DTHODuZg6blWZKUO4NWARgy3q0v+cPvcjaSYZyVMbpAO/gpa5M/zj5G
         Ze2UaYtyOeAXdAbePYpHlYy/k6Af1wI2TOQqyk0DWZs0gofv+z9wFArv3jAOUX2QJB7o
         BnTg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795474036; x=1796078836; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=prDmnot/bOxVS2gCc8v9HfYcjzpcvwnB8HRgvfXYsr0=;
        b=e9TlTdXc+gatXcuCFKKb7aj/RyvKZZs3Fc22DsvCbrqYMGGtwci3FfIjibOfYQ/CZW
         9N8fj6eIrKNnVRdbxmnkFIx1GgLKrWEmFGL9vOQOEa0GR8Bc8q6jIgpflc/R1WmaKkIq
         a1L/XNzQgQR2OfVdP5ZWakzu06AC21i4FBAOG3jwYP8Lhy9AUkzJO9T8iBSrC7rM4aSU
         +QCy52SpD8tCCzGsrVoCDffQdo0iiSxV39ldqNaCG7VxnqiWEDVWhmyRn5+Uk0DxMQhg
         +jgf5l52Pyk6Ega5GmFX/ULCv5YHSq3eiAljutksNIdRm4c/i9EcMfRht5xGucVDbs5/
         qj8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795474036; x=1796078836;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=prDmnot/bOxVS2gCc8v9HfYcjzpcvwnB8HRgvfXYsr0=;
        b=wymbZDYWv6OMushPjzbQ9/3MS60y7ix+s9QqpPUN+QDVG1vrfdPNEcBnSMXgOA3UY0
         Hx/8goitodGYn/QOXSnoXrd/XAa/rP6C/EB2wNZkM23sKkXbXqUskkE94ofTL78xxtPf
         beHxvM4MkFSdaQyqGTnpxZ+bRz7Yk6AUHQWL77nY3e5El+KasLSv2FTsYqPPxiXSdZi9
         MCgJwT4AVg2MXHsiR1FxTPw8ISqaHDry/z8mHkTJeB0So/wXUGaokHy4wWu4lBHB5ngq
         vx6UiJCOYxFPAphuDAHIrfSWMCRyujwSwl5j3BdqBFDy4CJmWRrmO4/OVkZRlEwcgs//
         e+XA==
X-Forwarded-Encrypted: i=1; AL+hErFXEqR/Y7RvOsoJWXbFjQeqv2ZYly+H3xyNPxuNTfoKYdvaYIm3vgZEoUug1rCRmZra1EeghcynSqk=@vger.kernel.org
X-Gm-Message-State: APuU4Z9fv9d/sbmYhYHqlYT2rUmC8nAZrkFI2hZSaENDXfvtZ0Fnc7uA
	jTYX8O0XEe48MTR8XPFOrLnSlzUWbs718BvAMorXAUDWZG2kGZ557OUMo6PO/ouVIVsTmQUlp2t
	yx5/tfoySGfeKGCRvCifvqplLgqEdnpI5bZPL
X-Gm-Gg: AZFdTZc0qdJG3B192cj0qM4edwxF2O2VKOway5F0wDuklqRIOLtS8y/7eNwqVzGKROG
	A267KejVWgXy2yM5rV+TjAZArNQ42zrFMQMol11sbnwr6djFqM1fZ+pyqeQbtgzhHLiRT6NJIkG
	NfnPwjNuRSjz4yih6x/rJtsIQl5EbEzBeWFQmEt4trADPZFC0PsY7yjuu0fiz27PxwZ2byetGgT
	/aLZehG+hao4qWCZ+u1EueSf5cIi7zX/peMPcezYlGX4qb/shVU2aVKZ0Q8thoNRzD9lI1U05FM
	DhYjvyNWl1HWjTaa/OOu9Ag/pLONCGv2cfHLCV0xY/DhfWEufJGYukmIKjVxQQfdI0+QcUg34rm
	naHSaF4d3vFd9d9zWfURHye8QjXm6HKh5ySI8fqi5D5c6p9E5Sfm4b+xgYbdSgflauBU/zg==
X-Received: by 2002:aa7:c710:0:b0:6b8:e848:d004 with SMTP id
 4fb4d7f45d1cf-6ba37e8dec5mr6855932a12.29.1795474036043; Mon, 23 Nov 2026
 14:47:16 -0800 (PST)
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
 <DN2X3RC5JUFQ.2LNGLQOUX4ZPF@gmail.com>
In-Reply-To: <DN2X3RC5JUFQ.2LNGLQOUX4ZPF@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 23:47:04 +0100
X-Gm-Features: Aa3M54pZr_aGN97hdgjJEJclpmHDWTbmXWMujrk4s8rCr1BMot2r_DEgpbuT4T0
Message-ID: <CAOQ4uxhsv_1EEqAZ3Ebp5Uy8Q6nvEnE3EAomJjjQO86nTcW0cg@mail.gmail.com>
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

On Mon, Nov 23, 2026 at 10:45=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
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
> By the way, should I use this description in the commit message (and

You could use that as a short TLDR intro

> integrate it with missing information before/after the bullet points),
> or should I keep the current one?
>
> (current one:)
> > This lets filesystems advertise their support for specific xflags, like
> > statx.stx_attributes_mask does, and userspace can specify only which
> > xflags it wants to change without needing a RMW cycle:
> > - on GET: each filesystem that wants to support this new API fills the
> >   masks according to its supported and read-only xflags, then:
> >   * for boolean xflags: it fills fsx_xflags with the current on-disk va=
lue
> >   * for value xflags: it sets the xflag bit to 1 in fsx_xflags and the
> >     xflag value in the struct field;
> > - on SET: userspace fills the rw_mask with the bits of the xflags it
> >   wants to change, then:
> >   * for boolean xflags: it provides the xflag value as a bit in fa_xfla=
gs
> >   * for value xflags: it sets the xflag bit to 1 in fa_xflags and then
> >     provides the value in the struct field; if the xflag bit is set to =
0
> >     instead, this informs the kernel to unset/clear that value.

You can keep it also but tbh UAPI documentation is more useful in
comments and in Documentation than in commit messages.

Thanks,
Amir.
