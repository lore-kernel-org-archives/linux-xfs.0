Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FA530FC1D
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 10:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194576; cv=none; b=dxXdKtucn7/ctvUYw9KoyjSv54gJS0XVOcEeBNz4ryytE5DMb+9kHl6GZLIQuz/qsaK7skJPPMCrZBJ0SBzQCeOMogqPZJQskXmIy7S6Yq/ACWAZdSstJiBNBitrkNkGWtJ3bSylJmezCKwrmK1wtvyngWzVPSEX0sG8Ne7AI+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194576; c=relaxed/simple;
	bh=bTAdBzO2y3FfjfAYAbtueBCQ/35yCB0jIkXyaRw/h3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u22hNAYpJvz1a9m34Syi+tO1ppgvokqAxlvouiy6uIm1L1izp2e5xBbbyTzgL5VeGN4RlncHVASXgyu6EkQHPjjNouzHFbiVmBbuqEK04tO1qphxN7HZcqKxRfS2OEln5nzrCR3cyHuDo7d1Aq8TWkYAy8QjAIeRGRaPRJYOi80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kT0koYZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kT0koYZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7981F000FF;
	Mon,  5 Oct 2026 10:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791194575;
	bh=s+LlNGV2njBGHth5X8CGRuAJx24UFW8QOcrAoFSIO08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kT0koYZSDwAhAyooxs6PJFKGMvRsPAQPZN3PV2anWImBG+ThgIfNwuPnBoXCFz2aa
	 9CEUnGD0TzsyoDjP026kbBCXJULCzuJjC2tnTcQ52urdPebaVfb4j59tc5gBBGJn45
	 vvq5GnkyOVLzTqdaMin2OOBhcewnJ4RU+0mFIoAagqCDkG6T48q7zjUFJvbXeZX1lt
	 4fSMYXO1068XO14XoeBnXNq12ICCmqzXN2ktbKmjwFudlhzbWP0F9VxBWrp5yLzdrL
	 odIxUmCYjnotS6g7zQCAPZqkWGe0ln9VebGGOFLRALskU8YdTpsy/uTdmpBmB50SkO
	 rdZE15R9pALLg==
Date: Mon, 5 Oct 2026 12:02:51 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: small cleanups to help code sharing with xfsprogs
Message-ID: <asN1cm2BFRVilJtl@nidhogg.toxiclabs.cc>
References: <20260925151841.3385994-1-hch@lst.de>
 <20260925225233.GZ2705364@frogsfrogsfrogs>
 <20260926060611.GC20636@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926060611.GC20636@lst.de>

Back from conferences. Sorry the late reply...

On Sat, Sep 26, 2026 at 08:06:11AM +0200, Christoph Hellwig wrote:
> On Fri, Sep 25, 2026 at 03:52:33PM -0700, Darrick J. Wong wrote:
> > On Fri, Sep 25, 2026 at 05:18:25PM +0200, Christoph Hellwig wrote:
> > > Hi all,
> > > 
> > > this series has a few trivial cleanups and code moves that help
> > > sharing more code with xfsprogs.
> > 
> > Hrmm.  This is a somewhat different approach than what Chris Wedgwood
> > did for his log port to userspace.
> 
> Well, that seems to have been an AI slop dump without any further
> engagement from the LLM-herder, so I'm not sure it matters.

Indeed, I'd stay with this series, so for this series:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> But it also is a bit of a different thing.  This series tries to reduce
> the kernel/user libxfs differences, and reusing whatever we can from
> the kernel helps with that.  What we do about the log becomes relevant
> if/when we want to update that or share more.  My previously stated
> opinion is that splitting a single kernel code base into two libraries,
> which then generally are linked into the same programs again is not
> helpful.  But someone comes up with a design that actually makes it
> work painlessly I would not complain.  In the meantime I'd improve
> the maintainability of libxfs without touching the logging code at all.

Agreed.
