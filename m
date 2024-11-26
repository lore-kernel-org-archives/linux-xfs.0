Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8684BBA27;
	Tue, 26 Nov 2024 01:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584377; cv=none; b=J5CbqF3JSKhC4ipJRFZLIqYz95juAuAHhBJzYL51ZaRlqamwKYSSOtLHiHcAoFGA2ghYHhb4n8sNms25n4zE0Yt8yDDLZykqjo34AyDGCWfxA/Jn/Kzrx5Ky5xZP++APxMjkpxkrym+djfRdJu6hzSepeZoLoAgwteb9rpP0n4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584377; c=relaxed/simple;
	bh=t6DG86LUR1IQfx1LU8BNTb6RkpBJgke+WARl0WWiVpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4gsgcodMD+2RdEb8iqaolP4IkyJ0IUkGFGYVR7W2L46EUJiKk8w9FuvSeogM4j038ogaVf5aKQLkMMEZ+aWgegCX+y5v3ABu0AgTj3PFZ5XZQGBwKWtMXER8RI9jvLLI1UdmaGspDgfU4aLZk+hVeym0aDdtDddX3s5o6NBLzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bRLH2TpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bRLH2TpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6383EC4CECF;
	Tue, 26 Nov 2024 01:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584377;
	bh=t6DG86LUR1IQfx1LU8BNTb6RkpBJgke+WARl0WWiVpc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bRLH2TpWFHQJRWABiy0W6LknNZ+5NUsVJujXAnAqUI3HR9dUOsZuW18G+qWFbjors
	 KEz47DsuFQQxqrQeY2oBgeK4tWuRJ07eRuMfuZPB+XZUYD0J36sKEYl0HCBXJesg/W
	 yEjOui15Q6wR3LEFj+8ghUKT6d6nZ+7TYXsLbOPOQS8RR/myOcHeaW5jMGIkboqvcl
	 gh1s90iSMxf8TKfE4vJt4vxzrqKIxGcvnqjzZsaJE7j9DTqpQtvQ+vrb/KmTxHTsZG
	 hQ0NvGloydOR/36S+Jimo+Cyi0ti96LIkvEW+nuHKBE/5YEzZW2VDcj1QEP3iS4xMw
	 8yIorac6T0c3Q==
Date: Mon, 25 Nov 2024 17:26:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Filipe Manana <fdmanana@kernel.org>
Subject: Re: [PATCH 09/17] generic/562: handle ENOSPC while cloning gracefully
Message-ID: <20241126012616.GD9425@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
 <173229420148.358248.4652252209849197144.stgit@frogsfrogsfrogs>
 <Z0QHw2IGqnTsNcqb@infradead.org>
 <20241125051639.GG9438@frogsfrogsfrogs>
 <Z0QJHXSg-neZvqPE@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0QJHXSg-neZvqPE@infradead.org>

On Sun, Nov 24, 2024 at 09:20:29PM -0800, Christoph Hellwig wrote:
> On Sun, Nov 24, 2024 at 09:16:39PM -0800, Darrick J. Wong wrote:
> > On Sun, Nov 24, 2024 at 09:14:43PM -0800, Christoph Hellwig wrote:
> > > On Fri, Nov 22, 2024 at 08:52:48AM -0800, Darrick J. Wong wrote:
> > > > +# with ENOSPC for example.  However, XFS will sometimes run out of space.
> > > > +_reflink $SCRATCH_MNT/bar $SCRATCH_MNT/foo >>$seqres.full 2> $tmp.err
> > > > +cat $tmp.err
> > > > +test "$FSTYP" = "xfs" && grep -q 'No space left on device' $tmp.err && \
> > > > +	_notrun "ran out of space while cloning"
> > > 
> > > Should this simply be unconditional instead of depend on XFS?
> > 
> > Felipe said no:
> > https://lore.kernel.org/fstests/CAL3q7H5KjvXsXzt4n0XP1FTUt=A5cKom7p+dGD6GG-iL7CyDXQ@mail.gmail.com/
> 
> Hmm.   Being able to totally fill the fs without ENOSPC seems odd.
> Maybe we need to figure out a way to scale down the size for the generic
> test and have a separate one for the XFS ENOSPC case?  Not a huge fan
> of that, but the current version also seems odd.

Yeah, I definitely need to write a fstest that can trip this bug on
smaller fsblock filesystems.  In the meantime, this one should not fail
just because xfs runs out of space before the point where this test
would have thought that would happen; and then xfs_io spews an error
message into the golden output.

Though if this is really a test that computes when *btrfs* would run out
of space and drives towards that point just to see if ENOSPC does /not/
come out of the kernel, then maybe this belongs in tests/btrfs/ ?

--D
