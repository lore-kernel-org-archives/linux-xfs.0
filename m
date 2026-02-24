Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF56630F55B
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 19:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771962242; cv=none; b=si7Vg5Si1OXmDsyEeSnexAG3fCMzOVIRQrdE/I2U6p/rTJF9mDiavkfDcR9rNiptsfN/KS7hPqKSPXvXBIMnL7oaEZS4TjU9alVxnqn9AelMk2MIwRSaLNzxOc8FCrImLcFXWWxLzm5JaXherAJfRQZZ5VZQXt/r8LHYudkcKN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771962242; c=relaxed/simple;
	bh=S0nYxQtrpdcp+PoTMdl3fjv+jhCSy4OW8Lj/QaN8Iu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c45xNqCrvKXx3WR4EeXENX3YcS4EiiFkprRLsfMZVpbIfjFsEFn+PFB2496QrKPY+g8kOtcuRbIelZLP2W68qwbv2Pmgl6WmOMBKat8I+v6TUu2H3B5rfwXQnI9MnHB3hmJtndEzR4sN7+i+y5XJuYnf3T2wnvf51m5sCWXI07g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3AsphTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3AsphTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEA0C116D0;
	Tue, 24 Feb 2026 19:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771962241;
	bh=S0nYxQtrpdcp+PoTMdl3fjv+jhCSy4OW8Lj/QaN8Iu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O3AsphTPDlry29k5Kv7RgrJGl4Br9RZta896R75Gg5gtFLTrbHHMi1PS0zhem8+ba
	 ufvFMzUuWZkDH1GCTwrJjiUUwNxwsrX8nyGGcK0Ln9xl5GM2JQqjU4jKJEfoA996f9
	 dz6SFNv1fBfSkVGPQUL342IdvB7bCYxW1w52Z65TM5x7BcgtnkABDk8FpAqGGMZBKD
	 ozbL9xGF+aO8WyK01X0Y1jqvnW6U2ClzRQFe7q6j8/45s5g309MaOco/RjGQayR5jy
	 vQyI05fqpXxUS0iw3F8F2tjFIFmQ6LjfrssXcA8o74+iZLt3i5CtKCxdeyWXjltTFo
	 XWKtdnf7w45hw==
Date: Tue, 24 Feb 2026 11:44:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: =?utf-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFE] xfs_growfs: option to clamp growth to an AG boundary
Message-ID: <20260224194401.GB13843@frogsfrogsfrogs>
References: <CAEmTpZGcBvxsMP6Qg4zcUd-D4M9-jmzS=+9ZsY2RemRDTDQcQg@mail.gmail.com>
 <20260223162320.GB2390353@frogsfrogsfrogs>
 <CAEmTpZFcHCgt_T63zE4pQk4mmyULZ7TfTNqPXDXDfJBma8dj+g@mail.gmail.com>
 <20260223230840.GD2390353@frogsfrogsfrogs>
 <aZ29NxAM6CpGXVWl@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZ29NxAM6CpGXVWl@infradead.org>

On Tue, Feb 24, 2026 at 07:01:11AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 23, 2026 at 03:08:40PM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 24, 2026 at 12:29:49AM +0500, Марк Коренберг wrote:
> > > ```
> > > cp: failed to clone
> > > '/run/ideco-overlay-dir/ideco-trash-o4ut52ue/upperdir/var/lib/clickhouse/store/e2b/e2bdef56-6be8-40bf-8fab-d8fb2e9fdd94/90-20250905_11925_11925_0/primary.cidx'
> > > from '/run/ideco-overlay-dir/storage/ideco-ngfw-19-7-19/upperdir/var/lib/clickhouse/store/e2b/e2bdef56-6be8-40bf-8fab-d8fb2e9fdd94/90-20250905_11925_11925_0/primary.cidx':
> > > No space left on device
> > 
> > Ah, that.  coreutils seems to think that FICLONE returning ENOSPC is a
> > fatal error.  I wonder if we need to amend the ficlone manpage to state
> > that ENOSPC can happen if there's not enough space in an AG to clone and
> > that the caller might try a regular copy; or just change xfs to return a
> > different errno?
> 
> I think the problem is that we report ENOSPC for this.  The historic
> error code coming from the old btrfs days is EINVAL for "can't support
> this for random unlisted reason", which btrfs does for example for
> inline extents.  We really should turn ENOSPC into that.

Yeah, I'll give that a spin.

--D
