Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043421C695;
	Thu, 16 Apr 2026 00:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776299971; cv=none; b=pFrqTr1a8WWB4IEGNryJEtWIMUj5OjQ51nF3qEE3YXbMzcToDMyMskysS36HyJo9zKbzIrUlwQW/tiEElS2EBBuOEO65Ew4VoT8JSAdbkrMsCQCVg0Zu7nAbiC/ePSmpsACE0pXNm5YJC7cMJTprnb/7remSBL9+o//BYi8AbI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776299971; c=relaxed/simple;
	bh=DXR/aA/jnkMlGZ8BKzKbrIe6fYnwHy9CH/ufEgcLIKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K9mn7PsxwbZ8Uws9w1zL+5exLHT6ArObn85v+IuD7jOELI0C/qeBaKhiXmCyZsiYH8zAwgd8xQU02JXHWxrPDv6as98i22zYqWyG6k5NrzTVDhOp8ZNGWNd/8Bz+lTCruf3ibo90tsCOvVBxy4HrDYAJFKY/OmI5g26MS1RmJGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTb2bcfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTb2bcfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB5FC19424;
	Thu, 16 Apr 2026 00:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776299970;
	bh=DXR/aA/jnkMlGZ8BKzKbrIe6fYnwHy9CH/ufEgcLIKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UTb2bcfGYmFEO84cWb8vq0FBFdP0pbizLdLmV2hYe+7JlEyKYya/WeZp+0iWcF2M4
	 xc941F52ELok6ksNLgg7sVGQeWlbaQZv9YHxPVlHBSuVuEJlVC7dH81/4mEJxpyYu/
	 ZjohHUVuqqbVHXvo88u/Dw8cPxTTBd3Jns0TSK4EvpPFlkIRdM3d7iqLs59KEnEguJ
	 D0bfsOtW5b+eCx3HIzeqNOUHDREqzqsi22TFxWEzaDFZjOdAV2s9ul1bateB8tHcER
	 KxrQtXmWEgnVFYYWiFjSVumhGKjamqK5W2E5Jux9xtpvEy82yWCrpKPnqFtjON9dkN
	 /jU034fJp8Y9A==
Date: Thu, 16 Apr 2026 10:39:22 +1000
From: Dave Chinner <dgc@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Yuto Ohnuki <ytohnuki@amazon.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: check hash ordering in xfs_da3_node_verify
Message-ID: <aeAvumXnznX55MAb@dread>
References: <20260415071223.48609-2-ytohnuki@amazon.com>
 <20260415151625.GB114209@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415151625.GB114209@frogsfrogsfrogs>

On Wed, Apr 15, 2026 at 08:16:25AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 15, 2026 at 08:12:24AM +0100, Yuto Ohnuki wrote:
> > The DA node verifier checks header fields such as level and count, but
> > it does not verify that the btree hash values are in non-decreasing
> > order.
> > 
> > DA node blocks are traversed by searching the btree array for the first
> > hash value that exceeds the lookup hash, which requires the hash values
> > to be ordered correctly.
> > 
> > Add a hash order check to xfs_da3_node_verify, similar to the existing
> > validation in xfs_dir3_leaf_check_int, so that misordered node
> > blocks are detected as metadata corruption.
> > 
> > Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>

There were good reasons why this wasn't implemented originally but
marked with an 'XXX: <question>' comment. It's not because it is
hard to implement, but because it is an -expensive- check and it is
has never been clear that the check would ever actually find
corruptions in production systems.

That is, any media level error that could corrupt a hash value will
be caught by the CRCs, hence the only vector for a production system
to experience an out of order hash value is a bug in the XFS kernel
code.

This situation has not changed in the past 12-13 years, so....

... what's the CPU cost of doing this check? How much performance
does this cost for cold cache directory traversal?

What if we have 64kB directory blocks and a full dabtree node? i.e.
this will iterate 64kB of 4 byte hash values one at time, so how
much does that cost?

What is the possible impacts of an out of order has entry? Lookups
may not find the entry they are looking for, so files might be
missing from directories. Even modifications will simply result in
more out of order hash values or trip over out of order keys in path
traversal which will trigger corruption reports and maybe shutdowns.
I'm not sure there is anything else that can go wrong at runtime.

Hence even fuzzers like syzbot creating out of order hash entries
shouldn't result in crashes or other sorts of serious failures.

In which case, how much extra protection against corruption based
failures does runtime detection in production systems actually gain
us? Is it worth the cost of running this verification on every
directory node read and write?

If the only real issue we need to defend against is software bugs,
then we should be modelling the verification on
xfs_dir3_data_check().  That's runtime dir3 data block check
function that is only run on DEBUG kernels. It is placed in the data
block modification code to catch corruptions immediately after the
broken modification code has created them. This seems like a similar
situation to me.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
