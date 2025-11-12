Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824561C695
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 19:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762976741; cv=none; b=PLtWofn7JZZJPEcDSyrpvu4xoqlydFd4ADU36OZGHS8aFU3jiWSkQQGNXlq2DQ/D2o3tZT9620l7xIy9QOxysYU7tfgCWusC+qx9pCvvGFuSr6gvhDi6VQfaKcsEgQrG8BvtznTwxhcxPNqiE7Fqu/9BkxzuVw3CjqAlliDxULc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762976741; c=relaxed/simple;
	bh=Cy9aTtadqseYnlgxqb35PSRkzUP7ochnjW/JT2gqVBw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MbnzOYNsam+cWepqG1hnCSD1Xhvb4Mz5+F5HmKd9QBzSQc399vIrVj2GkyKIhu8bvm1YK2wwg7JjiG/b5zuXIW0z3v5AegIj6V3SkU25XnSMpzodqO99nQm2av4EeGnfk5GFJfN/bz8iecHCWuHgoNr/WQIVO7Eb+DrJq5/vqNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=XjBV8U3S; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="XjBV8U3S"
Received: from monopod.intra.ispras.ru (unknown [10.10.3.121])
	by mail.ispras.ru (Postfix) with ESMTPSA id 2D4D94076729;
	Wed, 12 Nov 2025 19:45:37 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 2D4D94076729
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1762976737;
	bh=dCIZqNCkXEd7UO0SQlXMk7goFo0mKTiGHHiY3VpcZ9A=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=XjBV8U3Slyz007a6WuFubLBRGnWMxUl7ZZnObuBr5OASKUaY+JgWKe0MsKzeSNmk4
	 wZJl94m1X/inGZqiiTpwtZhbEaIUGTnwfwgf3iWPd4ZwitRBhsapipDl6YjNs8C7CW
	 mGmQmXCRFal56/vwDyHNPQXTNos5mcRfvI85Y1sw=
Date: Wed, 12 Nov 2025 22:45:37 +0300 (MSK)
From: Alexander Monakov <amonakov@ispras.ru>
To: "Darrick J. Wong" <djwong@kernel.org>
cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db rdump: remove sole_path logic
In-Reply-To: <20251112185308.GB196370@frogsfrogsfrogs>
Message-ID: <7e7a4185-040d-b438-1821-bdb8b602f257@ispras.ru>
References: <20251112151932.12141-1-amonakov@ispras.ru> <20251112151932.12141-2-amonakov@ispras.ru> <20251112185308.GB196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wed, 12 Nov 2025, Darrick J. Wong wrote:

> On Wed, Nov 12, 2025 at 06:19:31PM +0300, Alexander Monakov wrote:
> > Eliminate special handling of the case where rdump'ing one directory
> > does not create the corresponding directory in the destination, but
> > instead modifies the destination's attributes and creates children
> > alongside the pre-existing children.
> 
> It sounds like what happened is that you ran rdump with a non-empty
> destdir, only to have rdump mutate the existing children in that
> directory.  Is that correct?

Not really (what you describe would have been even worse).

In my case, I was rdump'ing into a directory that had rtinherit set, and
rdump undid that (generally speaking, all attributes of the destdir were
overwritten, not just rtinherit).

> If so, then I think what you really wanted was for rdump to check for
> that and error out, unless explicit --overwrite permission had been
> granted.  Because...

(I would still hit the above issue with attributes)

> > This can be a trap for the unwary (the effect on attributes can be
> > particularly surprising and non-trivial to undo), and, in general, fewer
> > special cases in such a low-level tool should be desirable.
> 
> ...I use this "special case" and don't understand why you decided that
> removing functionality was the solution here.  This is a filesystem
> debugger, there are weird functions and sharp edges everywhere.

Shouldn't we strive to have fewer surprises? For instance, if there was
an explicit flag for that, there wouldn't be an issue.

Out of curiosity, what is your use-case for this?

Thank you.
Alexander
