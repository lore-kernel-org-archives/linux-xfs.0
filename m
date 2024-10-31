Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E101CC16B
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 22:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412822; cv=none; b=MMFjr6HFATBMCcrAubSq+wgOGWuZoGGvp5jnKEhUj1UyJT9EG5s1Eg9BayKU9Cps0EJBH1pOnwz0LUgjvnS6OcyzP5g5o3/7ZilQ95CNfXEXxfxrVbNKTOYku5UhRuKo3RZp77C/846r6lD3801HPS79LuwVsyRb4NIBlEQYBAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412822; c=relaxed/simple;
	bh=ZQ9WnNzIU5LhkpuHhb+MiT0uRp+lOGTComvFyFxV2bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxFEnFuOZArO34GV9lpNCHEysWyVa+WB17dskw3Eu473c60wTHSlQrf7APEnwn1Mwri78Uwzf1Jm4bipFgablQprlLgVp07n19YByw6RIq9nVRBsZgq7c41vfPVHJru3N4wWxecLxKYozqiUqskL7YOazbjj7/NdUbxYmysCAgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eborw0F1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eborw0F1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467E7C4CEC3;
	Thu, 31 Oct 2024 22:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730412822;
	bh=ZQ9WnNzIU5LhkpuHhb+MiT0uRp+lOGTComvFyFxV2bc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eborw0F1XIchirt026HdvhiiP6YPOWpt2FrgWC87Mbp4SoSKuNjVrYhThlH+hMZ4k
	 aoK/ZDyUTFYObMnW7iSliEg7VN8gTgDlzDOnyWkIEWg3yzOf/Gnjm/B8KalI9K4zYc
	 VtJzoHVhSlXhJbW6NOHPsYj/YnRlIg2kcuVKl9hgVVR2qMZyDCa4U13Qfa+U2SqWVb
	 UaAANE8EI6qSoLWx1kZ8rKg+S02tcyH8z5v1WCeGQW3oNbgA5Bo3WCCPHJBuHqI0KD
	 jfZTk72e2i0giv+7BBkhgFl3ABOKWC0ToS2TNFD2X0ZEnWHYxP1SOqE6tEMog7aOxp
	 PA3Pn8tEi1JoA==
Date: Thu, 31 Oct 2024 15:13:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/3] xfs: sparse inodes overlap end of filesystem
Message-ID: <20241031221340.GB2386201@frogsfrogsfrogs>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <4da62d9a-0509-46e7-9021-d0bc771f86d9@sandeen.net>
 <pdaherlfgonztg2woct5w5o4jukxvq2ealhq7mxbnkzm5rtuhq@vvevvao2aua3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pdaherlfgonztg2woct5w5o4jukxvq2ealhq7mxbnkzm5rtuhq@vvevvao2aua3>

On Thu, Oct 31, 2024 at 12:44:12PM +0100, Carlos Maiolino wrote:
> On Tue, Oct 29, 2024 at 11:14:18AM -0500, Eric Sandeen wrote:
> > On 10/23/24 9:51 PM, Dave Chinner wrote:
> > > There is one question that needs to be resolved in this patchset: if
> > > we take patch 2 to allow sparse inodes at the end of the AG, why
> > > would we need the change in patch 1? Indeed, at this point I have to
> > > ask why we even need the min/max agbno guidelines to the inode chunk
> > > allocation as we end up allowing any aligned location in the AG to
> > > be used by sparse inodes. i.e. if we take patch 2, then patch 1 is
> > > unnecessary and now we can remove a bunch of code (min/max_agbno
> > > constraints) from the allocator paths...
> > > 
> > > I'd prefer that we take the latter path: ignore the first patch.
> > > This results in more flexible behaviour, allows existing filesystems
> > > with this issue to work without needing xfs_repair to fix them, and
> > > we get to remove complexity from the code.
> > > 
> > > Thoughts?
> > 
> > For some reason I'm struggling to grasp some of the details here, so
> > maybe I can just throw out a "what I think should happen" type response.
> > 
> > A concern is that older xfs_repair binaries will continue to see
> > inodes in this region as corrupt, and throw them away, IIUC - even
> > if the kernel is updated to handle them properly.
> > 
> > Older xfs_repair could be encountered on rescue CDs/images, maybe
> > even in initramfs environments, by virt hosts managing guest filesystems,
> > etc.
> > 
> > So it seems to me that it would be worth it to prevent any new inode
> > allocations in this region going forward, even if we *can* make it work,
> > so that we won't continue to generate what looks like corruption to older
> > userspace.
> > 
> > That might not be the most "pure" upstream approach, but as a practical
> > matter I think it might be a better outcome for users and support
> > orgs... even if distros update kernels & userspace together, that does
> > not necessarily prevent older userspace from encountering a filesystem
> > with inodes in this range and trashing them.
> >
> 
> I'm inclined to agree with Eric here as preventing the sparse inodes to be
> allocated at the edge of the runt AG sounds the most reasonable approach to me.
> It just seems to me yet another corner case to deal with for very little benefit,
> i.e to enable a few extra inodes, on a FS that seems to be in life support
> regarding space for new inodes, whether it's a distro kernel or upstream kernel.
> 
> It kind of seem risky to me, to allow users to run a new kernel, allocate inodes
> there, fill those inodes with data, just to run a not yet ready xfs_repair, and
> discard everything there. Just seems like a possible data loss vector.

I agree.  I think we have to fix the fsck/validation code to allow
inode clusters that go right up to EOAG on a runt AG because current
kernels write out filesystems that way.  I also think we have to take
the other patch that prevents the inode allocator from creating a chunk
that crosses EOAG so that unpatched xfs_repairs won't trip over newer
filesystems.

> Unless - and I'm not sure how reasonable it is -, we first release a new
> xfsprogs, preventing xfs_repair to rip off those inodes, and later update the
> kernel. But this will end up on users hitting a -EFSCORRUPTED every attempt to
> allocate inodes from the FS edge.
> 
> How feasible would be to first prevent inodes to be allocated at the runt AG's
> edge, let it sink for a while, and once we have a fixed xfs_repair for some
> time, we then enable inode allocation on the edge, giving enough time for users
> to have a newer xfs_repair?
> 
> Again, I'm not sure it it does make sense at all, hopefully it does.

I don't think we can ever re-enable inode allocation on the edge no
matter how much time goes by.

--D

> 
> Carlos
> 
