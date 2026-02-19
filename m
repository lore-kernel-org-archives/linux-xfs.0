Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F26D38DF9;
	Thu, 19 Feb 2026 00:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771460487; cv=none; b=uMQy9Rvx3BRg+jZFB25CmRdazU6yV1uHVXCkOEo3rqJsy6ZCXvPjDDDtzBqV+CiLDfCTYro53mODzvO5e93embjfdMTnZHBuy/LlPi+OYXrVNncPUJGS0zis+3RK/5u4LxD4dhWnY7Pl2jZCPxzSfB4VelmbSWcP9/WcxfDIUzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771460487; c=relaxed/simple;
	bh=Mdi2I8+7K7wYv0yvmURAkTJYjNkF7l27SscYYTDyY8k=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=NUDOq1mKIekZnq2wi0zF0TpPWXfQfmcbFdheukpM7fQpX2NEv66h+PSgMOx5jjBcChvuciLxlajY7NWBqyVadAzcDSqbczg+tHYpYTzEK94synZuvI5eyQw7Hd3GJsD1wjkY9+9VDj/Y96w2gLsfp3Jy1BeLt3EcdK2oS3SIjr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=SGNhXdwc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=X/Ai7KqO; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="SGNhXdwc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="X/Ai7KqO"
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 52DFB1400091;
	Wed, 18 Feb 2026 19:21:24 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Wed, 18 Feb 2026 19:21:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm3; t=
	1771460484; x=1771546884; bh=cjw1xMY2W59EObVzGIGXXPrIkKQOsDs5XwZ
	S/vWYm1Y=; b=SGNhXdwcrfWpuYzgOmDbc0b3t0zjP6tIoGmOLXMKVzW2GZX2G/E
	+egug3Io2QDVRiwhtoNV/BcakR9WcVdNirZo3XJJ8n5FRhBMTu4QSrNNYhPgEKGC
	4lQr8jz4bKo95Fz+dB4sMz0+KShg55k90DX2bKg3WH1KC8BLIE1IJB5cvpA/AAkP
	7DDaxRzQl5kch0cfK/ls+W128QWy+LbiFjXr5O6crp4RuwS4mi62UFF9iBrajb0X
	OiSClwGsutI15+CiQMOZgY6B9VLqzRZOLCscHv7SLxybcdI7bF431GzKun2/a0Pg
	yFScvt5Ej/Vaa9URnYnb9GlPsbLXH2bsmlg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1771460484; x=
	1771546884; bh=cjw1xMY2W59EObVzGIGXXPrIkKQOsDs5XwZS/vWYm1Y=; b=X
	/Ai7KqOAanCE9bhowqUHVnQIkmgzqMvxFIPnmF/ebSbpyWe7VUpzoon2gQpDAuZ9
	/Z8THvnSigZ6g58llC6fYN77ncZyK+rYCpX/0d6RxrvfbOlztvrr1H+KX/ku99ob
	3oNawdc4APpAHKrH4jTT31nJyf4Uwj1ChN71fK+cv/cmUSGlAyP6SDiSAfV0Ut15
	L9pz8r/hgOHoW2oBQRTyBDabtd4P5QWrRrOkX6pW32a5/AOzAc3hIiKTvZBETwCE
	qa6fftx6V+YnpR5noHzoW/BiYYXIebMLVwThS5W8vqP4TIMkgewQU+gqlnMrzm9v
	9/36kJMfpPQAvLTiOwbWw==
X-ME-Sender: <xms:hFeWaSbaSU5KfOKmx9xP6y7_NCccCEe9eD9r1hv5d5rsYcZ73Edc-A>
    <xme:hFeWaW4wGUQDgfxbiFCODdRKhY1UQ3-fY9SQiP7NPQOwGncQeKgHumA94ub8NNKP6
    bI1ZPNHjHWUPvwXw55M_AC05u14T0BQQi8HcCJe3q_gJ76ksw>
X-ME-Received: <xmr:hFeWadAvut7KM7pxboYaXWN-w3BSyVXAr75bOBlUD-CINw2r0gDeqOryKAxMi8nFulHxsq516IJ3Rs1JW7ghNniVgMlZbVamBp_qN0ytpz2K>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdegtdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtqhertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epleejtdefgeeukeeiteduveehudevfeffvedutefgteduhfegvdfgtdeigeeuudejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohephedpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopegtvghmsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegsrhgruh
    hnvghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegvthhhrghnthhiughmohhrvgdt
    ieesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:hFeWaUeV95NjWTAvRpRcGNdPGdFUTLyp6shi4CxgCnlOPnXQ5ETTmw>
    <xmx:hFeWaUKhNfb4tQ7tI-ZxcLgRZcvwS-t2pkytuHxzcBjSIZGEKGk4iA>
    <xmx:hFeWaX02AOB60pKs50GpAzs1R03SyivctrQo23DrItgVOo-NrFKjbQ>
    <xmx:hFeWaejbCnu6pKWBjXPywV3CsaGk4iAC3NYKU0aFvTVf9q2RMIaqLw>
    <xmx:hFeWabaPGATZg0ROEMS8J6t8sGpamg5cHtwWZ3btG3EhmwRUfpaSJE1x>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Feb 2026 19:21:22 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Ethan Tidmore" <ethantidmore06@gmail.com>
Cc: "Carlos Maiolino" <cem@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Ethan Tidmore" <ethantidmore06@gmail.com>
Subject: Re: [PATCH] xfs: Fix error pointer dereference
In-reply-to: <20260218195115.14049-1-ethantidmore06@gmail.com>
References: <20260218195115.14049-1-ethantidmore06@gmail.com>
Date: Thu, 19 Feb 2026 11:21:18 +1100
Message-id: <177146047805.8396.14699374115463997556@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Thu, 19 Feb 2026, Ethan Tidmore wrote:
> The function try_lookup_noperm() can return an error pointer and is not
> checked for one. Add checks for error pointer.
>=20
> Detected by Smatch:
> fs/xfs/scrub/orphanage.c:449 xrep_adoption_check_dcache() error:=20
> 'd_child' dereferencing possible ERR_PTR()
>=20
> fs/xfs/scrub/orphanage.c:485 xrep_adoption_zap_dcache() error:=20
> 'd_child' dereferencing possible ERR_PTR()
>=20
> Fixes: 06c567403ae5a ("Use try_lookup_noperm() instead of d_hash_and_lookup=
() outside of VFS")

This commit didn't introduce this behaviour.
It changed from using d_hash_and_lookup() to using try_lookup_noperm().

Both can return an ERR_PTR().  Neither ever do in this code.

As the lookup only happens in an XFS filesystem and as XFS doesn't
define d_hash(), d_hash_and_lookup() would never actually return an
error.

try_lookup_noperm() does add some error cases for, e.g.  , "." and ".."
and names containing "/".  But none of these apply here.

So this is worth fixing, but the current code has been like this since
it was written, so

Fixes: 73597e3e42b4 ("xfs: ensure dentry consistency when the orphanage adopt=
s a file")

would be more appropriate.

Thanks,
NeilBrown


> Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
> ---
>  fs/xfs/scrub/orphanage.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
> index 52a108f6d5f4..cdb0f486f50c 100644
> --- a/fs/xfs/scrub/orphanage.c
> +++ b/fs/xfs/scrub/orphanage.c
> @@ -442,7 +442,7 @@ xrep_adoption_check_dcache(
>  		return 0;
> =20
>  	d_child =3D try_lookup_noperm(&qname, d_orphanage);
> -	if (d_child) {
> +	if (!IS_ERR_OR_NULL(d_child)) {
>  		trace_xrep_adoption_check_child(sc->mp, d_child);
> =20
>  		if (d_is_positive(d_child)) {
> @@ -479,7 +479,7 @@ xrep_adoption_zap_dcache(
>  		return;
> =20
>  	d_child =3D try_lookup_noperm(&qname, d_orphanage);
> -	while (d_child !=3D NULL) {
> +	while (!IS_ERR_OR_NULL(d_child)) {
>  		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
> =20
>  		ASSERT(d_is_negative(d_child));
> --=20
> 2.53.0
>=20
>=20

