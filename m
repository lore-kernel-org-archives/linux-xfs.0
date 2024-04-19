Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404B1BE65
	for <linux-xfs@vger.kernel.org>; Fri, 19 Apr 2024 06:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713508188; cv=none; b=Im8Knsv9Cb3lKZ3K0Rz5Y6MPYyfpk93iKr7LNKPanjDtwjmltRIVu9mS6uqg9eb9z9jc8whE+3VOMfQIGHPpRLU83xdo97wCUr55+0+FtU8AG8AWbN7XXAl9HjDhKE5VO2EeM64t8eLB2MsqhFz8L4IKIdA5TtoSWJAgWd3093Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713508188; c=relaxed/simple;
	bh=kn0Gpj9wSadUn05kPaVMW9IhUtFpoa1zv8ak3p7PNs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EswASAnPcat8rcnqKjnpDBymmZrjfYfdZdei0/+eYFtYP3nq1fIyTZAc4RGf978J8DwDldCJoHGvG48KH1KMHncsyABir6j9McWyrb5vqZwvbYNOY/gOuQn1USRGlkY3o5ENkuUv5vlTMsVJhZz9aQlKUbtMiEPiPGMXMxAjTgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqaAn+I/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqaAn+I/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB88C072AA;
	Fri, 19 Apr 2024 06:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713508187;
	bh=kn0Gpj9wSadUn05kPaVMW9IhUtFpoa1zv8ak3p7PNs0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kqaAn+I/xvvl0/SSY21Nbs+44BqACy5dcSRBoumT/iKFYKotYQ/UhZHjRAqmw7RNl
	 jCjqG/DKkmgJdKAYlaGZUA4+tPHXh8HlRTVcfQ7TUHgnPQKK5Y+k40GMu346rYTIdn
	 Bc0sVzGvKxmt3cCVQsNg3A9ybBZX/PPynTKr+yJ8QWmj2nYczgXXQAGK6Lkj+18QhL
	 O1jJf5qU5kA4AvJyr1GMHQCMp0Dbn4v8FrfWBi5Jm+TzNx6pVg2PfBUXb1NNH5/Q3/
	 QKYnkgBSdNfaK8TN+GwgXvK1KtwsGrOi0C7uAYKHc9s/f/viKx0qjvleIRdRfTYXLa
	 j6bnCjITvcLlw==
Date: Fri, 19 Apr 2024 08:29:43 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Carlos E. R." <robin.listas@telefonica.net>
Cc: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] GPG key update
Message-ID: <phtliir2jh2tjsmupeavh6jx4bwpyhkganaho2aph453rgo4xc@2pevxtjkp3ki>
References: <akavzwaevicl2agsucc4salxjtxmmg74htvtiswzf2ortw2rud@fstpc2o5ywlo>
 <h7fd3gyOlNqOfiXBV5wf0r96pAGxaYvfmBQoBjZsbH2Tf9OSe76_YvBAF7jux1eifZJOHlMa8kcpiHjH6cJeGA==@protonmail.internalid>
 <3b60a114-762e-4139-9e78-8c8378454c7a@telefonica.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b60a114-762e-4139-9e78-8c8378454c7a@telefonica.net>

On Thu, Apr 18, 2024 at 08:02:09PM +0200, Carlos E. R. wrote:
> On 2024-04-18 10:23, Carlos Maiolino wrote:
> > Hi,
> > I didn't mean to send such email, but more than one person already asked me about it, so, sharing it
> > for a broader audience.
> > 
> > 
> > TL;DR;
> > 
> > I started to use a new key to sign stuff two months ago, if you had any key mismatch problem, update
> > your keyring. My apologies for any trouble.
> > 
> > 
> > == Long Version ==
> 
> ...
> 
> > My certify (or master key) is still the same: 4020459E58C1A52511F5399113F703E6C11CF6F0
> > With a new extra subkey added under it: 0C1D891C50A732E0680F7B644675A111E50B5FA6
> 
> I only wanted to point out that the network of GPG keyservers is broken,
> since the attack they suffered a few years back.

> 
> For instance, Thunderbird internal key manager finds your keys ID above,
> apparently using "vks://keys.openpgp.org, hkps://keys.mailvelope.com".
> 
> However, kleopatra (Plasma key manager) doesn't (using hkp://keys.gnupg.net
> or hkps://hkps.pool.sks-keyservers.net, not clear which).
> 
> 
> That is, keys are not propagated through all the servers as they were in the
> past.

You listed several reasons why kernel.org keeps its own repository with maintainers keys :)
There are even instructions on how to automatically update the keys based on kernel.org repository:
https://korg.docs.kernel.org/pgpkeys.html#automatically-refreshing-keys
So, everybody relying on maintainers keys  can keep their keyring updated.


> > And directly from the kernel.org's database:
> > 
> > pgpkeys $ man gp --with-subkey-fingerprint keys/13F703E6C11CF6F0.asc
> > pub   ed25519 2022-05-27 [C]
> >        4020459E58C1A52511F5399113F703E6C11CF6F0
> > uid                      Carlos Eduardo Maiolino <carlos@maiolino.me>
> > uid                      Carlos Eduardo Maiolino <cmaiolino@redhat.com>
> > uid                      Carlos Eduardo Maiolino <cem@kernel.org>
> > sub   ed25519 2022-05-27 [A]
> >        36C5DFE1ECA79D1D444FDD904E5621A566959599
> > sub   ed25519 2022-05-27 [S]
> >        FA406E206AFF7873897C6864B45618C36A24FD23 <-- Old key still valid
> > sub   cv25519 2022-05-27 [E]
> >        5AE98D09B21AFBDE62EE571EE01E05EA81B10D5C
> > sub   nistp384 2024-02-15 [A]
> >        D3DF1E315DBCB4EDF392D6ED2BE8B50768C99F00
> > sub   nistp384 2024-02-15 [S]
> >        0C1D891C50A732E0680F7B644675A111E50B5FA6  <-- New key
> > sub   nistp384 2024-02-15 [E]
> >        C79922EE45DEA3F58B99B4701201F4FA234EEFD8
> 
> 
> Information obtained once I changed the keyserver:
> 
> cer@Telcontar:~> gpg --list-keys \
>    4020459E58C1A52511F5399113F703E6C11CF6F0
> pub   ed25519 2022-05-27 [C]
>       4020459E58C1A52511F5399113F703E6C11CF6F0
> uid           [  full  ] Carlos Eduardo Maiolino <carlos@maiolino.me>
> uid           [  full  ] Carlos Eduardo Maiolino <cem@kernel.org>
> uid           [  full  ] Carlos Eduardo Maiolino <cmaiolino@redhat.com>
> sub   ed25519 2022-05-27 [A]
> sub   ed25519 2022-05-27 [S]
> sub   nistp384 2024-02-15 [A]
> sub   nistp384 2024-02-15 [S]
> sub   nistp384 2024-02-15 [E]
> sub   cv25519 2022-05-27 [E]
> 
> 
> 
> -- 
> Cheers / Saludos,
> 
> 		Carlos E. R.
> 		(from 15.5 x86_64 at Telcontar)
> 



