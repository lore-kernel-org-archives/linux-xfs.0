Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6AB33F5BC
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 16:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701369; cv=none; b=jBLR+PihtA2qbyPfONdHOBg8Nu3B7CgPwZbdUa/T7NQ34z3WGsSSYkpadi9NhbFqoqOX5t3BKLxA3R059nNCAo3hXTAGKglfg7w1f+lN86Z0eSwGM7TdlEmXLP8xAQEdcLRGBUoWkHDvV8Qo2ltGAKa/eZd5oZoELGD4PTIKGck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701369; c=relaxed/simple;
	bh=T7wzd+9PVTQqqJbh54vktlHHbqprWTHNgvr5h37aYCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=clnrm50JPXy764M4vBRyn03WOPqvAfi5fxWIhsP0FRI4BvRkq+bWRRGlrMYGSMAIzUDU/muchg6pP1oVnzXGKoXCDHshaSlPqXR0n2BakvsaUDahAhImC2XZneDAyRwJqhsT5agnAMHrYlau+xEu0UxrsgqgSqF5bD5RexGM2ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8iWZOcz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8iWZOcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C0FC19425;
	Mon, 20 Apr 2026 16:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776701369;
	bh=T7wzd+9PVTQqqJbh54vktlHHbqprWTHNgvr5h37aYCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A8iWZOcz7yV1cF7O3JdwJP7rDJyS1N0u/oRoRJTZ/O0U9dZDIFxLSbVVskLsUcDP4
	 /8m1kzZxxUNAyMuoE7pIIXlQoX93N45JJsnl5rnmS1OJpLLCykviIgSJYVx1Yy4dGA
	 qYW2oPZ2ay2OphEBjrVUrePUszc4IMK8FcgSn9aTn7xi5id3nvwpOk6dT9Og+LITGh
	 U8MLFZ5DYgtl0lx0WrNsg15FVHsjShhWX55JaKvZZBH58CyY3mJ9Of5peTLj7iK+o8
	 N5uKOQ90Q7K7jyVD+0/W0fCs7aehaIKBql5xN0LtY95aMPyvEzZx3kMFFBwT3ipyT/
	 rTCLnrw1cwNOQ==
Date: Mon, 20 Apr 2026 18:09:24 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: expose the current zonegc required status in
 sysfs
Message-ID: <aeZPtHgVAieyBEqo@ryzen>
References: <20260420135011.624587-4-cassel@kernel.org>
 <20260420135011.624587-6-cassel@kernel.org>
 <41e7ced6-90c0-423a-9a90-4bfa263bdb31@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41e7ced6-90c0-423a-9a90-4bfa263bdb31@kernel.org>

On Mon, Apr 20, 2026 at 05:47:55PM +0200, Damien Le Moal wrote:
> On 2026/04/20 15:50, Niklas Cassel wrote:
> > The current zonegc required status is currently available in
> > /proc/<pid>/mountstats (which contains stats for all mounted zoned XFS
> > filesystems), under "RT GC required:".
> > 
> > Add a sysfs attribute /sys/fs/xfs/<dev>/zoned/zonegc_required for the same.
> > This makes it trivial for monitoring software to read the value, for a
> > specific filesystem, without any complex parsing.
> > 
> > Signed-off-by: Niklas Cassel <cassel@kernel.org>
> 
> As is, I think this is OK, but I wonder if we should not instead call the
> attribute zonegc_running and use xfs_is_zonegc_running() to test the
> XFS_OPSTATE_ZONEGC_RUNNING flag for the attribute value ?
> 
> The reasoning here is that the GC thread also does zone reset for zones with all
> blocks invalidated, and in such case we may start the GC thread even when
> xfs_zoned_need_gc() is false.
> 
> And I think it is more interesting to see if the GC thread is running, so doing IOs.
> 
> Thoughts ?

I did originally create two patches:

This patch, which does exactly like "RT GC required:" in /proc/<pid>/mountstats
(which also calls xfs_zoned_need_gc()).

Another patch that added another sysfs attribute:
/sys/fs/xfs/<dev>/zoned/zonegc_running
which like you said, calls xfs_is_zonegc_running(zoned_to_mp(kobj))).

However, I couldn't come up with a good argument for adding two new sysfs
attributes that are more or less the same thing, therefore I chose the
attribute which is equivalent to what we already expose via mountstats.


If you think it is a good idea to have both, then I could just dig up my
patch from the git reflog, and sent it as well.

However, I think if we add such "GC running" attribute, then for consistency,
shouldn't we add the same also to mountstats?


BTW.. didn't you think about moving the zone resets out from the GC thread?
If we ever do submit such a patch, then the two attributes would always have
the same value. So perhaps we should hold off with adding two attributes until
we know for sure if we will move the zone resets out from the GC thread or not?


Kind regards,
Niklas
