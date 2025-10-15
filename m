Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E8C274FD0;
	Wed, 15 Oct 2025 15:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760542623; cv=none; b=MpLemvEK5WPsx4iOAB4V+gltX1Q9ROLfBdqwmYlEAqTWE6/UmWHnyNTwLjh2sqLR2VESv7oUY3YZ6A6uMzX+PgJeyqUegzOLKXNmgoHzuaIFumERY+baPdj6iAIKs/tJiWz/MRpdxOMZS5NJPvYfips8wK9M2pRL8rr8bEy64a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760542623; c=relaxed/simple;
	bh=IRi/SXyb72T5Nu6jdCpqgpazAGejm/gBUEwbA7A+Euo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZ+NOZcZfZ3jMQiGC4ewT1rv6DgPxkTPZF2k6DixPanCMukdofBYjwVinJNhazQcm7shSPuB2NK6IP9V6rnu9fjHvGomOYSSjr/iOQjfPujQOhBVoBXbj7fWSD+C6HGEP5lJb6R/T25446FYJTKTCtjKPtGkHo4SGll3RJOahMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ScTYFIFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ScTYFIFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCE5C4CEF8;
	Wed, 15 Oct 2025 15:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760542622;
	bh=IRi/SXyb72T5Nu6jdCpqgpazAGejm/gBUEwbA7A+Euo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ScTYFIFsqSpN5CvDLERY1Dmj96xRok0knf08wbTYQgtgax4WARNlwU9RBjURGJhJ+
	 wSfqo0PCnyo4Ugps+H8xW0fGROZg+dlLD9i51p5mehdYXdfwGMAnnm6e/M9kS42TzF
	 hUsTnWo1kTWTApWXSwtFbXckwPrrnhwGgjfPLA2lBLacZ60q6z3sJX4dEq15GKTPxV
	 uetC1s5U6H2pKRlN3ct6tRkFJH1pmavyDwi+/rhYy9I5tlzhPG1ABFzId4VdXkYIF/
	 GA1HUR6bDFzYOU3uUjEO/oP/uJezUKIPkXhkdEpa53d4P5c0dCeazqca9pGV9x3wOe
	 iJvgmxaSXbPsw==
Date: Wed, 15 Oct 2025 08:37:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Carlos Maiolino <cem@kernel.org>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Pavel Reichl <preichl@redhat.com>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [PATCH v2 3/3] xfs: quietly ignore deprecated mount options
Message-ID: <20251015153702.GY6188@frogsfrogsfrogs>
References: <20251015050133.GV6188@frogsfrogsfrogs>
 <20251015050431.GX6188@frogsfrogsfrogs>
 <93c2e9a0-f374-4211-b4a0-06c716e7d950@suse.cz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93c2e9a0-f374-4211-b4a0-06c716e7d950@suse.cz>

On Wed, Oct 15, 2025 at 10:07:54AM +0200, Vlastimil Babka wrote:
> On 10/15/25 07:04, Darrick J. Wong wrote:
> >  static const struct fs_parameter_spec xfs_fs_parameters[] = {
> > +	/*
> > +	 * These mount options were supposed to be deprecated in September 2025
> > +	 * but the deprecation warning was buggy, so not all users were
> > +	 * notified.  The deprecation is now obnoxiously loud and postponed to
> > +	 * September 2030.
> > +	 */
> 
> FWIW, this seems at odds with the subject "quietly ignore" ;)
> "loudly ignore"? ;)
> "warn about but otherwise ignore"?

Ugh, yeah, I forgot to update the subject line.

"xfs: loudly complain about defunct mount options", then.

> Also there's maybe a difference of ignoring "attr2" because it's enabled
> anyway, and ignoring "noattr2" because it's going to be enabled regardless.
> AFAIK prior to b9a176e54162f8 "noattr2" still prevented the enabling? But
> maybe it's not important. (I don't know how (no)ikeep works.)

Old filesystems will be automatically upgraded to attr2 the next time
anyone writes to an xattr structure.  After V4 is removed in 2030, xfs
won't have to deal with attr1 structures anymore, because V5 always has
attr2.

noikeep was (and still is) the default; it means that inode blocks are
deleted when they are no longer in use.

> Hypothetically someone might complaing after taking a disk out of very old
> system without attr2, booting it on 6.18 that will enable attr2, and not
> being able to use it again in the old system. (Funnily enough similar issue
> recently happened to me with btrfs from Turris 1.0 router's microSD). But
> maybe there are other things besides attr2 that can cause it anyway.
> 
> Anyway I think even in 2030 it will be the best to just keep warning instead
> of refusing to mount.

I think you're right, we should keep this forever.  It's not that big of
a deal to accumulate all the dead mount options via fsparam_dead, and
probably a good tombstone to prevent accidental reuse in the future.

--D

> > +	fsparam_dead("attr2"),
> > +	fsparam_dead("noattr2"),
> > +	fsparam_dead("ikeep"),
> > +	fsparam_dead("noikeep"),
> > +
> >  	fsparam_u32("logbufs",		Opt_logbufs),
> >  	fsparam_string("logbsize",	Opt_logbsize),
> >  	fsparam_string("logdev",	Opt_logdev),
> > @@ -1417,6 +1431,9 @@ xfs_fs_parse_param(
> >  		return opt;
> >  
> >  	switch (opt) {
> > +	case Op_deprecated:
> > +		xfs_fs_warn_deprecated(fc, param);
> > +		return 0;
> >  	case Opt_logbufs:
> >  		parsing_mp->m_logbufs = result.uint_32;
> >  		return 0;
> > @@ -1537,7 +1554,6 @@ xfs_fs_parse_param(
> >  		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
> >  		return 0;
> >  #endif
> > -	/* Following mount options will be removed in September 2025 */
> >  	case Opt_max_open_zones:
> >  		parsing_mp->m_max_open_zones = result.uint_32;
> >  		return 0;
> 
> 
