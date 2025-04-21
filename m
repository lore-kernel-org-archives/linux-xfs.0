Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CF313C3F6;
	Mon, 21 Apr 2025 08:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745224295; cv=none; b=KJKd+ynLNthOw8dwQEy+TcCbljoi/4fuFojLFHeN2Ht00cMSSGXf0oSjqN/B9btAg9DbiqzMWGmAr9k3mLt4a7nXUqS7xE6U/WvREipnCVdcUDEKZf8mYfTYJLEbwPTHOOrM+94FzceI4u/DWt2XU+Mh5r1v1ULdD0Rqy7cDOtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745224295; c=relaxed/simple;
	bh=6ybWQaWr2K5J38QeIe8zkxMMliX39OX8WjNRSHji00Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BX875Ph7+UZHS3Urjhe5xJSZedNhk4stAlvHr151Sre4pb9OQO4Qyse2/CteXbz2lSThHkPXuiv9ieo5693Cz1RxwrNF1QCbmPhGmvAfpAUqqrrpLNFyS5BCAmc7dGxvJkTjQ3WlyDjmMOLDmR6fN7CudRWX9SqYDk7cqC2Uk6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8621867373; Mon, 21 Apr 2025 10:31:28 +0200 (CEST)
Date: Mon, 21 Apr 2025 10:31:28 +0200
From: hch <hch@lst.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering
 zone GC
Message-ID: <20250421083128.GA20490@lst.de>
References: <20250325091007.24070-1-hans.holmberg@wdc.com> <iB7R4jpT-AaCUfizQ4YDpmyoSwGWmjJCdGfIRdvTE76nG3sPcUxeHgwVOgS5vFYV0DCeR1L5EINLppSGbgC3gg==@protonmail.internalid> <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net> <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7> <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Apr 20, 2025 at 10:42:56AM -0700, Guenter Roeck wrote:
> A possible local solution is below. Note the variable type change from s64 to u64.

I think that'll need a lower bound of 0 thrown in to be safe as these
counters can occasionally underflow.

Otherwise this is probably the right thing to do for now until mult_frac
gets fixed eventually.  Can you add a comment why this open codes
mult_frac to the code and send a formal patch for it?

