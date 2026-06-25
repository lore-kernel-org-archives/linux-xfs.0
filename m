Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2CB2253B0
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 22:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782427736; cv=none; b=c09Y5DgWVwyHRxf56YNv6V3PK4G5ir7bmP35U7vyPoBZgMQBC1HteuKX67Bg1MPV+vq4Nscy8FRQvaaCToLZjAfupfiTrbOKyf5Nx9iWcBrsbpYoD0MN5cHrkxad5nruJxUkPNqwnOX37RunnRCHEK1yTtifOjAvHY0GruCR8S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782427736; c=relaxed/simple;
	bh=GXnGMynCAfmk40lnw9rZRH9i/W+nXm2AIPSgjbtNAi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KG9/FV4/p5HRLij+BU1r0GVR2SeBymFuxLtmLXbrnT/kMAgYX39EPBE3xadotBEZSE4szo7qsVlVibLRfn8OEwWZ1Sdfw0F3rY0U2AQBKuGAg6mYlRnlLbj23yp20hP2aNLJabj07oRI7Y6DRyzlE7ZnZ+RJpXHbk6MTQO+iLrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGnTTbzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGnTTbzx"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F32961F000E9;
	Thu, 25 Jun 2026 22:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782427735;
	bh=nNmEphnIhQv+LN7uMrfrFYcT9dhZF/NBAEG7sPSKJlw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WGnTTbzx278nZdduW2j1xH4Sg66/R5nF4BveQ1IxnYrhTJhbCRI1mjVsZHIz7ZBsy
	 8TuuhsvlMODSsTfP+aZ0h3pR1HKDVE3SUOr20iSxJHUFqGutKUoyDGZ8tnuIkhUWZQ
	 I+Y/S0R2ImQufg/2CZ3IL/LfSna+zZGM4EvuvV7+gyXa23qlAE9/ovqsigOVRjyW+1
	 DUr9GQPkPktJ4lenykd1jGopfRVUUwIfnRmNLz8VaNPES9gmcFZ/f1QqMAHthbjvPA
	 ph1PiMmdSFRbL/nrDOhdCnCRJx2GzrImtdX1f+6sp2rkCCX/xFnt0zpfcaWKcaa5az
	 e3WxwP7CKkoVg==
Date: Thu, 25 Jun 2026 15:48:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs_scrub: handle media scans of internal rt
 devices correctly
Message-ID: <20260625224854.GM6078@frogsfrogsfrogs>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
 <178232484494.915780.16900802517191563379.stgit@frogsfrogsfrogs>
 <20260625120119.GD18766@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625120119.GD18766@lst.de>

On Thu, Jun 25, 2026 at 02:01:19PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 24, 2026 at 11:15:17AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Codex noticed media scans of internal rt devices don't work at all
> > correctly.  First, we fail to allocate a ctx->verify_disks[XFS_DEV_RT]
> > for the internal rt section, and even if we did, phase 6 doesn't
> > allocate media_verify_state.rvp[XFS_DEV_RT] if there's a media error on
> > an internal rt volume, so we'll crash there too.
> > 
> > Fix both issues to make it work properly.
> 
> Do you have a test case for this?

Sort of -- xfs/556 is the media verification test, but it _notruns on
zoned filesystems because of _require_xfs_scratch_non_zoned.  The
_notrun logic isn't quite right because while dm-error doesn't work for
zoned disks, it works fine with -rzoned=1 on conventional storage.

Well, not entirely -- with zoned=1 and conventional external rt storage
it works fine, but with an internal rt volume, it does:

--- /run/fstests/bin/tests/xfs/556.out  2025-07-15 14:41:40.342952932 -0700
+++ /run/fstests/logs/xfs/556.out.bad   2026-06-25 15:35:59.593600834 -0700
@@ -1,12 +1,7 @@
 QA output created by 556
+blockdev: cannot open : No such file or directory
 Scrub for injected media error (single threaded)
-Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
-SCRATCH_MNT: unfixable errors found: 1
 Scrub for injected media error (multi threaded)
-Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
-SCRATCH_MNT: unfixable errors found: 1
-od: SCRATCH_MNT/a: Input/output error
 Scrub for injected media error (after remount)
-Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
-SCRATCH_MNT: unfixable errors found: 1
+blockdev: cannot open : No such file or directory
 Scrub after removing injected media error

So I have to patch fstests further to avoid setting errordev=RT when
there's no external volume.

--D

> The changes look good, but I'd love to have coverage for it...
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 
