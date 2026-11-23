Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443738;
	b=DiwGNHvdM9KdkNT6FAgc4aQPsSWz1rAimtP0RrfrAdzWJG5+Ssv3RkfeSkdVzw05RF9R
	 KNKQthLdFxGxrF3OLTc1zbboTFC8iQInqTRNyTz7OCVeZ/uTOaKM8V7HqZkB91juuuTtm
	 3eLDoRda6PJEFoH2FNq6VdtXNuGLi0ExXo44hXLxN4s0PJhsD8x0T6SEU2+Wpwp55B9tG
	 UYueg6xJn5SPv4oErP830FPOt+iDxSp3hiYib9XZZENaQwu0QRrPGRxF+DgwJrkLIy9R/
	 GRlOlsb9/TYE9/B7LStoiXGFONov1OzGGj1+VYQ0D3kB+8EZ7t8ZLCkahu5On61vo7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443738;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=MWpQl1xkyrhsa4v1aNpU05mPb+pCD8JS1KWXDWW/Gpo=;
	b=UdBEdCmECij+J7YmnmREKLt+KgrC8wd6A+beR7SssDLq4C2nwCpAadEG/FjFeXxBuaxs
	 l+7I1pbwVWXbBmK0+TGmwBFBhW4QeKgDQ8/Mr1//2KRm806r0CtCTRtDBkLU3OwZjXgeA
	 b6+yzukuc3kdVF+o5a300DcknYIOCQFz8LqCyH9BGBLQ1chJKPTi87IqCDA/dyp+fR2PN
	 SkyP+8nqlavIulsR7mHxdD0SEmZ5N59PnDD1tx2RnnjV0/9d7oy2pLKJa/NkA5Evc/xaE
	 HQON05OWgTad0yeHcJEtrjiuPlwwloZUEgwkdiTMlvqipM/pRigFkpHU47FAJ0uXhJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=00fZwspv;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84737606A33C
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 14:22:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84737606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=00fZwspv
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so30770695e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 06:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443737; x=1796048537; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MWpQl1xkyrhsa4v1aNpU05mPb+pCD8JS1KWXDWW/Gpo=;
        b=00fZwspvrkZHzlXeIp1sk0DPnZy6zbXYi6zIJ3d5v+w1NsTls89lOgHp7t/tKAch7D
         Hd4wIO6XRRuOp6DsoVpuy1fI1JBPDAuB4H2ar/Lx9QF9UMM3I2Bn+apTm6C02HriyEjS
         KA72OMzw0B/nPuHEn1s5VR5vbpTHGND2TpdI0u8SjlASUOf9KvX7qqbdv4pthaNSOPjC
         CBP+ouQep439U4VPJ4zVW33k/OEd+wxFLAmiROh0/cG1vbpp0ujnO+YiOIBm4UWAjdd7
         OjHijbDRGvuUxSrmtMDu3hyafB2uG4C7Vi4d2cljbIB0BPnpF3JySA7ndBemr4CxbXa8
         8Zpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443737; x=1796048537;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MWpQl1xkyrhsa4v1aNpU05mPb+pCD8JS1KWXDWW/Gpo=;
        b=NxXwjZpkV+imfb3D5tdQ3rZbIwMaQ7exzovy+xi0TFXk8uFYsU4toDyBDmcnWrIgHO
         ttyXOleZKMlbNUWl2tzqKFjSWl6NZsUwBingXgT23UD/nbYTG1Q+pv+KvshflmIF5Osg
         5RYvAinV+v7EClVjTdGqvZFzXIEXSH30pcpRYe64P8vxaYVoDrF9tNlt83oTtKjO1Jx3
         +NVvfR+HH+SS98xhCULmvkgqDrmWJ/eVEJt1B0YAc9yXjQ+/tgJscT165osTEGVGlNPj
         XFifffLyTxSpOuxxGoW7perHX9n1HXT6tsJL6dxeZBkaLcz3ziPKiIUQD9JDZ5WbwQSW
         ddHw==
X-Forwarded-Encrypted: i=1; AL+hErGHVlg/FostCLO5DYqVnaW8Rt52e8dGZJCLEbRotiVph55HZ4FJwP7USeaPppdCsy8/SXzsEgWAgdc=@vger.kernel.org
X-Gm-Message-State: APuU4Z85Z8gqrNnFrw8BWwXq3W2v9vl6+3gBCzmYi5oTdH46z4rwhRIZ
	gpq6GaMEyK3lstVRMJ5r86Pgj5vQyHDVu7mtNDYUDdUFkBbVtF1HuPIR
X-Gm-Gg: AZFdTZebUjap5XuemXqPkUEtSbKevRFB2PYy39d9tlZ9i7NR43CXGR03MZpfHj1R456
	eoj2g0TZjLYVLuBXgGFoLYxBfP6tQ1GVXijfhJ+NIJ2ZpTqQ6t8Y+R9Db7FzLOEWRgtvRiBNawE
	rvplAxIrLki9fcDIcS2+LQr0zrpcaXS78CASrs6T4mQK3yglt9jObZYo54wO/eE9GMeuT0TDBcb
	D9a9hHeaBr/XZj+S5Eylz0q19TeUV7xJrlRqMjricQ94buy0fMZl7FJU3LhzCXReZCwSuFOzQXg
	U2S2jGQNhGiW/QKbHOE1d6/GU47qMNpuVFUlGP/0ZFp9kt0lDJIzXjdPGY72diNFQL+eFAq5Pyj
	Wnd5QhDHwARG/khFrZZjglAQK/ONzZj03gbf7M+vVEANwxkSa9kAAywGUvmeHhf1HMe9w8XHL4I
	SE00IDvXqjb2rXedSK6lRc5xhK8MJC6Urmy/9pPMvddZ8h9B6H9fDpAa++NfKHmexPh4cxa3oPB
	Pbi0z66fApqRP42hpfR3+vX0vlIqggm5d6eqDqQhbkbx+kLVhNcFihIj1+7JMG77qEc3mdFtgzD
	MmM2Dia8JgAIozloAUsT0YDa2g==
X-Received: by 2002:a05:600c:64c9:b0:4bb:679a:86ee with SMTP id 5b1f17b1804b1-4bb88938dbemr253115345e9.29.1795443736768;
        Mon, 23 Nov 2026 06:22:16 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm170939525e9.2.2026.11.23.06.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 06:22:15 -0800 (PST)
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
 boundary=6835006247ad5b556582ac77c37dad0d5918ae309cf17b9da0cf6b359cde;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 15:22:13 +0100
Message-Id: <DN2NOOG9J6HX.1L4IO84SKCYOG@gmail.com>
Cc: "Andrey Albershteyn" <aalbersh@kernel.org>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Hyunchul Lee" <hyc.lee@gmail.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan
 Kara" <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH 1/3] vfs: use goto out on error in vfs_fileattr_set()
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-2-koray.fra@gmail.com>
 <awP8S5KF9v-nqWVY@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <DN2NJH234CC4.2LSWRSOO4TX5I@gmail.com>
 <CAOQ4uxiREfVU-WKiUVRZLb-uzMXzDEsmG13FVMW7YBoyq10=Nw@mail.gmail.com>
In-Reply-To: <CAOQ4uxiREfVU-WKiUVRZLb-uzMXzDEsmG13FVMW7YBoyq10=Nw@mail.gmail.com>

--6835006247ad5b556582ac77c37dad0d5918ae309cf17b9da0cf6b359cde
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 3:18 PM CET, Amir Goldstein wrote:
> On Mon, Nov 23, 2026 at 3:15=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> On Mon Nov 23, 2026 at 9:42 AM CET, Andrey Albershteyn wrote:
>> > On 2026-11-22 01:08:54, koraynilay wrote:
>> >> Switch from using if (!err) { ... } to the cleaner if (err) goto out;
>> >> in the main body of vfs_fileattr_set().
>> >>
>> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> >
>> > Looks good to me
>> > Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
>>
>> Thank you, can I add this tag to the v2 version of this patch (since it
>> won't be changed, and link to this thread in the comment section of the
>> patch)?
>
> You should always keep RVB when re-posting without meaningful
(RVB =3D Reviewed-by, right?)
> changes to a patch.
>
> That's how reviewing works.

Ok perfect, thanks.

Best,
koraynilay

> Thanks,
> Amir.

--6835006247ad5b556582ac77c37dad0d5918ae309cf17b9da0cf6b359cde
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawRMFQAKCRDmj22qf5IG
XCZkAQDH8wiuPEqDaB1cat+NLbwVTy9AgTGpQeVFZlTodz2juwEA00+c7xq8+RtC
rQ07nQ+3av0Gvb1S4BH2IP+66ik5awQ=
=/Ubu
-----END PGP SIGNATURE-----

--6835006247ad5b556582ac77c37dad0d5918ae309cf17b9da0cf6b359cde--
