Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7501E1F8684
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 17:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734457355; cv=none; b=W0m1Eb+Cxa/Uc0KVwQg1jw6Gm6Re46oo3P49DY0gMKbH8JU1U1K7E/mdRNqlhDnB3c3YFzzZove2VnfVqSoxOEeVFbT9GGT7/pLBkACtBenFNCFM8mwU6xkE8SR1gwi/GA8WkuUiN+flgGS4T/hmXFCwk1t8t0ghm/+CWXf+hCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734457355; c=relaxed/simple;
	bh=OQn7Docogi5zYNZSYIRqUcqAqunIYVG0hYaio/pCb1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C0WNpqJauH7levvQADt9/3D+3nM5BqxTYmV285QC7Y55awiUdx790Ad4YB3Tb0WfFOSQGnoUvf+NrENOsXoXGqXPjtUAKGMbGrEyE/Cb4xJMx6s/8JVqC+3IaEjkP3H/h1/FgFR6iWhRGptNvIMZWGRNhgX42S5f4GH/QKZdeuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=osLYCLSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="osLYCLSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC57C4CED3;
	Tue, 17 Dec 2024 17:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734457353;
	bh=OQn7Docogi5zYNZSYIRqUcqAqunIYVG0hYaio/pCb1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=osLYCLSHXB9xY+7Yz02d8ksazfOrYLfpiOTdt0nS4ClYiuQMGBqQ+7GYt1Idwrvwn
	 8xBeLurC2la67ELe/MestiEoI9aLxmt2LAyolNFdbxIRTtN7oI1Z7yMLJC72SdAyVy
	 +42NGTxbBOVa+uQzHxHUANmcTym1OFZdaFUHQUVjja8jYQi+uy/AAuTTgO1sbXW8IU
	 wSvylH/HgMFNpItFyHRLGZ21rxCa9l3CPzfcCtfxVm3rVJQ+TvjgXyO12QVBBBU+CG
	 Fr9rP+s2HvRDayXrPrGZtj4U5uIapao7580wOwCiZYt7p2M+qd/bA01cAb2zRmNWWj
	 N9aDD5wu/LYwA==
Date: Tue, 17 Dec 2024 09:42:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/43] xfs: implement zoned garbage collection
Message-ID: <20241217174233.GM6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-27-hch@lst.de>
 <20241213221851.GP6678@frogsfrogsfrogs>
 <20241215055723.GF10051@lst.de>
 <20241217012753.GE6174@frogsfrogsfrogs>
 <20241217040655.GA14856@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217040655.GA14856@lst.de>

On Tue, Dec 17, 2024 at 05:06:55AM +0100, Christoph Hellwig wrote:
> On Mon, Dec 16, 2024 at 05:27:53PM -0800, Darrick J. Wong wrote:
> > > lot more work to move them and generates more metadata vs moving unshared
> > > blocks.  That being said it at least handles reflinks, which this currently
> > > doesn't.  I'll take a look at it for ideas on implementing shared block
> > > support for the GC code.
> > 
> > Hrmm.  For defragmenting free space, I thought it was best to move the
> > most highly shared extents first to increase the likelihood that the new
> > space allocation would be contiguous and not contribute to bmbt
> > expansion.
> 
> How does moving a highly shared extent vs a less shared extent help
> with keeping free space contiguous?  What matters for that in a non-zoned
> interface is that the extent is between two free space or soon to be
> free space extents, but the amount of sharing shouldn't really matter.

It might help if I mention that the clearspace code I wrote is given a
range of device daddrs to evacuate, so it tries to make *that range*
contiguous and free, possibly at the expense of other parts of the
filesystem.  Initially I wrote it to support evacuating near EOFS so
that you could shrink the filesystem, but Ted and others mentioned that
it can be more generally useful to recover after some database
compresses its table files and fragments the free space.

So I'm not defragmenting in the xfs_fsr sense, and maybe I should just
call it free space evacuation.  If the daddr range you want to evac
contains 1x 200MB extent shared 1000 times; and 10,000 fragmented 8k
blocks, you might want to move the 200MB extent (and all 1000 mappings)
first to try to keep that contiguous.  If moving the 8k fragments fails,
at least you cleared out 200MB of it.

> > For zone gc we have to clear out the whole rtgroup and we don't have a
> > /lot/ of control so maybe that matters less.  OTOH we know how much
> > space we can get out of the zone, so
> 
> But yes, independent of the above question, freespace for the zone
> allocator is always very contiguous.
> 
> > <nod> I'd definitely give the in-kernel gc a means to stop the userspace
> > gc if the zone runs out of space and it clearly isn't making progress.
> > The tricky part is how do we give the userspace gc one of the "gc
> > zones"?
> 
> Yes.  And how do we kill it when it doesn't act in time?  How do we
> even ensure it acts in time.  How do we deal with userspace GC not
> running or getting killed?
> 
> I have to say all my experiments with user space call ups for activity
> triggered by kernel fast path and memory reclaim activity have been
> overwhelmingly negative.  I won't NAK any of someone wants to experiment,
> but I don't plan to spend my time on it.

<nod> That was mostly built on the speculation that on a device with
130,000 zones, there probably aren't so many writer threads that we
couldn't add another gc process to clean out a few zones.  But that's
all highly speculative food for the roadmap.

> > Ah, right!  Would you mind putting that in a comment somewhere?
> 
> Will do.
> 
> > > 1 device XFS configurations we'll hit a metadata write error sooner
> > > or later and shut the file system down, but with an external RT device
> > > we don't and basically never shut down which is rather problematic.
> > > So I'm tempted to add code to (at least optionally) shut down after
> > > data write errors.
> > 
> > It would be kinda nice if we could report write(back) errors via
> > fanotify, but that's buried so deep in the filesystems that seems
> > tricky.
> 
> Reporting that is more useful than just the shutdown would be useful.
> How we get it on the other hand might be a bit hard.

Yeah.  The experimental healthmon code further down in my dev tree
explores that a little, but we'll see how everyone reacts to it. ;)

Also: while I was poking around with Felipe's ficlone/swapon test it
occurred to me -- does freezing the fs actually get the zonegc kthread
to finish up whatever work is in-flight at that moment?

--D
