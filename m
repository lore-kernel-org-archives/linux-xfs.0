Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75ED23EBF2E;
	Thu, 19 Feb 2026 00:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771460744; cv=none; b=aTafqNEfIlhtKRfZQf+ayQ4C3CkRwtFopk3JsJyZzZ8A0seoWH5kiYkpEo4Rp94K3XVeVkQWUC0AxyF2bSFZOJ/uhjrhWFg+OzCDnwKNGygrXLO5GlkH84gsPSKEQhd3STfR/iIY1/Dka/BEf+YBJIddFKG2ravb5mWSBzwr6a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771460744; c=relaxed/simple;
	bh=ALVICoe2CZlOTQ2F8IXgQ20JQLXcb6nUJt1aV5JpXPs=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=eMaF4ol7Q8Tn63hkcq5f9iR/EEIpfFoz3xVD/1FAyVyTshljWo92dO6p2ZNWuQYduHaRa6WQiCI3UPqSGfT/sjH/15CNLyKRpb4ZM2L/OSX2kOm6akt14M85/QrAl/ScTfZOHliTjrJBFSVErtnoe83NOgeZpeHv8k4X0hZBmbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=ltWfJAGk; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gBw6U8o/; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="ltWfJAGk";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gBw6U8o/"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A3F1C14001B6;
	Wed, 18 Feb 2026 19:25:42 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Wed, 18 Feb 2026 19:25:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm3; t=
	1771460742; x=1771547142; bh=0hEUnyF3Gb1BXeYBkK2airD0iF2iDP493Fq
	v5Jzn1Ro=; b=ltWfJAGkTf80eQF4xlBsqNUSPFWafVKWlneM0FUE9iqOj9kW6Vk
	SXqJzFT+F0HWU027sfQpJ1IfAfDOLbGrtdSkuqLW8Zpmb0a/ZxE5kcQgmyATkASX
	Sk4cPFOrLDQMTROKfjLo4OOVzkzWMZErAvreZH2rB6w40OdEFoT1oZt5JjvsJUx7
	0qiF2+DshC/t3CX16v3ixULvHqOSc/3aFgSLO6Mv453dgnoAzzF0hHjotPnv5xeY
	w0LQdKXfHAWMVA5/hLmZzp4IvdkGWDWEKuVK9HXcZl2dyTx3Q8cYC8bzardQuvLT
	qtP3XGALc6QiFcKcOkELlkOXMKECq7EPWrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1771460742; x=
	1771547142; bh=0hEUnyF3Gb1BXeYBkK2airD0iF2iDP493Fqv5Jzn1Ro=; b=g
	Bw6U8o/X8aBMQEiuoilVLGH6ggOg/dHneuFyiViVmZ9kDJ7rT4kY4dcqhN/OTous
	lRCCmmIJEv135N1rPXyp122/zy4v+9H6ga8Tpkk8veLRDcILSfV09ULlJwqf6Chu
	g78dyOeUc3HGQA+Dh6rG9SGzlnU+/A/kKlvdw1Yj7gBTYPQWPfCb4SPdWLatZe0C
	unETgE5FG7YafmMD+afjtckP6qt6sARuDcMOahj6pdSPJFqsm8j/GnhDIqLg3vEJ
	n25LuWf29NlmbEbjjF6fBhWYcFD8fZ9bdYOdQ0j3erWEu0hrAAb6yCD6Ur+/s7cg
	MzDI5Zee8YdOmhXn4M3LA==
X-ME-Sender: <xms:hliWadEiE6O2ErRKKuR3h_LuGks-me7ddSnTBoo1jVmnaxIhfoI5Zg>
    <xme:hliWaboIB9vRPE6wxt4I2a9Q94kbzpwAlPnwq5PF8rBbHmY-pCsLlUPjDt5cMzY2C
    wypLVlh6unwlhgovQ54CEx99KRm20rDOElgJt-zhSzPJ1ggOQ>
X-ME-Received: <xmr:hliWaWaiw1GBBEmTrl068fcumv-ANOtSfbN4wdIC2QzidsdP3C0Wvj57anG2xBDz4jRGykcsd0-VxOT87VbV9hmZSvLW4pibNKjzUFd24kMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdegtdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtqhertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epleejtdefgeeukeeiteduveehudevfeffvedutefgteduhfegvdfgtdeigeeuudejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohepiedpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopegujhifohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheptg
    gvmheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghrrghunhgvrheskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtohepvghthhgrnhhtihgumhhorhgvtdeisehgmhgrihhlrdgtoh
    hm
X-ME-Proxy: <xmx:hliWaUXoa01NOdMxC1UupoS1q0vStkNomQSSoHp0TS0cbHQSwTp-cg>
    <xmx:hliWaf9ZRO0wh2-eRx6Bf5CaFkkNSFhNiUDG2thpvRPgkcQnWSFNKg>
    <xmx:hliWad9v14bt4jmxUY1akLTmsTREohj27XwSWUTdKMwjPc47ABwz1Q>
    <xmx:hliWafTXFGcaEXi_Q-rIoV6vHnzUMPNI50acHdDT9maBzoMgNXRhiQ>
    <xmx:hliWaQ8J3W742MtkVbW4wnByP-ulzqLAQHz5Y5ObEBB2VrnQbyBrALDr>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Feb 2026 19:25:40 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "Ethan Tidmore" <ethantidmore06@gmail.com>,
 "Carlos Maiolino" <cem@kernel.org>, "Christian Brauner" <brauner@kernel.org>,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix error pointer dereference
In-reply-to: <20260218234917.GA6490@frogsfrogsfrogs>
References: <20260218195115.14049-1-ethantidmore06@gmail.com>,
 <20260218234917.GA6490@frogsfrogsfrogs>
Date: Thu, 19 Feb 2026 11:25:38 +1100
Message-id: <177146073877.8396.8928465677585359848@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Thu, 19 Feb 2026, Darrick J. Wong wrote:
> On Wed, Feb 18, 2026 at 01:51:15PM -0600, Ethan Tidmore wrote:
> > The function try_lookup_noperm() can return an error pointer and is not
> > checked for one. Add checks for error pointer.
> >=20
> > Detected by Smatch:
> > fs/xfs/scrub/orphanage.c:449 xrep_adoption_check_dcache() error:=20
> > 'd_child' dereferencing possible ERR_PTR()
> >=20
> > fs/xfs/scrub/orphanage.c:485 xrep_adoption_zap_dcache() error:=20
> > 'd_child' dereferencing possible ERR_PTR()
> >=20
> > Fixes: 06c567403ae5a ("Use try_lookup_noperm() instead of d_hash_and_look=
up() outside of VFS")
>=20
> Cc: <stable@vger.kernel.org> # v6.16

I don't think this is justified.  In this use case try_lookup_noperm()
will never actually return an error.

>=20
> > Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
> > ---
> >  fs/xfs/scrub/orphanage.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
> > index 52a108f6d5f4..cdb0f486f50c 100644
> > --- a/fs/xfs/scrub/orphanage.c
> > +++ b/fs/xfs/scrub/orphanage.c
> > @@ -442,7 +442,7 @@ xrep_adoption_check_dcache(
> >  		return 0;
> > =20
> >  	d_child =3D try_lookup_noperm(&qname, d_orphanage);
>=20
> "Look up a dentry by name in the dcache, returning NULL if it does not
> currently exist."
>=20
> Could you please fix the documentation since try_lookup_noperm can
> return ERR_PTR values?

Fair - I'll include a patch with my next batch.

>=20
> > -	if (d_child) {
> > +	if (!IS_ERR_OR_NULL(d_child)) {
>=20
> If d_child is an ERR_PTR, shouldn't we extract that error value and
> return it instead of zero?

This is a purely cosmetic question as no error is actually returned in
practice.  So whatever you feel most comfortable with is best.

NeilBrown


>=20
> --D
>=20
> >  		trace_xrep_adoption_check_child(sc->mp, d_child);
> > =20
> >  		if (d_is_positive(d_child)) {
> > @@ -479,7 +479,7 @@ xrep_adoption_zap_dcache(
> >  		return;
> > =20
> >  	d_child =3D try_lookup_noperm(&qname, d_orphanage);
> > -	while (d_child !=3D NULL) {
> > +	while (!IS_ERR_OR_NULL(d_child)) {
> >  		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
> > =20
> >  		ASSERT(d_is_negative(d_child));
> > --=20
> > 2.53.0
> >=20
> >=20
>=20

