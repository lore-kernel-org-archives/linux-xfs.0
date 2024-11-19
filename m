Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912C014A60C;
	Tue, 19 Nov 2024 21:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732050971; cv=none; b=YX3eWeQDR/EpbUGINWkxiJu2aRN/wARDt857H9V6/1QmdO9LGV2ax+0G5FNC4euVu7bchdGiCzwBsVYDuY9ePtGKtPo3inldvPbPSzQwKHDgYGCOcvh0ivsP5PHa6TUbdECFYWIPM/sAPLrqAVxyo18xhpdZoZSQLC4DCpt40rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732050971; c=relaxed/simple;
	bh=sV0Z1RteWm4XkqWJEbjLQpgcBz57/jGW1tOkCde5n+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HcYedFJzcuEI3IvohoZWwRG8HFq1y+vwG5sjGlop6Q5ElTemPlrax6whkW5zYuHFjM17zTh2YsdHx7ffaWYx12O/R4Wg/bH6quDmtkhHb2OnGniNkET3OccBPdRG5BQcopIBRbj8vmuOMY2IgBTINREPtTfKXDlF0e9PsybzS2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IphSw65p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IphSw65p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20950C4CECF;
	Tue, 19 Nov 2024 21:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732050971;
	bh=sV0Z1RteWm4XkqWJEbjLQpgcBz57/jGW1tOkCde5n+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IphSw65pGsr8r6wx2L0hNnxlWfacQ8PA9vTDX9p9S+2Edsx4H46giNe1wQ4ZBzj8u
	 CbNclCHJyvmH5hMFlgGnRpjCOx3e4TOniyeo2Dns7rVLURyXu6PNDt8L56fCLXDqUQ
	 eQoIqQjUrtKgzMgSIF0unIQfw6Cb3bLrxx4C7wc3BWoDujTUCV7dfIwbsme21dMFzy
	 pmcoEmKTfBpJ3UMTb0SM0meHhJzg/yCjeeeNBQ60KBMkSI9N/x/ihn+8p/6FFjeOct
	 e5nWa5C88SWU24hnyCX1HuXZqNcYc4XJDo5lbq2k7AxZoWTs0//S69cC1/evM0jQ6v
	 ihNh1uiRLhOYA==
Date: Tue, 19 Nov 2024 13:16:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>, f@magnolia.djwong.org
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 09/12] generic/251: constrain runtime via time/load/soak
 factors
Message-ID: <20241119211610.GB1926309@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064562.904310.6083759089693476713.stgit@frogsfrogsfrogs>
 <ZzvtoVID2ASv4IM2@dread.disaster.area>
 <Zzwsgzu81kiv5JPB@infradead.org>
 <20241119154520.GM9425@frogsfrogsfrogs>
 <Zzz9a9RhImWP4F02@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zzz9a9RhImWP4F02@dread.disaster.area>

On Wed, Nov 20, 2024 at 08:04:43AM +1100, Dave Chinner wrote:
> On Tue, Nov 19, 2024 at 07:45:20AM -0800, Darrick J. Wong wrote:
> > On Mon, Nov 18, 2024 at 10:13:23PM -0800, Christoph Hellwig wrote:
> > > On Tue, Nov 19, 2024 at 12:45:05PM +1100, Dave Chinner wrote:
> > > > Question for you: Does your $here directory contain a .git subdir?
> > > > 
> > > > One of the causes of long runtime for me has been that $here might
> > > > only contain 30MB of files, but the .git subdir balloons to several
> > > > hundred MB over time, resulting is really long runtimes because it's
> > > > copying GBs of data from the .git subdir.
> > > 
> > > Or the results/ directory when run in a persistent test VM like the
> > > one for quick runs on my laptop.  I currently need to persistently
> > > purge that for just this test.
> 
> Yeah, I use persistent VMs and that's why the .git dir grows...
> 
> > > > --- a/tests/generic/251
> > > > +++ b/tests/generic/251
> > > > @@ -175,9 +175,12 @@ nproc=20
> > > >  # Copy $here to the scratch fs and make coipes of the replica.  The fstests
> > > >  # output (and hence $seqres.full) could be in $here, so we need to snapshot
> > > >  # $here before computing file checksums.
> > > > +#
> > > > +# $here/* as the files to copy so we avoid any .git directory that might be
> > > > +# much, much larger than the rest of the fstests source tree we are copying.
> > > >  content=$SCRATCH_MNT/orig
> > > >  mkdir -p $content
> > > > -cp -axT $here/ $content/
> > > > +cp -ax $here/* $content/
> > > 
> > > Maybe we just need a way to generate more predictable file system
> > > content?
> > 
> > How about running fsstress for ~50000ops or so, to generate some test
> > files and directory tree?
> 
> Do we even need to do that? It's a set of small files distributed
> over a few directories. There are few large files in the mix, so we
> could just create a heap of 1-4 block files across a dozen or so
> directories and get the same sort of data set to copy.
> 
> And given this observation, if we are generating the data set in the
> first place, why use cp to copy it every time? Why not just have
> each thread generate the data set on the fly?

run_process compares the copies to the original to try to discover
places where written blocks got discarded, so they actually do need to
be copies.

/me suspects that this test is kinda bogus if the block device doesn't
set discard_zeroes_data because it won't trip on discard errors for
crappy sata ssds that don't actually clear the remapping tables until
minutes later.

--D

> # create a directory structure with numdirs directories and numfiles
> # files per directory. Files are 0-3 blocks in length, space is
> # allocated by fallocate to avoid needing to write data. Files are
> # created concurrently across directories to create the data set as
> # fast as possible.
> create_files()
> {
> 	local numdirs=$1
> 	local numfiles=$2
> 	local basedir=$3
> 
> 	for ((i=0; i<$numdirs; i++)); do
> 		mkdir -p $basedir/$i
> 		for ((j=0; j<$numfiles; j++); do
> 			local len=$((RANDOM % 4))
> 			$XFS_IO_PROG -fc "falloc 0 ${len}b" $basedir/$i/$j
> 		done &
> 	done
> 	wait
> }
> 
> -Dave
> 
> -- 
> Dave Chinner
> david@fromorbit.com
