Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3A4158558
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 19:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738699164; cv=none; b=COQ7CsG00o0uoD965MboGszT0v9q3ljYnHMlI4YlSWQas2GD0L9zGHOweTkMb7UZNn/E29JsUwF4lPT07Dyxqz6TwH8I0iqybwLZc5HEW6yRRiWFQKuJnUuw0JiFjzyGzTfG320J/i4ioB4Am8i2zB4cdLE6pkA6NVttb4drNTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738699164; c=relaxed/simple;
	bh=X2Iy/G3kJZCaDEB9xA8MUD/VlpJM0GlHqv/Z0WxV+L4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=latjypvMvoPXmejydB1aL40Xw5M/Q4V4YeA4NYCk8nhH64EriZaBlrg0bVko4SyHHvsvdyCAiid9msS3hQgw7+eH5oxbTSG1jvwsqB1SdXVYQLbA092t0N9jOfKXY2L+ZXfji7DJ0BwfqgPfUlCzTGoQkh6WSgsmse3cP3oE4ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rBes6uTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rBes6uTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEFCC4CEDF;
	Tue,  4 Feb 2025 19:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738699164;
	bh=X2Iy/G3kJZCaDEB9xA8MUD/VlpJM0GlHqv/Z0WxV+L4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rBes6uTveyTqzJ94Ywk3Qomg6avvxsfkMr5kRfNhqtG3pwWEEDaYEhGN1GNP6elRC
	 OHQCQE77k4ta1fXUTZOyjOD8yhyzolumYsMHKOMZ+5gYFtvc+Id4yshm+z3HDWtRoK
	 d+6hWBdOla0Lz0cJhV3isILmDw5IkJLgD5cIXNsr6RaD0gh5s2ABcD+tUNg/31on0J
	 WpuNktpWVt3V7yeg5cVlWcjtY5lUnMBn7rEsxgBJEGKqnF8LpJunIotJDZh+DX9vmT
	 foo7a2JEYc4+pkCE1w2ZQccJx/64yjPL7hvBXLMl7WOtR+YXwzFbyfjG5rY37GKPNH
	 beR4j8IK1tPDQ==
Date: Tue, 4 Feb 2025 11:59:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Lukas Herbolt <lukas@herbolt.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: do not check NEEDSREPAIR if ro,norecovery mount.
Message-ID: <20250204195923.GF21808@frogsfrogsfrogs>
References: <20250203085513.79335-1-lukas@herbolt.com>
 <20250203085513.79335-2-lukas@herbolt.com>
 <20250203222652.GG134507@frogsfrogsfrogs>
 <0e383591-7023-47bb-a202-2277e2d4f7ad@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e383591-7023-47bb-a202-2277e2d4f7ad@sandeen.net>

On Tue, Feb 04, 2025 at 11:55:00AM -0600, Eric Sandeen wrote:
> On 2/3/25 4:26 PM, Darrick J. Wong wrote:
> > On Mon, Feb 03, 2025 at 09:55:13AM +0100, Lukas Herbolt wrote:
> >> If there is corrutpion on the filesystem andxfs_repair
> >> fails to repair it. The last resort of getting the data
> >> is to use norecovery,ro mount. But if the NEEDSREPAIR is
> >> set the filesystem cannot be mounted. The flag must be
> >> cleared out manually using xfs_db, to get access to what
> >> left over of the corrupted fs.
> >>
> >> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> >> ---
> >>  fs/xfs/xfs_super.c | 8 ++++++--
> >>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> >> index 394fdf3bb535..c2566dcc4f88 100644
> >> --- a/fs/xfs/xfs_super.c
> >> +++ b/fs/xfs/xfs_super.c
> >> @@ -1635,8 +1635,12 @@ xfs_fs_fill_super(
> >>  #endif
> >>  	}
> >>  
> >> -	/* Filesystem claims it needs repair, so refuse the mount. */
> >> -	if (xfs_has_needsrepair(mp)) {
> >> +	/*
> >> +	 * Filesystem claims it needs repair, so refuse the mount unless
> >> +	 * norecovery is also specified, in which case the filesystem can
> >> +	 * be mounted with no risk of further damage.
> >> +	 */
> >> +	if (xfs_has_needsrepair(mp) && !xfs_has_norecovery(mp)) {
> > 
> > I think a better way to handle badly damaged filesystems is for us to
> > provide a means to extract directory trees in userspace, rather than
> > making the user take the risk of mounting a known-bad filesystem.
> > I've a draft of an xfs_db subcommand for doing exactly that and will
> > share for xfsprogs 6.14.
> 
> I think whether a userspace extractor is better or not depends on the
> usecase. I suppose there's some truth that a NEEDSREPAIR filesystem is
> "known bad" but we already suffer the risk of "unknown bad" filesystems
> today. (Or for that matter, the fact that we allow "norecovery" today,
> which also guarantees a mount of an inconsistent filesystem.)
> 
> "Something is wrong with this filesystem, let's mount it readonly and
> copy off the data" is a pretty time-tested approach, I think, hampered
> only by the fairly recent addition of NEEDSREPAIR.
> 
> a userspace scrape-the-device tool may well be useful for some, but
> I don't think that vs. this kernelspace option needs to be an either/or
> decision.

Fair enough; it's not like we have a tool today that can extract
directory trees from an unmountable filesystem.  Do you want to rvb this
one, then?

--D

> Thanks,
> 
> -Eric
> 
> > --D
> > 
> >>  		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
> >>  		error = -EFSCORRUPTED;
> >>  		goto out_free_sb;
> >> -- 
> >> 2.48.1
> >>
> >>
> > 
> 
> 
