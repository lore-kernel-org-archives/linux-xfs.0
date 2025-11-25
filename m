Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606CD218845;
	Tue, 25 Nov 2025 17:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764090385; cv=none; b=IALHCGNfKnVX+I/UrDxhnM/bvOJfdcx03j8j8nsMNlPuP/03XwQTtP5d/o0pRFShZ8ypunx0m9QC/dDr5u1Q5rMJ+ro87NiTCjwiMgHAJyau714oxYJ8gi3la1pMck4IH1WKtx/qP1h1u2Tq7idWb62/2LhGM5vlpFefnDcDFqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764090385; c=relaxed/simple;
	bh=Bh0B/kyPNC1+OWM9/m3mEthutUZz0Rx1kc11ORF7ocU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OIJEoDAIP3vvFLp3V1jqokN8mNa2jRl1jjKKFK1gTV+pQcNP69L7mKObiB6krqj8W07tUJduRzASATd2m1xfVRoztRVoLevoDuBb5qjNymkrecPtwqU7Yt4ps4LSO5d1daVsaID20UDtuoFWkp0lgTfrHldxNrpggag9djYJ4Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hv2YP3DV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hv2YP3DV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF1EC116B1;
	Tue, 25 Nov 2025 17:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764090384;
	bh=Bh0B/kyPNC1+OWM9/m3mEthutUZz0Rx1kc11ORF7ocU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hv2YP3DV6rBMnNsnU9TCxxacbVo3Cvu7SmFUbjpS45YJZZRz1T8eQKn3JO2pwxVFD
	 GUlbOzlFzxqH0uENw4/ciilhStBgoGySR9g7SPZcDPjvtYlNyZjXl9UCVyYvxI1Mdt
	 1SU4k1Jhr+nhNj988M+Cq4YLbvRRVV7ZwNA8+cyOUcnrB0AGEx4GpkULxBRreHrd8B
	 GCF5ebbpG2uFilVfvTMWyZ8DL0REUEz5nCE4ioL/mZUSSC7DOl4kAplOjE0j5JAQsY
	 7XokgHvCmGL9jLdG1Cpg4s8Z3EWcJZUd2snCrLTKS7IZDx/P9jpPpnZVnIIFk+fb8W
	 rzyy8Larubksg==
Date: Tue, 25 Nov 2025 09:06:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>, cem@kernel.org,
	chandanbabu@kernel.org, bfoster@redhat.com, david@fromorbit.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Subject: Re: [PATCH v5] xfs: validate log record version against superblock
 log version
Message-ID: <20251125170624.GA23380@frogsfrogsfrogs>
References: <aR67xfAFjuVdbgqq@infradead.org>
 <20251124174658.59275-3-rpthibeault@gmail.com>
 <20251124185203.GA6076@frogsfrogsfrogs>
 <aSVNOhcK3PvdlSET@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSVNOhcK3PvdlSET@infradead.org>

On Mon, Nov 24, 2025 at 10:31:22PM -0800, Christoph Hellwig wrote:
> > Hrmm maybe we ought to reserve XLOG_VERSION==0x3 so that whenever we do
> > log v3 we don't accidentally write logs with bits that won't be
> > validated quite right on old kernels?
> 
> Why do we need to reserve that?  The code checks for either 1 or 2
> right now based on the log feature flag.  If we add a v3 log we'll
> have to ammend this, but reservations won't help with that.

Yeah, I suppose you're right -- log v3 will require a new sb feature
bit, and that's good enough.

--D

> > > +	if (xfs_has_logv2(mp)) {
> > > +		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_2))
> > 
> > Being pedantic here, but the kernel cpu_to_be32 wrappers are magic in
> > that they compile to byteswapped constants so you can avoid the runtime
> > overhead of byteswapping rhead->h_version by doing:
> > 
> > 	if (XFS_IS_CORRUPT(mp,
> > 	    rhead->h_version != cpu_to_be32(XLOG_VERSION_2)))
> > 		return -EFSCORRUPTED;
> > 
> > But seeing as this is log validation for recovery, I think the
> > performance implications are vanishingly small.
> 
> Yes.
> 
> 
