Received: from mta-202a.earthlink-vadesecure.net (mta-202b.earthlink-vadesecure.net [51.81.232.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3A33DD526;
	Tue, 29 Sep 2026 13:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.81.232.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790688930; cv=none; b=QiINCBEgkOKcZ09bJ8hOm4DSVUndqINOvrLjfBeH32etD+EIxW9n1+hvbEWQ31lA/Frz8p/9tzDS8TaqzmhqFEpjmpdzT7Miy4QaCFm3ow1q/hFvuKyfrmuqeqkLmA0WYSGaL3v0iEy83WcNDXtcc4muQnuu8rLgGEuIsWcXBew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790688930; c=relaxed/simple;
	bh=pkOk2e7X7lgxbqSq7Tboa7FmmRyyDOoeNcRyOH/IJ2o=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=V/WUZInf1R7rDhF05V9PRMwCwG+bIP6Uc9XvfVTVKTWWf4KvUd4ZNHfNzwdN/KwnHIaX9/hPzk+/QTjCrkj0MezqM8SO9U7ZkPcX+sGYi9Nt32mBz0W6sGkf0civIfts/mGQcwj49UH8XXSuk2AaECTRRv89a0/GTS04Gc99Dfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=earthlink.net header.i=@earthlink.net header.b=bqAtQtf9; arc=none smtp.client-ip=51.81.232.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=earthlink.net header.i=@earthlink.net header.b="bqAtQtf9"
DKIM-Signature: v=1; a=rsa-sha256; bh=xcuEx3ZPmxQThn6FCLcEuqA+fR38H0R3e75qJ9
 87ejk=; c=relaxed/relaxed; d=earthlink.net; h=from:reply-to:subject:
 date:to:cc:resent-date:resent-from:resent-to:resent-cc:in-reply-to:
 references:list-id:list-help:list-unsubscribe:list-unsubscribe-post:
 list-subscribe:list-post:list-owner:list-archive; q=dns/txt;
 s=dk12062016; t=1790687995; x=1791292795; b=bqAtQtf95f1diT4pUMbNEI2tIIW
 /aTNgi5UP59i2Dwa1So4EgICtrMpQV2Bz921Y48P6ClE9ka6UxmVsGSeKNkPt3GqU9H5TqG
 VGSK7HsRQVWiiyld22FKRyZNzGy+KxtknA3zAxo+pqB7IthxPXwmInwPpqQhsQLG15JsuQe
 ap84S3UY+IulhPw/Vqg5gNrDNcNPnmiTFEt9/9lrV5NEDn8njpwZi820TomIIdy6cFmCgKl
 Vvhd/QpbooE2mZVgb8OoszQIBuX6JG1NsU+g7WaMYWAJCNLd6IgF8BQwm0ZBr5kJ/mTxOy1
 0UUerMgnajDQ4jBo++iZmJ5uBtX0y6g==
Received: from smtpclient.apple ([98.27.167.98])
 by vsel2nmtao02p.internal.vadesecure.com with ngmta
 id eec61a03-18d9cd3d92cb3ff3; Tue, 29 Sep 2026 13:19:55 +0000
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
In-Reply-To: <arj3Mp6Cq2_qwaIb@cronus.toxiclabs.cc>
Date: Tue, 29 Sep 2026 09:19:39 -0400
Cc: Christoph Hellwig <hch@infradead.org>,
 linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1B01BE22-06A8-412D-B141-CD94026E0A39@gmail.com>
References: <56847E8D-EA83-4984-82F3-9BC93E4C02FF@gmail.com>
 <ardhDI-Ko7b5RccH@infradead.org>
 <BC228018-42A4-4715-B186-057AFDE8A4D0@gmail.com>
 <arj3Mp6Cq2_qwaIb@cronus.toxiclabs.cc>
To: Carlos Maiolino <cem@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)

I=E2=80=99m disappointed in your responses. I would have thought that =
you=E2=80=99d at least be interested in how well the AI did.

It=E2=80=99s going to get better =E2=80=94 not worse.

Since the initial 2-node TCP/DLM release (0.89.77 on September 23), =
Fable and Astra have completed 2-node CAW (0.90.7 on September 26), and =
4-node TCP and CAW (0.90.24) have now been released on:
=E2=80=A2 Proxmox VE 9 (kernels 6.17 and 7.0)
=E2=80=A2 RHEL / AlmaLinux / Rocky 9.8
=E2=80=A2 Ubuntu 24.04 LTS (GA kernel 6.8)
=E2=80=A2 Debian 13 (kernel 6.12)

All are distributed as native DEB/RPM packages, with the kernel module =
built against the target kernel via DKMS.

The 0.90.24 release passed the complete release criteria: 4-node TCP =
31/31, 4-node CAW 30/30, 2-node TCP 31/31, and 2-node CAW 30/30. All =
four platforms passed their packaged installation and validation runs.

The goal is full 32-node support for both TCP and CAW DLM.



The next project is OSN =E2=80=94 a fully AI-written OS from scratch.


> On Sep 27, 2026, at 7:03=E2=80=AFAM, Carlos Maiolino <cem@kernel.org> =
wrote:
>=20
> On Sat, Sep 26, 2026 at 07:32:27AM -0500, Steve Shoecraft wrote:
>>=20
>> Good catch on the magic - I had it changed in previous attempts and =
forgot on this one - release 0.90.0 has MXFS unique magic.
>>=20
>> I=E2=80=99ve been writing device drivers since the 90s on FreeBSD.  =
This was a research project to see if an LLM could do it with the right =
harness.
>>=20
>> Release conditions of course included 100% data integrity and 100% =
stability.   XFS was the right choice for the base.
>>=20
>> Intent is a good clustered FS for Proxmox to compete with vSphere and =
VMFS.  Yes, I=E2=80=99m aware of the differences in implementations.
>=20
> If you are not even bothering reviewing your own project source code =
as
> you stated, don't expect anybody else to spend their time or have
> interest on it.
>=20
>=20
>>=20
>>=20
>>> On Sep 26, 2026, at 1:07=E2=80=AFAM, Christoph Hellwig =
<hch@infradead.org> wrote:
>>>=20
>>> I don't think too many people are going to care about your LLM dump,
>>> or even review it.  But please make sure you use different magic =
numbers
>>> so that a mxfs image left in the wild is not mistaken for an xfs =
one.

