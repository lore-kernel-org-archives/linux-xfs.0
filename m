Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AC32B9B9;
	Wed, 21 Jan 2026 00:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768955603; cv=none; b=qzJKtOHvWPA1yOr/86u0vtD1BP3IZ/Qa9N56Ve6gRLdz+j9/SptWcyi4E426pWiqG+rly8AlLmWmt79u/NyDmBwHG6ucCH7Oz8d9Hm1dE5fGk+FhloR3AuKYqeHJrCqw377ITCEUZ0bha1vZMEzD+S1Ta5N4dHDw0l5NKk27h1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768955603; c=relaxed/simple;
	bh=/vp5HJoHRTcfFSNLBUypmK0z0DfluPBOscM/suEHmkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m9KdcjOY29pVUoGbhfG42nB6PmT1UGMKYGzy2QbV8o7NaTh5xD03yjWE4fa4Idv4xckSCHCAn2qK2p20BWQ24zjDQ7tgVIT6pK75gpceN7W0L3FlimO+LL9aZX+aNA7KAf/oH2xr0IqHb5NaTOlWl0E8WTaS5nz7pbYgtG63Z4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rqM3bN0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rqM3bN0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ED9C16AAE;
	Wed, 21 Jan 2026 00:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768955602;
	bh=/vp5HJoHRTcfFSNLBUypmK0z0DfluPBOscM/suEHmkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rqM3bN0WqdI5fs9aAXvurpd24tVDtH+KKUZjWxJBKq2kGLJyJwxjf1iUZuxm5O1Pa
	 JOoywhjd3tKvZBPTUeV1CZrXMTL9qq2ZXzwRrXmer+aZldYpo3tio7yNs2I/+SmkWp
	 rpOo5XGa8wFpTGpFpcGoRUGuoylaajFajCOqRrbxTh3BYb46KppwaBz3lsWYSyWhfI
	 nIMGwmAAlpmRMIHnhU5Za0bwRZuofgkgJL/UHzdXzYVdULUnFrwl6S7d1ZHqygvfm9
	 w2+SOxejI2OQlN4alf74BLbjhielYpghNx2gvQBUA/hsOZl/icpFVRAdFXdD83KnDn
	 5EY2dhoCIYrZg==
Date: Tue, 20 Jan 2026 16:33:21 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v2 1/2] fs: add FS_XFLAG_VERITY for fs-verity files
Message-ID: <20260121003321.GB12110@quark>
References: <20260119165644.2945008-1-aalbersh@kernel.org>
 <20260119165644.2945008-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119165644.2945008-2-aalbersh@kernel.org>

On Mon, Jan 19, 2026 at 05:56:42PM +0100, Andrey Albershteyn wrote:
>  /* Read-only inode flags */
>  #define FS_XFLAG_RDONLY_MASK \
> -	(FS_XFLAG_PREALLOC | FS_XFLAG_HASATTR)
> +	(FS_XFLAG_PREALLOC | FS_XFLAG_HASATTR | FS_XFLAG_VERITY)

This is the first flag that's both a common flag and a read-only flag.

Looking at how FS_XFLAG_RDONLY_MASK gets used in
copy_fsxattr_from_user():

    fileattr_fill_xflags(fa, xfa.fsx_xflags);
    fa->fsx_xflags &= ~FS_XFLAG_RDONLY_MASK;

So it translates the xflags into fsflags, then clears the read-only
xflags *but not the read-only fsflags*.

If the user passed FS_XFLAG_VERITY, the result will be that
FS_XFLAG_VERITY will *not* be set in xflags, but FS_VERITY_FL will be
set in fsflags.

Is that working as intended?  It seems inconsistent.

- Eric
