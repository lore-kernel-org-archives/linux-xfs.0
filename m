Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57A63BED5E;
	Thu,  5 Mar 2026 16:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772727664; cv=none; b=C0P/3J53U8EXnbxiIeCxLsnRozPugLq/02xoZcNm3tvYIud1FLQLMx9OViZHc7CHRvhp4Hd3O3zj1r4J/bHvdm611UkCjbf1QxEbz1bRyg2LZlme5Q9pyuFDwmT/vPQcJ60bY1xCz14hLNc0u+YbYxaT8hUD0Ih10dAxupB3Y0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772727664; c=relaxed/simple;
	bh=mczRhjYMeXSlgmFunKwEInL6PHag54s74KFFOb95N5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ojTiAae5VvhiWXw/i5TZlxP+eHgNIkj9HO+7SwFp8fu3AyJ0gccJzCPPcP7RyoK9HWhvssNmIE1LAVCXW01Goaa9pKQ9gP8KMhbeBji34HfU8nEJ/JbUVOePzdDftkWp10dNsm6hdOofzyV/+qPwRcaoMfK833S+GOwIiIj6oSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bskykuSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bskykuSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED77C116C6;
	Thu,  5 Mar 2026 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772727663;
	bh=mczRhjYMeXSlgmFunKwEInL6PHag54s74KFFOb95N5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bskykuSKMANUt16C8ePZBBl5YQPSeAEnVggLCK49Sov3oJhNf6UzS+tt9m/Ynvp9b
	 lQ53QlFaW7J456jcCOgjoIajDGTdGaW7Fl8SfrwWYQX3vkRpeWDAcQTMuNyaCNhJhN
	 fKJNawwi8EwQXWLrQeIhoZgkNnj0ZeSCbpBxMJy/JfnC7IkokbVcDKFaN9bI/kxLdC
	 yE1AHWA7SeU9pwyYUD7z9+wtsYQoiaxUyLq73tMAhdHvJE9sBzrfJyPGaA/CUJH067
	 FU3MKusRPklbZTjUBCQX5trgfMjobRCt1PqVRLgwn/aUAPpRqZ1g3OyWH744XjauLn
	 yryWgSuYGt32g==
Date: Thu, 5 Mar 2026 17:20:58 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: don't clobber bi_status in xfs_zone_alloc_and_submit
Message-ID: <aamtVVapQpISrQHV@nidhogg.toxiclabs.cc>
References: <20260304185923.291592-1-agruenba@redhat.com>
 <aamNC9JwxBNBBTmW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aamNC9JwxBNBBTmW@infradead.org>

On Thu, Mar 05, 2026 at 06:02:51AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 04, 2026 at 07:59:20PM +0100, Andreas Gruenbacher wrote:
> > Function xfs_zone_alloc_and_submit() sets bio->bi_status and then it
> > calls bio_io_error() which overwrites that value again.  Fix that by
> > completing the bio separately after setting bio->bi_status.
> 
> Looks good, but can you drop the pointless goto label renaming?
> I'd also be tempted to just open code the split error case instead
> of adding a label for it.
> 

/me goes pull it off the next pull-request
