Received: from mta-201a.earthlink-vadesecure.net (mta-201a.earthlink-vadesecure.net [51.81.229.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294B352F28B;
	Tue, 29 Sep 2026 15:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.81.229.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790694830; cv=none; b=F4bWhsq6UpT8AG6q9FQMJdXVkL0B0nsdqfilUxw8a1n2jAQ/iJ2WwCg8KDCsp8p4zJoWTuR5jqR9l/1vEfdQSVs+eKm7Sf/se87p5Bnv8jtRiUhibr8yLpoDfAu+2Yd+ix4MUKmbp8kMwmrq5Q/khfWJfWkxFLGLrO+c/KueCDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790694830; c=relaxed/simple;
	bh=7dljAa4C1wt6iVIQTOKsMI8D3vH3A4sVO+d/NbxzvkE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=GI7wEl8nYrmgPHYLzRVJ5z2ZLGVQGA7vsYtaY2qkJ5yvUkKruXvFWB07opz1cQADpic0+ckJH9l1Y3lhuxt+pV/SLLgMz0DaJmygHwyzfvhrtFRdFXvOPUaN54KvGfuEbs+zJsIneJpGofLzC+e98Sh3K+B9KZXt5mkCpDRwOaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=earthlink.net header.i=@earthlink.net header.b=gcch53KU; arc=none smtp.client-ip=51.81.229.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=earthlink.net header.i=@earthlink.net header.b="gcch53KU"
DKIM-Signature: v=1; a=rsa-sha256; bh=b7XBLzCH56VpIGuehNu0uRprj6RKU43lZEumxo
 FtC18=; c=relaxed/relaxed; d=earthlink.net; h=from:reply-to:subject:
 date:to:cc:resent-date:resent-from:resent-to:resent-cc:in-reply-to:
 references:list-id:list-help:list-unsubscribe:list-unsubscribe-post:
 list-subscribe:list-post:list-owner:list-archive; q=dns/txt;
 s=dk12062016; t=1790694490; x=1791299290; b=gcch53KU/lTwIX6bgy7aVVIZjoP
 qfanj5YRzE8H/C0317zpX2jZGHEf/0oC2XK9HA9Z8UTgQwfsNm+RycoITm5d8y8GbgTggt5
 bkEnSY/yrJhUgbGvJA9j+71eJE6Z4j/gHy+2GYusGk9LCMkNB+zGOClS9K9xM7L+iLmapuZ
 RcVeEGNc2wD37cmPi1tJsoZlf+ZjSuSx81sGSFE+BwTTQGxf0RwQeMbR+yjvmkQh19fh2Kn
 JvNKmhtZjLt8nb7y881Sbjvtcwylbxi0wcCdJF8pdJFK3sUso1MOSsc9xYz/jQ6F2dwd+mS
 iGUOra+ecn3qsMqDvoR7v7Pj6zl3L3A==
Received: from smtpclient.apple ([98.27.167.98])
 by vsel2nmtao01p.internal.vadesecure.com with ngmta
 id 235b0cd9-18d9d325ed35a566; Tue, 29 Sep 2026 15:08:10 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [RFC] MXFS: a shared-disk clustered filesystem derived from XFS
From: Steve Shoecraft <spshoecraft@gmail.com>
In-Reply-To: <20260929150056.GG6244@frogsfrogsfrogs>
Date: Tue, 29 Sep 2026 11:07:54 -0400
Cc: Carlos Maiolino <cem@kernel.org>,
 Christoph Hellwig <hch@infradead.org>,
 linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9E7E7E56-7F4F-4F0E-A971-2FEB93CB82FC@gmail.com>
References: <56847E8D-EA83-4984-82F3-9BC93E4C02FF@gmail.com>
 <ardhDI-Ko7b5RccH@infradead.org>
 <BC228018-42A4-4715-B186-057AFDE8A4D0@gmail.com>
 <arj3Mp6Cq2_qwaIb@cronus.toxiclabs.cc>
 <1B01BE22-06A8-412D-B141-CD94026E0A39@gmail.com>
 <20260929150056.GG6244@frogsfrogsfrogs>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)


All good points and a nice snarky comment at the end - was a definite =
oversight that has been rectified.


> On Sep 29, 2026, at 11:00=E2=80=AFAM, Darrick J. Wong =
<djwong@kernel.org> wrote:
>=20
> On Tue, Sep 29, 2026 at 09:19:39AM -0400, Steve Shoecraft wrote:
>> I=E2=80=99m disappointed in your responses. I would have thought that =
you=E2=80=99d at
>> least be interested in how well the AI did.
>=20
> And I'm disappointed every time someone unfamiliar to the (xfs)
> community appears out of nowhere with a giant pile of code (LLM
> generated or otherwise) and a request that we read it.
>=20
> If you want people to review your code, start by watching the mailing
> list for a month or two to familiarize yourself with community norms,
> and to ask questions when others post patches.
>=20
>> It=E2=80=99s going to get better =E2=80=94 not worse.
>>=20
>> Since the initial 2-node TCP/DLM release (0.89.77 on September 23), =
Fable and Astra have completed 2-node CAW (0.90.7 on September 26), and =
4-node TCP and CAW (0.90.24) have now been released on:
>> =E2=80=A2 Proxmox VE 9 (kernels 6.17 and 7.0)
>> =E2=80=A2 RHEL / AlmaLinux / Rocky 9.8
>> =E2=80=A2 Ubuntu 24.04 LTS (GA kernel 6.8)
>> =E2=80=A2 Debian 13 (kernel 6.12)
>>=20
>> All are distributed as native DEB/RPM packages, with the kernel =
module built against the target kernel via DKMS.
>>=20
>> The 0.90.24 release passed the complete release criteria: 4-node TCP =
31/31, 4-node CAW 30/30, 2-node TCP 31/31, and 2-node CAW 30/30. All =
four platforms passed their packaged installation and validation runs.
>>=20
>> The goal is full 32-node support for both TCP and CAW DLM.
>>=20
>>=20
>>=20
>> The next project is OSN =E2=80=94 a fully AI-written OS from scratch.
>=20
> Good luck with that when you can't even be bothered to llmcode a test
> to make sure the magic numbers do not match standard xfs.
>=20
> --D
>=20
>>> On Sep 27, 2026, at 7:03=E2=80=AFAM, Carlos Maiolino =
<cem@kernel.org> wrote:
>>>=20
>>> On Sat, Sep 26, 2026 at 07:32:27AM -0500, Steve Shoecraft wrote:
>>>>=20
>>>> Good catch on the magic - I had it changed in previous attempts and =
forgot on this one - release 0.90.0 has MXFS unique magic.
>>>>=20
>>>> I=E2=80=99ve been writing device drivers since the 90s on FreeBSD.  =
This was a research project to see if an LLM could do it with the right =
harness.
>>>>=20
>>>> Release conditions of course included 100% data integrity and 100% =
stability.   XFS was the right choice for the base.
>>>>=20
>>>> Intent is a good clustered FS for Proxmox to compete with vSphere =
and VMFS.  Yes, I=E2=80=99m aware of the differences in implementations.
>>>=20
>>> If you are not even bothering reviewing your own project source code =
as
>>> you stated, don't expect anybody else to spend their time or have
>>> interest on it.
>>>=20
>>>=20
>>>>=20
>>>>=20
>>>>> On Sep 26, 2026, at 1:07=E2=80=AFAM, Christoph Hellwig =
<hch@infradead.org> wrote:
>>>>>=20
>>>>> I don't think too many people are going to care about your LLM =
dump,
>>>>> or even review it.  But please make sure you use different magic =
numbers
>>>>> so that a mxfs image left in the wild is not mistaken for an xfs =
one.


