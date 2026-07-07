Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CA92E2EEE;
	Tue,  7 Jul 2026 09:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783416337; cv=none; b=I2wGwsE6G7Asz0UjbvPD8bdRLyJ9aX7qHlawZtFDBrVkWZi/Pc3/AETdNQV3sPhnG0BQXpEnBfRQnLpzTp1IuBlqK2YiO81TTluNVXdHOdTPIiM77jImvyUXrHK8L9pE2z+RHs3A5kZ+K1F6YesXly+366OJGjmYsMGa+bUhO+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783416337; c=relaxed/simple;
	bh=l8zBeiHHt9RNtbBVObyGS4iR7B3WMMT8bULwgsn2SAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D7COoRVaCRtF/2y3F4422l8wbYBzy3KOY6CqAR3gU6NJP9DTdKeUmgunNgMZfYwfO9/SY5PdKkm/VETTFpSHFuWkl+pXfqUygxvwVwaZxeXFGrvk/p43x8YEzF4bTkJe2fKSGW9y2CxkOvMaYVbGvdUXYZxR35fB5tn4Qnt+9Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lsdf7uUC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsdf7uUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BD71F000E9;
	Tue,  7 Jul 2026 09:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783416336;
	bh=/s6dQCG8Vq9qzFkSO18vHf5c+R2dhjuaEKt5KWL8DuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lsdf7uUCABm3bz8vixwqLG3XO8rFvp2hj/PR3FvHClBF58wwlXutRul2MEEU6UJaU
	 FiS6x4imxyW8nS+tPJksBN/rAo2IeIrNCc7syoSCjqfpFu6B3W6oAWvzeLDT0fSHek
	 mBXkp436ZSLiSrOObWXIGAmhiPc6xYSHi6yNB2K/tFT+W8hD9JeOFSIq9MBChaA5JT
	 16DPf7bf1pLs2tc6j/dQtwmK38PkMhdp/o+PygTNjPwwezQ8jOYP5+5jau1yVpo58J
	 KbyZBjST0s+BqTD8/QIEfx95XBjaFJV18L0oCe55gByuhekcnEaMJer1OolosHzIOp
	 L5i2OeAMPFThA==
Date: Tue, 7 Jul 2026 11:25:30 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, 
	Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH v3 2/5] capability: Add new capable_noaudit
Message-ID: <akzF7UJj4xZqVpHO@nidhogg.toxiclabs.cc>
References: <20260702093324.127450-1-cem@kernel.org>
 <20260702093324.127450-5-cem@kernel.org>
 <20260702155605.GE9392@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702155605.GE9392@frogsfrogsfrogs>

On Thu, Jul 02, 2026 at 08:56:05AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 02, 2026 at 11:33:19AM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > In some situations (quota enforcement bypass in this case) we'd like to
> > check for a specific capability without triggering spurious audit
> > messages from security modules like selinux.
> > 
> > Add a new helper so we don't need to use ns_capable_noaudit() directly.
> > 
> > V3: remove the extern declaration
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Darrick J. Wong <djwong@kernel.org>
> > Cc: Dave Chinner <david@fromorbit.com>
> > Cc: Eric Sandeen <sandeen@redhat.com>
> > Cc: Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
> > Cc: linux-xfs@vger.kernel.org
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: linux-security-module@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Serge Hallyn <serge@hallyn.com>
> > ---
> >  include/linux/capability.h |  5 +++++
> >  kernel/capability.c        | 17 +++++++++++++++++
> >  2 files changed, 22 insertions(+)
> > 
> > diff --git a/include/linux/capability.h b/include/linux/capability.h
> > index 37db92b3d6f8..f8532d92fcad 100644
> > --- a/include/linux/capability.h
> > +++ b/include/linux/capability.h
> > @@ -145,6 +145,7 @@ extern bool has_capability_noaudit(struct task_struct *t, int cap);
> >  extern bool has_ns_capability_noaudit(struct task_struct *t,
> >  				      struct user_namespace *ns, int cap);
> >  extern bool capable(int cap);
> > +bool capable_noaudit(int cap);
> >  extern bool ns_capable(struct user_namespace *ns, int cap);
> >  extern bool ns_capable_noaudit(struct user_namespace *ns, int cap);
> >  extern bool ns_capable_setid(struct user_namespace *ns, int cap);
> > @@ -167,6 +168,10 @@ static inline bool capable(int cap)
> >  {
> >  	return true;
> >  }
> > +static inline bool capable_noaudit(int cap)
> > +{
> > +	return true;
> > +}
> >  static inline bool ns_capable(struct user_namespace *ns, int cap)
> >  {
> >  	return true;
> > diff --git a/kernel/capability.c b/kernel/capability.c
> > index 829f49ae07b9..2c2d1e8300bd 100644
> > --- a/kernel/capability.c
> > +++ b/kernel/capability.c
> > @@ -416,6 +416,23 @@ bool capable(int cap)
> >  	return ns_capable(&init_user_ns, cap);
> >  }
> >  EXPORT_SYMBOL(capable);
> > +
> > +/**
> > + * capable_noaudit - Determine if the current task has a superior
> > + * capability in effect (unaudited).
> > + * @cap: The capability to be tested for
> > + *
> > + * This is the same as capable(), except it uses CAP_OPT_NOAUDIT as to prevent
> > + * issuing spurious audit messages.
> > + *
> > + * This sets PF_SUPERPRIV on the task if the capability is available on the
> > + * assumption that it's about to be used.
> 
> Same complaint about the documentation as last time:
> https://lore.kernel.org/linux-fsdevel/20260626151656.GT6078@frogsfrogsfrogs/

Right. I assumed "capability in effect" would suffice that, but I can
add some extra comment here.

> 
> --D
> 
> > + */
> > +bool capable_noaudit(int cap)
> > +{
> > +	return ns_capable_noaudit(&init_user_ns, cap);
> > +}
> > +EXPORT_SYMBOL(capable_noaudit);
> >  #endif /* CONFIG_MULTIUSER */
> >  
> >  /**
> > -- 
> > 2.54.0
> > 
> > 
> 
