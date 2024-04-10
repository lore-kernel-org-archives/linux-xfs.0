Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C975C181BBC
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 20:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712782695; cv=none; b=JnHKZq58SHEEzqHvqI7vv02hiyYx88ckhEp1+gC/GQECzvG/wkITOlfLEvLyyQ0UK+DZ889wbx9yXWjJOmHo4XURovZCqYZddrVV3XLz/7U6fwRdPXB1/I0U01G9kMhM7R2aTekj/lHjqmPiCSYfZ3yFipkfAFDXYmPZq5YlDr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712782695; c=relaxed/simple;
	bh=Il5uoZLTTC4Vfe/PKvWJX8grKZ+biWLQPnKzoiPIHUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzJvh6n8+53L9Bl75a7Lrl/0SikxIMS45FGPtI+9hlx5FJiz3RTv7E/0bFJ4PE2YdnIf1kv/1xBi3pfSjwIuqkYFYiTPyxu9ARK+1kXVLC1QxKTn9plRGELGOzpTmwyRWbwfPC9eymaDVztycdWnub0Zh4ZDktDgpP+WYljG2Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dyfHdGq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dyfHdGq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5810DC433F1;
	Wed, 10 Apr 2024 20:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712782695;
	bh=Il5uoZLTTC4Vfe/PKvWJX8grKZ+biWLQPnKzoiPIHUQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dyfHdGq0UBkF36yR7ClMJ0zrxJ4wMRId/LFDuvWJS4pImiuqUGNH3euOVu4fS1/sD
	 cz4bWFY5mn+eLQdWpM0hQhqmAGhcN3eEIYRX1FU3ayk85myPk7a+bD7zwjCeDW1Qpe
	 N+Sz6izTTF34Im7V2q2+UZlWlRPM5jfOM/tkQgVHWNY4X1kJ3Ze2JmnQgkGwiTxHQ9
	 4KeXbaPuya6KBVq7wXLl3wefXY3ZuOp8puo24IneAuGWzf6E6l6oTkNqWju8HTL6bH
	 lKRkHaUuaiJGZknVDl2abgYAvg+N/cT88RbHxgNLRl1gqpxn/4AsU0ROV4zbqlZP2n
	 Zlxn/sQUAwCtw==
Date: Wed, 10 Apr 2024 13:58:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: attr fork iext must be loaded before calling
 xfs_attr_is_leaf
Message-ID: <20240410205814.GB6390@frogsfrogsfrogs>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270968870.3631545.18232340920205425116.stgit@frogsfrogsfrogs>
 <ZhYdyz8n0EU4Hrpc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYdyz8n0EU4Hrpc@infradead.org>

On Tue, Apr 09, 2024 at 10:04:11PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 05:50:38PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Christoph noticed that the xfs_attr_is_leaf in xfs_attr_get_ilocked can
> > access the incore extent tree of the attr fork, but nothing in the
> > xfs_attr_get path guarantees that the incore tree is actually loaded.
> > 
> > Most of the time it is, but seeing as xfs_attr_is_leaf ignores the
> > return value of xfs_iext_get_extent I guess we've been making choices
> > based on random stack contents and nobody's complained?
> 
> Yes, I'm kinda puzzled.

I suspect that most of the time we get lucky and *someone* has read in
the attr fork or created it or whatever.

> Note that the dir code actually reads the extents in their
> is_leaf/is_block helpers.  But given how the attr code is structured
> that would thread through a lot of code so it might not be worth it.

<nod> But it would be more consistent...

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
