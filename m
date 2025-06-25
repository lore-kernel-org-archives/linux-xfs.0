Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558E825B677
	for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 11:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750850584; cv=none; b=u4lafIwIfWuQVSZDoPafSxyFUpuyEg3xXL4klo1k4gT0sbXRNXBuck7NCSFNmXugU/NIEXR7slqjycWbylkfM2SpMLSqx67ocZpgNmvdbz04e+7bKb8QEKm+a8t2TSMeuF+El+6wwHB9P10LKlktstS/rvPImKHHm0t9HTOsDYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750850584; c=relaxed/simple;
	bh=vW2dPU36DqGfzsJNQ/oTRHvh+HeKmeZzozfc5JVqLDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pH56tH14di52D2susnuWbPqKZMsOEH1VuuBOrGryFAhdcHWaRAIciN4zXyBpoJg3ykQq3iJzB43UJ9pp/N9Hlb78FC9TEZaLojdXGE0iKE22LpUqzdkm9/tw1f5L1/tZhwUxGS9n0iPNzuvUgiKdpCMe/FtfOLmkqg3qk4RzdaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C0D7C67373; Wed, 25 Jun 2025 13:22:57 +0200 (CEST)
Date: Wed, 25 Jun 2025 13:22:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 1/2] xfs: replace iclogs circular list with a list_head
Message-ID: <20250625112257.GA30589@lst.de>
References: <20250620070813.919516-1-cem@kernel.org> <20250620070813.919516-2-cem@kernel.org> <aFoKgNq6IuPJAJAv@dread.disaster.area> <39xujXwbUGTy3j2E9pH6kGvaRPmJbSuo2peOANlQ21_G69mQy2f2TQX2zhXE2fEvknjHBViVbuVkacBo3jLZ1w==@protonmail.internalid> <20250624135740.GA24420@lst.de> <b5q3uuhkn2jqcjgg6qcv6z444bftoec7dwxh4qoxbj64z2vnfv@gogvtu75o4qj> <Xov06u5kQ-s2ZQXaFz0nUaYULne1GqJm_OEkG120aRXgOlMUgpYtYZ6I7noAjsto67svKHEFCMLeooos3iYkdg==@protonmail.internalid> <20250625062157.GA9641@lst.de> <tyu7x2ha543tu32auj4k32ot3lroqzm2epqn6e42hs54k3k3ox@4ubdiogmywqy>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tyu7x2ha543tu32auj4k32ot3lroqzm2epqn6e42hs54k3k3ox@4ubdiogmywqy>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 25, 2025 at 10:20:35AM +0200, Carlos Maiolino wrote:
> > As long as the maximum numbers
> > of iclogs is relatively slow and/or the default is close to the maximum
> > this seems optimal.  If we every support a very huge number or default
> > to something much lower than the default a separate allocation would
> > be better here, but that's a trivial change.
> 
> Well, unless we decide in the future to increase the number of iclogs, this
> seems doable, and the iclogs pointers array will fit into its own cache line,
> eliminating the problem pointed by Dave.

Even for a modest increase of iclog that seems fine (and I think Dave
at least had vague plans to increas the numbers).  And if we get a huge
increase we'll just switch to a dynamically allocated array, which is
also trivial.

> I can do the work if we agree this can be useful somehow, at this point I'm
> wondering if change this will actually improve anything :/

The question of what's the point is why I gave up multiple attempts to
clean this up after running into issues with my initial idea :)

