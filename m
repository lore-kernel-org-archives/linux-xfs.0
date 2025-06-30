Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9050B25E46A;
	Mon, 30 Jun 2025 14:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751293101; cv=none; b=nTe94rqLMfFHvx/L4KacVzHrCm7IRlxmk/p4BlfR0PgV9L+nFrx8FR45yNcI82m1aLm5XUfXmJ8lfrXkXfEV48pbbvdCHvfZS6hiN08u9bRIN+0mSLG4ttsBpXXcGnFoRQuJdNcTFWQuA2sSbvvzWUNp3S1n0LnnEavsSOlzVDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751293101; c=relaxed/simple;
	bh=MJKZQQl4xS6GkWd/fK/rvCo6TRq6P4jCNco7oktzSZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=et1CptktXLF0WIRKHGn0vyFiehUYmU5iUE1Fmojsqi5udw3MjVALZjZQ78SxQ9xhPvVtTfg639cVcIemjuBhyjJGQOS8u/YpAt+bOJR7nlJgbbqSgirLwxtunXVs9ZNTtydIYjzcapz1NDKOI+T1dnGcavdMvYisxrzEqPcbFNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=listout.xyz; spf=pass smtp.mailfrom=listout.xyz; dkim=pass (2048-bit key) header.d=listout.xyz header.i=@listout.xyz header.b=iFV20gty; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=listout.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=listout.xyz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=listout.xyz header.i=@listout.xyz header.b="iFV20gty"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4bW7YM5Rqbz9smJ;
	Mon, 30 Jun 2025 16:18:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=listout.xyz; s=MBO0001;
	t=1751293095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t7fvedv2c/IIXDtuy4ODNT6VaqU7XH//j7biHuOSDJ8=;
	b=iFV20gty7lS9FWG2R/tdYlaKqwJF9ZmznAY4Zp4LBGigUMQDqwBC5QWcSadn7lAV7moSMX
	COGhJpdokXFLYpUOb6QIc64xp29WcpW5KVFIOvcJ20ho33PUYnZC7LJXzJnvSW7EG0vc7l
	f3+c86gUBhlWcG4D6pQu5+ehA5V1UMD/NEgTQUOb71H1lh2nIVH+P2dFWSbFLaqPAMXF1s
	clddVSoNZRqqrDRbUzxlgrJgu0kID3WT0wxAlsw0KKFw28PhzCnyaNhEbRxoZQzgIdFpS+
	yywN7FJe7kPfzD8No+cZx4tXO9XAjHB8dn+pnmrR8wnxMx32LjixKfBFHhAdCQ==
Date: Mon, 30 Jun 2025 19:48:03 +0530
From: Brahmajit Das <listout@listout.xyz>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, skhan@linuxfoundation.org, 
	linux-kernel-mentees@lists.linux.dev, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/xfs: replace strncpy with strscpy
Message-ID: <ldak3a3zmqlkv67mjproobt4g7pe6ii7pkqzzohd5o5kyv64xw@r63jjlqzafzp>
References: <BgUaxdxshFCssVdvh_jiOf_C2IyUDDKB9gNz_bt5pLaC8fFmFa0E_Cvq6s9eXOGe8M0fvBUFYG3bqVQAsCyz3w==@protonmail.internalid>
 <20250617124546.24102-1-pranav.tyagi03@gmail.com>
 <qlogdnggv2y4nbzzt62oq4yguitq4ytkqavdwele3xrqi6gwfo@aj45rl7f3eik>
 <CAH4c4jLjiBEqVxgRG0GH37RELDp=Py3EoY6bcJhzA+ydfV=Q1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAH4c4jLjiBEqVxgRG0GH37RELDp=Py3EoY6bcJhzA+ydfV=Q1A@mail.gmail.com>

On 30.06.2025 14:36, Pranav Tyagi wrote:
... snip ...
> > >       spin_unlock(&mp->m_sb_lock);
> > >
> > >       if (copy_to_user(user_label, label, sizeof(label)))
> > > --
> > > 2.49.0
> > >
> 
> Hi,
> 
> Thank you for the feedback. I understand that my patch is incorrect and
> it causes a buffer overrun. The destination buffer is indeed, already, null
> terminated. Would you like me to send a corrected patch which uses
> strscpy() (as strncpy() is deprecated)?
> 
If the destination buffer is already NUL terminated, you can use either
strtomem or strtomem_pad [0].

[0]: https://docs.kernel.org/core-api/kernel-api.html#c.strncpy
(Description)
> Regret the inconvenience.
> 
> Regards
> Pranav Tyagi
> 

-- 
Regards,
listout
