Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C411836EF
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 21:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786308; cv=none; b=OkxiLS9ZtMJRFL7bHPaWSn9dOYQNVf5VakLqH9IXG4VusidC1vK9ewdgZuRX4jBFH6XEAvh7DvhdUyvGkWaN9bOpkVuk2CGgoJhhdmwgn3MSWUzX4NyPHR33YkWifN/FdseEH9ATuV5G3Em+m8QuVJHKBsoxo9uKIijoRhZO7W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786308; c=relaxed/simple;
	bh=1i8b+QDGZtRG16Y/n5JZNvPAnoqtcVLTBYRI6ywCeAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ciuuZROBBT8/XBOqI9HEtXkU72aon5dumjJ/MAZ9tJ5i9tI4nq4uohal3ZX7Cy7RMNeCyVbnDALtIvbeQyjFo/zBqJl6s4eTnpi0CPFi0Kk4gFGDp5Qg1pXCHLELonGJ8b6Gb0KAHi+DgeCbNdAApMHPGdieUOeFlIDP7c+oAqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSv/Jfva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSv/Jfva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348D6C433F1;
	Wed, 10 Apr 2024 21:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712786308;
	bh=1i8b+QDGZtRG16Y/n5JZNvPAnoqtcVLTBYRI6ywCeAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RSv/Jfva/VMZFKgS39tmhAvgG35G37Lpo98n63Y71SSmTJYxfxeDqtoPzqHIrb1aN
	 4ApY52PL6Gh9dO4Wg0+hu5pVpk/8blvrT4jYAPrx/JwV9+SNLvKN5YbZyt8wT9jaRf
	 hCZr8krLClwXu/luSqvjvtUW3N6Ks8KDbZAT8tmcqcZMmE1hOiyjHTB6pur+yA7Rnc
	 gtL2KjwKjU1XoQFrZnpIOBqkvBf5kl9dnHCBHnsJb/35LrqGLBSc2pWKFpFVMEmhpO
	 ITy8MHmEQN50qBZdoHQSnKp3tVy4lmL9h6fQtB5Q1txZXT8f/v38FJEO/er8849tbm
	 9d3XKen8uCNXw==
Date: Wed, 10 Apr 2024 14:58:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/32] xfs: Filter XFS_ATTR_PARENT for getfattr
Message-ID: <20240410215827.GH6390@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969941.3631889.11060276222007768999.stgit@frogsfrogsfrogs>
 <ZhYo1hcMYpYQ4gcv@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYo1hcMYpYQ4gcv@infradead.org>

On Tue, Apr 09, 2024 at 10:51:18PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 05:59:30PM -0700, Darrick J. Wong wrote:
> > From: Allison Henderson <allison.henderson@oracle.com>
> > 
> > Parent pointers returned to the get_fattr tool cause errors since
> > the tool cannot parse parent pointers.  Fix this by filtering parent
> > parent pointers from xfs_xattr_put_listent.
> 
> With the new format returning the attrs should not cause parsing errors.
> OTOH we now have duplicate names, which means a get operation based on
> the name can't actually work in that case.
> 
> I'd also argue that parent pointers are internal enough that they
> should not be exposed through the normal xattr interfaces.

Yeah, I probably should change the commit message to:

"xfs: don't return XFS_ATTR_PARENT attributes via listxattr

"Parent pointers are internal filesystem metadata.  They're not intended
to be directly visible to userspace, so filter them out of
xfs_xattr_put_listent so that they don't appear in listxattr."

> > +/*
> > + * This file defines functions to work with externally visible extended
> > + * attributes, such as those in user, system, or security namespaces.  They
> > + * should not be used for internally used attributes.  Consider xfs_attr.c.
> > + */
> 
> As long as xfs_attr_change and xfs_attr_grab_log_assist are xfs_xattr.c
> that is not actually true.  However I think they should be moved to
> xfs_attr.c (and in case of xfs_attr_change merged into xfs_attr_set)
> to make this comment true.

I don't want to hoist all the larp enabling jun^Wmachinery to libxfs and
then have to stub that out in userspace.  I'd rather get rid of larp
mode entirely, after which point xfs_attr_change becomes a trivial
helper that can be collapsed.

> However I'd make it part of the top of file comment above the include
> statements.  And please add it in a separate commit as it has nothing
> to do with the other changes here.

Or just get rid of the comment entirely?  It came from the verity
series.

--D
