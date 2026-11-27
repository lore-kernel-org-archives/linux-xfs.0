Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795779356;
	b=idCQygScahCHYnvJ9ylZQh4wGL7qKXGgcorVfmmMbENz8sdwpdmqk+UBRzIX+lTdJ7EC
	 Inum/NLe22Cg9ueSiq3EPDgpPb2xXYcXNHFDx8yTzan5+Am47w0xV+g1xkOmVSREuGpSa
	 PNjTCfS7diCRYpyFCHbXeE5QMqcNbcNjJmT2dKdu9Dr3/kZXghIeAEG++INyv3LrW4Xrf
	 hbQrEbOkqNj9zMAIkXblJFWZpT0h4jfcl4qn/HAE3BVH5bDhKEzR3/7a5H6q5ho5QCger
	 /8D2z0MUNYXr+AA6VX+lhq4y66OBil0f8blg2pYxsfSgaUIdIvOCPjM025xnz5MQHrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795779356;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zckLxKTSVIvkUKQrRBT4ZQPN8xSZzGvjPSGz1nKrgeM=;
	b=svvGcSUWrnJYSErbfDicQ35rOQQp2NdbsZFfJl3MljwMa+A8pioQfReBQzGGKweb0ueN
	 Vgmpago+H0PEKOkIw9apmM96XA6sGFCxtdCyn3433recSPT32bphyYtqGYkoSUKUfhPdu
	 L++0rLuQHFXws1Co7XL+MWJtrcB0Xj8Eb1IoViyBb7j2eRkKcYn6/PheKRY5vMnejKxwH
	 u72ExN6qqxoKuXvanRbkF4h7BgdZVI/W5r/HCjWkqXsEi2jZ2mrWuZN3zJOUI2yeJxSB8
	 DZxJ8FnWJWG+/coj2pMP/O3cef6qB2Dk9VAWu9C53MH5ztPYpsSJBuOaIXvpMKXlOBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vfl6nsas;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AF3606A31F
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 11:35:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06AF3606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vfl6nsas
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6bb06dc1fffso5586643a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 03:35:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795779353; cv=none;
        d=google.com; s=arc-20260327;
        b=kujNXxdmJTkW3vrclKlG9LOhZq1hKuPuhHdIdwl/9Qw4G8VH/pYrt+DkkkJ2qeZ7Bv
         ABpdui2f45ES9ejsDP6Ro5WKp8x+hE0qGAvQcEA4jC+0KaI3kKTQfT6j9Lt2vdSnAozz
         DkGWSXRSy/uP4v25GSOgKXleuvfop1CyQ/R1GAYKEwN4pIbgxUy1LweEEIk53Wj6du6i
         /dWAsXbCob8M1Jet6bG8KZNQniJNh+JzX+wt9fElF6iKPgeiNqyqioz2QYuFibUQ7XjP
         aDQlwg0t/K6qGzzYj7GW3FluZlV3n3+8hNHwgD27f4/BXjjG9ga4r5URZdMvxZPZhEUT
         jP1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zckLxKTSVIvkUKQrRBT4ZQPN8xSZzGvjPSGz1nKrgeM=;
        fh=xK+cVFTOXKtwJEeBzyC65uF2Eoh0qNbP4KskFJw5rlU=;
        b=DOOHOmHUJvQrvDT3U7WE5LHWJbDcKVvGNZuOLpYDmIKqGOcmTZKodoT4ZXJM9nBQ7e
         A9AzAIeMTzk9oVu516QqmmBUwkZrDKRFEpAqCsX54+zgQRXjlRZtGY4QtuQ/gLv4epM0
         eeHtKWmzdA+4vKXNBlq63h+zNqkx+KXC/NFn/8d5CdaPFq19ETf1tiIq/193Wuojzth/
         Hr9agMP5BWVjYa6nMEP5hsaIClLSjgcPetiOCHPyfyv2HUUSaI1lnLsH9tMpVlkj7wdN
         R11t85FTiT0SJ4t3Kp15entnZKn8/K9jQTvSQYCm5c8zYHJM/e1hFKrnZYkWktEwEM7q
         VeZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795779353; x=1796384153; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zckLxKTSVIvkUKQrRBT4ZQPN8xSZzGvjPSGz1nKrgeM=;
        b=vfl6nsasnL9MeKJC3PKlnSrIcRDT85xssIPtgR+brRFXXZVzFiEq6BssOPBNi+U1NX
         rACDgNvbgFoECMBGeOSxlv7f9ZZPlw8jbFZGiBU72Swu1vfaeCoxTTziHNw7UcLrHWJR
         AKKiFDsyO93LUbEmoG+hHJdZEh650ptJD3odyQ/w9fPYc4PvSJ0mm2Sf5PxZt3k35+Xr
         wxob5ZuRAYUg/cXXu2K92l8bOQgHSH8rodtPWHXJuG7bBF/5TfgeoeRbDB0Wy/K1sCCD
         uVtxcxA6CrL6WBmCavRtirj9U2/SaEAzfTB9jrKlSoL4xIH/1z47TjHh6YE/4ycLvzHM
         m/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795779353; x=1796384153;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zckLxKTSVIvkUKQrRBT4ZQPN8xSZzGvjPSGz1nKrgeM=;
        b=Go5PUcs15G/vQNcM1SzFhp8i3zwjGOP8vNqmwOd3UiB1KurNLi5+5XR/EE3cozcvhT
         ITBNnI5HFoWiT0gv6vtKPWRW7JEqmlR+ptsodeqTdfDkE5tU/1idDErVLz06CFiO7ih7
         31pQ6rfV3oO+9lbuZbCcG3woUj3LexozgrX++g1StRjBu/tP6LqTAgcgW7QN2px4Team
         FLkRR49NywMTBb2NCNF7qFWpQXD7DyEZnNoPTdjHsophVCb2mOjPQqZCaaNxrUsRUeWp
         T6271zMShVM5NHdFa7X677nJhYDn6flPOHL5R5IrItFPKOFd6BW87pYuD0gJVhZ6ErBI
         OEnA==
X-Forwarded-Encrypted: i=1; AL+hErHEs05vDwL5yXkIkPR7dT/Lsed22LCKyU4OKpj5YhPGk+tAKeLeOlpFd68mxL9U4YQMnzGfbUYpRYc=@vger.kernel.org
X-Gm-Message-State: APuU4Z+1crwaVjTM/soORnMlT2C0zHqKugC6FDD8C82pfCWTBbhkv+nk
	1/qXfi3bpzQqtFWcZZEaKbtjWufz0RC5rZYLe+rDdXU3xrH267Z4NsgAesbqWJOElZYsdQV+N/b
	4WceslPs4pW2hc6RWFUB7HHzsLv91qGo=
X-Gm-Gg: AZFdTZf4qqLUK00VXgx+I03veCwRRc5zFaSlbj8R3IaxTVCT4nYPdJMbpBI2PgLp35t
	i87dwOrsCycua9nKXoeoL3PClOUKSGyzcFShv5a5pqw7MMYoUQC97LCu1kuZgb0hP5iXKlBgmzG
	Hgwlp/mkwIKLM4fI7VkF27hgrZDAF9riCq93FuaptuqrDk1O1W8egFeS7SaaWMlieAfRLXzaoKv
	OxLD6mDL8YwtCywoV03idMQzHdz7JPwCw/uxvuZOVWB6kCZHeGZGBlzh4APj3LZ+5QeMMhzeXQd
	lKzdxsOkRMKSeaJfMRys3snzrPDg/J5D3q3j5FuVk0T29MCr0R9S+r/tu+alKzN9Xib1+gFZJdS
	AIbMa8MXOhBVE0lUBPhSqx1nvsrCktkwrLGygUCBhE6K+2qvSMBbKIHYGoTDZOG8r9dRH1A==
X-Received: by 2002:a05:6402:42cd:b0:6b7:b872:27c0 with SMTP id
 4fb4d7f45d1cf-6ba37ebff16mr18720566a12.44.1795779353347; Fri, 27 Nov 2026
 03:35:53 -0800 (PST)
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
In-Reply-To: <20261126163114.403846-3-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 12:35:41 +0100
X-Gm-Features: Aa3M54oDVUmD4L041vA_Ja2kzcuIcnu49jvnV20FPfNA1gUDEEUT8nV16GU1jvk
Message-ID: <CAOQ4uxjGLfuZMFABCwMvdXwnU+P24G_aTJLudWbjeSmWwyDF6Q@mail.gmail.com>
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

On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Update fscrypt_prepare_setflags() to use FS_XFLAG_* xflags instead of
> legacy FS_*_FL flags.
>
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/crypto/hooks.c       | 10 +++++-----
>  fs/file_attr.c          |  2 +-
>  include/linux/fscrypt.h |  6 +++---
>  3 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
> index 149498bdab94..52d6a33fc9e9 100644
> --- a/fs/crypto/hooks.c
> +++ b/fs/crypto/hooks.c
> @@ -182,10 +182,10 @@ int __fscrypt_prepare_setattr(struct dentry *dentry=
, struct iattr *attr)
>  EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
>
>  /**
> - * fscrypt_prepare_setflags() - prepare to change flags with FS_IOC_SETF=
LAGS
> + * fscrypt_prepare_setflags() - prepare to change xflags

prepare to change the file attributes with file_setattr() or one of
the legacy ioctls

>   * @inode: the inode on which flags are being changed
> - * @oldflags: the old flags
> - * @flags: the new flags
> + * @oldxflags: the old xflags
> + * @xflags: the new xflags
>   *
>   * The caller should be holding i_rwsem for write.
>   *
> @@ -193,7 +193,7 @@ EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
>   *        another error occurs.
>   */
>  int fscrypt_prepare_setflags(struct inode *inode,
> -                            unsigned int oldflags, unsigned int flags)
> +                            unsigned int oldxflags, unsigned int xflags)

This here is a backporting landmine -

Changing the semantics drastically without changing the helper name
or signature.

Please rename the helper something like fscrypt_prepare_fileattr_set()
so that backporting mistakes will be caught at build time.

Thanks,
Amir.
