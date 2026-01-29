Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA0E344DA6
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 17:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769706643; cv=none; b=nTM9nMjs7z1/fWqT4yyYbL09TnI3L2U3HATQBjbMaqBW18uDI066V4pNQkIE0A1DPRv76Zi75RkAc3CdiFzFbQaOxyvB59096j6x855CIcqUUpsfzOukPLTyU7m+Z3Ni0KALEP3uMXjDX4NRzzOZualqsiV+bvTtwBdQYkDtC7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769706643; c=relaxed/simple;
	bh=w/LNeWAXYVi9drVn8Wn8YDU6shA2Vgfehpd/XK7hKds=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=EEQou11Kbuw83SH/BvtOxURJ7S5LDC7Sl4VYb7Xb89kqAyzC0pYPjjnIouRndX6lbHZrX5bbGPNKA9ikqRENOagkfn0vdUU+6NhRK9AD16hwRfErfgYpzVaXRWy5VOPn8Ldxxxmwm0nMLkgUmlkuNbL0DjPNspD1eucGgTvKIR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mL1jyJjV; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mL1jyJjV"
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-8230c839409so1120006b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 09:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769706640; x=1770311440; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=749boWrxR9GohsKOjzF9HdRImmXyhBe8V9MDPxWLjdQ=;
        b=mL1jyJjVH9WwHLTxca4teM+ynT8doh3/IdKHAxO0t3X5ANmi+D754J/x9CeBuLRnZw
         TM1y0bh7I1Xmxg46v1vlHYFqswjKbGxHNi9JCNQjielovt0cU7Ruy/tiy+pYS4bGIg6F
         vs/WY6cOMoTDxaKFGbgGu7PfP9wqmZFcnpcAzJs6WJbH6Z8VRgITarBRZLjxIqEpi3En
         C92cps3SvmoWbiv8sLidVxEq1KoHIUXRSVAvPfpqLxg/T97EwWoMp6uJ+XYqPuJ15pB7
         O9i8tU8gCDByvP1aWk1FId07C0/MsjetGJLCrTTo1SMPK+wcIS7e+1obAUI8WQkKuMcD
         syaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769706640; x=1770311440;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=749boWrxR9GohsKOjzF9HdRImmXyhBe8V9MDPxWLjdQ=;
        b=OWcsI5kLSqSDpD7KM+cB6XmPwHhEBieq3p4tciERoQpHjNz66iR7qO2W4GBrsLnBzs
         r9dh6f3C2b6VWwOONeRh6S50GJxaMZcejtq0N3nnLFSiU44bhRaj3Drq8noHZXHoOVRW
         4pDhkiCSjRildcjpUIPu0LA4fYJIt5iWePaiwSM2Vomd8L4yEeTcu1YGBJGlh4tIoS6g
         7d50N7WbVeZRkV03/2O0cLK1/XnHGWrBSm7LwoVRdFaN4jIYqSHMUk/adh7fioBbLeFn
         xdgNOjrRZ8hPsrparALnzjgZBvpd6RFyb++SS8zjhV5X7Ke6/xbA2FbHfle7ulcm8boX
         Y7Uw==
X-Forwarded-Encrypted: i=1; AJvYcCWCCQMMVLrUNhvV+4nbe4O7cXVT9o+NENlpeHrmyfb6bTH786wF7yIyKl/K2awBifoxszhkkvNpkv0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzT1dA3q7ZuWOZp0dH0YH9ruMfAH7wH3aONq5WTgqPDNmOnVEx
	77CAZQ+n0SDulomTD+m2mMzq+Ltw9vqo6afAN/7QKBFfvdepeQOBeqHx
X-Gm-Gg: AZuq6aI+OqhL53AGsZwaPsiDG0mwkWqoTtsr9r9xS3r5RPb1LEz7R7oJH0ghDzy4He7
	cjOSqim9Ihcq7q+iyL1PVYXzPyXDMPsOLdB3FCqa08MvVs4tdTx+C2XrnvK0P3c1CPOjc5tXfcA
	ZufmwWLBL54l55/hwOHV1nxPQMWyxql1r8dcHQWE+5UT31SlJAQBMw7G7z8i65XFQjSRcWvMyuO
	sKK6CYQH1uANf5UHfn+gqjjs22apqJuIO0/zCOQaee6Ww5mgP3pTBbrJrmTClxFTUuwPNTxBWbb
	eVi1VEGqmWvUnz9AO/DlrOpLjJRav0II6lkEuqh7YVPuTuvMk+HL7HKy5XWGg5MHRHNPiHJ2jcs
	Aze9Vc2bs9lVGKfAglEoL2V1uV4wYEvqmC055ZpWfR2LZwD8v5kXGmflYh/Z6o3ZqPHE+xg==
X-Received: by 2002:a05:6a00:761b:b0:81f:9bf3:6deb with SMTP id d2e1a72fcca58-823691975edmr6976256b3a.15.1769706640272;
        Thu, 29 Jan 2026 09:10:40 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b4e96dsm5929316b3a.23.2026.01.29.09.10.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Jan 2026 09:10:39 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v2 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <aXtdDnpguPkytiPT@nidhogg.toxiclabs.cc>
Date: Fri, 30 Jan 2026 01:10:23 +0800
Cc: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
 linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com,
 ojaswin@linux.ibm.com,
 djwong@kernel.org,
 hch@infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E34A8CA9-5A01-4A2F-9660-209D5E8A6A56@gmail.com>
References: <cover.1769625536.git.nirjhar.roy.lists@gmail.com>
 <e9f8457440db64b07ab448bd7d426d3eb9d457d6.1769625536.git.nirjhar.roy.lists@gmail.com>
 <aXse1lm9J66RTvwZ@nidhogg.toxiclabs.cc>
 <aXsgia9chv4y91u3@nidhogg.toxiclabs.cc>
 <d6020236-04e6-442f-af6f-0fd690442902@gmail.com>
 <aXtdDnpguPkytiPT@nidhogg.toxiclabs.cc>
To: Carlos Maiolino <cem@kernel.org>
X-Mailer: Apple Mail (2.3864.300.41.1.7)

On Jan 29, 2026, at 21:29, Carlos Maiolino <cem@kernel.org> wrote:
>=20
> On Thu, Jan 29, 2026 at 06:04:20PM +0530, Nirjhar Roy (IBM) wrote:
>>=20
>> On 1/29/26 14:27, Carlos Maiolino wrote:
>>> On Thu, Jan 29, 2026 at 09:52:02AM +0100, Carlos Maiolino wrote:
>>>> On Thu, Jan 29, 2026 at 12:14:41AM +0530, Nirjhar Roy (IBM) wrote:
>>>>> We should ASSERT on a variable before using it, so that we
>>>>> don't end up using an illegal value.
>>>>>=20
>>>>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>>>>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>>>>> ---
>>>>>  fs/xfs/xfs_rtalloc.c | 6 +++++-
>>>>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>>>>=20
>>>>> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
>>>>> index a12ffed12391..9fb975171bf8 100644
>>>>> --- a/fs/xfs/xfs_rtalloc.c
>>>>> +++ b/fs/xfs/xfs_rtalloc.c
>>>>> @@ -112,6 +112,11 @@ xfs_rtcopy_summary(
>>>>>   error =3D xfs_rtget_summary(oargs, log, bbno, &sum);
>>>>>   if (error)
>>>>>   goto out;
>>>>> + if (sum < 0) {
>>>>> + ASSERT(sum >=3D 0);
>>>>> + error =3D -EFSCORRUPTED;
>>>>> + goto out;
>>>>> + }
>>>> What am I missing here? This looks weird...
>>>> We execute the block if sum is lower than 0, and then we assert =
it's
>>>> greater or equal than zero? This looks the assert will never fire =
as it
>>>> will only be checked when sum is always negative.
>>> Ugh, nvm, I'll grab more coffee. On the other hand, this still looks
>>> confusing, it would be better if we just ASSERT(0) there.
>>=20
>> Well, the idea (as discussed in [1] and [2]) was that we should log =
that sum
>> has been assigned an illegal negative value (using an ASSERT) and =
then bail
>> out.
>=20
>>=20
>> [1] =
https://lore.kernel.org/all/20260122181148.GE5945@frogsfrogsfrogs/
>>=20
>> [2] =
https://lore.kernel.org/all/20260128161447.GV5945@frogsfrogsfrogs/
>=20
> I see. I honestly think this is really ugly, pointless, and confusing =
at
> a first glance (at least for me). The assert location is logged anyway
> when it fire.
>=20
> If I'm the only one who finds this confusing, then fine, otherwise I'd
> rather see ASSERT(0) in there.

I had the same thought before, and I think ASSERT(0) would be less =
confusing.

>=20
> Darrick, hch, thoughts?
>=20
>>=20
>> --NR
>>=20
>>>=20
>>>> What am I missing from this patch?
>>>>=20
>>>>>   if (sum =3D=3D 0)
>>>>>   continue;
>>>>>   error =3D xfs_rtmodify_summary(oargs, log, bbno, -sum);
>>>>> @@ -120,7 +125,6 @@ xfs_rtcopy_summary(
>>>>>   error =3D xfs_rtmodify_summary(nargs, log, bbno, sum);
>>>>>   if (error)
>>>>>   goto out;
>>>>> - ASSERT(sum > 0);
>>>>>   }
>>>>>   }
>>>>>   error =3D 0;
>>>>> --=20
>>>>> 2.43.5
>>>>>=20
>>>>>=20
>> --=20
>> Nirjhar Roy
>> Linux Kernel Developer
>> IBM, Bangalore


