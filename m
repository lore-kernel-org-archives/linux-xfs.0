Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6671133A9C4
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 22:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771971952; cv=none; b=C3aawCjeasnf5ZxM6rOawLO3MLAs9CXMQhtSwLMApencSilEwnpnqJeiX1wbsW7jl13eOiyfka9dRCQWK7R7OdOfuG1v0E9A6aTgXlrIOQFn4hSkJyxOBLl7dRHF+coKocg3exrH/TjpnbTQpMw9ddlA4jfoVxkANdjnJfqoVe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771971952; c=relaxed/simple;
	bh=6ZrtAKmz352mTqwx8WW9nPH2FBknC6jKqtHUmvyy5rA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LCFQom5AK6aAe7h4gqSe1X7HJ7gKiMBP1NDLpL9YFUI0wOie6/2pzqDysr7smT1xBKv9/WMUXRZ/a585ZyqEzMAj5r52dNEV+UKYVScq9rA56DPhqbN/JvB3IzFdGO8Lx3tfbQ6FnCrq0YWP8gCsFcicjSzG6uNjomlD2tnYdQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vb+RAZyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vb+RAZyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7DBC116D0;
	Tue, 24 Feb 2026 22:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771971952;
	bh=6ZrtAKmz352mTqwx8WW9nPH2FBknC6jKqtHUmvyy5rA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vb+RAZyJPb6NGiIsXU8y3Hred+nEabm1iaegHqn1T+IYwXH0ojCCd5X6nUm9+0IrD
	 btDBpklrTMQ3TLN5y079zT4k102YmE098Er1J6pwN3xx9fYxuhPIyM4S9MTQUsdp7k
	 zSKlzTAgBcpWV5yWSXwmAufAm28kohlx4BrSLlPqWDlwKlbA5wlrG19h0Vcs0QcgUs
	 Pl2jNrxe9MYr1B5v/T51JLBQJfuGQhdw20oXY2zbSZDLyU1I4NDoe37OwPQTTSWBXP
	 0tuwHpKvU544TilcvcZsa8rDRCdZ1eRvoXDsKHFVD3ui50plVvzfcq3469jHKMb3lf
	 AUzxcHA1kv+Xg==
Date: Tue, 24 Feb 2026 14:25:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: =?utf-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFE] xfs_growfs: option to clamp growth to an AG boundary
Message-ID: <20260224222551.GA13853@frogsfrogsfrogs>
References: <CAEmTpZGcBvxsMP6Qg4zcUd-D4M9-jmzS=+9ZsY2RemRDTDQcQg@mail.gmail.com>
 <20260223162320.GB2390353@frogsfrogsfrogs>
 <CAEmTpZFcHCgt_T63zE4pQk4mmyULZ7TfTNqPXDXDfJBma8dj+g@mail.gmail.com>
 <20260223230840.GD2390353@frogsfrogsfrogs>
 <aZ29NxAM6CpGXVWl@infradead.org>
 <20260224194401.GB13843@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260224194401.GB13843@frogsfrogsfrogs>

On Tue, Feb 24, 2026 at 11:44:01AM -0800, Darrick J. Wong wrote:
> On Tue, Feb 24, 2026 at 07:01:11AM -0800, Christoph Hellwig wrote:
> > On Mon, Feb 23, 2026 at 03:08:40PM -0800, Darrick J. Wong wrote:
> > > On Tue, Feb 24, 2026 at 12:29:49AM +0500, Марк Коренберг wrote:
> > > > ```
> > > > cp: failed to clone
> > > > '/run/ideco-overlay-dir/ideco-trash-o4ut52ue/upperdir/var/lib/clickhouse/store/e2b/e2bdef56-6be8-40bf-8fab-d8fb2e9fdd94/90-20250905_11925_11925_0/primary.cidx'
> > > > from '/run/ideco-overlay-dir/storage/ideco-ngfw-19-7-19/upperdir/var/lib/clickhouse/store/e2b/e2bdef56-6be8-40bf-8fab-d8fb2e9fdd94/90-20250905_11925_11925_0/primary.cidx':
> > > > No space left on device
> > > 
> > > Ah, that.  coreutils seems to think that FICLONE returning ENOSPC is a
> > > fatal error.  I wonder if we need to amend the ficlone manpage to state
> > > that ENOSPC can happen if there's not enough space in an AG to clone and
> > > that the caller might try a regular copy; or just change xfs to return a
> > > different errno?
> > 
> > I think the problem is that we report ENOSPC for this.  The historic
> > error code coming from the old btrfs days is EINVAL for "can't support
> > this for random unlisted reason", which btrfs does for example for
> > inline extents.  We really should turn ENOSPC into that.
> 
> Yeah, I'll give that a spin.

...and that regresses generic/33[34] because they actually fill the
filesystem up to full (or at least to the point where the fs won't let
us write more) and test that reflink returns ENOSPC.

Seeing as the reporter would actually rather we didn't fall back to a
slow pagecache copy(!) I'll drop this patch.

--D
