Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792584680;
	b=Sl10IIg6s/mExkIkYBAvRLMS5gTiLOw9CsbUQmmVdZ3o04lHKG64/XLQwwbBghfhkotz
	 mbhhdLNRNyXDL38kJTCgtFd2LM54SbD4yyd8bavr/LCxTIiQAYB4AH/Xx5XrCGxvUK4+g
	 WdnaDXFujRGhc4DNXxmZvXoUYdycihc8bCVir1/b1TkjTiwNi3f43pAs5lBTDk2LP9eY1
	 FNOzIR9zbr5XiVOMxMDa65hmYbQLxekq0JjvolBeejzrq4NpqWUGizqzX8UmTdHi3uZAo
	 p0IbOsv7ZIQU+hxuyHTkzeRuhPyEIfr/VRdOE2ER34B25Zi8YlFhdzmJc+RpBZI6sfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792584680;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=rC7i7oJQKZBAX00N3sMgtoFqTxIhdHPW9VTspHueJBg=;
	b=iCrfii00/Aa7PLIFGPxd9wJfig11UOO6cPsxiVVgGOJDNY1SH9xnZvfVAuT3NaoE2bZv
	 w69ADnvw8xWKtWFouQuRpYYGKfc4H2czk128+FL/18XLUMnR985c/s6YNRJjS7jfIvkYv
	 Q0KoVOyQSSApAfJQhkLoCO9YPzJiQc76/Jf/Leid+3dRnCrgG0tSdQnv6Z7GVVb60t5Sj
	 0pBcaa9bS57575H39dBi7mrZVh67hRP1jh8GCl/7Fw/qz1To5ZuvkeNsNw6lxzIk3bJ9F
	 N2Z/S4A2GHFpRjdVjSQrqJyjjmiHhfIugKIHxccWbsuGfIQqrBLcGzmP0jF4RuzfQAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HSCORzJB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F55C606A319;
	Wed, 21 Oct 2026 12:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HSCORzJB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8711F000C4;
	Wed, 21 Oct 2026 12:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792584680;
	bh=rC7i7oJQKZBAX00N3sMgtoFqTxIhdHPW9VTspHueJBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HSCORzJBo8wwnX3KQAW0iHdPLj7ZPHYPMaNtYNT+biNakjBUMKcrtCS8k00jU3LEw
	 G9wwqTamsLg383QlyH9JCT/gw+L16iTHush1JuefEi9Qm07rZmWqCqTIj/ZCzO3xqq
	 F0iPdNRHq77ps0EGxYTCUPP97u5OKcyRGP26QNjqrWPtvG5omQP/f2Yj3VIDivbywC
	 6joLlGJy1UsckQ5WStBJPSv3vcnzxFtbjOarSA5hy7+SFaBAABQSlxpaOTyEviXg3i
	 9ofuCg3uzZG0KZnOl15pIPl/2q5awAzNy7RWABbwoWalF2NWpmK14W7b/5z9hvu57u
	 MtwbKG2kW5Aig==
Date: Wed, 21 Oct 2026 14:11:15 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Cc: "djwong@kernel.org" <djwong@kernel.org>, 
	"dchinner@redhat.com" <dchinner@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
Message-ID: <atirYb9qxRsaRYhs@cronus.toxiclabs.cc>
References: <20261001145153.308087-1-siddh.raman.pant@oracle.com>
 <as5AloTkTT3bZkyq@nidhogg.toxiclabs.cc>
 <e7feec9bf096ed64f581536aa314a21723cccc63.camel@oracle.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7feec9bf096ed64f581536aa314a21723cccc63.camel@oracle.com>

On Thu, Oct 15, 2026 at 12:56:43PM +0000, Siddh Raman Pant wrote:
> On Tue, Oct 13 2026 at 20:01:04 +0530, Carlos Maiolino wrote:
> > On Thu, Oct 01, 2026 at 08:21:53PM +0530, Siddh Raman Pant wrote:
> > > Probably an (harmless) error in copy-paste.
> > > 
> > > Fixes: db6a2274162d ("xfs: catch stale AGF/AGF metadata")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
> > > ---
> > > Put in stables <= 6.12 after the backport series lands.
> > 
> > Fix the tags accordingly to Darrick's review and re-send please.
> > 
> 
> I have sent some backports for remaining kernels and I would like this
> to go into them too once they land. Should I still do it?

Probably. You've gotta tell stable this patch should land there in some
way. I think they are looking into those tags to guide them what
versions this should be backported to.

> 
> Thanks,
> Siddh


