Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795470310;
	b=JE4a9Roo58pS+ZH0nzZpMPVpMZe/vLSPmBRqbnCK3TKqOpji6GMtkCVt7QqX07SJexhQ
	 DCLLb09bFURDJplPPuoyWL8kjl+9+EE7JaCVnKD4lsH+Q4+Wdk7DpVkyuP25k3EoX8G/h
	 3bOg6Zluqa9i/KFtx4vpLp3iPMSd/1OC1SazWYggbiC/zSF5UET0hiUPD/vvTaTQIttMC
	 2EoUgXDUdyEBIct+hJ62zvXuHlbe+71fOVSn4bfrWZyEZvj8pjjf2CjEUPXX+/+H0iiTQ
	 S1kzszOTLKw4lrrBePSQzzKFYRb8U4XiNI4LfnMoR82izgCuIKD+WgfG1S7M6l8ukOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795470310;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=LkpmMbGmbwOY5rWgpls3HX12a8MYucO7aG0St1F+2Jo=;
	b=DNmq9cfjBLk6Wv0MSQN7nIiLv5xK8BCAjdBPMx7HQYJOkP4U+BDzr6wDbYpNZiN1eCTn
	 +hDHqoPqE3NGhQ1yOvOG46bf/6nAhHoYmM7IMR6Pn4TvHeQujJyzDZ6csC88/c9wvZBKp
	 w0M6XMC/LVohJl0Vusu6O8U27vfJ3q39Juqt6pNz9uBT/6iF7YsDCKx3S0hjTIYisdnWV
	 +xjo61XXgtYfYqIrl4HfotR6Fnj3iP3I0cgQEK+CYmmJKl+coBSS7MKp2P8/4I4I3VYMo
	 G2l3nNyOyovUm//4ZukoISd6S4s3xzzrRsqpUQYW2IEIUjrTF+imQ/vNDyF4fvRI+LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VZ0qknZT;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B8F606A331
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 21:45:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7B8F606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VZ0qknZT
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so21763305e9.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 13:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795470308; x=1796075108; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LkpmMbGmbwOY5rWgpls3HX12a8MYucO7aG0St1F+2Jo=;
        b=VZ0qknZT6G8jiDP7QwV1V0pKiCHfdpHhv+ble/Qqp2dsIvFkJZWZEQo9bOyiSNJfxd
         S62RlIDUJbUvN3ioWmiGkyqYIloVbEYSHTae7xvHfTYjToSl0gWsie7uEe66mU9suH3p
         OVMHRCvIk0WsbVuDVgcLSNPF7Ec0HXwEKBtOuom5CsvElRQA+M09E4cfcpO+i6PBdryb
         ntAhjU6XZ90W6FYquDYaWxhvbvTHEcYGCuWP5AiwluJI8NENSfLLy/pk0lrjhY0kyvi0
         bgVXn3+C6HgJDHqY72JeJyuVhniaC40uz87cw3lEvo4xKYC0niCxsDe90FBOCsZpGKYq
         0TKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795470308; x=1796075108;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LkpmMbGmbwOY5rWgpls3HX12a8MYucO7aG0St1F+2Jo=;
        b=AEz26l8V2tuZjN5ZJZSgh+2JFRJpfPLUYNcKRtRmBWsG9V+zmJgs/NUler/BuknUy0
         60Ctb1yH+aocH7OBEZjF8PqrC9FfScpOHgOvuLDfrUW1/1y4poDJsgslIayh1/2P6ws6
         rnLVVDP/dUQj9UZ5f9Fqbzy7/kmlRpbk2DagW7Vk/9OMjm7plBn88JqcykCr9XKsjpze
         W1es3SFmRfsYiyETFFBhVmfP0cYgDOrCDqPgAqe/bdG1wS3OCaIqwIMfFrjT73x9MtnW
         +46PRqd1ZZQvdJF97DedEjeB8anAKHH1KaWOlQ5kbTJtoc9FonfWQys6iL46QAUR36dL
         +alA==
X-Forwarded-Encrypted: i=1; AL+hErGMWz6aFMQ7XNfukLBuQ64gBVImrpBgtCKeQj2lWWRNsyG2vGwFcJP/xjxXQP8xyeoWwnCGkhNHhKw=@vger.kernel.org
X-Gm-Message-State: APuU4Z91wXZDntpk+e1ZZEDnqg5w8m9Je5YB7eGZSBCw3saPoML4phyw
	5dN4bioKisE0fuHH5Q2OZ9fdz1oGQTDD4CTT6dt75HjUarHK0XsQfSAR
X-Gm-Gg: AZFdTZckK2JD1FZu48i6k6QRjeZE6UejaS4ULgC9mMwoCGlyCSASJ9El2PhukL5qv8J
	h5fyF5CbsYEU5Iwg9tay+MGvZ4pQymP4LoCPsHCNkpn0eVwkAFfbd/xgClnMlO4hNpwcjq1csJa
	8U8Fe37I/YTs24GFewkFFFX6a67FeBImCDd3c1KgKDwe2zjQ0v+nbxDv5E7T8b583xQ2aqE86bD
	HCrADmMq5BD/qcluCo4DOYyvS4SOF4w0DkdWcgt/TANcpGBaAdprhMyuy7Eo9mZCYCtvkm+ufMp
	fshBt9BeYRsNdFo9KnPKqnx2cC6f7bFpno4vScyTNLeI8CcnNak+CUvsj9Qn21lnixzafCClqQo
	9BS8mod7F4PBXtoHt3x2Q+fJgXrSbGhOGijWf/BIUevuqlsjR7eYCUyMFyAwt3l/pBJ1IHrbJx2
	642n0oSc+f1owObYoH+SzEBkYWwyDriF8/QRMkJeDnBAj3sM1qxefPyAMZevE8EWk6IBLI53Qy+
	xeoiKRJR1sTUzx/1OovS631T/P0k8ZtA11rk/DuGvhJI05FBVU3ELtSyUXloeh6NC2sIX74NJ1m
	yYpVgSs0PZ06fyOFD7rjeG6vCUBaiPdhLVzbqHc3mXwdfvM=
X-Received: by 2002:a05:600c:a08b:b0:4a5:87b3:ddc1 with SMTP id 5b1f17b1804b1-4bb88922c52mr247479825e9.13.1795470307434;
        Mon, 23 Nov 2026 13:45:07 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88442995sm390803475e9.2.2026.11.23.13.45.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 13:45:06 -0800 (PST)
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
 boundary=f93e91cd8129c4ef5a6623f4aac998269e771b61eaa5f43d069bef622e5a;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 22:45:05 +0100
Message-Id: <DN2X3RC5JUFQ.2LNGLQOUX4ZPF@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>, "Darrick J . Wong"
 <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add f*_xflags_{rw,ro}_mask flags to the fileattr
 API
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <CAOQ4uxgf2KE=Ag13EPAu5=KnrFwt7zRH=im-qmLc8+i10Tjd+Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxgf2KE=Ag13EPAu5=KnrFwt7zRH=im-qmLc8+i10Tjd+Q@mail.gmail.com>

--f93e91cd8129c4ef5a6623f4aac998269e771b61eaa5f43d069bef622e5a
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 2:35 PM CET, Amir Goldstein wrote:
> On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> This is a follow up patch series stemmed from [1] and [2], splitting the
>> _mask change for the fileattr API into its own separate patch.
>>
>> The first patch is a preparatory patch so that the code in the patch
>> after can be formatted better.
>>
>> The second patch is the actual implementation, which introduces:
>> - fa_xflags_{rw,ro}_mask fields to struct file_attr
>> - fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct file_k=
attr
>>
>> These masks have the following semantics:
>> - rw_mask:
>>   * for filesystems: advertise which xflags they support changing
>>   * for userspace: specify which xflags it wants to modify
>> - ro_mask:
>>   * for filesystems: advertise which xflags they support only reading
>>   * for userspace: ignored
>
> Nice!
> I think this API description is very clear and coherent

By the way, should I use this description in the commit message (and
integrate it with missing information before/after the bullet points),
or should I keep the current one?

(current one:)
> This lets filesystems advertise their support for specific xflags, like
> statx.stx_attributes_mask does, and userspace can specify only which
> xflags it wants to change without needing a RMW cycle:
> - on GET: each filesystem that wants to support this new API fills the
>   masks according to its supported and read-only xflags, then:
>   * for boolean xflags: it fills fsx_xflags with the current on-disk valu=
e
>   * for value xflags: it sets the xflag bit to 1 in fsx_xflags and the
>     xflag value in the struct field;
> - on SET: userspace fills the rw_mask with the bits of the xflags it
>   wants to change, then:
>   * for boolean xflags: it provides the xflag value as a bit in fa_xflags
>   * for value xflags: it sets the xflag bit to 1 in fa_xflags and then
>     provides the value in the struct field; if the xflag bit is set to 0
>     instead, this informs the kernel to unset/clear that value.

Thanks,
koraynilay

--f93e91cd8129c4ef5a6623f4aac998269e771b61eaa5f43d069bef622e5a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawSz4QAKCRDmj22qf5IG
XFP0AQDoHuI0GUaYOoQkPYkvkC952uJ2NGRvnCWrDXc2mGNcRgD8D3IvRyNkeRF4
hY+IdbU3Ldb+X7gx8ejbGnOW7iQXcAM=
=P1l+
-----END PGP SIGNATURE-----

--f93e91cd8129c4ef5a6623f4aac998269e771b61eaa5f43d069bef622e5a--
