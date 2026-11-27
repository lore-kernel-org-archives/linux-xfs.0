Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795769327;
	b=GcXkDhF+RHY9yCg2XPhUNeP6RzaWzyYTd0WQdhP6tjmosz9ma2c5Nd9RctNfgTssFfb9
	 P5fyhkW6ybo6jlrEnCl/LZ7rY684AQ3ZN9N+n+YQKapOIVItgDO40r+fNUzcNwlBQ1grG
	 88ka8Tt2xfsfsSeQzFDZMUEq6DzIfxWOfGu9ZRgupq0773b/+Aqj00b8RZ3aWJhCyaam6
	 l3/Hkb2DaNti/AwLr1F6Q63mreH9zKLhiFnzN1NmRmM0n3dMTvWTNWIXrgyl6AL1GY13t
	 kOM0ucDOU5eD2SG3r9U4p9h/Bw32EKw8G5k+C+oBRFqyfXVY4LBmQqfb6C8Gq945ZQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795769327;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=IDez9NqT7Tj1QDvV6FYEN7zWNFn2T031QM3aseBOhj8=;
	b=qF/QaUAPciCIGrvwVcnvc8SaQd9YoVgok4H7tKHJzrduP1m2VFFx5WfV7LgxbjCJ0y06
	 1SjwXlGoEHcFstRSRE5dAEGQG50EVEjGqUUYpzggQv6WayYafctwMfTle7SadT3aVm+8i
	 ASzf8F7szFoMarvole+iAj5FkwFG5IWL93XbP1G2CIn/rj/dZXJ+Bu+HmzfYDtCmsYJsC
	 DLrJmKr1HO0jZRH7vpSRDu6O0K9GtpcuM9wobmNVUaKjRPm7iDQ4oTga3f19784cWUp8K
	 AYwNKsJPl6qP0Qa4FBXqkd0VXiMXq1L54NPK74OZn9C1EzNeI8gLiUIC0ygfPc7syvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dbJOZn5M;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D57606A321
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 08:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90D57606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dbJOZn5M
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso76852755e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 00:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795769324; x=1796374124; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IDez9NqT7Tj1QDvV6FYEN7zWNFn2T031QM3aseBOhj8=;
        b=dbJOZn5M3rCgRLPPOUJ++VnJKMJQm3Ohn3x6VlLjqOyC2bNT9/mOFF1yxLOyrzF1bl
         C+Kj5lfk/G5v+Ibl6kXxQpP75b5N2GOnPrygQfOpb+hL8pJdLWW2ruCSdOPWljpoOom9
         3k2U5q90CgtKcvQNVpmkgFpbHw4JRD8hnkpuKZMsHjBoE3LC1jnUEnzmSEuovDxk9r9t
         Wtqp53MEml1QkDIqwqCWvYw2/rzLoJc4/KbtnJ3GcoNMKSCSq01qjbob847q1eNmgWQu
         Cney17f61yibRSRiKAu1tIAGEODdNaIqbSZsxA3cV2i7XAT3GC/VSTY+hR3Urp47LrxJ
         8cOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795769324; x=1796374124;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IDez9NqT7Tj1QDvV6FYEN7zWNFn2T031QM3aseBOhj8=;
        b=HqUxVCNTnxlI1gp4izDxdzJ2/hcxlS5sqvC0sLY+NcV8Dwgz9axiCIhlgb/J5dIoEj
         5u5pS+q1SRF77LcyAaUOWmiOpgtRGS89SPNrAPtqGQ/GqihadBmMSgHp6KPIjGIDWPuN
         HnaQ2RchixdWOU66MV6sK45/v4ZV0PpdZGJGYlUXIMnmXyYAWh8wzqJbk6cNmVCY0HKl
         fgce6VDFP32oX2V+Rm/Inq2aic6w6i3T6i5VBvVlMpiLLGjvtVnoh1v5BKqkgCtgcPSz
         RXhSypF4ztYD4s42sp+aBbcE0Wmuq/wDyFgC3RdS/GV+TYvkI3YzUaJYsqnJLGlWetXd
         P09w==
X-Forwarded-Encrypted: i=1; AL+hErH2cg5r/FbgMy+pHF9dwiKPP9dRGP3u+Bj4dxz30uZYwre4TAHh9CVwlQDMe3nXMLTHt595HGu724U=@vger.kernel.org
X-Gm-Message-State: APuU4Z84ekOgZGtBfi+TlCp5jkaOtvz+eEqFtBB3vTrOVtln06rBgMPE
	/ZFfx/IfeguK+Yv7lnLiY+9SzO5awR5gK7JZSAoucKwoCPi/NMvDZROJ
X-Gm-Gg: AZFdTZdUUuRqdnMYrD7EBoNXDJThuG4BZrnJUHfakW/JUiLqT25HDB2BL5tVQqvt7FN
	NWrX8dH8F0JEjJflMIJs5/3zhBTTaTyV9awTm/gqi8u3KAlqObkfgOrADs6dZADBfOYFwLlyW7G
	pW8LSp79sZm4PWjA2401NWIzPGlZNZkF7h6n6cmm3fCu4XysP5+DGx7LaCo8QWDqlbsQNrNGU07
	Zc8KOHNb1KKKAIedBu2q6eNFRF8OVbm/sXREOLRUV3UnJx8FXC2GAqt8sZHRshyBYHB+oRfTR0j
	x9s2ox0rgAvaZqIwUu48KGW84WLMuCwtTBccm9lNZcnXIBUFso5wsabdbhoNeI18+RGCXBV+KsR
	dP+JdBofqMW2fxQH+C0E2w9x2Jpl95NwKeLButTQq2ABSAOdTyzdpr+r0Qcsf54frcl3bBQg9gh
	i46MpkCm9D7EcgzWv7jq/QqpWTSUBWFdQZ3OejyZaHVW5ZQjBnJE1FW2tV078i3jKhTWs+ZOByF
	IUN395wceoVLR8NTurORcMeIf3zsTAUDjjrv40He+eGhNl3CfeemAHmkVd8aEqe7DKuayXp8GnD
	oYm8i0358Nlw8fTH+TNgTOrTth4iPPjwHvzrjxTsXvf23mCkgv6t4jRjtO/pYKwQjJTDvQ==
X-Received: by 2002:a05:600c:4f81:b0:4bb:5e8c:13bc with SMTP id 5b1f17b1804b1-4bb88805902mr454676765e9.7.1795769323802;
        Fri, 27 Nov 2026 00:48:43 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906635c7sm426511305e9.2.2026.11.27.00.48.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 00:48:43 -0800 (PST)
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
 boundary=c6f8ca06bd0087fb130def184d18448cb7c766d554c063c5f32d1cf88680;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 27 Nov 2026 09:48:36 +0100
Message-Id: <DN5V3F9BWZNC.ZIJY7Q6XMDOM@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Eric Biggers" <ebiggers@kernel.org>, "Theodore Y .
 Ts'o" <tytso@mit.edu>, "Jaegeuk Kim" <jaegeuk@kernel.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan Kara"
 <jack@suse.cz>, "Alexander Aring" <alex.aring@gmail.com>, "Darrick J .
 Wong" <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, "Lauri Gates" <lauri.gates@gmail.com>, "Christoph
 Hellwig" <hch@infradead.org>, "Dave Chinner" <dgc@kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <ntfs@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] vfs: use goto out on error in vfs_fileattr_set()
From: "koraynilay" <koray.fra@gmail.com>
To: "Greg KH" <gregkh@linuxfoundation.org>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261126163114.403846-1-koray.fra@gmail.com>
 <20261126163114.403846-2-koray.fra@gmail.com>
 <2026112647-earful-frosted-6ef3@gregkh>
In-Reply-To: <2026112647-earful-frosted-6ef3@gregkh>

--c6f8ca06bd0087fb130def184d18448cb7c766d554c063c5f32d1cf88680
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Nov 26, 2026 at 8:05 PM CET, Greg KH wrote:
> On Thu, Nov 26, 2026 at 05:31:11PM +0100, koraynilay wrote:
>> Switch from using if (!err) { ... } to the cleaner if (err) goto out;
>> in the main body of vfs_fileattr_set().
>>=20
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>
> Real name please.

Hello, this is the handle I use for everything online, thus my "known
identity", and even Linus himself in Commit d4563201f33a
("Documentation: simplify and clarify DCO contribution example
language") said
> And despite the language, we've always accepted nicknames and
> that language was never meant to be any kind of exclusionary wording.

Also, I already have a few accepted commits (here[1] and elsewhere[2])
with this DCO, so it shuold stay like this.

Thanks,
koraynilay

[1]: https://lore.kernel.org/linux-cifs/?q=3Dkoraynilay+%22Applied+it%22+f%=
3Ajeon
[2]: https://sourceware.org/git/?p=3Dglibc.git;a=3Dcommit;h=3D29803ed3ce

--c6f8ca06bd0087fb130def184d18448cb7c766d554c063c5f32d1cf88680
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCawlD5AAKCRA0bnTtJTDo
OA8rAQDeEx1D2WxXRvyGunXEuOW+Cj+dElpy7MJchlEm/WMNBwD+JvucXkEupO3z
6yiHSY99QVuCP3aqlN/orccezZlLGQ4=
=mM8H
-----END PGP SIGNATURE-----

--c6f8ca06bd0087fb130def184d18448cb7c766d554c063c5f32d1cf88680--
