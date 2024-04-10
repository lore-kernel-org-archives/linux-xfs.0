Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C7B17A93C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712765862; cv=none; b=hADM0Qic3IIs+ZNh+Ia47jhWELoocqQ5dS8upalUV1/XOchtLCsH2s7+jrHYG6QHP0mgaMsdTc65YJEVfpD+ypAeliOraqmemd30zcsEIs4viBli3en1MJCYl4VvAxJ12beRWiZ7RzLpn1agfZ+KJ/ORQrW6+AfVYQETjF2AuFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712765862; c=relaxed/simple;
	bh=XicnAFnRvHBWMvzQ5fZBNDYMbCNcZwR1uOHgTMBTOT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jPmXJCvGTR1HD4OZZKuNy33av1P/49BW3h2QlwpuGOcbrkL6jBb2VpUK/9EE7wr3poM1MCVBwWOV/qY/VxlbDPyd/4II4i06VRS5qkRCB0brVuxsAGWMdcRtiA/TDF5AkgMe/klAivnYQZoTRuwxk64l/WdUKmCezQzMW6B9yGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vHFUxV2+; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vHFUxV2+"
Date: Wed, 10 Apr 2024 12:17:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712765856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+o/MLS0hmQa69Esy9kJHOFDd5v80IMd7GjTpFqqLwVQ=;
	b=vHFUxV2+OABQhA0/M9Gnisty2vYtszMdiZSkg460PUw06EZTTVoVp/iK8yd49yuo8bXcPt
	1Icjvi9eCkmxt/mvWp+x+XnbCNrJKfAlAC3PZeaVXlkKe+ECLucLp0q6NrLwVpWXCgdynM
	SOOKrRhFhqL6ISndu7vtUuGfaHMgXXA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] xfs: nodataio mount option to skip data I/O
Message-ID: <bbzdge7cxlxkfbjoduck5pg7s4tvyxuu6z25nwqbbqjxsz3w6f@756fkmdbqsp6>
References: <20240410140956.1186563-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410140956.1186563-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 10, 2024 at 10:09:53AM -0400, Brian Foster wrote:
> Hi all,
> 
> bcachefs has a nodataio mount option that is used for isolated metadata
> performance testing purposes. When enabled, it performs all metadata I/O
> as normal and shortcuts data I/O by directly invoking bio completion.
> Kent had asked for something similar for fs comparison purposes some
> time ago and I put together a quick hack based around an iomap flag and
> mount option for XFS.
> 
> I don't recall if I ever posted the initial version and Kent recently
> asked about whether we'd want to consider merging something like this. I
> think there are at least a couple things that probably need addressing
> before that is a viable option.
> 
> One is that the mount option is kind of hacky in and of itself. Beyond
> that, this mechanism provides a means for stale data exposure because
> writes with nodataio mode enabled will operate as if writes were
> completed normally (including unwritten extent conversion). Therefore, a
> remount to !nodataio mode means we read off whatever was last written to
> storage.
> 
> Kent mentioned that Eric (or somebody?) had floated the idea of a mkfs
> time feature flag or some such to control nodataio mode. That would
> avoid mount api changes in general and also disallow use of such
> filesystems in a non-nodataio mode, so to me seems like the direction
> bcachefs should go with its variant of this regardless.
> 
> Personally, I don't have much of an opinion on whether something like
> this lands upstream or just remains as a local test hack for isolated
> performance testing. The code is simple enough as it is and not really
> worth the additional polishing for the latter, but I offered to at least
> rebase and post for discussion. Thoughts, reviews, flames appreciated.
> 
> Brian
> 
> Brian Foster (3):
>   iomap: factor out a bio submission helper
>   iomap: add nosubmit flag to skip data I/O on iomap mapping
>   xfs: add nodataio mount option to skip all data I/O
> 
>  fs/iomap/buffered-io.c | 37 ++++++++++++++++++++++++++++---------
>  fs/xfs/xfs_iomap.c     |  3 +++
>  fs/xfs/xfs_mount.h     |  2 ++
>  fs/xfs/xfs_super.c     |  6 +++++-
>  include/linux/iomap.h  |  1 +
>  5 files changed, 39 insertions(+), 10 deletions(-)
> 
> -- 
> 2.44.0

I'm contemplating add the superblock option to bcachefs as well, that
would fit well with using this for working with metadata dumps too.
("Yes, we know all data checksums are wrong, it's fine").

Another thing that makes this exceedingly useful - SSDs these days are
_garbage_ in terms of getting consistent results. Without this, run to
run variance is ridiculous without a bunch of prep between each test
(that takes longer than the test itself).
