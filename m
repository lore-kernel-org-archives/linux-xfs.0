Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323C4128395
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 02:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770688841; cv=none; b=XyM2K+HoyjBwiYeuIG9AYqeYHqXMOXbPRrDn/OZZ5YgWoOtC8myLO5FIyf1Yk/w5Xs0JT0KE+x9RfvTj+Cf1ghS8FRPYn8ekdiLgTRW3PAgHYmMe7qYxLaY6/fyrD/X6wBtfGnreqwcp0f2CL4vZzIRgrepZLDbIgi7k7MpAVyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770688841; c=relaxed/simple;
	bh=KVPReESYyKCiXNwAWln9qboAf73skfa/b6cY3Th6vAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5Ma1UUsfGJnGzJPLwDVm1MkJZyshn6KabAbDzi337Efe0gV7dKtsveDKq0uhWB3BFZsTSYLUCTUUhYGaz81NyfLTx2zDu92vxUV/aEORKA3t1QpY+w8vaITnEiCRGjxsCJSGFUpgxoOgYa4TtY94p5hc4fQT+E0558YVJQMq34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tH2n6kkC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tH2n6kkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48C7C116C6;
	Tue, 10 Feb 2026 02:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770688840;
	bh=KVPReESYyKCiXNwAWln9qboAf73skfa/b6cY3Th6vAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tH2n6kkCmhThvpDJyAdbdAhXLlKlIDJpIwpRR1+7+SDPEct4ZUlN60tP1Nl/ZNsPN
	 jDrZUvVA2eWY8OJJKGav0Mo6LQcTcjXwtdjAv/ygseYblvFKlOcxdNNmi3YXtEpG1h
	 ukN9mxVoJ3/oCHt+ROsHsxsakeAw+vcpP42FKToJmHaDMSptqesXmka3ef9DaWGr4O
	 MXx9pMLA3MgpD6eXXQoLIGMrirEacsydXXSVJdL9lU8TGwgkB8pdLiY0NxgDp3Jm2T
	 yiCUmDOjW90zgp6nUGPL8BSEZSbgrCNmuslUNAXo9IF9l2g05fQT3bjAZyxjo5XPP7
	 5yaJkwT69bWbA==
Date: Mon, 9 Feb 2026 18:00:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [bug report] xfs/802 failure due to mssing fstype report by lsblk
Message-ID: <20260210020040.GC7712@frogsfrogsfrogs>
References: <aYWobEmDn0jSPzqo@shinmob>
 <20260206173805.GY7712@frogsfrogsfrogs>
 <aYlHZ4bBQI3Vpb3N@shinmob>
 <20260209060716.GL1535390@frogsfrogsfrogs>
 <20260209062821.GA9021@lst.de>
 <aYmRhwnL286jv550@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYmRhwnL286jv550@shinmob>

On Mon, Feb 09, 2026 at 07:54:38AM +0000, Shinichiro Kawasaki wrote:
> On Feb 09, 2026 / 07:28, hch wrote:
> > On Sun, Feb 08, 2026 at 10:07:16PM -0800, Darrick J. Wong wrote:
> > > Waitaminute, how can you even format xfs on nullblk to run fstests?
> > > Isn't that the bdev that silently discards everything written to it, and
> > > returns zero on reads??
> > 
> > nullblk can be used with or without a backing store.  In the former
> > case it will not always return zeroes on reads obviously.
> 
> Yes, null_blk has the "memory_backed" parameter. When 1 is set to this, data
> written to the null_blk device is kept and read back. I create two 8GiB null_blk
> devices enabling this memory_backed option, and use them as TEST_DEV and
> SCRATCH_DEV for the regular xfs test runs.

Huh, ok.  Just out of curiosity, does blkid (in cache mode) /ever/ see
the xfs filesystem?  I'm wondering if there's a race, a slow utility, or
if whatever builds the blkid cache sees that it's nullblk and ignores
it?

--D
