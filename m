Received: from mta-101a.earthlink-vadesecure.net (mta-101a.earthlink-vadesecure.net [51.81.61.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D3532D7F8;
	Sat, 26 Sep 2026 12:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.81.61.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790425976; cv=none; b=O9Y/kdInemXSrcddAb2PYCGqXL0JMZ2w7+eKSylpWvw4VyhVl2IQFE23foswrXBHeq5P1kOyMVYoI327UZQSqAxztSYrSznONbJVI1X1/f3M5YLfTIa2amtjW1DixHRDfIfCwLtQBokHxind/QU1vv93sR9YTi/4/m4hYZQdqAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790425976; c=relaxed/simple;
	bh=Jkgm6++32y8guAgrTQyIPhxA76pbsD7tvMNLXOb8sjQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=D+xmkyQV6ZlxHpijBnRsAnpOtf8qNNygya50pZqoSAWCvXekOLtxLKCCp7t17aSaRrq1zzxl18aMJBvajOky75Rf0Wcd97gJrgoQQaPjbVDbpluKhTZE+CIX8YLNCT7lurMLtBOpzsDA4qmjCsAJxIjOeKlfVQgGTAFdWw/EA6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=earthlink.net header.i=@earthlink.net header.b=lZSDuB4u; arc=none smtp.client-ip=51.81.61.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=earthlink.net header.i=@earthlink.net header.b="lZSDuB4u"
DKIM-Signature: v=1; a=rsa-sha256; bh=abnD/nWWrhCc16pyr19HDQyIxYjMrMKv5SwEpK
 vl/HY=; c=relaxed/relaxed; d=earthlink.net; h=from:reply-to:subject:
 date:to:cc:resent-date:resent-from:resent-to:resent-cc:in-reply-to:
 references:list-id:list-help:list-unsubscribe:list-unsubscribe-post:
 list-subscribe:list-post:list-owner:list-archive; q=dns/txt;
 s=dk12062016; t=1790425962; x=1791030762; b=lZSDuB4uFRksu035QgxY1D1WRBI
 nSZsAldxVr+DlQs0MjBk6GF9URAbhyPzjFCgqd6sp/wCA3aY1++Oy+r+OKmJFk0ELGMXTLG
 aKjh5gv7CUpWjmvBu0yj/6s4bV75MSMD5McKMz/O8ZAsD3O+bma+dWMYheIWWbmSGAWII+x
 2B9HTjEnVbyWLEJBttVxHs7uBY8iHrRVWDk0aXVZchUnnVIkHxA778FTYpMWVfjd+wWvb90
 i0CLEE2FyHG6VCXztC9JDZ6JSjJvP1blnWQn2+kim70TeAvEhx6A2dAeMfroJ4w4tHiUIEX
 I8jxCu6obVFV/SszQMkCGuf83gqw7bg==
Received: from smtpclient.apple ([47.219.251.75])
 by vsel1nmtao01p.internal.vadesecure.com with ngmta
 id 8e78e419-18d8deec423399e2; Sat, 26 Sep 2026 12:32:42 +0000
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
In-Reply-To: <ardhDI-Ko7b5RccH@infradead.org>
Date: Sat, 26 Sep 2026 07:32:27 -0500
Cc: linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BC228018-42A4-4715-B186-057AFDE8A4D0@gmail.com>
References: <56847E8D-EA83-4984-82F3-9BC93E4C02FF@gmail.com>
 <ardhDI-Ko7b5RccH@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)


Good catch on the magic - I had it changed in previous attempts and =
forgot on this one - release 0.90.0 has MXFS unique magic.

I=E2=80=99ve been writing device drivers since the 90s on FreeBSD.  This =
was a research project to see if an LLM could do it with the right =
harness.

Release conditions of course included 100% data integrity and 100% =
stability.   XFS was the right choice for the base.

Intent is a good clustered FS for Proxmox to compete with vSphere and =
VMFS.  Yes, I=E2=80=99m aware of the differences in implementations.


> On Sep 26, 2026, at 1:07=E2=80=AFAM, Christoph Hellwig =
<hch@infradead.org> wrote:
>=20
> I don't think too many people are going to care about your LLM dump,
> or even review it.  But please make sure you use different magic =
numbers
> so that a mxfs image left in the wild is not mistaken for an xfs one.
>=20

