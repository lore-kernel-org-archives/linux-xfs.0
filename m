Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A77E19ADA6;
	Tue, 22 Apr 2025 06:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745301707; cv=none; b=i5AixeNEw2wKQCI21+KYYLujfhPr21Hpoz2RBWq4uRvmQv/W1iJdtJvGjLbprv5IkNZ3oZauYF35DDZG/I1ntjullwwjGJ+r4Sckl4ntorAWiHCmH6HIqeEuvJQGIM5JtFTR6xtsABbdvWJBXmNLc1f+Xng8vcxn9t42KkmtGuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745301707; c=relaxed/simple;
	bh=ClA3eYNfdnMYPkIepnDKgnoJHN1p0vxxpst748rmpVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XT7cNzJG0FGRGAFwSDGFbSaPlaFXbsVaI2Tzr65eErIwRcYQE8/i9WFHGL0rxWiRZegPRqJdHBUMs5ihR/kqrgvnCsenM11+JZKSUymEq+AXsctrYmhwHf6JTbt7gvqVcB3Z+8aNU8FYhJ+FmyXLRXc72DGssduhVgZYmiVf17Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D16E4227AAF; Tue, 22 Apr 2025 08:01:38 +0200 (CEST)
Date: Tue, 22 Apr 2025 08:01:37 +0200
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
Message-ID: <20250422060137.GA29668@lst.de>
References: <20250325091007.24070-1-hans.holmberg@wdc.com> <iB7R4jpT-AaCUfizQ4YDpmyoSwGWmjJCdGfIRdvTE76nG3sPcUxeHgwVOgS5vFYV0DCeR1L5EINLppSGbgC3gg==@protonmail.internalid> <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net> <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7> <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net> <20250421083128.GA20490@lst.de> <c432be87-827e-4ed7-87e9-3b56d4dbcf26@roeck-us.net> <20250422054851.GA29297@lst.de> <c575ab39-f118-4459-aaea-6d3c213819cb@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c575ab39-f118-4459-aaea-6d3c213819cb@roeck-us.net>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 21, 2025 at 10:57:31PM -0700, Guenter Roeck wrote:
>> free should be floored to zero, i.e.
>>
>> 	free = min(0, xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS));
>>
>
> Do you mean max, maybe ?

Yes, sorry.

Also if you want the work taken off your hands I can prepare a patch
as well, I just don't want to do that without approval from the
original author.
