Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB3613E8B8;
	Fri, 29 Mar 2024 23:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753641; cv=none; b=FfkZfOAQAHyOMKxhk7t5X0EKEf16FCfHEtN1CV9TZLeXL04xWptPJjuoANmJ9LzejdCPXDdr4WedUHNHSgGpBpof5jYU5QJMR4bo2OCfgq1yKZDbg3asY1Jw7VaatAvsIQcv1EqYg1nOSKV/XQ2d/Y/f0ts4UW/XrlH6oBDNnEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753641; c=relaxed/simple;
	bh=c3dZuRLMGPfeGBh58rShTMt8UR7t7s8U0R1tItqt2Vg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0Yc+9Cyj+QZIxJAz9PvTRyUmP1neiku+2/DEjN4wQsbK60j5rjmtsOb6KRcWT8lWbfNObJvdXT6mF+6hMGgqrGzn/UkQMSOlYFI4krGPBOqb6rQXH3H8W1luE1SQUkeRtihyADa+SwbdbLy5ysa+de2PXfZYE8Hf0FQOdIUzrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+trecTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+trecTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF5BC433C7;
	Fri, 29 Mar 2024 23:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711753640;
	bh=c3dZuRLMGPfeGBh58rShTMt8UR7t7s8U0R1tItqt2Vg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d+trecTRXXuAISVG7ocjgOLA9Gn+X9Jgnsd3fshtIBiI/FPpyG1SHLcUx5GO7HLYc
	 zhS5VUoshYSKr/UN8GTFO8A7Nh9cO/RYUlPO7jHDC4yu9HIBhSEwQxXvcCk5cmsHuz
	 0W9q2bxWNkQkcxN/+HFpURM/sHpqHJ3wWKN5a5lE24QWfKhQlcmve1zlHZIUSjck9Q
	 T5IVH4Mv36RaIbFpvwzVz0UiCh9IbIAZaA5FjrCcUf234IGLgL2ESOqAzHBJPm20y8
	 oCyTJMcd7c6aKp47z66i8vbAZcr0Ql3Fdz7P2R7OZkTAkHNdrve44McAUVqFpQ/PhH
	 ybVUABlAnqL2Q==
Date: Fri, 29 Mar 2024 16:07:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	guan@eryu.me
Subject: Re: [PATCH 3/4] generic/{166,167,333,334,671}: actually fill the
 filesystem with snapshots
Message-ID: <20240329230720.GE6379@frogsfrogsfrogs>
References: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
 <171150741593.3286541.18115194618541313905.stgit@frogsfrogsfrogs>
 <ZgRQYV_uc94IImTk@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgRQYV_uc94IImTk@infradead.org>

On Wed, Mar 27, 2024 at 09:59:13AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 26, 2024 at 07:43:35PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > XFS has this behavior in its reflink implementation where it returns
> > ENOSPC if one of the AGs that would be involved in the sharing operation
> > becomes more than 90% full.  As Kent Overstreet points out, that means
> > the snapshot creator shuts down when the filesystem is only about a
> > third full.  We could exercise the system harder by not *forcing*
> > reflink, which will actually fill the filesystem full.
> 
> All these tests are supposed to test the reflink code, how does
> using cp --reflink=auto make sense for that?

Hmm.  Well my initial thought was that the snapshot could fall back to
buffered copies of file1 so that we wouldn't abort the test well before
actually filling up the filesystem.

But you're right that my solution smells off -- we want to test reflink
dealing with ENOSPC.  Perhaps the right thing to do is to truncate and
rewrite file1 after a _cp_reflink fails, so that the next time through
the loop we'll be reflinking extents from a (probably less full) AG.

Ok let's see how that does.

--D
