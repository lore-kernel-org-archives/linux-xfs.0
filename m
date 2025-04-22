Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52347603F;
	Tue, 22 Apr 2025 05:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745300940; cv=none; b=Xna9ajKyR09Q0ufR6VeXt1fbSsreS6HLXyKAH4MF/uuc14CRHSO1+n30Tuui95ZJ7hGaYYa96rfsiNWd4pXLTQpWTqdZhwn4svUuvi6IQZWH5Da1CjjLXk0XXis8bWKL5IBWd05QXVl27Pbq/cmyXh8nioBFx9OALTxp0zn6EkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745300940; c=relaxed/simple;
	bh=oOmHaUh3XMoyTX+9SKqcADLzRmCG6YZr6n2mPFgsGJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j47HTdEXTV98crtYipiTxFEOaj2rzJFEehedWkCcX8Ugr2N9o4wYmZ05yyNjjTGKhCTtkk2Nno/aXXYD79CiM++aSPnj6JoNJJif7HODM+uqdXnkMvgJlVHsUPr+RHK8ZJ/camp9Su8BO1t3qK8PYU7UPT2REWlUZVmjrFVakzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3322D68BFE; Tue, 22 Apr 2025 07:48:52 +0200 (CEST)
Date: Tue, 22 Apr 2025 07:48:51 +0200
From: hch <hch@lst.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering
 zone GC
Message-ID: <20250422054851.GA29297@lst.de>
References: <20250325091007.24070-1-hans.holmberg@wdc.com> <iB7R4jpT-AaCUfizQ4YDpmyoSwGWmjJCdGfIRdvTE76nG3sPcUxeHgwVOgS5vFYV0DCeR1L5EINLppSGbgC3gg==@protonmail.internalid> <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net> <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7> <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net> <20250421083128.GA20490@lst.de> <c432be87-827e-4ed7-87e9-3b56d4dbcf26@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c432be87-827e-4ed7-87e9-3b56d4dbcf26@roeck-us.net>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 21, 2025 at 06:41:43AM -0700, Guenter Roeck wrote:
> On 4/21/25 01:31, hch wrote:
>> On Sun, Apr 20, 2025 at 10:42:56AM -0700, Guenter Roeck wrote:
>>> A possible local solution is below. Note the variable type change from s64 to u64.
>>
>> I think that'll need a lower bound of 0 thrown in to be safe as these
>> counters can occasionally underflow.
>>
>> Otherwise this is probably the right thing to do for now until mult_frac
>> gets fixed eventually.  Can you add a comment why this open codes
>> mult_frac to the code and send a formal patch for it?
>>
>
> Technically only free needs to be u64 for do_div to work. But that makes
> me wonder what the function is supposed to return if free < 0.

free should be floored to zero, i.e.

	free = min(0, xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS));

