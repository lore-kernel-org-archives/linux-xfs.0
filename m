Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795779540;
	b=y22OMBKgChatmpWvt0g+s/T62WoVTM8re2oTIE7GWNcvq/Yw5agl3kFqa2SmIHs/qWFG
	 KWoH1qd3/qRAXkLL4jq9alIX2UiE2mPymiDlptq0iypErIH76SgKNGU1g1CqbEgpXSYz0
	 il/TVUBYfynt/DQwb9FvHTSB7N+JtHhPy+ft8iY5bg2fqJ2s4hLqKmtmg3Oa89KOIgGXA
	 Ud636/u/vInYARov+X73uiD+Cd5CHekYiFWmAbylzVEdFKX2bJSR/Jm5zvSVYO3IK+Ix2
	 fmLhYqlXBuj4cy7WR0Oi4gOZ/74XIZV9otF5a+mZ3/sIs2murXQ0UJUrTXgnw49EsxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795779540;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=c9ZC6MWzu3Bp3v+qDNZq5DpuS0weGkOl2JzPS3hazF4=;
	b=FAKjWSl9N8sneUr325f68YoR0qcwLscqVTV7N+1jGr+evxxMRjhG0E7CfguHSS51c2HZ
	 vomuyTJcj36B6t0LT331EFg/PfZwduJgTUop+bfbynXMqpHNI2FsKns4YgIU1bp5bTfoV
	 Q2m4ze1zalSM0ke4lMeWJJ3ngd0zEtUH43G4ejrK2Bwyk9Og88kPzmcM1vkLTQVfhpZd0
	 pc+j5Q6MRWJiIHMn5C2MdnvursxZ5m0yMklQ/YU0sUd2+lZcUGuR9vJgryF9LdPfq/GsZ
	 hykaMksKU10SzzeiiOTEr/ki2p3OAHahCh2uIOrntXRZy2+jTItELy8V6EN0CHQgT2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=llEwaPv+;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12967606A327
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 11:38:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12967606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=llEwaPv+
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e47347279so4879237f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 03:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795779538; x=1796384338; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=c9ZC6MWzu3Bp3v+qDNZq5DpuS0weGkOl2JzPS3hazF4=;
        b=llEwaPv+yFD5ixI8gLf/1YwHVK2jY3Uk8e7fnri0ADHVRlxkfS7BFhdVyvvCcaEa3q
         0I4JkU036mRaoGL6vnf66vTlDYsmGEDkItLzroZmPEezNwr/Hq0mGEKiiJs/ikI4ypVh
         wc+m80A3/oGTgAuxPo/4mPwcgEwhqlk0aAmDAlM9SmSy5xGBmAt8Rga3E5XmvdsH0wFV
         UbPPUJccgQ4TUVFrL6EyJaylmleBLGju/dWoahaKaVn3UoKJUpudMs7T0mYH7SKPRdK1
         CIY/AKj/VrWyhv7OsdQ6XeuqK0joerjAoY1iv0YbSvCXosUVHJsHrmf2Vm5Kl0J9HhZJ
         Yx2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795779538; x=1796384338;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=c9ZC6MWzu3Bp3v+qDNZq5DpuS0weGkOl2JzPS3hazF4=;
        b=pfW/LZp5Jh8oAQ/LnYhLRxwqHcrhSaR1trPI3/KpGpdBiVfvxa65VZONUwbLeik/fH
         Skx7YEKiSDT+dQEA6S0+p/gZstwxPG0TmJCRWPiIRUgFXQdfUHEFRm8zjw918mwxDZju
         evV1ZZPrzAtynKL1e9XZC60s8RnmiHXnE2fVjp89JZGLcZo0Sl9JZubsj0XeqyEgzZIo
         zXYC4R1L0Zq4YINe1IaGKYCIJ6Tfn3Khfed3kWkQQs45jHZq0D7Eysl0b/x1l5RlaDZV
         ijwusXVVGwLfhrQKntg6GnoN243WUsDZ513PDtobgimvQDAZfohC6vOLHgPZuPhHC9CO
         vCMw==
X-Forwarded-Encrypted: i=1; AL+hErFCHZ5KAyV7xdE2uBgXC01kMiL0fJJsqMhHayo3hmoZ0vORDrezbQsnf580+Pyi2jocnefS9NxBSbw=@vger.kernel.org
X-Gm-Message-State: APuU4Z+TdsCHwRivUW+zIVGLOAnCbMehZi+4iChQhDW9pvLa8AzAIlCo
	VhsmR4iMoB1o65PPoeFFXLml0v9AphSm0ZOlqnjB/tG48p+X1ymPRORy
X-Gm-Gg: AZFdTZfojaxlzRCXYBdaSl0Pz9Tbmcrq7WAv+tsqUEJSOjCbHHhwWFpXCk5rMNa11Ca
	hL6dIItPj0ooX17h0dVF7H1oDx1Yuc9/1ZnqEu4peZ1ATXoGnEWXATHs4nZimF+P4o/IL67crVs
	V3/2PGdBVCFLTvBDBo8Wpd1w49HA7qDyZDv/QnDE5BLjlA2A46RnnuIN9/2SuV4hAB/IBlIIvnS
	6LuyfZZ6lUiOcoMLqjRo1fDMHdIdYp5iwBzlfPcaSnrcFiiFWhR8FTb6opjfKdQ6xGx3wwXbnXS
	sfe6d8/l4GyNSd0Sh5u+ESP3pkHwfspDMPNYK0upyom36j819EAhz1PagEIUY2nJRUHdt/CPF4G
	QckIHf1mvaYd96Pwxofeo/DXHsLaEwwBUcpnvpPXLm2MEYeQIviBB6T5C/8On7QfhmfdwKzmFag
	B2AzrbE/8MAYkKq9eWljRYHybKhPqHl3Ye/HGtTDTB16oG+Sxj6laP5tVNGrWwg7LSKGBtJm0T8
	iPJOIp7Qe4sTt3Dax4tmjSRiagdpsjmmnMTkgS1vz2PDm2WSJlVbfkTrmVOnEmDUwSaegmr7lrA
	xe7YmuiE1GRb3MgZOuOHyFJ8NzYreHDCmPSpzMNiTtbjwlZZ
X-Received: by 2002:a5d:5888:0:b0:492:5ef7:5d98 with SMTP id ffacd0b85a97d-4abb6651686mr44136319f8f.38.1795779537909;
        Fri, 27 Nov 2026 03:38:57 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a67fec7sm44099896f8f.26.2026.11.27.03.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 03:38:57 -0800 (PST)
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
 boundary=9ee92098a335c2a68fb67c27de6debd3005add5d1428b82089d4d2e1ae1e;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 27 Nov 2026 12:38:49 +0100
Message-Id: <DN5YPR39J7QI.1S1LCFLNUCZNL@gmail.com>
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
Subject: Re: [PATCH v2 2/4] fscrypt: update fscrypt_prepare_setflags() to
 use xflags
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261126163114.403846-1-koray.fra@gmail.com>
 <20261126163114.403846-3-koray.fra@gmail.com>
 <CAOQ4uxjGLfuZMFABCwMvdXwnU+P24G_aTJLudWbjeSmWwyDF6Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxjGLfuZMFABCwMvdXwnU+P24G_aTJLudWbjeSmWwyDF6Q@mail.gmail.com>

--9ee92098a335c2a68fb67c27de6debd3005add5d1428b82089d4d2e1ae1e
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 27, 2026 at 12:35 PM CET, Amir Goldstein wrote:
> On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Update fscrypt_prepare_setflags() to use FS_XFLAG_* xflags instead of
>> legacy FS_*_FL flags.
>>
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> ---
>>  fs/crypto/hooks.c       | 10 +++++-----
>>  fs/file_attr.c          |  2 +-
>>  include/linux/fscrypt.h |  6 +++---
>>  3 files changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
>> index 149498bdab94..52d6a33fc9e9 100644
>> --- a/fs/crypto/hooks.c
>> +++ b/fs/crypto/hooks.c
>> @@ -182,10 +182,10 @@ int __fscrypt_prepare_setattr(struct dentry *dentr=
y, struct iattr *attr)
>>  EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
>>
>>  /**
>> - * fscrypt_prepare_setflags() - prepare to change flags with FS_IOC_SET=
FLAGS
>> + * fscrypt_prepare_setflags() - prepare to change xflags
>
> prepare to change the file attributes with file_setattr() or one of
> the legacy ioctls

Ah yes.

>>   * @inode: the inode on which flags are being changed
>> - * @oldflags: the old flags
>> - * @flags: the new flags
>> + * @oldxflags: the old xflags
>> + * @xflags: the new xflags
>>   *
>>   * The caller should be holding i_rwsem for write.
>>   *
>> @@ -193,7 +193,7 @@ EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
>>   *        another error occurs.
>>   */
>>  int fscrypt_prepare_setflags(struct inode *inode,
>> -                            unsigned int oldflags, unsigned int flags)
>> +                            unsigned int oldxflags, unsigned int xflags=
)
>
> This here is a backporting landmine -
>
> Changing the semantics drastically without changing the helper name
> or signature.
>
> Please rename the helper something like fscrypt_prepare_fileattr_set()
> so that backporting mistakes will be caught at build time.

Yes, though, would it maybe be better to just use xflags_to_flags() in
the vfs patch instead of changing the fscrypt function at all?
(Also to avoid maybe having regressions, I forgot to test fscrypt)

Thanks,
koraynilay

> Thanks,
> Amir.



--9ee92098a335c2a68fb67c27de6debd3005add5d1428b82089d4d2e1ae1e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCawlryQAKCRA0bnTtJTDo
OAscAQCnLyzS8zZ9SFk9wktpq3tvXIGHHr6PhrHJzvvIIX5a3QD/d7iHp6UzpXcB
1oYG2CGEhM4jPCS3n/9+H/haKMzfdwI=
=mdIi
-----END PGP SIGNATURE-----

--9ee92098a335c2a68fb67c27de6debd3005add5d1428b82089d4d2e1ae1e--
