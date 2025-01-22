Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EE114A619;
	Wed, 22 Jan 2025 03:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737517943; cv=none; b=sdOj6V0wgDpgxyaDoDOXkNRIZ7yTJw29yjd5c+C1gDS3NqqrYIwz7UvepdJrtAB/dDv9WN+XrCCq2gkZKbgHo8F3GIjd1f5r7FTfiNtmTpkQNqG7oDkHKohaHpEnOg5KC3TWAaJVmY0BM2MnacpwEgE6e9x6OYuhDgZdtUkJPhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737517943; c=relaxed/simple;
	bh=J2QkGyLWjEwuprHlB369/Mhwx4YkhGt5CvykOtkopDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BsH6dMwRI9kMAMtpiv6Dbwu2gSWeXDtOPEcAwfkyIzw6f8KtfDlr6lQrQnxeQbNfWSwXxTKmEplA1IQ2rxisUhaYkVOUSo8Yqd7nS4fWG5CoH72uoLE5ytIqeGDQW5Yrm865DG7tgNFMur8T2VHphYhPKOkFSlc+xzKEewKQy7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9CvnXQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9CvnXQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EF6C4CED6;
	Wed, 22 Jan 2025 03:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737517943;
	bh=J2QkGyLWjEwuprHlB369/Mhwx4YkhGt5CvykOtkopDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n9CvnXQhr8eqXO+zKwnDKsY5yzaKBn5XWOyOe7WZlmoGfKZm4CzCtuuDI3zba8WR9
	 uLk9dRnqXm+P1wJSkppMWN3iYvMw08AOLJK1BzFUM0qS+uB2YATp4JP0uNgdBUhJ/2
	 Cr4TR02AFtT7oLRXADuYQHhe7SvwBlyye0i/fzI8FkiBVdxBBeswDIX8IUtodx7PeV
	 0fVjxKPX/BphGMnZhZXpfirc9J+QFFCDGSfuzPMurA7J2Nxw8EDOiovakv2rxntXTn
	 tmYGpHaG74N7zqBONrd5pOP/mRHdsMKU4v5ORB8Kuf8iuLCLuEs+hotfjvJMsZEAip
	 /E4x15VUkl2rA==
Date: Tue, 21 Jan 2025 19:52:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/23] common/rc: don't copy fsstress to $TEST_DIR
Message-ID: <20250122035222.GU1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974363.1927324.3221404706023084828.stgit@frogsfrogsfrogs>
 <Z48rIh_I5PTrwJrh@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z48rIh_I5PTrwJrh@dread.disaster.area>

On Tue, Jan 21, 2025 at 04:05:38PM +1100, Dave Chinner wrote:
> On Thu, Jan 16, 2025 at 03:30:07PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that we can pkill only processes that were started by this test, we
> > don't need to copy the fsstress binary to $TEST_DIR to avoid killing the
> > wrong program instances.  This avoids a whole slew of ETXTBSY problems
> > with scrub stress tests that run multiple copies of fsstress in the
> > background.
> > 
> > Revert most of the changes to generic/270, because it wants to do
> > something fancy with the fsstress binary, so it needs to control the
> > process directly.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Change looks fine, though this should be a lot further up near the
> top of the patchset so that the change to g/482 and the revert here
> is not necessary at all.
> 
> With that reordering done:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Done, and thanks for responding to the big patch set.

--D

> -- 
> Dave Chinner
> david@fromorbit.com
> 
