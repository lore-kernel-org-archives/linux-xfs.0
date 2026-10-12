Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87B849891F;
	Mon, 12 Oct 2026 15:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791820070; cv=none; b=n1i+9V8NUc487e806GVSugHEH4/Fu7lRF6rUjmnVrFQDVmIYN+ja3ujAoV2F/liOKMk/Gg1g7/lixtlgQx8PkGIYnI83UZuGeoZIKHIpjog5AWtqsE8vRvuNx8L5BE65PBXYXQfSd7xdkiWJGJzx/ydNcCqEIn2G8fITAZFXpLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791820070; c=relaxed/simple;
	bh=aMs92VW4xEsQaDa34gb5tkTfSiDKqGcrkBdi+GwjQXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZELLU5bm/y+SlfQWQ6fnYFyndWlNVppEkMziNpGFOCqT9jy7+lNnyBmx+QuqTw4lU2n/QIN8bIptRKsllWNJ3TliguoB06H7rmLuqVfLAIP3QNMUROJTWONAu4X19drayLkQqzjDvWqbUM05Izm6Hu+SZhE5CkmOB7vJLTRXRI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bU/1vGGO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bU/1vGGO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 795EE1F0089C;
	Mon, 12 Oct 2026 15:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791820069;
	bh=cxatueqfO47A8zw0ntZhDxOu2QAe6UvpcuALPYe7gR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bU/1vGGOzSXkVlD2pmV34AmngM2sq4DynBp51JikIOSAQcbdBhEAm9RoUHQ8wSgcI
	 q+Lth4VXhNNyt99R7Q2hgxAx2aeyU9Lrf/GdSutoIJN6FK1bHTURnGT6XtomTDXkRH
	 sCBVost+HGKIhFHFKk0iUaZuME32NTh6lKkU5sWl3F84H2fHUBKwuSmpkgbH7Hrxmp
	 oBOGz7d/u2rhCaXe+3CAczen6C2ByA7GXMlgCsVWGpTA+1fZMsdF9p6dkScVO+vKCp
	 ON8TxEH6rKl9t3qGbWHoQ5H1gGYNgtO7X4LalZRE3bLgF1aQxaFDUV8pH7UxCB4Loq
	 FT9lBCQ7o2lAw==
Date: Mon, 12 Oct 2026 08:47:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: reduce new btree slack factor if free space
 is negative
Message-ID: <20261012154749.GA2705364@frogsfrogsfrogs>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
 <179178065281.1058326.11344648618549479599.stgit@frogsfrogsfrogs>
 <aszbuYSyUzTIrlJi@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aszbuYSyUzTIrlJi@infradead.org>

On Mon, Oct 12, 2026 at 06:08:09AM -0700, Christoph Hellwig wrote:
> On Sun, Oct 11, 2026 at 10:56:46PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM points out that if the incore fdblocks counter is negative, the
> > assignment to uint64_t will mask this possibly low space situation and
> > we don't pack the btree blocks as tightly as we probably ought to.  If
> > it's the case that there's some free space and fdblocks is too low due
> > to an error in the superblock field, then we can end up failing btree
> > rebuilds due to ENOSPC unnecessarily.  This is a corner case, but let's
> > fix it anyway.
> 
> Should thi simply use xfs_sum_freecounter instead of
> xfs_sum_freecounter_raw as the former takes care of the issue
> in the more "normal" way?

Heh, yes.  I forgot that existed :(

Fixed, thanks!

--D
