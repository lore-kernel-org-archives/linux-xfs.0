Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430C718CBFB
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 22:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722378496; cv=none; b=kED85HlOhXo+d6EPxgXLcdXA33pvxsitNsfMtAtUlMmRjY1bj96Eb2HayPvRdq+pDKfbCkfmLg12mTlxDwOj+BjoLIDXlupib5pU5F3Xwcdc7YQL4VFlRM6Og2MvnKPzUS0jwY0dx/WSeo6SFV79B1mzHiVdqIX0dHMpOpTazBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722378496; c=relaxed/simple;
	bh=JPdPJn8aVeQb+8qoc21GrfY6MvdauQcklTTVCFVoyTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bkca4V2aSilx0z60QhKeJ7XfZ9dE2eN9k8klRCZ1QXzfAT5hBMh4hXfj4BqSmAdZ358zxFavm4QljLbP9L0L+Za7MUc4Hbdeu1dSRxyQNBzuxGADFQm4p4395NiTgkMo6Y2NL5wF9lk7XarLHhdsY2TPA3DBKs3Tf5vxyXTq63k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMKPwwI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMKPwwI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0287C32782;
	Tue, 30 Jul 2024 22:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722378495;
	bh=JPdPJn8aVeQb+8qoc21GrfY6MvdauQcklTTVCFVoyTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OMKPwwI571dBBwCK1+2MEqpFFwzE0jv53HweEb4RYXdBihw4DVoU8XCf3BfJjJoe2
	 lbXQ+udSxRwonr+uPMTW9xCrMK0v2IFFZAJs49Wp3oD8QJu5jvUZsrBtyQk9KSj9xp
	 LduL+WSxdU/2f2lmpP8066EO95zjlAe8acUDScNT0tAdsXFldhmUFMvLmRsnpH+Cnd
	 I1uQ8Sw9rMT2Kis13qGDOxJ5k11o3zYThb9D2pifJFmYLsM3y8DLK+RuM0VJxR2VQK
	 MFzv+4IlfkWymT8FEx5shFeRgNefv8MnqdUhlybsfD/Ej9NtQ6FPMmPC+KUyYnzHrl
	 Xbt3seIrjTIpw==
Date: Tue, 30 Jul 2024 15:28:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_property: add a new tool to administer fs
 properties
Message-ID: <20240730222815.GK6352@frogsfrogsfrogs>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940678.1543753.11215656166264361855.stgit@frogsfrogsfrogs>
 <ZqlegsIRSwlccyX8@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqlegsIRSwlccyX8@infradead.org>

On Tue, Jul 30, 2024 at 02:43:30PM -0700, Christoph Hellwig wrote:
> On Mon, Jul 29, 2024 at 08:21:32PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a tool to list, get, set, and remove filesystem properties.
> 
> Ok, so this wraps spaceman.  Can we make the property manipulation only
> available through this interface to cause less confusion?

I think you're asking if I could make xfs_spaceman expose the
{list,get,set}fsprops commands and db expose the -Z flag to
attr_{get,set,list} when someone starts them up with -p xfs_property ?

If so, then yes, I can do that.

--D
