Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795474624;
	b=e4Xrih81YZwBfdvJyDuzKBbSbXCxiekAzz5EMll0mgh5ge2/uoTK34vE+lCx7Ny7AfjU
	 JOUUvt9pn0qiU9dqFZ1iULEgx5LE+xotFg49doVPCMdmI16aY2i6H2HSLcz/2F2rM5WRg
	 5xHohWgbCHZTNnsSp2+PwfwXmjTYHd6A3AGAp7bt+jiW8hX/UoFKhn241rmk2XQZ/s46x
	 SYkGxAipreUktlKN+NLCuzucWDdcKPKJNwEEuS1/jWDx1OogFoAAzjFFtAakoYL81WBX9
	 4ujJdk/jZhfHbWJTwOTdRZt/L4clpeOF3BqVuojFRMCLnL/+a1P0GtNhJTSJDGrolYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795474624;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=sPZNFd5TfGrxBwoDp6YQ8+YhzR/t7dsRFdx4A9ccfqM=;
	b=s6YTzPJgxmJl4bZTVgDg3T4d2l+FmprGuqbRSG9WKsUutQaZM6aIU2NJZY/tQ6CuXf5Z
	 6KLvPgg0p2e++b/rtEg1Em1IEVLPWKRQG06mPlHWedc37nsQpGNbB+ft1YQJ/5jf8aXtZ
	 2ybD8VdOimr8qp0CbIeVb6rI4UjulHa70diPwFsLPb4h4vRHQkzbAV7KEhAdKKlGtL1o+
	 7OBu7xevViyUDsrii4OmYXgshUeaORNAM296eFR5iZkgamBzTN92W360V3mohkuEU+Vz+
	 RyY+qUHAqqqnGYfIoiIgc8TtUrQZstvIDhg131RWMcl9sTvb856ZLgkuuQX++MvLToA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PewkInMK;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3454606A321
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 22:57:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3454606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PewkInMK
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb606491faso21538755e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 14:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795474622; x=1796079422; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sPZNFd5TfGrxBwoDp6YQ8+YhzR/t7dsRFdx4A9ccfqM=;
        b=PewkInMK7WQWpp6ySCG05xMLjFwiuXGYIL9fT6a9KwzGgdXqRBYaifRH2CCs4oC+TJ
         9yZqvbx2J4HMbE3hwKZNoBP4BEYdOLnO9xsvu1PBjg/7W4cDDVA0+4WXZfc2RE7QhasK
         HBraF594yoj2LikLhvrb2Uv5n0XCn3YbuZuSWNI772TsKs/Q903J6pw0WdUqI96slep9
         QaYENizaotcREWserlmvK7cWFjPgOZzu+Zxvwi5t/OeIxBywZgqVsutE0njlpRfcI7I2
         xvsJnbiQ51KTBY56x1ixrtXxIhGs7unzaQaI1DlshSs+Tk28V9lawW84OB1kZabVzJ1G
         lyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795474622; x=1796079422;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=sPZNFd5TfGrxBwoDp6YQ8+YhzR/t7dsRFdx4A9ccfqM=;
        b=OOK/gGLLP8QMQCCT0q770pEDofQi4n1Rd61JIlsiNj6hfHMr4jCO6UqObW10I5z7my
         51mpvpErGAsbZpzM0qjqtERv56I4adNOA6OKcP9Dxn9KafxnBjBWUilfN8eH/LKB/5yY
         foNfZAtBTK1yAmdLc/IEeqivGhF9wkzosg9/mhM3ozdziE5UWSFa0bf4S7KItVZ3S+pv
         +wBaiNDNegpb5hUntuTdcM6O7dIlmxQZseTqBqNF1I07M79IHWdQRybWRTPtYuGFTFal
         BlO+oM9McK6JZ34hjzdWsU7cNFJrE0BKrHzUi5+YroIWAK9kOSRWyZFdM+FluPOMthJ+
         s21Q==
X-Forwarded-Encrypted: i=1; AL+hErEuPZoG59th7m8/sLfB4Y2FOSiikAvUACO52X2APKocmG5k153TiCQRnrdpifSvWX8b/U40wI/wCtw=@vger.kernel.org
X-Gm-Message-State: APuU4Z+Z5KnpQ9gB4Axj/GyDaI5P1BE+/15ujUMViWG1OQzmUW7ZLsr5
	u1NS34hog2BQlaH8G38H7r3qm+nPqKcepdQCfEUOS5f1pCtLbTqt6RLK
X-Gm-Gg: AZFdTZdm3RyXgnmJnEWIQNBs8lljJ8/cTVFhGQCiCSdgAf4ttAU6kfPwNcIpKPk/M7c
	A2MtQYgwzuspTDLNbtpNS8ByTN7lldb37xkK++tt9RpmwcmlCyckBHOnOiz8Fz3S1PM9jl1EvjE
	cCj6yL0gYsno5Ho47X0vBAIlIx1MpjfugCNgWrsIZpSIQNFHV8Ul5iQY9rIXvYTzAwyOKi+aUyU
	bSYEIxVq9mLIbrHOy9KljhcXgY8YwQaw6xJpuHf4MFvSzP9ALpGkygCaJ5qtReY1LyHYSZaiEvl
	OD73jOYHLcSvTBvA0peFCwILxjGuaB2BMoeFd3aWN71Hu0+5upKpqY9VzBs6hKIrfzwWnEiWA3t
	Iw8yahwogvRN0R6NbXJmD1LnjopDa3G+Pq8OI9SNYsyUdcSoHrHzMzPRHzMUa8VrE1H9MXJ4qlr
	fnOb3hFFxsSrMpEuS+jwiacpMlDsjdkOyBbfdn1nJf1X9kWtO7yKquy1+TW6QOqt5d+NN9HPHZ5
	z2hQVXXchO8W8BgINbn4JAX/pQAzCZ1Th5QMB2MhSRHUUK4wgu2VgI5psP+a28PoWEboaMrjRfu
	2MtSBJSPPSTNOc6aUFG/jT0C2g==
X-Received: by 2002:a05:600c:1548:b0:4bb:7347:d5df with SMTP id 5b1f17b1804b1-4bb88814405mr279680765e9.13.1795474622192;
        Mon, 23 Nov 2026 14:57:02 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884865a2sm387664415e9.3.2026.11.23.14.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 14:57:01 -0800 (PST)
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
 boundary=087e7b3569ab5fea48a039af92ae6dae8d0b4b3bd53fcaa587687d1ee3aa;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 23:56:59 +0100
Message-Id: <DN2YMTH77KWE.3IPE9OG8377X0@gmail.com>
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
 <DN2X3RC5JUFQ.2LNGLQOUX4ZPF@gmail.com>
 <CAOQ4uxhsv_1EEqAZ3Ebp5Uy8Q6nvEnE3EAomJjjQO86nTcW0cg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhsv_1EEqAZ3Ebp5Uy8Q6nvEnE3EAomJjjQO86nTcW0cg@mail.gmail.com>

--087e7b3569ab5fea48a039af92ae6dae8d0b4b3bd53fcaa587687d1ee3aa
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 11:47 PM CET, Amir Goldstein wrote:
> On Mon, Nov 23, 2026 at 10:45=E2=80=AFPM koraynilay <koray.fra@gmail.com>=
 wrote:
>>
>> On Mon Nov 23, 2026 at 2:35 PM CET, Amir Goldstein wrote:
>> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.co=
m> wrote:
>> >>
>> >> This is a follow up patch series stemmed from [1] and [2], splitting =
the
>> >> _mask change for the fileattr API into its own separate patch.
>> >>
>> >> The first patch is a preparatory patch so that the code in the patch
>> >> after can be formatted better.
>> >>
>> >> The second patch is the actual implementation, which introduces:
>> >> - fa_xflags_{rw,ro}_mask fields to struct file_attr
>> >> - fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct fil=
e_kattr
>> >>
>> >> These masks have the following semantics:
>> >> - rw_mask:
>> >>   * for filesystems: advertise which xflags they support changing
>> >>   * for userspace: specify which xflags it wants to modify
>> >> - ro_mask:
>> >>   * for filesystems: advertise which xflags they support only reading
>> >>   * for userspace: ignored
>> >
>> > Nice!
>> > I think this API description is very clear and coherent
>>
>> By the way, should I use this description in the commit message (and
>
> You could use that as a short TLDR intro

Hmm, then would it be better keep only this for the commit message

>> integrate it with missing information before/after the bullet points),
>> or should I keep the current one?
>>
>> (current one:)
>> > This lets filesystems advertise their support for specific xflags, lik=
e
>> > statx.stx_attributes_mask does, and userspace can specify only which
>> > xflags it wants to change without needing a RMW cycle:
>> > - on GET: each filesystem that wants to support this new API fills the
>> >   masks according to its supported and read-only xflags, then:
>> >   * for boolean xflags: it fills fsx_xflags with the current on-disk v=
alue
>> >   * for value xflags: it sets the xflag bit to 1 in fsx_xflags and the
>> >     xflag value in the struct field;
>> > - on SET: userspace fills the rw_mask with the bits of the xflags it
>> >   wants to change, then:
>> >   * for boolean xflags: it provides the xflag value as a bit in fa_xfl=
ags
>> >   * for value xflags: it sets the xflag bit to 1 in fa_xflags and then
>> >     provides the value in the struct field; if the xflag bit is set to=
 0
>> >     instead, this informs the kernel to unset/clear that value.
>
> You can keep it also but tbh UAPI documentation is more useful in
> comments and in Documentation than in commit messages.

and add a documentation patch that uses this (maybe expanded/clearer
since it would be user-facing docs)?

> You and I have parts of the design in our heads w.r.t backward
> compat with legacy API, both UAPI and vfs internal api.
>
> I think you should put it in writing to see that you and I have
> not left anything out because this v1 surely does get it wrong
> in several places both wrt legacy UAPI breakage and internal
> API correctness.

It would also be useful for this actually, so I'll draft it tomorrow
and then send it as part of the patch series.

Thanks,
koraynilay

> Thanks,
> Amir.



--087e7b3569ab5fea48a039af92ae6dae8d0b4b3bd53fcaa587687d1ee3aa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawTEuwAKCRDmj22qf5IG
XJSLAQDMKqaaLRonYupOnklcoeYgChReKj8OE4zSSu89z/D8OQEA7usw5cak0k1z
cR5yX9avh+N9tPTBs/BRmKcdA8wcowk=
=072h
-----END PGP SIGNATURE-----

--087e7b3569ab5fea48a039af92ae6dae8d0b4b3bd53fcaa587687d1ee3aa--
