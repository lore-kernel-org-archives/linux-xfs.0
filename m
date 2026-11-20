Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795185854;
	b=joxxG7E5mCENgQpQ9GB2Eij3Gho1nE79HQhU1wGWfyXEGAadwAZZMY5sMfAk92qctkVI
	 vLKkaoQnH3w10t0+ssPmzI07CVbUPKEVOdXjd2/cqo3zAXcC7uqvLTTB+IQcqDKecr3tx
	 ghep8+hj3YlHT0pMyTmuemxQwfQ/eLCASupQdDJLZzM63XwUKjnoOcVIFMlvyPqbDbFfC
	 pYaMUTuI7LMYJnB8ib5Me2UCY4VJEDP7iuQxJ/MyVlbfMk0mmRFWhADTwxhqrDBqexNhJ
	 y20zzD/Jm1jsSYMInNg6jlJ7eUJ8zxhkZSA9pI20KpYLNzq0fm9i+VY2vCWw/Vbmz9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795185854;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
	b=a8/IPmKqU0qs/9Eb5KiLQsLNaJDc7swhbSTgn81AejsQt4Z4MDQjbhxO00+tLG3s+zmg
	 cnS49F1HbUnWKXOQc9Zq/qKn9zUqGmqTfj3cZmJUQkLfQLU3mZ1AKzYjwbw2IKJnDJu5D
	 OYjm5uzqogph/ZwAPEPxhSju5q5Blbkv18LF3lyZhiNgfl/Dk54wzadZNO9S0Hn0wTkrX
	 30gLM+/kRIFEkli2NHtxmjlukn/IaEyU1HXoevaTHiIJV7tkuNqXLmauUEguY5Iqsyi7c
	 MSpHc6HcJuWI1v15ezsz1pUuQYIn8Cn/zY/hFagFpuUe7oX/ku99BdDoV3YHC2SIYuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UCx2E0Sw;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5ABE606A331
	for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 14:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5ABE606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UCx2E0Sw
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-492fcbfaa88so604840f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 06:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795185852; x=1795790652; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
        b=UCx2E0SwKcK/oqyYNLOz686VusYmii+3mMDSe2hm1s34x/9j7y81gtRcvRwLvYBz3L
         8OWonxeJ7ONGBIAdCYN28kX+LRG6+zE1qzjaKqtJdHF3MJBPWqGI5u3OnZMZ4nUYhE9m
         PEaUWEoqsvQP3IAgHgg36VjHmqvLstmO20zMnptGeWfnBQnfV8Xwbcf2i+5+HPE/je1g
         UffyYR0okyEW/XxdVXBfUQ2+CTA3+deWuJyIBQP4+m3bQJNmt6Az6/sbA917Q6G5mzbK
         Rj5vUQAl8Up+44D/OFiKqlCYJFj+9wTD4uBgXkGE6VmgSc/N2pGJihXdIl+6jSPw+Tjd
         ggNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795185852; x=1795790652;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
        b=ngaDYBmAFmMO+KXaCfGh1dJQok4vuNUsXhnYpBFMzqBozUH5Xh+HUASAc7p4TCEOMZ
         QHCZIztxV9xayytaJvBm9xabkbHs5NA/97qnwE2mT4WGZO09XJHFcxZvtv9YOZBApGhD
         Daqfj4pI66bgBGeNxpRfdZmBc07qPyQwfFxpHSKHJrHnH2N4ZDGqdqYHcHvNFSRQBmHp
         XIBK+0mFs4D+sZMnGRSVVzNct5smHR8OPxS+CajTPiMticYHy8rKTUq4xJShyL2Xw3Ll
         m1TmChzEo9uNvZuyfhQpFQiwZyu+2wDrTIZUakzozb/VGpf72/BPZtlN+H/f/uxkfXDY
         YSRw==
X-Forwarded-Encrypted: i=1; AL+hErFidl0HJNjoSny1D/iwMq6P+d6wahM4jSYOTUA1dICtZRZ1Lc/liSaPVHWaBEUcEB43emmUgQQjnV8=@vger.kernel.org
X-Gm-Message-State: APuU4Z9weppauy8Pwl1qTh2LmZCTaCqw9wNT8plQV4oyxvhFpYHSnpej
	nMktFHVAy/y6lr13/prPJDPZ8oH303aApEat7zOagjye5FaG/vXkaheC
X-Gm-Gg: AZFdTZdSMlSYXOIT1c7GuDReKqQBH3U8KQxQhDoiYYohzQ2CZT1NtJ8su+XLOuK3IWh
	Z1pXhdVwkuvNEZxw/p69aeOzRiUyctrZerlyL8/CtznwYXWJVIaQbxQ7OtxLHfD5b7jnGvbLF72
	01+hZjN3gVtJ7kyXf39Rm/9/3NPlLruSD8i1aI56SzstXxogwR8XCNFU5ODFheiREFruUsk0Whq
	/Y8VANhqAGvuQTyIdFeSmYfhF3SEUoe12wieCWufgYrG2EmU8YZbU8Pt49A8FJRyQxeCRxcGwGj
	yvydUULIoGWfAFEfS6O7KW9Bmj3kWSt9CLDNuE6LjcxBKjSR+zYJPoYu6xEDEKKbdGnWuYgkx/c
	jXmv0t4Pf3seD6QjV+Urg7Ho512MqLk8tROzgUxZ5PxsDbqbIhHZZenTaNwPG/sluKxq/9tKsI1
	q7YBojfhZou7+LtzvHWlSqBlIQFQ5JuDNgiPzUdnaOaVc7Kw1w7Sv503iBF0miu20DqgoXsfy9V
	SQ5zNgmp/D/C4LRwiUkYAqWasyYQHh5G4V485veN0z1Jes/GuVf5SGXGSglt81Z78wT/+A/SBtm
	xHelMAKv8Xtx+VEXaa966MMR5vxn1iPJb3mq2xzgy4lstg+P
X-Received: by 2002:adf:e014:0:20b0:491:8462:20cc with SMTP id ffacd0b85a97d-4abb400c0cbmr5198457f8f.37.1795185852061;
        Fri, 20 Nov 2026 06:44:12 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf62f7sm6426849f8f.13.2026.11.20.06.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 06:44:11 -0800 (PST)
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
 boundary=8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 20 Nov 2026 15:44:07 +0100
Message-Id: <DN049T7Y67NZ.10CIWW8DE6PP5@gmail.com>
Cc: "Lauri Gates" <lauri.gates@gmail.com>, "Dave Chinner" <dgc@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>, "Christoph Hellwig"
 <hch@infradead.org>, <linux-xfs@vger.kernel.org>, "Carlos Maiolino"
 <cem@kernel.org>, "Christian Brauner" <christian@brauner.io>, "Darrick J.
 Wong" <djwong@kernel.org>, <linux-api@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
 <ocfs2-devel@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <linux-cifs@vger.kernel.org>, "Theodore Tso" <tytso@mit.edu>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <av4Hn9u80fs8iHZ6@dread>
 <20261119095943.85048-1-lauri.gates@gmail.com>
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
 <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
 <DMZJDGMJ1RVF.32ES391JKNFGP@gmail.com>
 <CAOQ4uxjVQ9cjV=_jBjQtNg9zCuWUEJT9KNYMKV+1jwBkHen5OA@mail.gmail.com>
 <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
 <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>

--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 20, 2026 at 3:35 PM CET, Amir Goldstein wrote:
> On Fri, Nov 20, 2026 at 3:12=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>> > With non-zero xflags_mask, internal contact masks
>> > can be used for -EINVAL not for silent ignoring.
>>
>> What do you mean by "internal contact masks"?
>>
>
> I mean that users do file_setattr() with a bunch of flags
> some of them are just ignored randomly without any any way
> for user to know about it, because this logic is some internal kernel con=
stant,
> which cannot and should not be documented in the API.

Ah ok.

Thanks,
koraynilay

> Thanks,
> Amir.



--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCawBctwAKCRA0bnTtJTDo
OG67AP99DCLnFsLMHCsRAeUitR3pAiNRglGbALKnTbw7U718dAD/Rbb718IIJvnz
/T8g9StMlY2VrgWntvlMz+RabJ8OUgY=
=dJIP
-----END PGP SIGNATURE-----

--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd--
