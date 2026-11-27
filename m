Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795805478;
	b=N1f6gtt1RDX7n+SN5xaKSLXvPBLGydw0cUHi4G/U2/diygBdQEjdCs2b3PPQF/d3XXjZ
	 hFJwANXxLDC2QsiVSOH6Oh53oOdYkLJar9OnuC86I2kWcEArCiapi8RkRgaRS6yGIkARl
	 glJf4ePe+C7kZTaW4rXJBSt9x07xbgJblYopvR7FqqjrGcMETZJZUwo2tiPZnOF7eGhFu
	 9XRPDhRbxPHmDyLr1UaFL7xKfLFdPwNnXGYKHJgEygt3WSOQ87r54xHGQ3l8hswIX/+uw
	 NXVcCXUWMjarvVfUSLxeSF/l+hYIo44SfwIXBXAicOQcNRFSfLT0PJeZGqu1a19g08g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795805478;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=JmL8LoMVs76VvbagqtHAZXdxFbOYrgh5zmv9OUe36GM=;
	b=ePywe9LujJWnozxQyxQPEmvQj0eUshKe6AT/brI9My23q4ql6Z9thE8pj7dZZhf0rSbO
	 E9OkmaKfvgq2hhoqWhB4IyR2wk53Un+v6O+PyZsvZUIvEsEAro4R9AVOpTshLmRZO2hhQ
	 qxOva+3FnH3N5uIXNyNP9o8elyzzJBq+/uqUJ7ahXjv7Q6yoc/X7ek4t3jQ3hHTfWGX/D
	 GHla0QZERgQHqN69hL8wDXlKPciATC0AGMB4w/nE2NnjXKeegqY/+FB9JKaigvzmfa67w
	 +MfAODk3EpievaMdcDN8NbdmQVIOAatQQBWTyxn+GJNCLQTPBZSTD5kkHolobRGI4Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m3pNdptj;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0557606A321
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 18:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0557606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m3pNdptj
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-490c3ae81d3so5278022f8f.2
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 10:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795805476; x=1796410276; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JmL8LoMVs76VvbagqtHAZXdxFbOYrgh5zmv9OUe36GM=;
        b=m3pNdptjqW81pY9NLNr665+hJMXwfSRIqlg9cV1mmo9g7662QC2nuYP6a74k3dZ3Iv
         zvWxD2plIKeVWrLGkl0fu/pCXc3Vzo5AvT6VFc4h9ivwKjhKyhk7gIjLCx9npZwJUmyQ
         Nk4TvX4IzB2micR2Tn6o+UKGujjmbSTrorSwb1pZ/GkQGqOji8LqBS5bCMicKVrMKepu
         ioYd1kId/PYWHMgCja4C2aGhqgHUyOK5G1CCmNbKgHfRfy+Yjo4yFy+orjpyYzTB+iHt
         M9/R5HRHUsAyOqHMXuprEzV4ETE8D3x09EMM2j33PoYMAXrIBvD7VzX01Z6gcTlyJABk
         Dmow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795805476; x=1796410276;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JmL8LoMVs76VvbagqtHAZXdxFbOYrgh5zmv9OUe36GM=;
        b=Xsd+MfXOWOiQIlCLUVzcJtkm25CdSW9+cBKGLQsXa8Z7GnCxnuMJckkKM0nCWZONhg
         jZItY5/G6hjhVkH0qssaqfYunAoGYpC4FqVH8KUGjG1fsSuDdXFqAXfGQrsKiuq3G6Pw
         oFl69UmZGPcR81LJr0Jcnq4nrjp1A52R/xMtsEuFjNlVBV5ZqkljEqvqPX1BklFscikQ
         DOKbrGLwyqmlxKb6HwYKix20JtnD69eLZPQkIfOhmsJtZovjuFw6uiotlB0m2S6xvsA3
         lCqWU9QEbxzNZQoZKsneRBNMlyWbUDUiZyesxF5867QH5zbkKHKMKPbpkA1s4zoUqcGy
         lRyA==
X-Forwarded-Encrypted: i=1; AL+hErHo/+Bd/kSqU0ACyxxTSFQj82vpdNOVVCudgEX8ZwL1+W7/ZkBKJzIa3YMiZm8ESqRLJGxNMVJIPoQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z/DftuUOu/vJI2j+ZPZ1a67AvNkKqQluPs4hp92X3FIOrG/oHF8
	8+ZJR3JmzXgzxRIQQoR0IUUYBc2PYAeb3LrbpgqVvbg2Wcw4AUB/SDhQ
X-Gm-Gg: AZFdTZe3n1K4O86HokyS8+okGwqPlmwb9hQ6kpy6YpMLe+MBj7Aroh+bSbSyQi5nx5D
	fwxKmln2ZW5Giu9ZQVL3v5e+AaRuzoNofB1DFPiLvIQfCY7RhRGt9/ep66alGO+0W29StRvRCta
	8Jt12GoTQk2zoZCg57jVyvir//vjsW9V9u3b6DnEnq9ck/u9rOzbWP5XIYiDJE4KsJ37VadlatD
	6xlukaINcXJDvadGPrgYkh6opQm4pmbU9Ephrlqe8Vx/mmneb1GZV8XnG0a385P064uFCb+Ryjf
	cxGbKVJo9BAQyX0vA9b8flauouOsvwKT+IDLGxTNQIGd0tPy5EauthUs8+gB30sQNkkWtrIFnej
	UdbEAgDy0Axi4wYVs5jwkJtiqo0mpDecSh53mwaGgsSvhFqanqNa1K8xb0e+cIwK5aLRJb5YiTY
	05dTk58zmBiDGt+utQmQdP6qOz7f40GSQ1axmObT7LKp5rNxrSIgWWx2tB3TGAAWl0i3UfqOgqE
	k/CPNDqMAT/O9mjQxBT6WvtIKkyHo/Rh8FblP9+rbnxf07/LiwJ1jWo9pViiPBQhbNT4jmerheH
	o7aHx+HBPis8uzfYrBKb7VScJA==
X-Received: by 2002:a05:6000:4812:b0:48d:b650:69aa with SMTP id ffacd0b85a97d-4abb55185e4mr49465105f8f.50.1795805475952;
        Fri, 27 Nov 2026 10:51:15 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4bef07f9e0dsm4921752f8f.53.2026.11.27.10.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 10:51:15 -0800 (PST)
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
 boundary=3d0117b6230d8b8a6a185cfbfe10dda73718c7f46272653fffdbe69dff91;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 27 Nov 2026 19:51:13 +0100
Message-Id: <DN67WTNVL19F.1D5GOBP57BP1L@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Eric Biggers" <ebiggers@kernel.org>, "Theodore Y .
 Ts'o" <tytso@mit.edu>, "Jaegeuk Kim" <jaegeuk@kernel.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan Kara"
 <jack@suse.cz>, "Alexander Aring" <alex.aring@gmail.com>, "Darrick J .
 Wong" <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] vfs: add xflags mask to fileattr API
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261126163114.403846-1-koray.fra@gmail.com>
 <20261126163114.403846-4-koray.fra@gmail.com>
 <CAOQ4uxhA+93bo5WseLxe7cAvJHJ8eQodoQHLwh=iToyEVkeXEA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhA+93bo5WseLxe7cAvJHJ8eQodoQHLwh=iToyEVkeXEA@mail.gmail.com>

--3d0117b6230d8b8a6a185cfbfe10dda73718c7f46272653fffdbe69dff91
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 27, 2026 at 6:48 PM CET, Amir Goldstein wrote:
> On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Add fa_xflags_rw_mask and fa_xflags_ro_mask to struct file_attr, both
>> __u64 to match fa_xflags' size, and bump FILE_ATTR_SIZE_LATEST to
>> FILE_ATTR_SIZE_VER1, which is now 40 bytes.
>>
...
>
>>  #endif /* _UAPI_LINUX_FCNTL_H */
>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> index a13c7b32a1bd..63d88ebe3420 100644
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -238,10 +238,13 @@ struct file_attr {
>>         __u32 fa_nextents;      /* nextents field value (get)   */
>>         __u32 fa_projid;        /* project identifier (get/set) */
>>         __u32 fa_cowextsize;    /* CoW extsize field value (get/set) */
>> +       __u64 fa_xflags_rw_mask;/* supported writeable xflags (get) / fl=
ags to set (set) */
>> +       __u64 fa_xflags_ro_mask;/* supported read-only xflags (get) */
>>  };
>>
>>  #define FILE_ATTR_SIZE_VER0 24
>> -#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER0
>> +#define FILE_ATTR_SIZE_VER1 40
>> +#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER1
>>
>
> Man... we really need a bot to review all UAPI changes
> Please someone tell the bot to check
> NO LATEST/LAST/ALL constants in UAPI headers!!!

Forgot to add: maybe Sashiko can do it if asked nicely :D

> Your patch does not introduce this constant in UAPI but if we change
> it we risk spreading different versions in installed headers.
>
> Honestly I see no reason for FILE_ATTR_SIZE_VER* to be in UAPI
> either. For other UAPIs those constants are not in the UAPI header:
>
> ~/src/linux$ git grep SIZE_LATEST include/linux/
> include/linux/fcntl.h:#define OPEN_HOW_SIZE_LATEST      OPEN_HOW_SIZE_VER=
0
> include/linux/seccomp.h:#define SECCOMP_NOTIFY_ADDFD_SIZE_LATEST
> SECCOMP_NOTIFY_ADDFD_SIZE_VER0
> include/linux/xattr.h:#define XATTR_ARGS_SIZE_LATEST    XATTR_ARGS_SIZE_V=
ER0
>
> So please move those contacts before adding/changing them
> (can be in the same patch IMO).
>
> This is a high level review.
> I did not look at the details of the conversions and validations
> Will do that for v3.
>
> Thanks,
> Amir.



--3d0117b6230d8b8a6a185cfbfe10dda73718c7f46272653fffdbe69dff91
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawnRIQAKCRDmj22qf5IG
XJUmAP9OYQdkwBS0FIjyqP9a3I8gdrfFrp/bZms8ThGuY3SovAEA9zGXlhLiGxhC
iuYnX95tMjFyQ2w7/Y0yIwxjSTRZ7gg=
=DR0g
-----END PGP SIGNATURE-----

--3d0117b6230d8b8a6a185cfbfe10dda73718c7f46272653fffdbe69dff91--
