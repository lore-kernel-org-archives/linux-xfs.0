Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795785380;
	b=4WwodMvSJnRfdv+vL/2yczS2Avkq0VDiQoKnsZ8/q6JNMta74sRm0y4GwkNHxm3Z1lpn
	 rMYDXICJD3Y8dbhCg13itemjuPJfadbU+t55M8j5Ok8CuZbPgJkbw2qvj85C7yAIuU8z2
	 m4r2Apte72lFPURjWuf57CD2WCmhGSeORosWCwQxqO51SfeMrdBWNp7S0kNikyoxpSz1g
	 JcpS+VEousXJgOo3DOqP7ENcrRnn2GoAJn7DPnLt4x62Fe3rTOVdqEazkD+pXHy+2DXaO
	 3M2mQideOU0u/+tb9xvLvA4scAE4koL5diuVU6z314xuqLlHmZrWjliU7P1RAUKLbSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795785380;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:X-Mailer:
	 References:In-Reply-To;
	bh=KP1KQQ5zc6J2penQP9T7HSMskKwpsejXhyxZijwDgBw=;
	b=PBP9fRvKM1voOaamvb/bEV4TlGusdWrxEMkpF2HcC1QQAhVj7YW8cJfk0IHTJHZvR3k5
	 O0WgKn6/LBtx2G5nm7m3cSO7mN+roweRCWqd4mFUegRxQioLJaRlZn8QQudO4OdV37CCW
	 NFQEfxLtiU2tWtKhLE1QJyf+5DLUl3U7DxyPYEKrV6XM6PhbjfACVSgAHnXukcUwgJQgG
	 IzqIcablDdtTvoWJd9P10DQC9hne1YMespPcRkq9oY8CFkEDgoIc9KlZgj24zX6x9+Ihi
	 QuuNtGr4KrGEuSwrFQQeMeZkj+vl17oD7/aqaZHnLzBJD6DLLb/ePAbLLg7GHop8b2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jDNYoHai;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B2D606A321
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 13:16:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23B2D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jDNYoHai
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so82089595e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 05:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795785378; x=1796390178; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KP1KQQ5zc6J2penQP9T7HSMskKwpsejXhyxZijwDgBw=;
        b=jDNYoHaiPCM26YLr1LFLyg6vcqQ3lRu+qOryzuAYi+xEuAHmc0UqBdZ4poBpehE/5s
         7PiUWUCK2wkW2dteZs/thupIvuqyOU4W3Pq5sVdCMf0lb1Kxo4J28XQbhfyF7mT2cs7q
         3uFW87E7O1hT4++crNJt3NAX0SUI6+EOb5aReqGo7+i54H0+ooS6ly1ZFIV5I74tqsqS
         IKB4ZHTTJl+Khf2B08Stb1mg1Yplxkn/8s7Lx6Cqfze+pKKEyi0RsBeOj+BbhwP9gSIJ
         mP2LhvB4dpZzb760HoemttcxB1nTp4qjR8BwnjtOJyYwn3j7VDur80K0A/7El8aVvwX8
         YkZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795785378; x=1796390178;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KP1KQQ5zc6J2penQP9T7HSMskKwpsejXhyxZijwDgBw=;
        b=nr8p9Dz/ud4C1CuZV3T0NCguh8ppGjDtg6YxmpfaVqHf9Gm3NIPhGHFnHDGE4sIWnZ
         csZGmGuGcsCzNFdXoR3aEQSvKSQWchmSq1IIs4Bq6JvhdBovPwB3g+3nBKJAnPCKIKPB
         UpoLMQZQhmfIbYbJd387MrzzEouCkQfgXwa4ZAC+ANdxQBgJU1oa65snjB9w5iZaGeXg
         uzKEC7YmHdGinYur2uJaVyb1AV01ZPnM19cAEQIhKJXMnHhoGm6MOnKvvuxNmMfvfM1q
         ZIEwUwYmotW5eKvVzCgF2p8hgBCMdddFD/IxHsnH2/dYVB+SyCkTZYOSwE6f5SOuhkhB
         vx9A==
X-Forwarded-Encrypted: i=1; AL+hErErBvEE7Zx0pyqqDLAp4KwXe/kGqAfyGurwQdj8+7qn/7AsXLT5oJc+qg/i//SrRnXln0COjhpQF5U=@vger.kernel.org
X-Gm-Message-State: APuU4Z9eBsbXIz4icuy270ge0WqIUfIJn7z6NNmNuKMKZo4JI1voEE91
	ztAgKr9o6v862fmr7H0Fpe5gMmfIZTLNhjj9GsSq9yXWAzM0ccpizzeGzsF6tCJC8f0=
X-Gm-Gg: AZFdTZdaQ+49xIBB9pgCD0Nk43DEBJfH5gxzc4tNnQSXByorK4OqKM+1h8shc+ptRal
	czvRK/Wf8dVqhhrvhCLuGTDa8PTcgb4keI2kd0Z4E2mX8uRXqm9iJ45tnB+C1gy3MJwu4IC+B3v
	1kDa5YD/4v6JNGPTLuIGdJfWwLLAzt3vArX/Ov432S5fUKbp+Z4CSFLSRfCUY2O41fAKKHSGcaJ
	MKDMLMUCV5ZB01Gz7mFvGcgHljwJ48i4zDOf/EEZ+AQn2zK/tOf1ZPgebAnWVtsTNY5YyyxZKpo
	3pEsEMrFw8tzF4BrxabWOfCnQTXzt83QQxsD7dTmVWuFKprsTJqDKfo8ByagiY46y+Yi/RZRkam
	L80BMluC0AukKQhAvGjfRAWLOJLZ1gropwNgiZZzKNQcHuNNIuQ1qvVfU1anDbWF5+G39tqIj79
	LwqSdk7xEjhn1liW4tclXL+DcKGWZDzg+FDnyyQ867/gLgJ+iYjCAQvAroZh1l3WkYHHGYNvZKq
	QdKI04CV5ShPAQTQvjufMv7+XbezBRlcd4RC31AisCWvib1arkWffFFOYH4yFFL1X3PKnloUf+l
	TpbgnB7ByYC4QHW5LCpor7LDUa7X6ZVIG776wZe69wmNKtFqWAh2wRvkOhqC
X-Received: by 2002:a05:600c:6219:b0:4bb:a5f1:fc5f with SMTP id 5b1f17b1804b1-4bba60168f3mr171039875e9.26.1795785378311;
        Fri, 27 Nov 2026 05:16:18 -0800 (PST)
Received: from localhost (mob-176-246-245-5.net.vodafone.it. [176.246.245.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm947107665e9.13.2026.11.27.05.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 05:16:17 -0800 (PST)
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
 boundary=d266ab6a5424ddaad121a0a52eacc7f99696bf23ca7b0dd531f4216c8dd3;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 27 Nov 2026 14:16:09 +0100
Message-Id: <DN60SA2AMQI2.3C10NXIO3L211@gmail.com>
Subject: Re: [PATCH v2 2/4] fscrypt: update fscrypt_prepare_setflags() to
 use xflags
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
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
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261126163114.403846-1-koray.fra@gmail.com>
 <20261126163114.403846-3-koray.fra@gmail.com>
 <CAOQ4uxjGLfuZMFABCwMvdXwnU+P24G_aTJLudWbjeSmWwyDF6Q@mail.gmail.com>
 <DN5YPR39J7QI.1S1LCFLNUCZNL@gmail.com>
 <CAOQ4uxgzmB0dEpQCVGKOc8reJ6OFV=BxDMgRW81aKiCMwDSn_Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxgzmB0dEpQCVGKOc8reJ6OFV=BxDMgRW81aKiCMwDSn_Q@mail.gmail.com>

--d266ab6a5424ddaad121a0a52eacc7f99696bf23ca7b0dd531f4216c8dd3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 27, 2026 at 1:02 PM CET, Amir Goldstein wrote:
> On Fri, Nov 27, 2026 at 12:38=E2=80=AFPM koraynilay <koray.fra@gmail.com>=
 wrote:
>>
>> On Fri Nov 27, 2026 at 12:35 PM CET, Amir Goldstein wrote:
>> > On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.co=
m> wrote:
>> >>
>> >> Update fscrypt_prepare_setflags() to use FS_XFLAG_* xflags instead of
>> >> legacy FS_*_FL flags.
>> >>
>> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> >> ---
>> >>  fs/crypto/hooks.c       | 10 +++++-----
>> >>  fs/file_attr.c          |  2 +-
>> >>  include/linux/fscrypt.h |  6 +++---
>> >>  3 files changed, 9 insertions(+), 9 deletions(-)
>> >>
>> >> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
>> >> index 149498bdab94..52d6a33fc9e9 100644
>> >> --- a/fs/crypto/hooks.c
>> >> +++ b/fs/crypto/hooks.c
>> >> @@ -182,10 +182,10 @@ int __fscrypt_prepare_setattr(struct dentry *de=
ntry, struct iattr *attr)
>> >>  EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
>> >>
>> >>  /**
>> >> - * fscrypt_prepare_setflags() - prepare to change flags with FS_IOC_=
SETFLAGS
>> >> + * fscrypt_prepare_setflags() - prepare to change xflags
>> >
>> > prepare to change the file attributes with file_setattr() or one of
>> > the legacy ioctls
>>
>> Ah yes.
>>
>> >>   * @inode: the inode on which flags are being changed
>> >> - * @oldflags: the old flags
>> >> - * @flags: the new flags
>> >> + * @oldxflags: the old xflags
>> >> + * @xflags: the new xflags
>> >>   *
>> >>   * The caller should be holding i_rwsem for write.
>> >>   *
>> >> @@ -193,7 +193,7 @@ EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
>> >>   *        another error occurs.
>> >>   */
>> >>  int fscrypt_prepare_setflags(struct inode *inode,
>> >> -                            unsigned int oldflags, unsigned int flag=
s)
>> >> +                            unsigned int oldxflags, unsigned int xfl=
ags)
>> >
>> > This here is a backporting landmine -
>> >
>> > Changing the semantics drastically without changing the helper name
>> > or signature.
>> >
>> > Please rename the helper something like fscrypt_prepare_fileattr_set()
>> > so that backporting mistakes will be caught at build time.
>>
>> Yes, though, would it maybe be better to just use xflags_to_flags() in
>> the vfs patch instead of changing the fscrypt function at all?
>
> Yes, much better. I agree.

Ok, will do in v3.

> Now looking at the /* initialize missing bits from old_ma */
> hunk my reaction is to look away its huge and it should be
> using helpers probably called from within fileattr_set_prepare()
> itself - because if this is de-facto preparing for a set.

(I'll reply to this in the vfs patch thread, so it's easier for me to
find it again)

Thanks,
koraynilay

> Thanks,
> Amir.



--d266ab6a5424ddaad121a0a52eacc7f99696bf23ca7b0dd531f4216c8dd3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCawmCmgAKCRA0bnTtJTDo
OM+8AQC9tcOsGFPF287JKL4pLZnhvZs7off4ihtuxm56vgpT2AEArgij7OQEsKKN
AWm00Ai0JaPzKxHQtiid5dTOQhG5TAY=
=uJ63
-----END PGP SIGNATURE-----

--d266ab6a5424ddaad121a0a52eacc7f99696bf23ca7b0dd531f4216c8dd3--
