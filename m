Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3F23803DB
	for <linux-xfs@vger.kernel.org>; Tue,  4 Aug 2026 11:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785844582; cv=none; b=T/z82nKS8BEt4MYsOBrlS/aTC79kQtc0cFNoRDa1UYVKdqL5pd/Va7vZlNrnqoI3yI2eBesdlLVSgP2km4GzMXUfmabNnhY4ZDsLdH+WF+JUiPlMPMkwTxTn33x+q0oxC/BnXJwXAZj/qmhu1oP6OLg/KI1OUCdYNGWyEJbG1+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785844582; c=relaxed/simple;
	bh=7wLG2xHpT2AFGQ6kJN8LqbVdv+zTAgnmhU3KOGJm13I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QyPGr6+tslKPcW4S9IaqfEp/jsYojfqWACxiq6ym0i4vPoq5uBCG0TkuGdJjGisT5R7Q7WxWtFiCg5j4H96sxdMgq9QJEUhdlWkIFZvLUcIJqVblPCkfvn5DvR9P9QDCAUUeZbrZgJHWUyHW3Htet51R8X+mZxgkX3rhkm+UUnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFXZ1CLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFXZ1CLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562D91F000E9;
	Tue,  4 Aug 2026 11:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785844581;
	bh=vT89eWuKRGe+c127utTPEG/970+lCyrq2jHBN5pC9Xg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BFXZ1CLAl2oTBNecKlPhnaKreC2I4n3L8/kzjqt/2Yal/X/pdCYXfUB5WazjRlLQz
	 xpj96Tr1AvqNzqae8a86heVsLdJhQlVyCMqqiznRvYa6NLORF2XAbW9As2FJxIj7Ln
	 CQKeyLAZ21Yi8W9iDa06ZqHIxHf9JOyvCm4l4dW3R5ayzvq3kMkuDZRPXwsgF9X7DT
	 uvf9SB4xn51T254xhqzUklVV0LJfQqKmaWgi8PXaAI6TKF6T3cro6ZK0pTJgQynN+7
	 KWPq7/0cJguPl/n7OFWP1Yp5d1TvcGf+phxQFBUPxgo1y+rK7ut7+Y0rhM86Mo3ikS
	 8JJi8aB5hE+4g==
Date: Tue, 4 Aug 2026 13:56:17 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: improve log context annotations
Message-ID: <anHTCHGsqjL9edw3@andromeda.toxiclabs.cc>
References: <20260720094609.2191633-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720094609.2191633-1-hch@lst.de>

On Mon, Jul 20, 2026 at 11:45:37AM +0200, Christoph Hellwig wrote:
> Hi Carlos,
> 
> this series improves the lock annotations in the XFS code.
> 
> Note that right now this is all mostly unused - the less stringent sparse
> lock context checks got disabled when the clang version was merged, and
> we're not quite ready to enable the latter yet due to our conditional
> locking in the ilock helper and the locking contexts transferred to the
> transaction for the inode and dquot locks, but I'm working on that.
> 

I do disagree these annotations should be killed, so, for the series:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> In the meantime having these corrected at least serves as useful
> documentation.
> 
> Diffstat:
>  xfs_extent_busy.c |    4 ++--
>  xfs_icache.c      |    3 ++-
>  xfs_log.c         |   33 +++++++++++++++++++++------------
>  xfs_log_cil.c     |    3 ++-
>  xfs_log_priv.h    |    4 ++--
>  xfs_mru_cache.c   |    2 +-
>  xfs_trans_ail.c   |    4 +++-
>  xfs_zone_alloc.c  |    2 ++
>  8 files changed, 35 insertions(+), 20 deletions(-)
> 
