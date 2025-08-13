Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F023E2C1585;
	Wed, 13 Aug 2025 06:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755065693; cv=none; b=se2R+9PeT//e8/0aNAWvBh+OYZUS+Qf5sdidjy5fnUjw3Ja39RIqz0p9w1AUBIg04LHXM747nMfUu72r5AB7MBICOPfueRVDmCkY9NIIjVqmBMys8UI4b0kWMM4PphD9/0wszFB6zxbmfRl3div1m60RwJSpLSedG4NlqmsyX9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755065693; c=relaxed/simple;
	bh=ViLZ5Tc73kivdDFEKOl5oYPBzGq6XRQvk+ce04LMZLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PdXZDcjCzheqmUl0c7CoE92NzzlNFV/HGIZ8gPyzvce4/ZXu7ApJ67XETbqYAWpj5nlgn670LhuppxKoVvBhA5LauqdW576Dh3W6rrP3CjuSPKH/3oM8gdOKtU8s5gTD6N/f841FTchJ04rAutXWKFgtDcNExxOBOqAUL5TmPUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spfxZYgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spfxZYgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885FAC4CEEB;
	Wed, 13 Aug 2025 06:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755065692;
	bh=ViLZ5Tc73kivdDFEKOl5oYPBzGq6XRQvk+ce04LMZLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=spfxZYguSr9/QSSAnq6c0IR6NIRukeL9OjDhWvlyhtvdAd0JqZTusBE1+QVlSHdoF
	 XhQ3eV2P2W9SUyFyVNUWyd1ORrUFrHjQHsHe49qwdOnbzmJq2uK0nHPqfuHmMlvx/Z
	 GU58rjpzZFvSwgqq/7gmLKjMHC8PrfWSafZu/MLpkvH6nXloPe8bUn1zNwSbodbq+/
	 /9EEbsUmVT2yo7sMiaM1Se1Kn3AU3bnolvKzCTH9wNgfoJ0svBFM2af0WjCSM5ZG1j
	 GSDt/128bCFoVRuT1HpHjNLvryz58OfHeNE1ktz2xJqlB4prUSl5L3dCDbr4CKHyJ1
	 eyUVHmVNiAeiA==
Date: Tue, 12 Aug 2025 23:14:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] generic/427: try to ensure there's some free space
 before we do the aio test
Message-ID: <20250813061452.GC7981@frogsfrogsfrogs>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381957936.3020742.7058031120679185727.stgit@frogsfrogsfrogs>
 <aIopyOh1TDosDK1m@infradead.org>
 <20250812185459.GB7952@frogsfrogsfrogs>
 <aJwfiw9radbDZq-p@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJwfiw9radbDZq-p@infradead.org>

On Tue, Aug 12, 2025 at 10:15:55PM -0700, Christoph Hellwig wrote:
> On Tue, Aug 12, 2025 at 11:54:59AM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 30, 2025 at 07:18:48AM -0700, Christoph Hellwig wrote:
> > > On Tue, Jul 29, 2025 at 01:08:46PM -0700, Darrick J. Wong wrote:
> > > > The pwrite failure comes from the aio-dio-eof-race.c program because the
> > > > filesystem ran out of space.  There are no speculative posteof
> > > > preallocations on a zoned filesystem, so let's skip this test on those
> > > > setups.
> > > 
> > > Did it run out of space because it is overwriting and we need a new
> > > allocation (I've not actually seen this fail in my zoned testing,
> > > that's why I'm asking)?  If so it really should be using the new
> > > _require_inplace_writes Filipe just sent to the list.
> > 
> > I took a deeper look into what's going on here, and I think the
> > intermittent ENOSPC failures are caused by:
> > 
> > 1. First we write to every byte in the 256M zoned rt device so that
> >    0x55 gets written to the disk.
> > 2. Then we delete the huge file we created.
> > 3. The zoned garbage collector doesn't run.
> > 4. aio-dio-eof-race starts up and initiates an aiodio at pos 0.
> > 5. xfs_file_dio_write_zoned calls xfs_zoned_write_space_reserve
> > 6. xfs_zoned_space_reserve tries to decrement 64k from XC_FREE_RTEXTENTS
> >    but gets ENOSPC.
> > 7. We didn't pass XFS_ZR_GREEDY, so we error out.
> > 
> > If I make the test sleep until I see zonegc do some work before starting
> > aio-dio-eof-race, the problem goes away.  I'm not sure what the proper
> > solution is, but maybe it's adding a wake_up to the gc process and
> > waiting for it?
> 
> Isn't the problem here that zonegc only even sees the freed block
> after inodegc did run?  i.e. after 2 the inode hasn't been truncated
> yet, and thus the blocks haven't been marked as free.

Yeah... for the other ENOSPC-on-write paths, we kick inodegc, so maybe
xfs_zoned_space_reserve (or its caller, more likely) ought to do that
too?

--D
