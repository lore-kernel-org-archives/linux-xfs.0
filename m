Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990C74C0420;
	Mon,  5 Oct 2026 15:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791213659; cv=none; b=TCh0ttBPVtkSc9RIYqyhIgx3nvCr0kkCJQn7rAw1wBmmMvFNte3NKyPJJTyXJtddpJ93sMDBuv5u0nrzUm5HGeMepLV8AhWffKap07vqCAQ/kEJESprF64xhonqRbvZSwItWwEo6dGcxIhx1FsSUNnt6tF2PXF5OKuUVgVBs9qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791213659; c=relaxed/simple;
	bh=eYogfqbCFjpN3nb4+0jvS9G9bRa7bCK98tyzGW0sITk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=adeS/wE4/qwq++OfdqJHEXxko6G27qZQ0tAUc7oF9AQ8swnwwDWPGJpwR3nBD5fJv1nihueTF00YaER/6MU6tqvn6b0rLMqfXmEmymKZ3qe1xQC85S2w1RsRxzgWIdzXAOSFKqvTLHXdfUzOeLKojwCm1NgU2Ld8/9kARp5qqgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7or3/kk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7or3/kk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D2B4B1F000FF;
	Mon,  5 Oct 2026 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791213657;
	bh=MZ8jWH01nNtxeW8Q3dRgNwgB1z9TT0AKTtsyR9tFoII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q7or3/kk93LSD8sJc1XkbQ69kmT0gIUumyC1KrH/TOzPJs8tfIhVyTmfmOzu/KqdT
	 bdMrqzfqoXcbN4sdqNr96onykXPQQDtx5Z736812SSpbOC9CZL7pHFh3Zfg5Gv66m3
	 mOiBnSCZSCH+GRjy+d4p30rFdOJEBVETXiVlj4rT+qqs7wAyn9jmVGUWokPTgJVYCp
	 0G0HI7lH7DQ7rSz4ovxB+trpD9Uvq4aH7JkWCOR8cAA77bxGyEmkzX9UehC2QjFNNz
	 FOYk7CTC2ox2OEnaxuHmI98rCM6JtkszygLLUJPqdJ8fB+KCt7GCa+P1pt1q7rGeJx
	 9kA9r1KCyg3+w==
Date: Mon, 5 Oct 2026 08:20:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs/2304: version of generic/388 that run
 xfs_scrub -x for each iteration
Message-ID: <20261005152057.GC2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-10-hch@lst.de>
 <20260929015645.GL2705364@frogsfrogsfrogs>
 <20261005132522.GN26805@lst.de>
 <20261005145123.GB2705364@frogsfrogsfrogs>
 <20261005145615.GB2082@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005145615.GB2082@lst.de>

On Mon, Oct 05, 2026 at 04:56:15PM +0200, Christoph Hellwig wrote:
> On Mon, Oct 05, 2026 at 07:51:23AM -0700, Darrick J. Wong wrote:
> > I'm ok with g388 running more slowly if it'll catch data checksum bugs
> > and whatnot.  I'm a little surprised that it doesn't already run
> > _check_filesystems every loop iteration.
> 
> Maybe we should patch that in first, and then XFS_VERIFY_FILE_DATA
> magically does the right thing?

I was about to repy "Sounds like a good idea for g388 and probably g475
as well" but then I remembered something from my notes.  The two tests
run without _check_filesystems on the assumption that accidental
corruptions will multiply until either (a) the cycle_mount will fail or
(b) the post-test _check_filesystems will have a lot to complain about.
Doing the check every loop cycle reduces the number of log recoveries
that we can do in a given SOAK_DURATION by a significant amount.

What if we ran $XFS_IO_PROG -c verifymedia once per loop if
XFS_VERIFY_FILE_DATA?  That would avoid a full xfs_{repair,scrub} run
(+ extra mount cycle) but catch problems earlier.

--D
