Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443330;
	b=IOCsqiO2C+69mlfvixCyEvBvgKDBvpeX3zTSheAcVpoeYCCWKfU5to4wZIU23gpYokqX
	 bG8Igcpw4Kef+c9YFPb5CTdRIcPjO/1eb1KDp4923J+wWMr3vZQ0IhOMsXVaBBT+/jsC3
	 RPJWbZMW7iYi0e4dW8/XEN3PXtg30o5Ia4PloFBXREbXYU6MfWeSO+tXEKHdBDEEhcBjj
	 cLjXFIDH0yoOquJOVoqj+y7fMJgdn79YiS0Xh4bsh8nh1xLm01+GSo9WGNTWXZy5AK8CM
	 p6IkSB+iYBqUX6VmQvuot47FzwlrxTxBjpjCBFCrhmNZipxQJpBNVddF40rtDROT60g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443330;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=SVkCiAZ9hVspPzZuKZbqXCYeKQk4BcDbwlCFk9p1ut0=;
	b=y83yHXFHegTn2EJOSafVqSF/P57K9/NfpLhciQ+ua5DjAu4b8OkFkl28hlrcJTuBBcy5
	 EmLvuWGdUxZ9QGijImQg3MGpJpEECqg2vAFnRpYWzq4GHX0rk8itOG3bMe/+lNmUkKIFO
	 XhXbaQ8rLYJ5g5tKp7z+QC/3qdXAACAw/7Ou6rbr2yTcgoJWoogspnaiY9fBh8Sb7GajL
	 AaeUJ3noElxjbsk5A9WZKELnrqB0r+UQ2felqv36JBdl2/Q7CMe3kFn1Qoc2ejIlUm7xy
	 as+QjLZkOd4fGURt2rErkXqsK3jmnsEke0Pi8GLKJUGK8e1QCyXQ4V51lXoj5k3JgUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LhurUaLd;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B65D606A33D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 14:15:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B65D606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LhurUaLd
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-49412eb1474so2121072f8f.3
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 06:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443328; x=1796048128; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SVkCiAZ9hVspPzZuKZbqXCYeKQk4BcDbwlCFk9p1ut0=;
        b=LhurUaLdrrD6el1BtOOCJ70R+8KqK05u0u89mfuXWG8+J9Bw3rVb386658OMP5zMq0
         decyq5yItprIln2niTvSLmNubbRMdoF++9VmjkmrA05HZdXvZxDurdMDYBuXSM2/ru83
         DL0zGzc4TqwjCvYZ5gt34/pSFJf4/mCtDoKXgpXPt+Sv7g1Y86AFw3XQ6uM+o5M48dZA
         fsqr7/KfuhPw2PRwDKKUwpkICKW7wj5qvnFdYfxcb8shaROlLIM069A9F1sNO6bSCk2N
         auXzk8QjTdj3SnDJjqubihTVZqQWZzgbhHEkWSyJVafh+Xk4iboolLWwWkG1XoRweIGi
         qdfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443328; x=1796048128;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SVkCiAZ9hVspPzZuKZbqXCYeKQk4BcDbwlCFk9p1ut0=;
        b=1OueA9T8hexRQRbXOiTjSmFlzkIYQfLq4WolRWFkXde8r1hAoSuPvk+ArUER2PX0q5
         HSeVrGTqvKCU/URDcPLud9vbe5hWgJx2LaPnq3cqrcFMb271LQDOiuX2oQcfjczg3q23
         hs7B6Ov7W+ijdFK76+sgzFxlPP1qp02WgV1LoYGYnirwBIfMz+uQ1yJQICOozUMXWvCE
         Fo4QMBoOKPymRyhYaZp7UaWZHVBMcBDHCpl/P9TkEOOmnbXqoylh8Xmk+YHr7T95p5IC
         77RpctI1/f3r8crnv+QBm0ySF24cOmzu9/77YEZA96NSM92v0XN2A/FN0X31CX/+vnpR
         Kexw==
X-Forwarded-Encrypted: i=1; AL+hErFow8iN1/zYLoftf/Jrq7bWpJvKJqy5+vvZaZC9E/kHwzwOep1GpBaClWEY8C01DjHXBabVkKSDaaM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+7YQ/b+jfqqY9VddULQWzHybu/itvbiyIFcljocUv+3lkzfSx2
	SkGYsg2obeaI5eCYX2P12/HOgbvzlLgXbn+tDo+KTs2KW5JDpNXZOEt3
X-Gm-Gg: AZFdTZfAMxT0a9C2IHDmfKafpCXfJ7SIebQYPAqrqwYb3UPYk0KQBYPmhLfFGvheWPE
	VcpGkyEMcysogSuJoXacZDuRlaUOlaINReH5eWr3xrflE5o6tO55EUo9I+RpPNsavufw+EWGhjW
	73uy1zGIwwIILOGhVLh+7lRCC1X71qNLi4eVz/ybEzfKX4tBnT1OW0icDaTD0m3sDIGzJicGXfu
	GOyVjrBiR26+T+rOz66vxsQh/a+HXKvQ96//pZkF7t96LR9dNDm3H3CZZtByr2Y3w42QIo2TmIF
	0KtbbE5yLvvqtKZz6YdwEQnLEm8V1tT8tFMxA+t0CTHRXnGs0DEtw2raHMjXQ9cYv2aqdj2uqAg
	2y+Jq3AaS3mDPNpmAJq3G6GEn5WA7OKAtO2rywq053ZKonIFU84Fk4p6aLuntIspanThRjGn0uy
	MjBjttWCyHQ2XtaVQ8/7gYAjnHc3usxBZH9CmU9jBvR0tMrUQMUuTIr/saRaW/AZUYRAhv9GCP5
	TXKoDXB1pINeA2+AiLR1yb+zskumHDon9ZIvvn5GbtIZFpaKGMdKpCtp+fDnJk75zHim08x2zy7
	SfFgAZHQM7SGb2Mj9OQN6bPyjxw=
X-Received: by 2002:a05:6000:4b0f:b0:48e:d7c:4bc8 with SMTP id ffacd0b85a97d-4abad6a1782mr21438558f8f.7.1795443327853;
        Mon, 23 Nov 2026 06:15:27 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ad6403fdbbsm15815535f8f.15.2026.11.23.06.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 06:15:27 -0800 (PST)
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
 boundary=d4d0d8ea600ad9a6a0e804d6ccca97eae7564ecdc87e5749b6027a98fdf4;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 15:15:25 +0100
Message-Id: <DN2NJH234CC4.2LSWRSOO4TX5I@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>, "Darrick J . Wong"
 <djwong@kernel.org>, "Amir Goldstein" <amir73il@gmail.com>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH 1/3] vfs: use goto out on error in vfs_fileattr_set()
From: "koraynilay" <koray.fra@gmail.com>
To: "Andrey Albershteyn" <aalbersh@kernel.org>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-2-koray.fra@gmail.com>
 <awP8S5KF9v-nqWVY@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
In-Reply-To: <awP8S5KF9v-nqWVY@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

--d4d0d8ea600ad9a6a0e804d6ccca97eae7564ecdc87e5749b6027a98fdf4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 9:42 AM CET, Andrey Albershteyn wrote:
> On 2026-11-22 01:08:54, koraynilay wrote:
>> Switch from using if (!err) { ... } to the cleaner if (err) goto out;
>> in the main body of vfs_fileattr_set().
>>=20
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>
> Looks good to me
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

Thank you, can I add this tag to the v2 version of this patch (since it
won't be changed, and link to this thread in the comment section of the
patch)?

Thanks,
koraynilay

--d4d0d8ea600ad9a6a0e804d6ccca97eae7564ecdc87e5749b6027a98fdf4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawRKfQAKCRDmj22qf5IG
XGk/AP9j2YLEmAts6UKmrX6qw0EDoHRjv0eLrfHDRJfhkjSDdQEAixfLgqqT3tMt
wDbEqGGddyloPl2sCvNgcE83htldvgM=
=8yb/
-----END PGP SIGNATURE-----

--d4d0d8ea600ad9a6a0e804d6ccca97eae7564ecdc87e5749b6027a98fdf4--
