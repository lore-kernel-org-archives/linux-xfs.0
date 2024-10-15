Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2521F80A1
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 19:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729019162; cv=none; b=kDsblAeIUsCpxJF3U7CY7a9BdY/an+uRVe750ZrCcOqtJJC/qAjr1yQEQULP/sucbEGv3axtmb029WrI+lb/6bAALllPzaWXLZOnK0VRgqFR7Ha6l9hIkD7lHbOiE2xqCZk5Ty43DapsErazqRa6x+s//DCpfdvOBR+sVyXyIxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729019162; c=relaxed/simple;
	bh=zfAqAUVY2qWlmUFED0AxddNUHWGiXmzLBBYKyvmCf1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PuMgMxS8aG42cYsjTtcqguI7n3iGFMnFMv4/72h5hO1JdryNu8jwZmSiHa0EulsH8IFxw1K5eLv9fpkvWcR889p6uzfbvcdfu4AEnkTZwJeCLpTaii0DLSjN7KcgHzvP0B78BIatZnHxdoCGHDWGLA/K6dAmch6sC3Qs6XVtjrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCSDobFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCSDobFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F700C4CEC6;
	Tue, 15 Oct 2024 19:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729019162;
	bh=zfAqAUVY2qWlmUFED0AxddNUHWGiXmzLBBYKyvmCf1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FCSDobFL/NOUwe0yzgr6TP1EofhLVBSEelqQo/8autdqRsmB/bmKDGOppjNb9MKJz
	 lgYU8HHwpq96wKobZ8wftP5X3OZO+BSuhzmAcobCVbDNZbzCM3iGyUXH4iwgLVRA1b
	 6KVZ8cMqsQSZjf7zNj0W5Tr/8N2bNeEoBzlkH1mOIDRB4X3qTsqz8/YSi/iZlsQ7Bd
	 X8xo0HJMpRDSTAeUL2lq3yQGZfp0t5AQQFAblGeJAUQl6Vf4R7O4naTjpog0W7/Adw
	 tmZhXqVGJPfsh6sJfbhsbzOyB7bLS64z7ibMPh6XAogdOzVgVkhSR0O6rWKVkcLiDU
	 KrdUFBTmUF+mg==
Date: Tue, 15 Oct 2024 12:06:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "hch@infradead.org" <hch@infradead.org>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 10/36] xfs: export the geometry of realtime groups to
 userspace
Message-ID: <20241015190601.GI21853@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644412.4178701.5633521217539140453.stgit@frogsfrogsfrogs>
 <ZwzXRdcbnpOh9VEe@infradead.org>
 <8ecae4c5-aeaa-4889-8a3a-e4ba17f3bf7c@wdc.com>
 <20241015011432.GQ21853@frogsfrogsfrogs>
 <Zw3h6JUJZa0SZisW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw3h6JUJZa0SZisW@infradead.org>

On Mon, Oct 14, 2024 at 08:30:48PM -0700, hch@infradead.org wrote:
> On Mon, Oct 14, 2024 at 06:14:32PM -0700, Darrick J. Wong wrote:
> > Hmmm so if I'm understanding you correctly: you want to define
> > "capacity" to mean "maximum number of blocks available to userspace"?
> 
> Well, what we want is to figure out how much data each rtg (and thus
> hardware zone) can store.  This allows databases to align their table
> size to it, and assuming XFS does a good job at data placement get
> optimal performance and write aplification.
> 
> > Does that available block count depend on privilege level (ala ext4
> > which always hides 5% of the blocks for root)?  I think the answer to
> > that is 'no' because you're really just reporting the number of LBAs in
> > that zone that are available to /any/ application program, and there's a
> > direct mapping from 'available LBAs in a zone' to 'rgblocks available in
> > a rtgroup'.
> 
> It's really per-group not total file system global.  So the reserves
> and privilege level should not matter.
> 
> > But yeah, I agree that it might be nice to know total blocks available
> > in a particular rtgroup.  Is it useful to track and report the number of
> > unwritten blocks remaining in that group?
> 
> Maybe.  Not rally the prime concern.  Note that for the zoned code we
> can do that completely trivially, but for the bitmap allocator it would
> be a bit expensive.

Not if we stuffed a field in the summary inode somewhere, but ... I
don't think anyone really cares, and that'd be another piece of metadata
needing cross-checking.

If anyone really wants that kind of info, they can figure it out from
GETFSMAP.  If anyone /does/ use GETFSMAP to figure that out and thinks
it's too slow, now would be the time to speak up.

--D
