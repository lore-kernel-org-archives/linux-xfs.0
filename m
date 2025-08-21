Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9042F747E
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 12:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755780780; cv=none; b=T3l3kgHL05IIGJygSELSS5VZwyMITGaT+qVNaQKQCsUgztv22f8Ukv9AXSI4p/cvSZ8lDCSKQnXBdNUpwd79Bd0Hgfy+lZESk1m0jLlc+yee+/S+sFuFxsFmyufWq/0TNvedZf9HpB/bTDwOjagQPgLP+DXWdHgzGvxhoaRClJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755780780; c=relaxed/simple;
	bh=1sovR6/XYd+SXEktH68RwUiFAMjeuDDXBRS7A4h5UAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lfvqdys/r6bVU1Stj1kAJREfUrRJqmCBhVpEP5kFQnahjmgCBRzYnw+sdUa7ruN7L/nfqDibwSwaCuCekHKnST24QUbvRgXrGJ1RhYGNB/0J46/aPrXU0PHsYN0loOXEaIBWtvGLFPCO2L2HPvoSSQ0AogYtV35HmVQ0Nm7+rJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJlf6GCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJlf6GCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A41C4CEEB;
	Thu, 21 Aug 2025 12:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755780780;
	bh=1sovR6/XYd+SXEktH68RwUiFAMjeuDDXBRS7A4h5UAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SJlf6GCD95yO9P+Y68or9sFVy3SQYL0xlVij3h16gifOvxeoM/l6SJQW00QAaorNu
	 xXWgfMrYWZJzoLMuZ28LnwCUmlKTH6B3jZZE/JK28+u6Yj1tTI57Cb3AZx8o9J3Cho
	 yWJvUYlcqMEn8qWW9Vb6Cv/IJhIEiif+bdigTg7T5oNAaXRte8RarMOEE+O0E1k3RC
	 sv81CldxS2tQZOBOUKY1HfiTqFjtvkTcPstA7C7R6qXt3j7Qpbx7zc8F2E1EA9qYI7
	 VIfRjJH8BX81Eks4hrHsLjhOPtoQiSNn8+9Dfr5WJbinyA8uJX18fJMR/2z7dszRUs
	 GCBPwEWofcCiA==
Date: Thu, 21 Aug 2025 14:52:55 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Donald Douwsma <ddouwsma@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Eric Sandeen <sandeen@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
Message-ID: <22vxocakop5le2flnejcrkuftszwdweqzco4qdf3fbvxsf2a5e@j3ffahfdd2zh>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <20250818204533.GV7965@frogsfrogsfrogs>
 <zyfEYJMTkKD5zOCGC1U7KIpJyi-frJE_rYWyR5xVhz1u_VwOJDZm00KBbDZs-fKPTDD-Q7BOfuJrybFyo31WbQ==@protonmail.internalid>
 <85ac8fbf-2d12-4b2e-9bfa-010867a91ecd@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85ac8fbf-2d12-4b2e-9bfa-010867a91ecd@redhat.com>

On Thu, Aug 21, 2025 at 07:16:49PM +1000, Donald Douwsma wrote:
> 
> 
> On 19/8/25 06:45, Darrick J. Wong wrote:
> > On Mon, Aug 18, 2025 at 03:22:02PM -0500, Eric Sandeen wrote:
> >> We had a report that a failing scsi disk was oopsing XFS when an xattr
> >> read encountered a media error. This is because the media error returned
> >> -ENODATA, which we map in xattr code to -ENOATTR and treat specially.

scsi_debug can be configured to return a MEDIUM error which if I follow
the discussion properly, would result in the block layer converting it
to ENODATA.

Carlos


P.S.
I'm pretty sure I heard somebody suggesting scsi_debug before,
I just don't remember who and where.

> >>
> >> In this particular case, it looked like:
> >>
> >> xfs_attr_leaf_get()
> >> 	error = xfs_attr_leaf_hasname(args, &bp);
> >> 	// here bp is NULL, error == -ENODATA from disk failure
> >> 	// but we define ENOATTR as ENODATA, so ...
> >> 	if (error == -ENOATTR)  {
> >> 		// whoops, surprise! bp is NULL, OOPS here
> >> 		xfs_trans_brelse(args->trans, bp);
> >> 		return error;
> >> 	} ...
> >>
> >> To avoid whack-a-mole "test for null bp" or "which -ENODATA do we really
> >> mean in this function?" throughout the xattr code, my first thought is
> >> that we should simply map -ENODATA in lower level read functions back to
> >> -EIO, which is unambiguous, even if we lose the nuance of the underlying
> >> error code. (The block device probably already squawked.) Thoughts?
> >
> > Uhhhh where does this ENODATA come from?  Is it the block layer?
> >
> > $ git grep -w ENODATA block/
> > block/blk-core.c:146:   [BLK_STS_MEDIUM]        = { -ENODATA,   "critical medium" },
> >
> 
> I had been working on a test case for this based on dmerror, but It
> never successfully triggered this, since dmerror returned EIO.
> 
> At least it didn't until Eric got creative mapping the the error back to
> ENODATA.
> 
> I'll was in the process of turning this into an xfstest based on your
> tests/xfs/556, I'll reply here with it in case its useful to anyone, but
> it would need to be modified to somehow inject ENODATA into the return
> path.
> 
> Don
> 
> 
> 
> It should work with a systemtap to map the error, though I think Eric
> was considering alternatives.
> 
> 
> 
> 
> 
> 
