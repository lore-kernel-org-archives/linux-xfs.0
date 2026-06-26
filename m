Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2903DB62F;
	Fri, 26 Jun 2026 07:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782459285; cv=none; b=fzfFUOCY9hsFLrZcBWYiPnQoA6AEDYsZQA/DpDMrhPAr1he0R+UG+r8Ys00tOSwwv99sxDOCL/xbmW7tvdSrROO13Smv+/yNDkWPueTCCnJUeOOPTLzFkyjGButtVLN8fY0nTbgesUyGO994hSXHtfcypmRZgq0RHVYKHZBEYS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782459285; c=relaxed/simple;
	bh=XibRtr3lArfBwIX108UOrQuWbqvLRRJQahUof7b9dK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P3aTa6PfLR89pJOcZGN5B0HsqrMrveP27uxZeFqlR0dfXdA45kUUswIAmXgvW/F0cyFREp/m+7Pb0Ngg2jcuTE0Xda3yftjdV8jrfC4oxEu5dT5yK1G4qy1cEbjbb1+00T4NKCFodFdMM6fNsOXpQD56bVvQ2WV6ZigdiLiQ2hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n80+wOrW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n80+wOrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13911F00A3A;
	Fri, 26 Jun 2026 07:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782459284;
	bh=aY6yBcadbyrJ7uPn7rxhL8zgDn4sJwvT0MNe17nykgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n80+wOrW9gYIE+hX25DQBtQnemZCnGh1I5SwOIx3lvE7Td5jTVD1nOu9JpO/8gIYS
	 iCAxOQS4FhSTgKrlVoKf5pLQrkNXxXXD70pXL+ngSJ1d/vg2SCLsQol8bMojsbpgAk
	 swY0LOpk0Xi70RKSqObS9S5sQ/Qbe24zv16HVRlIquhEcjIluGtzUzAFeqXLlVh0NY
	 ljiuJQgANbqABzrazNnwlknWlAbdO1v0CqX/jn3UQVNAlkZJuDaZrjIBfMLdaiXze8
	 4t2OV9lz4f96TeEv/mv4T1EdrqkEMTA71AKhMJ5OphtkhX18JooVDt9vJ552PuQGWB
	 08O+QZPfI5g3g==
Date: Fri, 26 Jun 2026 09:34:38 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, 
	linux-xfs@vger.kernel.org, stable@vger.kernel.org, Dave Chinner <david@fromorbit.com>, 
	Eric Sandeen <sandeen@redhat.com>, "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>, 
	linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] xfs: fix capabily check in xfs_setattr_nonsize
Message-ID: <aj4qgCpFTXewu6gh@nidhogg.toxiclabs.cc>
References: <20260624101436.362533-1-cem@kernel.org>
 <20260624134039.GB5649@lst.de>
 <qcsdbdpp23fsu3cqhpjdpwusvl6onc2knnrun522ofrutxpz6j@reh3k2ofqjir>
 <20260625123754.GA19947@lst.de>
 <aj1CdKwE3A40vQhQ@nidhogg.toxiclabs.cc>
 <20260625160317.GY6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625160317.GY6078@frogsfrogsfrogs>

On Thu, Jun 25, 2026 at 09:03:17AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 25, 2026 at 05:00:21PM +0200, Carlos Maiolino wrote:
> > On Thu, Jun 25, 2026 at 02:37:54PM +0200, Christoph Hellwig wrote:
> > > On Thu, Jun 25, 2026 at 12:43:54PM +0200, Jan Kara wrote:
> > > > On Wed 24-06-26 15:40:39, Christoph Hellwig wrote:
> > > > > Adding Jan and Christian for quota and user_ns knowledge.
> > > > > 
> > > > > On Wed, Jun 24, 2026 at 12:14:29PM +0200, cem@kernel.org wrote:
> > > > > > From: Carlos Maiolino <cem@kernel.org>
> > > > > > 
> > > > > > An user reported a bug where he managed to evade group's quota
> > > > > > by changing a file's gid to a different group id the same user
> > > > > > belonged to, even though quotas were enforced on both gids and the
> > > > > > file's size was big enough to exceed the quota's hardlimit.
> > > > > > 
> > > > > > Commit eba0549bc7d1 replaced a capable() call by a
> > > > > > has_capability_noaudit() to prevent unnecessary selinux audit messages.
> > > > > > Turns out that both calls have slightly different semantics even though
> > > > > > their documentation seems similar. Where in a nutshell:
> > > > > > 
> > > > > > capable() - Tests the task's effective credentials
> > > > > > has_ns_capability_noaudit() - Tests the task's real credentials
> > > > > 
> > > > > Eww..
> > > > 
> > > > Yeah, that's a catch.
> 
> I spent a while trying to figure out how I went wrong in selecting the
> function name:
> 
>  * capable - Determine if the current task has a superior capability in effect
>  * @cap: The capability to be tested for
>  *
>  * Return true if the current task has the given superior capability currently
>  * available for use, false if not.
> 
> vs.
> 
>  * has_capability_noaudit - Does a task have a capability (unaudited) in the
>  * initial user ns
>  * @t: The task in question
>  * @cap: The capability to be tested for
>  *
>  * Return true if the specified task has the given superior capability
>  * currently in effect to init_user_ns, false if not.  Don't write an
>  * audit message for the check.
> 
> vs.
> 
>  * ns_capable_noaudit - Determine if the current task has a superior capability
>  * (unaudited) in effect
>  * @ns:  The usernamespace we want the capability in
>  * @cap: The capability to be tested for
>  *
>  * Return true if the current task has the given superior capability currently
>  * available for use, false if not.
> 
> All three of these sound the same to me.  But what about the call path?

Yup, I reached the same conclusion, they are all the same, so I decided
to look at the implementation...

> 
> capable -> ns_capable -> ns_capable_common
> 
> has_capability_noaudit -> has_ns_capability_noaudit
> 
> ns_capable_noaudit -> ns_capable_common
> 
> Hum, maybe that's the difference -- ns_capable_common vs.
> has_ns_capability_noaudit?
> 
> ns_capable_common calls security_capable() with current_cred(), whereas
> has_ns_capability_noaudit calls it with __task_cred(t), which is
> @current in the xfs_trans_alloc_ichange case.
> 
> Aha!  current_cred is current->cred, whereas __task_cred(current) is
> current->real_cred, and these aren't the same thing:
> 
> 	/* Objective and real subjective task credentials (COW): */
> 	const struct cred __rcu		*real_cred;
> 
> 	/* Effective (overridable) subjective task credentials (COW): */
> 	const struct cred __rcu		*cred;
> 
> So I guess ns_capable_common (and wrappers) are testing the process'
> effective credentials, whereas has_ns_capability_noaudit is testing the
> process' real credentials?
> 
> It would have been *really* nice if the documentation for those
> functions mentioned that distinction!

Yup, this is a much more detailed versions from my same findings :)


> 
> > > > > > This most of the time has no practical difference but in some cases like
> > > > > > changing attrs (specifically group id in this case) through a NFS client
> > > > > > this will allow the quota code to use XFS_QMOPT_FORCE_RES, effectively
> > > > > > bypassing quota accounting checks.
> > > > > 
> > > > > Yeah, this does look wrong.  Do the other conversion in the above commit
> > > > > have tthe same issue?
> > > > > 
> > > > > > Using instead ns_capable_noaudit() should fix this issue and prevent
> > > > > > selinux audit messages.
> > > > > 
> > > > > The generic quota code manages to do without either has_capability_noaudit
> > > > > or ns_capable_noaudit.  I think this might be hidden behind
> > > > > inode_owner_or_capable calls.  Any idea why we're different?
> > > > 
> > > > Actually no. Generic quota code has equivalent checks in ignore_hardlimit()
> > > > function which does capable(CAP_SYS_RESOURCE) check. I guess the reason why
> > > > nobody complained about generic quota code is that we call
> > > > ignore_hardlimit() only if we are above hardlimit whereas XFS calls this
> > > > for every transaction...
> > > 
> > > I guess we should aim for the same to avoid the spurious audit logs.
> > > 
> > > I.e. xfs_trans_alloc_ichange is currently always called either with
> > > force = true or force = this capable check.  So as a first step we can
> > > move the check into xfs_trans_alloc_ichange for the !force case, and the
> > > propagate that through XFS_QMOPT_FORCE_RES into xfs_trans_dqresv, i.e.
> > > only set XFS_QMOPT_FORCE_RES for the real forced case and instead
> > > have the capable check down in xfs_trans_dqresv.
> > > 
> > 
> > Sounds fair, I'll give it a try tomorrow.
> 
> So yeah, I agree we should change that to:
> 
> 	ns_capable_noaudit(&init_user_ns, CAP_FOWNER)
> 
> Though it's also weird that XFS gates it on CAP_FOWNER whereas the VFS
> checks CAP_SYS_RESOURCE.  Though I would have added this:

Same to me, I think there is no real reason for us to be using
CAP_FOWNER? I thought about changing it to CAP_SYS_RESOURCE but honestly
I'd avoid doing that for LTS and just stick with CAP_FOWNER initially.

> 
> static inline bool
> current_may_ignore_quota_limits(void)
> {
> 	/*
> 	 * If the current process' effective credentials include
> 	 * CAP_FOWNER, then they're allowed to ignore the hard limit.
> 	 */
> 	return ns_capable_noaudit(&init_user_ns, CAP_FOWNER);
> }
> 
> and then changed the callsites in xfs_ioctl/xfs_iops.c to:
> 
> 	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> 			current_may_ignore_quota_limits(), &tp);
> 
> The has_capability_noaudit call in xfs_fsmap.c should change to
> ns_capable_noaudit.

I'm working on a version now adding some bits hch suggested. At the end
I think we should add a new helper in kernel/capabililty, but I want to
avoid doing that now so LTS can cleanly backport a fix. Then we can
update it.
I'm working on both things in parallel and see how it goes. I'll Cc you
folks.

> 
> --D
> 
