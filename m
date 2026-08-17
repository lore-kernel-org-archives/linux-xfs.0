Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0DF41E6D5;
	Mon, 17 Aug 2026 12:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786971518; cv=none; b=ZI/D+on+f0bfSt6i1t7bnQcJL9KajLM9N8d/rctyglak+olfQeKsIiZrCWS8kbtcp4+7OEqc5EzD5eSZp/vdzN2BPjguaCa2RL1u3/KobiIORB1M9f3d63QOqBAWmsgsgaXZxVcqxDZuMNCDhvsEGqC1GjrGIuTAb26L7e5yCT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786971518; c=relaxed/simple;
	bh=T77iMH3Z7su686rwm4StmqSLreGVhRCgO3oVeMiLkFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VlfDJF997hiSpEHMVJz9ICnyarfyqO/z7aXDiZL8kwNUXgMqu/RvDklZ0dPzKNT6y+Xgh3vGG0V15C/58KlD6zjjDw+rn2THQUUF2TjcT7xeJjucrz7AQ+I8gvkEJF3QOXhGaVyMKRyRzluSEgsSOjzP1l0Rov/+OMPq1dlVVo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lm1e/4MG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lm1e/4MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DFE1F000E9;
	Mon, 17 Aug 2026 12:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786971516;
	bh=B24AzCGu2i0BRtNVjCKkH15/evGoeyRqt5EfBxlcjZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lm1e/4MGolyMIDxOxQ/5lbFPDnVoASbnCrwYLmIDP2c8dHLbqcSYOCcVYNX2LKTAI
	 jdqMoVjcHYdEYr8SgBFKYaFhG3H4VplroKymHXfaKGLqQeAYzVyu1viR+YyfB7sdaY
	 33w3jikSLH7FnlCYnyCJfVCnjN6jEjEWoQbz/UNOGH6P79mQ3zesYsEXM+r9NLIa7D
	 gD6tq161RayJm8xEz1CqrfWjxeFtw4LOpuO/s4xSSzA+rqvo+5y/dsxtqeI5gkwNuJ
	 nlBJaEk5eOYwC92wfhwSdBsjvjo7graMKPaHqSHeHnDzUCysncDbnDTu81IPLqSjFj
	 JfzvSDXpFr7iw==
Date: Mon, 17 Aug 2026 14:58:31 +0200
From: Carlos Maiolino <cem@kernel.org>
To: sergeh@kernel.org
Cc: jack@suse.cz, djwong@kernel.org, hch@lst.de, serge@hallyn.com, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org, "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: Re: [PATCH v4 1/5] xfs: fix capability check in xfs
Message-ID: <aoMFRhWDH0LpgDid@andromeda.toxiclabs.cc>
References: <20260804094602.84766-1-cem@kernel.org>
 <20260804094602.84766-2-cem@kernel.org>
 <anTC1e_zAhKedcpH@AUS2MQ6190Y76.amd.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anTC1e_zAhKedcpH@AUS2MQ6190Y76.amd.com>

On Thu, Aug 06, 2026 at 12:22:29PM -0500, sergeh@kernel.org wrote:
> On Tue, Aug 04, 2026 at 11:45:51AM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > An user reported a bug where he managed to evade group's quota
> > by changing a file's gid to a different group id the same user
> > belonged to, even though quotas were enforced on both gids and the
> > file's size was big enough to exceed the quota's hardlimit.
> > 
> > Commit eba0549bc7d1 replaced a capable() call by a
> > has_capability_noaudit() to prevent unnecessary selinux audit messages.
> > Turns out that both calls have slightly different semantics even though
> > their documentation seems similar. Where in a nutshell:
> > 
> > capable() - Tests the task's effective credentials
> > has_ns_capability_noaudit() - Tests the task's real credentials
> > 
> > This most of the time has no practical difference but in some cases like
> > changing attrs (specifically group id in this case) through a NFS client
> > this will allow the quota code to use XFS_QMOPT_FORCE_RES, effectively
> > bypassing quota accounting checks.
> > 
> > Using instead ns_capable_noaudit() should fix this issue and prevent
> > selinux audit messages.
> 
> Hi,
> 
> this makes perfect sense, but since you say "should fix this issue",
> did you have a chance to set up a reproducer, and verify?

Hi Serge.

Yes, I do have a reproducer to test this all, I'm in process of wiring
it up on a xfstests once I get to it on my pile of stuff to do :)


> 
> > This also fix the remaining calls to has_capability_noaudit()
> > 
> > Fixes: eba0549bc7d1 ("xfs: don't generate selinux audit messages for capability testing")
> > Cc: <stable@vger.kernel.org> # v5.18
> > Reported-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Reviewed-by: Serge Hallyn <sergeh@kernel.org>
> 
> thanks,
> -serge
> 
> > ---
> >  fs/xfs/xfs_fsmap.c | 2 +-
> >  fs/xfs/xfs_ioctl.c | 2 +-
> >  fs/xfs/xfs_iops.c  | 2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> > index b6a3bc9f143c..7c79fbe0a74c 100644
> > --- a/fs/xfs/xfs_fsmap.c
> > +++ b/fs/xfs/xfs_fsmap.c
> > @@ -1175,7 +1175,7 @@ xfs_getfsmap(
> >  		return -EINVAL;
> >  
> >  	use_rmap = xfs_has_rmapbt(mp) &&
> > -		   has_capability_noaudit(current, CAP_SYS_ADMIN);
> > +		   ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
> >  	head->fmh_entries = 0;
> >  
> >  	/* Set up our device handlers. */
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 1b53701bebea..1a8af827dde1 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -647,7 +647,7 @@ xfs_ioctl_setattr_get_trans(
> >  		goto out_error;
> >  
> >  	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
> > -			has_capability_noaudit(current, CAP_FOWNER), &tp);
> > +			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
> >  	if (error)
> >  		goto out_error;
> >  
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 6339f4956ecb..7a8c77fdcf68 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -835,7 +835,7 @@ xfs_setattr_nonsize(
> >  	}
> >  
> >  	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> > -			has_capability_noaudit(current, CAP_FOWNER), &tp);
> > +			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
> >  	if (error)
> >  		goto out_dqrele;
> >  
> > -- 
> > 2.55.0
> > 
> 
