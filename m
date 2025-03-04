Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069072E3377
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 20:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741119661; cv=none; b=VJXpYH2RD9f4K0pZynaMuoQakQHpdTkK290FNMvuxVxj3xlmhLBiP07mRAf/HnSGaoPLqi7u9dndKqy0Ql+2qXf4l+wzCUj6bEYGcFR629VrGToR1Qhnd1vL91IiGOHWD5PuSSbF6YkISS+g3YpDgC97qD2pK4m9fWpUEuaZyiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741119661; c=relaxed/simple;
	bh=5AKaIFuyF+numgdzrD+p/mOw57rarwBSA7TWKaIFLxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OkQnr3RGxHVeiggpJDaAlird0rrZRrXpRT5/ki06wVdyuxDkZ/4F/JnaUgfqwmgpPv/18wGhpu7+GZqaIpjuMAgFikoO2nTSREPePnEU1rdySD0IxnGuCLIOcYUoH1q4bxhT4qqRbOmiW6DeJ0y5UQIepMCm7j6VsmABc9+Z5Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XqxvGvAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqxvGvAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC6FC4CEE5;
	Tue,  4 Mar 2025 20:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741119660;
	bh=5AKaIFuyF+numgdzrD+p/mOw57rarwBSA7TWKaIFLxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XqxvGvAsrqbua9gFXdjzVkk0JUUazVVd41+iJOibpnDzpDkv2hhKDvn6jv8Mwt3FK
	 1zlJeoNy4nfxHVhkOagyn5sRdfyrarbKd7q/PAnWpkQKE/+wZ72P9brVWUehTI0po5
	 2+WF3FaTD6Sp2b8atqZu1Zi2GTdbWzJkPCvn+D/cqy0+LaebFRUUJo42VSX+eQGNkt
	 NcqQ9opeplZSd1GoCjIpT+ATfUPX/47tmjPCLhXzVReSSbVebMZty7eHjqYDs6J6sU
	 CrwZ2WKJykNGZRoz6I288EThvbBSZ6SRFd8E0b43jNQtfcvhcKBBVvJlK9dcCw9w1O
	 v/nS8HOvKDlyw==
Date: Tue, 4 Mar 2025 12:20:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	david@fromorbit.com, sandeen@redhat.com, bfoster@redhat.com,
	aalbersh@kernel.org, axboe@kernel.dk
Subject: Re: Changes to XFS patch integration process
Message-ID: <20250304202059.GE2803749@frogsfrogsfrogs>
References: <m6movx2b6yeygut6ow5hjkkfyyu32brsfzjcwydqge5gimz5z3@sw5hrcsah3ga>
 <WW-YcYkHs91Udy3MU9JoG8oirMMUKrs7XB4_rExNq8_azaAVtgdcf-7vtuKI23iITfyc832nCqSz_O7R41btrA==@protonmail.internalid>
 <20250303140547.GA16126@lst.de>
 <rbyicja5damtyfcfxwbk6mspeus42jqwzr6qqch44gizki3zgb@awiat6qbwl7z>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rbyicja5damtyfcfxwbk6mspeus42jqwzr6qqch44gizki3zgb@awiat6qbwl7z>

On Mon, Mar 03, 2025 at 04:00:39PM +0100, Carlos Maiolino wrote:
> On Mon, Mar 03, 2025 at 03:05:47PM +0100, Christoph Hellwig wrote:
> > On Mon, Mar 03, 2025 at 11:42:12AM +0100, Carlos Maiolino wrote:
> > > The biggest change here is that for-next will likely need to be rebased
> > > more often than today. But also patches will spend more time under testings
> > > in linux-next and everybody will have a more updated tree to work on.
> > 
> > FYI, what other trees do is to keep separate branches for the current
> > and next release, i.e. right now: for-6.14 and for-6.15 and merge those
> > into the for-next or have both of them in linux-next (e.g. for-linus and
> > for-next).  In that case most of the time you don't need to rebase at
> > all.  Instead you might occasionally need to merge the current into the
> > next tree to resolve conflicts, and Linus is fine with that if you
> > document the reason for that merge.

Separate branches for 6.14 and 6.15 that then get merged into a for-next
is what I did when I had separate trains running at the same time.  Most
of the time I just rolled the post-rc6 fixes into the next release, so I
usually only dealt with one at a time.

(to some grumbling)

> This is pretty much aligned with my intentions, I haven't looked close yet how
> other subsystems deals with it, but by a few releases now, I keep a
> xfs-fixes-$ver branch which I collect patches for the current version, so adding
> a new branch for the next merge window is what I aimed to do with
> xfs-6.15-merge.
> 
> The question for me now lies exactly on how to synchronize both. You partially
> answered my question, although merging the current into next sounds weird to me.
> 
> If I merge current into next, and send Linus a PR for each (let's say for -rc7
> and in sequence for the next merge window), Linus will receive two PRs with
> possibly the same patches, and yet, on the merge window PR, there will also be a
> merge commit from -current, is this what you're describing?

If I had a for-6.14 and a for-6.15 branch, I'd base the PRs off of those
branches, not the for-next branch itself.

> Thanks for the input.
> 
> > 
> > >
> > > Also, I'm still thinking how to handle pull requests I receive. I try
> > > hard to not change the commit hashes from the PRs, so I'm still not sure
> > > how feasible it will be to keep the same hash ids from PRs giving more often
> > > than not I'll need to rebase the next merge tree on the top of fixes for the
> > > current -RC and in some cases, on top of other trees with dependencies.
> > 
> > With the above you just keep the pull requests as-is.
> > 
> > 
> 
> Sounds reasonable

Or you can ask the PR submitter to rebase off latest for-6.15 and handle
the merge themselves.

--D
