Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20BE38888F;
	Fri,  7 Aug 2026 10:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786097048; cv=none; b=KlLXDa1gBJ9QUaXpWRopv4+wBAawNlOL60WrtRd+Mcv3+ni3EH+EdyPaY9SY3MHd61DXNbvKE6vDdg359TZXOv+wTrGEtBNDSulbbbZBGLpTytSGtUkeztGE7+z/1ytZq8wDhc0OPOqKLxdgdax4LwGgc7+F1Z1l+jFROHBGZqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786097048; c=relaxed/simple;
	bh=CC8ZmSsCyRT0vQ/SYIlxzzEt60W1cd6e0Bqby7RRmHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9nitYS8JOS+E8N51Q4wzV4BHPPCWjr9b5QN6bJFNr9B1tJuqSO8/mb2R/0QAiIiIMYt6RTtsNq+F2XvUel5okIPzkOpANLHTu4ShnDTrwIyQNzP1+VM+GkIlWc3pGqrrXBhyOa9bEf2zs/NSgwNyLNMOYIeXjGBFlSMtkB/YRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ry+qsMGW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ry+qsMGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564351F000E9;
	Fri,  7 Aug 2026 10:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786097047;
	bh=WbTOBaCF6fjuXkFujOI6JeEU/Vx+OvEFANV/j9gHbVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ry+qsMGWLCFbLkDyYZGdKU2BHsnVTmXHtwfx/mdORCvd6mrXZgdqKcbYSl+bsfMJZ
	 Pd2K4oaa/ohSIitKjO9gXXex3WyOS/C2vPaBAtSmXApy9wPQB5Oh6QRuyZwuHYQ+/A
	 8zBxnb+i1rLPGHTyuojjMzbkjlWSHbRc+0qJpDhv0TaRpzTK/Dwlf0ozAy9eRURi21
	 NZt4fxDQwFtFel0h62eZak4VzvAYDdjr7zbkZC7yb7ZxpyXLMi7xagVwWrXjNmSpY4
	 dkPqikihanXrvT2ZrF6pLU1RG5Nh/Ph4jYCZIMYvOLdoCvWSNwBcE1ue4CB2vq3Emp
	 dLyHdyM8CPRIg==
Date: Fri, 7 Aug 2026 12:04:02 +0200
From: Carlos Maiolino <cem@kernel.org>
To: sergeh@kernel.org
Cc: jack@suse.cz, djwong@kernel.org, hch@lst.de, serge@hallyn.com, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 4/5] xfs: replace ns_capable_noaudit
Message-ID: <anWtdAZmncCVYRI2@andromeda.toxiclabs.cc>
References: <20260804094602.84766-1-cem@kernel.org>
 <20260804094602.84766-5-cem@kernel.org>
 <anT4a9F1izXTl5TG@AUS2MQ6190Y76.amd.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anT4a9F1izXTl5TG@AUS2MQ6190Y76.amd.com>

On Thu, Aug 06, 2026 at 04:11:07PM -0500, sergeh@kernel.org wrote:
> On Tue, Aug 04, 2026 at 11:45:54AM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > Now that capable_noaudit() is available, we don't need to keep
> > using ns_capable_noaudit() and specifying the usernaspace every single
> 
> (typo - usernaspace)

Woops thanks, I'll fix it keeping the RwB

> 
> > time.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> > V4: Fix indentation on xfs_ioctl_setattr_get_trans() changes
> > 
> >  fs/xfs/xfs_fsmap.c | 3 +--
> >  fs/xfs/xfs_ioctl.c | 2 +-
> >  fs/xfs/xfs_iops.c  | 2 +-
> >  3 files changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> > index 7c79fbe0a74c..041bb2105ec6 100644
> > --- a/fs/xfs/xfs_fsmap.c
> > +++ b/fs/xfs/xfs_fsmap.c
> > @@ -1174,8 +1174,7 @@ xfs_getfsmap(
> >  	if (!xfs_getfsmap_check_keys(&head->fmh_keys[0], &head->fmh_keys[1]))
> >  		return -EINVAL;
> >  
> > -	use_rmap = xfs_has_rmapbt(mp) &&
> > -		   ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
> > +	use_rmap = xfs_has_rmapbt(mp) && capable_noaudit(CAP_SYS_ADMIN);
> >  	head->fmh_entries = 0;
> >  
> >  	/* Set up our device handlers. */
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 1a8af827dde1..96ca3e480cb9 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -647,7 +647,7 @@ xfs_ioctl_setattr_get_trans(
> >  		goto out_error;
> >  
> >  	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
> > -			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
> > +			capable_noaudit(CAP_FOWNER), &tp);
> >  	if (error)
> >  		goto out_error;
> >  
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 7a8c77fdcf68..3f36d6e7b917 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -835,7 +835,7 @@ xfs_setattr_nonsize(
> >  	}
> >  
> >  	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> > -			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
> > +			capable_noaudit(CAP_FOWNER), &tp);
> >  	if (error)
> >  		goto out_dqrele;
> >  
> > -- 
> > 2.55.0
> > 
> 
