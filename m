Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795440928;
	b=P73FkVFViXsjY8w5PPesbzzhTB9VZjLKZZUo1EShqzMLN568BS3Y3WmWoD8cIjK8Ue5U
	 YoYVsXJq76e/cAXaT2EuDYhYjlGX4SfqQiiGNyfrkWWotZM3WMSJMlvv3P350EKgG8jON
	 EiyK/PMUpg8KiamCHVXxa8EARuz9dQYWL7bVl5lnoRRrGXvoJGPrSEwHihnuCGMGqk0fn
	 c0aWMmpTPSoeeSPDs4n0Ll+AAWrkKP05roAFHUbNQYd6/VFgx9+9C2Utr3XYnu6TMYcNZ
	 6MIrgUFZr0VPfRV3qBdPWyldzA4We0czEJXOweg4qFDGIyWmzn7S067cY5eo01Z1ppg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795440928;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=wA48BtGM3vO5100Jfaf4088EYVNimRYHtUBWITFpY8A=;
	b=RQ4E2dFEyjFRhM7m/ODNSQlsbuD1Kqq2EwwkGXodOFywQQZ2TIqMrKmD04Kx2Ym7XD9t
	 TDejFzzFGNay4mjQ2Li/5RC1I9h7/+Ftn+Cw26cBCFeKvCcR0unVn2B3cf69hsZrdcMK6
	 QdHIBQ3zCZIGJsKZjqw9Yq/JtbWCTaV4a/YM6Jx5Igb1nXcV6rKHLbKpgOYbRMjeeQkim
	 HpwP0UFfYsmpCMsNJ/xOuHiW7gThYj4f8L0WkKlIBV68/82zEjrS4UjP+eD3KXiVFwcOb
	 CyXIFPtkJ0YjLJqXlBQ78I1inb9OEu7QVLhADa1GTgOX+QaYbHYyvzV3zZYanik147Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CUalyFmo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F608606A32C
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 13:35:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F608606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CUalyFmo
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b87a92c17eso4577724a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 05:35:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795440927; cv=none;
        d=google.com; s=arc-20260327;
        b=NwyFNcMJTdb2VpCbEF+ie5/bRTnfOXuKsK+DXWM5mDtEgMvCCJIXwgA8gGMvmegXwR
         U4ahgHe07lR2YWLJTOXCZ23Bf3bffGKADsXSK3f3CntFGWapweHBHhyxyn9OjR577Y8M
         VumOqb2DVhgl2UlpBt3LomqIjpXkM8qVlEIUjg/hn/LZ9qRbCtaQKImaNN7F093ahp5/
         SUVv3gEN5YXQfkLEWdEM0YqobgAi9c7+5PohqSR60v4oBHKQV9jYbFKvzJhkWNg9X+OV
         ULU+9emNmmJy7bewOGYfwCHHlfTxDx7vcZ7JGDKFZ/V0gE0q54CPZPjHO9aI2GBk674s
         EotQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wA48BtGM3vO5100Jfaf4088EYVNimRYHtUBWITFpY8A=;
        fh=P41ie3xVaiSzp0Jdl8OLMKlrqUswvj8R1E14zcK02J4=;
        b=E7Bc0elJHaSCf9IIfoB0hYko2YX5KmkyCqg2bg6ETElw1Guom9/N7L3/sZYebLNBvp
         nl9gYlGEuCc3fjmYMY5rULYOtPYyXOVDKv47HkKBURF/FqaN/u4C0f6grOlLF0wLazAE
         +L7/n4zh6IyAF/AzdH1umcxZVS4d3x9li7cdX2ydAlFtaweP5FxOmXTmjImxMKMss2VB
         Hiupg6KU8NkiYt/H5aYxOXXhZYB56xcUs6SMXF84O0EKArLo85yT8MUajnIL/GXDVRVI
         hBnqEMopIZ4qxCA8ve+1RsdbKL6TYRx7XznCiHIlPUUIKxRwv+RmjUgKpNGQpeWXrDQm
         NsYg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795440927; x=1796045727; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wA48BtGM3vO5100Jfaf4088EYVNimRYHtUBWITFpY8A=;
        b=CUalyFmoReb/83xqvr2Uap9kVXJPiulZAZ9BuYFqHt3BZvwosq+NJSvwCx7EXaJ61q
         0UImgM/pK6aJnaecMJUvuPZ2cI7g4pQe50qM9Pea8hpjQVdlAcsrhBAjR5pkLoL6krP6
         nRENxUXoYZaxAwVNugh+MZ7YZxx2ccbHZqMsfjTLAWxmMDno9W5bQVXg6ZykzS6zofee
         MuNz4LKoADJSq/Wy8NqZgyRU3Eg71INdz3RDm6YrbcXLD3QD36tPN1Wy8wpv41odHg+C
         B4L+HLWFbiG+tetJRVhqx1bMgUVGiUgvZsZjbnHTLfWPYdIp22KPI7gyBEnpYFSEFiNv
         Y33w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795440927; x=1796045727;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wA48BtGM3vO5100Jfaf4088EYVNimRYHtUBWITFpY8A=;
        b=LPV/ldx8j7sok6brEk3+9rFrW3juzk3R9uZ+dFFhVhKMDFCduaPPrIPAXoB9+NLQWm
         /909REjmjNUCTajIOF1HSYPSlaV9tqvav6xpu/WePss6QqRLD/q4Z1CvEJsG/vA18hVK
         prrzJ9T3v4UqetUzPNJ6lUlQzI/6XVfv4UVjwHxJgg98rgtqgpQVucrpwGvEn1iavV4B
         lF1do0QVMKXClFsGk5ZLkr9m+oC3USxkjSDvx2RCr9u6p+V5QIHSyxLk6UZbEFlpDBzq
         oYYcqNA34yhm884TmMCqfDwQBrijsFDCJkGLkK2+rAkgDPNU1Q5rNOPG17W177z9L2r/
         4bKA==
X-Forwarded-Encrypted: i=1; AL+hErFef3mjjSJR1hj6xwQl4rx8JensN8gyS9JrekdakDHfwVcWa+eXkaRn0eWgz2kJW+0feFWY/U8RkwE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/cquj2uhKQNcSlsyDUHX3Uxp19CebJNLzP0Mv/9Ywiygs9lArg
	8WAMt8p/wX3XhkLuv19OPzu+Ub8u/8Na4UzZN3bQp5czLjCUWtpaqzVlE4QkXSTrNZO/pTLVuxK
	5k7UZV62PjCG1UnChQFF0k01fYR1fLDA=
X-Gm-Gg: AZFdTZe12L6KxwpDTMSu+/J+DMaJmGkIESN/8qt909YRUlthhMVI8CgMiGEI9XgEVaF
	ihsqMAZRk/xzNyysQTJue5Y5pqTDumY6FpyHNXl/kU7XGiD4Xr8DW3v1THXS4hoS9DH1m8oxF9R
	4tpCJGrZTtzzA4M3UCAUQCGzDkOwrTxgk2btgYsT1nx0Y6fvBbWUkLRZMXKzjr2WuDkV+I0Lz7T
	eeoEkPgW5ZHyAq5qYT/3N2RFdsUS+yO3/RN7Q8w73/xLfGUb/oM9Pf320lcgbNNs1mI8bWVUhx9
	+4tKhkmr3kjKTriPcsQ5RS5+7ebCqLTBSvud53usLH0VTyAb/9o3QRugCsIyg4nSvVxo0Ylri7u
	4r6tqCcnvgXVVn0YXccRzBWHqIh8IkfIPJQ6hnS6v+rZiGPkVZ/ZT4c6K5WOMUD8K+7KMcQ==
X-Received: by 2002:a05:6402:1ed4:b0:6ba:7e42:d88b with SMTP id
 4fb4d7f45d1cf-6ba7e42da5dmr4190054a12.12.1795440926543; Mon, 23 Nov 2026
 05:35:26 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com>
In-Reply-To: <20261122000856.536902-1-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 14:35:15 +0100
X-Gm-Features: Aa3M54oltothA2ZyBgLZ2dfkBmCeGTagh_PAD6Wp2_FkqMP-qy6jOW6gmvjqNlE
Message-ID: <CAOQ4uxgf2KE=Ag13EPAu5=KnrFwt7zRH=im-qmLc8+i10Tjd+Q@mail.gmail.com>
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

On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> This is a follow up patch series stemmed from [1] and [2], splitting the
> _mask change for the fileattr API into its own separate patch.
>
> The first patch is a preparatory patch so that the code in the patch
> after can be formatted better.
>
> The second patch is the actual implementation, which introduces:
> - fa_xflags_{rw,ro}_mask fields to struct file_attr
> - fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct file_ka=
ttr
>
> These masks have the following semantics:
> - rw_mask:
>   * for filesystems: advertise which xflags they support changing
>   * for userspace: specify which xflags it wants to modify
> - ro_mask:
>   * for filesystems: advertise which xflags they support only reading
>   * for userspace: ignored

Nice!
I think this API description is very clear and coherent

>
> (ro_mask for userspace was also proposed as a "verification mask"[3] but
> I left out that semantic to keep this patch series more contained, and
> can be added later if needed.)

Not so easily added later.
We cannot change the meaning from ignore to verify without any opt-in
later, but we could use the combination of
rw_mask |=3D X
ro_mask |=3D X

to "verify" (set it as long as it is already set)
all we need to do now is make sure that the API returns -EINVAL
for rw_mask & ro_mask on set.

>
> This allows userspace to not have to do a RMW cycle when using the
> file_[gs]etattr() syscalls, avoiding possible race conditions and
> simplifying their usage.
>
> Patch 2/3 also introduces the missing FS_XFLAG_PROJID flag so that
> programs like chattr can leverage the new mask API.
> FS_XFLAG_PROJID is kept out of the legacy FS_XFLAG_MASK and so it's
> defined as part of a new FS_FILE_ATTR_XFLAGS_MASK group of xflags that
> will be used moving forward for any new xflag (like the one proposed in [=
2]).
>
> Patch 3/3 converts fs/ntfs to this new API, to show how it can benefit
> filesystem drivers too.
>
> The series has been tested across NTFS, ext4 (with project quotas), XFS
> (project quotas and extent size hints), and Btrfs.
>

Judging from the number of bugs reported by Sashiko and by my agent
on the COMMON flags change,
I think this needs test coverage for the old APIs, especially with old bina=
ries
chattt/xfs_io that do the get/set cycle and re-built binaries with new head=
ers
both tested against old and new kernel.
Sorry, but the UAPI issues are fragile...

This is one of the changes that would have been very hard to audit without
the LLM agents. Hopefully with the agents it is doable, but need to guide
them how to review/test for regressions.

Thanks,
Amir.
