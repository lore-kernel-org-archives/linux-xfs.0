Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FF03B0583
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 15:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791387484; cv=none; b=VOCndyVCjtLhnEsMcW7Qb5SXe/ERaSr3fR6Pknim9GjcYfWw7ApY35ft+zwRFVOAi2H7Bnpo2BiSP8Q2ov0sBcITzT0IJ3dIfSI0si2BLMe3BPiVe6epcVSIkxDF3eIRDZn7w0F64WgqwQpe3JKOKL6Z8Zz9Vo0Cp4fJDin7EKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791387484; c=relaxed/simple;
	bh=aNAd8KSDKDunFWIGwhBhlgZ1WpmnDHOl1VB/6/hIlAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PmmQVHjUhT48sTyT8AAY4utPQrdQjvkjz5zQ0y6V0kw7JEXmOA++1w07M+CDw8pl65AWf7mzRCmDU9JZJ78o2ynHfg3wKfak5C6VS71Nzb9kPxrRvhWPF946BBZIon7JyaRjOC6pXDeHGT/sUj2Y0kBrHY3esy67zKU+BekBEEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=THHF/KX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="THHF/KX0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 994911F000FF;
	Wed,  7 Oct 2026 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791387477;
	bh=FKNloAfeJWjof4J4K6LoUNzNLhxxsuF+LiSzbRQ515g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=THHF/KX03WM2i2uB0Ayoq4RqIZ+ihCie2Er8Ol7T6zpINAfgxxBSghfQpFsM2HGuD
	 Nfy8efOYCauuKv4SZGrkhi2EDB+gP8qKFEtFxYx3pdPGQBcmctc13Vu0MqwvlE0zjD
	 Ia6eQLEQw9jIErSZfHPt7TY6wz2EdYQT+7Z97y+uI6/CLFTXsEX+XFdgXh8qdo0Dwy
	 UGEUYw5/myPBvF8LqEUvnoJKEHcW5Habzja70c06aN5j35AV5RE6NtiJ6eSiQ17LFd
	 OQsiv9ekUZUtVb6QasCgHCcRfMBxvhvVXWNUYjB88A5fYUyRXwavBiGvliEDVVpcxR
	 AjgwW1CZfd/2A==
Date: Wed, 7 Oct 2026 08:37:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [PATCH 3/3] xfs: re-use refcount scrub/repair code for rtrefcount
Message-ID: <20261007153757.GC2705364@frogsfrogsfrogs>
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-4-sandeen@redhat.com>
 <asZOVQfQU3TpEBgv@infradead.org>
 <7206d033-2082-4591-81e7-43a5c5bd631a@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7206d033-2082-4591-81e7-43a5c5bd631a@sandeen.net>

On Wed, Oct 07, 2026 at 10:32:20AM -0500, Eric Sandeen wrote:
> On 10/7/26 8:51 AM, Christoph Hellwig wrote:
> > On Fri, Oct 02, 2026 at 04:08:11PM -0500, Eric Sandeen wrote:
> >> Some code in scrub/rtrefcount.c is copied from scrub/refcount.c; it
> >> differs only in function & structure names and a couple types and
> >> macros, which share the same underlying types and values.
> >>
> >> Similarly for code in fs/xfs/scrub/[rt]refcount_repair.c
> >>
> >> Export the refcount versions, use them for rtrefcount scrubbing,
> > 
> > Not really an export fortunately :)
> 
> Oh, uh, yeah. I didn't mean like EXPORT_SYMBOL just un-STATIC. :( 
> 
> Maybe Carlos fix it to:
> 
> Make the refcount versions non-static and use them for rtrefcount scrubbing.
> 
> on commit, or I can send another version if needed.

s/Export/Share/ ?

--D

> > 
> >> eliminate the copies, and add build-time asserts so that the type/value
> >> matches mentioned above do not drift.
> > 
> >>  5 files changed, 72 insertions(+), 316 deletions(-)
> > 
> > Nice code savings!
> > 
> > Looks good modulo the commit log nitpick:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> 
> Thanks,
> -Eric
> 
