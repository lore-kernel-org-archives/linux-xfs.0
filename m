Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35B13F825C;
	Fri,  7 Aug 2026 09:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786096598; cv=none; b=lJyoAW9yIdJQIy7+cHEcTjtoNrY6XKyS0pvpypQcNJ5ltNd6zfYFH3gcLYbki2QjaXftKNJmuE85TDsI/0gH+V9QirJ12taDncU3b7T8Yrf7JYO/dTdGj08ggURp+BITs0gwSasLgSGqGnK+iQufasIKYQVY0bDWwQ8AyDJcpOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786096598; c=relaxed/simple;
	bh=puPekR8u4Ntf4WNh7LkQwShDTy6E22ICpXc2HmJs8mk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qwNO5mrqJnPoBaKDZILFltZVwMnm7bfd6lyt3exCX7KZnx8FIoD5KZs4WgPoo6fOnoCN5FapZ379rQjAvtj/BFD3oTm5ZopZpLCv3MxV64HaWpQJU46/eMRAE2JFKuO4fb9FoAlyfYkVOXQrCn2o7tHYGZBpQ/fAAK4fqXN41oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZg+Ik6s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZg+Ik6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9731F000E9;
	Fri,  7 Aug 2026 09:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786096597;
	bh=TF0dNrmC+9yc17KxAr12fUFORywLJoFcd9icfZ/vXlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mZg+Ik6sHzGJa1ouN9sq4J0yT/+cZlJ2s/osu1WUBfeGoC9eWyG452b8X68Oei96M
	 oWiyDXHbFrRZZtOu9tS5bvzZeeoan7FN+J2iY7OAk3fDBWwjGOj31isEGCpnxGUvjt
	 LOdpnoJes/MCR6PfLZRHMUTda90Zi39wyO29aXvFOgnACR34kXsg4xeHkxCIJZY8js
	 TrMuPDaFP+TRs+JghcGLEKGvTYHqmFfDRYr3yxYQqivs4sNcykHz4AEMNY+e3wbjsR
	 p0CNaQCO6NmdL7bt5wZzuPS8izFnROeQiIYotmNlcIWQvsFF6kgWVZk7hXckwqu3HX
	 PMpiYPdfPk7fg==
Date: Fri, 7 Aug 2026 11:56:32 +0200
From: Carlos Maiolino <cem@kernel.org>
To: sergeh@kernel.org
Cc: jack@suse.cz, djwong@kernel.org, hch@lst.de, serge@hallyn.com, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 5/5] capability: unexport has_capability_noaudit
Message-ID: <anWro2_jU0RazltI@andromeda.toxiclabs.cc>
References: <20260804094602.84766-1-cem@kernel.org>
 <20260804094602.84766-6-cem@kernel.org>
 <anTYXy17kYz6MivZ@AUS2MQ6190Y76.amd.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anTYXy17kYz6MivZ@AUS2MQ6190Y76.amd.com>

On Thu, Aug 06, 2026 at 01:54:23PM -0500, sergeh@kernel.org wrote:
> On Tue, Aug 04, 2026 at 11:45:55AM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > This has been originally exported to be used in xfs. Giving we are not
> > using it anymore, unexport for consistency.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Reviewed-by: Serge Hallyn <sergeh@kernel.org>
> 
> Thanks, Carlos.
> 
> Should these all just go in through the xfs tree?

Yeah, I'm pulling them through XFS tree if you are ok with it?!

Cheers.

> 
> > ---
> >  kernel/capability.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/kernel/capability.c b/kernel/capability.c
> > index f4a7f1963c9d..90e6ab62f6db 100644
> > --- a/kernel/capability.c
> > +++ b/kernel/capability.c
> > @@ -326,7 +326,6 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
> >  {
> >  	return has_ns_capability_noaudit(t, &init_user_ns, cap);
> >  }
> > -EXPORT_SYMBOL(has_capability_noaudit);
> >  
> >  static bool ns_capable_common(struct user_namespace *ns,
> >  			      int cap,
> > -- 
> > 2.55.0
> > 
> 
