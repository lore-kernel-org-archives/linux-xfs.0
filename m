Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9898219AD73
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 11:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730375059; cv=none; b=IFi/We+YFIuii4E+Bk1BVnfGyncKLeEj9foofz9s6thLkLQEiGQtch+bCEUEf/l36rfJc7ieHxyIy3W+jQj5YL/x37mZScitpo2d6Sa4sgosCzko+hTi58wQcsBdLGB41qBUPAxfkm8uPelg3n3rMGvZ0j4Kp0oOeyZIMICWdo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730375059; c=relaxed/simple;
	bh=byoBqb4GtGhB/fJgekdx3r8/Mn8O/lbJA51bNN3/Y3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NR267a/lYE6ZmkYe72gV4DUYudMmC9oqF8IABrhK347d+z2GzGR3qlYobTwgJhaqgcUWsLdUmswfbQVbRAITPddEZ0bQhiJlZCRCJI11fD+Sds/sp+PMH04f8hBXIzEOuZRridyt5erTOwBdkVakgO4vWnu/6U8xfi8b/JiDCBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ln//eqXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ln//eqXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB59AC4CED2;
	Thu, 31 Oct 2024 11:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730375057;
	bh=byoBqb4GtGhB/fJgekdx3r8/Mn8O/lbJA51bNN3/Y3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ln//eqXNWqbr5v9u3PKAwbvTm+h8k8Iah0dhdZfv++hyVL58P0VD+TcX28qgzudU2
	 SZvDLraWqzqWjeYO5OASySRBxvO6x60p3eqN2JXDLz+t9nVLgDRuwP+1on7TI86I1U
	 9BA81rfCT7U7wZnhaSnf1ztJNPakDCbYOfLNtBD0VHhECoKGfhcsvYKKqWqYfq/U//
	 5xW2JUWDzHwV+agG9NudXV4WCoGe09MIhnziz61JE490z/Sas2SwBe3uzuqhNfC+Pa
	 Dg6LoyiI8pJvHFD5k9QZb2H7o9VMCJJM9vzKA/wYL6+Wb5Cj1pzDqAic4+5tajLDHU
	 LOONedR2kISeg==
Date: Thu, 31 Oct 2024 12:44:12 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/3] xfs: sparse inodes overlap end of filesystem
Message-ID: <pdaherlfgonztg2woct5w5o4jukxvq2ealhq7mxbnkzm5rtuhq@vvevvao2aua3>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <4da62d9a-0509-46e7-9021-d0bc771f86d9@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4da62d9a-0509-46e7-9021-d0bc771f86d9@sandeen.net>

On Tue, Oct 29, 2024 at 11:14:18AM -0500, Eric Sandeen wrote:
> On 10/23/24 9:51 PM, Dave Chinner wrote:
> > There is one question that needs to be resolved in this patchset: if
> > we take patch 2 to allow sparse inodes at the end of the AG, why
> > would we need the change in patch 1? Indeed, at this point I have to
> > ask why we even need the min/max agbno guidelines to the inode chunk
> > allocation as we end up allowing any aligned location in the AG to
> > be used by sparse inodes. i.e. if we take patch 2, then patch 1 is
> > unnecessary and now we can remove a bunch of code (min/max_agbno
> > constraints) from the allocator paths...
> > 
> > I'd prefer that we take the latter path: ignore the first patch.
> > This results in more flexible behaviour, allows existing filesystems
> > with this issue to work without needing xfs_repair to fix them, and
> > we get to remove complexity from the code.
> > 
> > Thoughts?
> 
> For some reason I'm struggling to grasp some of the details here, so
> maybe I can just throw out a "what I think should happen" type response.
> 
> A concern is that older xfs_repair binaries will continue to see
> inodes in this region as corrupt, and throw them away, IIUC - even
> if the kernel is updated to handle them properly.
> 
> Older xfs_repair could be encountered on rescue CDs/images, maybe
> even in initramfs environments, by virt hosts managing guest filesystems,
> etc.
> 
> So it seems to me that it would be worth it to prevent any new inode
> allocations in this region going forward, even if we *can* make it work,
> so that we won't continue to generate what looks like corruption to older
> userspace.
> 
> That might not be the most "pure" upstream approach, but as a practical
> matter I think it might be a better outcome for users and support
> orgs... even if distros update kernels & userspace together, that does
> not necessarily prevent older userspace from encountering a filesystem
> with inodes in this range and trashing them.
>

I'm inclined to agree with Eric here as preventing the sparse inodes to be
allocated at the edge of the runt AG sounds the most reasonable approach to me.

It just seems to me yet another corner case to deal with for very little benefit,
i.e to enable a few extra inodes, on a FS that seems to be in life support
regarding space for new inodes, whether it's a distro kernel or upstream kernel.

It kind of seem risky to me, to allow users to run a new kernel, allocate inodes
there, fill those inodes with data, just to run a not yet ready xfs_repair, and
discard everything there. Just seems like a possible data loss vector.

Unless - and I'm not sure how reasonable it is -, we first release a new
xfsprogs, preventing xfs_repair to rip off those inodes, and later update the
kernel. But this will end up on users hitting a -EFSCORRUPTED every attempt to
allocate inodes from the FS edge.

How feasible would be to first prevent inodes to be allocated at the runt AG's
edge, let it sink for a while, and once we have a fixed xfs_repair for some
time, we then enable inode allocation on the edge, giving enough time for users
to have a newer xfs_repair?

Again, I'm not sure it it does make sense at all, hopefully it does.

Carlos
