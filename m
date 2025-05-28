Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD75221721;
	Wed, 28 May 2025 22:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748470947; cv=none; b=LlonZiusZ5PyW7XlM7Qmf/g/9QS0wBhm0JUfpIbPgbQYbHp3AzY7xK7Zs00LO7sFXNF8ZFoqM2MKXgXZURpDIXUUwHWE1FABQkSf/xnObYEc1AtTnq6EJmizRD3MGzuo3dfGzLwm4KSwQAq1N+N5B+QYeJ7oMZkEAIKTSZrZFzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748470947; c=relaxed/simple;
	bh=eqIsvYmimSK/DqV2hNI3lKHjY6it5CNEBd71JQNxKOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBThSANhbgElphKx/mkqp7OV1Rkc8+q/hYM04FLYOrgsi48hATAcc3Gu3Ez5BYfSLp/GSHTGlDaRp4JiXIuSId1+CZ9e6ISqU4uZx+E4miN23sac34I5XwIihkRav5wnlyW6N0QL0/vrZdBZ+6O+eWQQcHJG+t1DEMcrYg4ASPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EuVzzytT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EuVzzytT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181CEC4CEE3;
	Wed, 28 May 2025 22:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748470947;
	bh=eqIsvYmimSK/DqV2hNI3lKHjY6it5CNEBd71JQNxKOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EuVzzytTowoEFY87+SEomMrGrm526KbP5P9QCWJ/qB2j1dgmSd11y2hb4LmtybOLg
	 QPU3CrLr63BIKWkADEXkVdLrITmiiTCNQ+sFdzlPev0+5f+2rkbUjzuDCSaIJu8MRh
	 HuqRMQzg/5Gm7icNLROIxFNUWt6dq1uypCGbzUJJcmNab7UEagpvojMJy2Oz7ZQp6s
	 Zq3RFGsHJEDbsySr+adwIBMAWs6zILimcb1QbCOHKAD96MT6coqmr68Nmr7OeEpPJ4
	 y5gQOW3Nxd5+GR1mpbysY7MPkQwpYP7TECM1tYYwoainwQj2d1tDAot7aAXSFPIE5Q
	 q2HGzxnMJUvjw==
Date: Wed, 28 May 2025 15:22:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/259: try to force loop device block size
Message-ID: <20250528222226.GB8303@frogsfrogsfrogs>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
 <174786719445.1398726.2165923649877733743.stgit@frogsfrogsfrogs>
 <aDAFRGWYESUaILZ6@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aDAFRGWYESUaILZ6@infradead.org>

On Thu, May 22, 2025 at 10:19:00PM -0700, Christoph Hellwig wrote:
> On Wed, May 21, 2025 at 03:41:36PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Starting with 6.15-rc1, loop devices created with directio mode enabled
> > will set their logical block size to whatever STATX_DIO_ALIGN on the
> > host filesystem reports.  If you happen to be running a kernel that
> > always sets up loop devices in directio mode
> 
> Such a kernel has some weird out of tree patches.  Why would we want
> to support that?

Welll... the only reason I patched the loop driver to turn ovn directio
by default is because writeback throttling for loop devices keeps
getting turned on and off randomly.  At this point I have NFI if
throttling is actually the desired behavior or not.  It makes fstests
crawl really slowly.

On one hand it seems bogus that a loopbacked filesystem with enough
dirty pages to trip the thresholds then gets throttled doing writeback
to the pagecache of the loop file, but OTOH it /is/ more dirty
pagecache.  Ultimately I think non-directio loop devices are stupid
especially when there are filesystems on top of them, but I bet there's
some user that would break if we suddenly started requiring directio
alignments.

Maybe RWF_DONTCACHE will solve this whenever it stabilizes.

--D
