Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AE1242D9B;
	Sun,  2 Aug 2026 08:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.160.73.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785659720; cv=none; b=X+AVJKcRSET7eF335Sg9cRAxKyNEQnj8Lce35thrRUox9jwEdHaHcPmvCAwUhy6/Sf/SoXdWheXqgHkIotPJaScMReQ/hCGTIbA2cUiBPI3dPOvT8P5M3tn2GuZjwEd6fRj0bD1A8AhidVo3jUBIpOwE03YS5rWimtkgJD/f3xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785659720; c=relaxed/simple;
	bh=Cs/3Ev2eZxo9khBZraoIvoqOPeQ+FmelWox5vGPyHmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TSMpMPvRxUJ1Fo3ZbilYMM2Xyw1rIbcPhoVMu9QPujwEm0RMXzNnA6TRJqby/EOZc98Xn384+BxmUne7Urof5nDVvXoWh+CyM0LIhST4hb/Y0p85q8SqTQ0b343XfTiJgo5fM0NmpQgLHRGMOsHCsxF7cJfE2kIKeMsF9XuBDeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=narfation.org; spf=pass smtp.mailfrom=narfation.org; dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b=TueGegMq; arc=none smtp.client-ip=213.160.73.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=narfation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=narfation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b="TueGegMq"
Received: by dvalin.narfation.org (Postfix) id B916D1FD24;
	Sun, 02 Aug 2026 08:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
	s=20121; t=1785659712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fMYTzQH1zttmydLDPHjeKd4YAQFJdYtzol8QiKD72s0=;
	b=TueGegMq9xyGtbq+ge+5NdN7v1B8vxfD/vxcWTrmY6BcdyS3NWWcAi74vjzEqbF+DDoYhd
	+F8s6PT9dgZNMSLh/qpm0Ch5RSfza05r9kGjjZjv+BZgUF1CRtUVS6QLAd8t1KUfpW0oqR
	HsjYNFrJFAxwJNUV+q6S2wkbef0CbFQ=
From: Sven Eckelmann <sven@narfation.org>
To: cem@kernel.org, David Lee <david.lee@trailofbits.com>,
 Kyle Zeng <kylebot@openai.com>
Cc: Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: validate btree block level on read
Date: Sun, 02 Aug 2026 10:35:10 +0200
Message-ID: <3703777.44csPzL39Z@sven-desktop>
In-Reply-To: <20260731120344.558808-1-david.lee@trailofbits.com>
References: <20260731120344.558808-1-david.lee@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8986943.T7Z3S40VBb";
 micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart8986943.T7Z3S40VBb
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
Subject: Re: [PATCH] xfs: validate btree block level on read
Date: Sun, 02 Aug 2026 10:35:10 +0200
Message-ID: <3703777.44csPzL39Z@sven-desktop>
In-Reply-To: <20260731120344.558808-1-david.lee@trailofbits.com>
References: <20260731120344.558808-1-david.lee@trailofbits.com>
MIME-Version: 1.0

On Friday, 31 July 2026 14:03:42 CEST David Lee wrote:
> Fixes: 3d3e6f64e22c ("xfs: verify btree blocks as they are read from disk")
> Bug found and triaged by OpenAI Security Research and 
> validated by Trail of Bits.
> 
> Assisted-by: Codex:gpt-5.6-sol gpt-5.5-cyber
> Signed-off-by: Kyle Zeng <kylebot@openai.com>

1. weird text (advertisement) + newlines in the tags section which shouldn't be there
   https://docs.kernel.org/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin
   (and all these tag/format related sections below)

2. author didn't sign off the patch (see below)

3. odd unrelated Signed-off-by without any obvious connection to 
   the patch

   - I actually would guess that Kyle Zeng <kylebot@openai.com> is the author 
     and David Lee removed its authorship (From: ) before sending the patch.
     But in its current form, David is claiming to be the author. And even
     when it is the case, David must still add the the non-Author SoB at the
     end.

Regards,
	Sven
--nextPart8986943.T7Z3S40VBb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQS81G/PswftH/OW8cVND3cr0xT1ywUCam8BPgAKCRBND3cr0xT1
y6FEAP9xAzNZs8c2szyiSbreoB4zK0Vc/zSWkDYv4HnsP+taZQD9HMcIQVvTX8KB
mPa+3YX6qc6eAeaml6cZrrYNhBkV7g0=
=sNHn
-----END PGP SIGNATURE-----

--nextPart8986943.T7Z3S40VBb--



