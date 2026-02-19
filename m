Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1E46FBF
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 13:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771506593; cv=none; b=GsfVYDLI0jW9r3eFiRh2StLF/oY78d9YtDv767JwfzHhpc4e4J361s7Vk/B5yZ7l8EymoaMgSGPCxB78jujtvMVRhLgsdZWL585GbAC+ZHSQK8bYHMaj4WwnKVwUVgeA+pSLgQFWU6g31DRXy6IOsmc3+01gdeppCM5SzrbpN2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771506593; c=relaxed/simple;
	bh=Qf/IhL6LDxdsjv0mbEXZVrFpMYnXJUOXV8R0zDKBT/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YWZTxhTU8NUtJ/0U3B9C0cOFG/yvZjIH4OQg2Q9vDJ7uJYAoJmXmhG/j27/SeNZ7ojuBU12tGtwnx8EQ84WJIfj2FVA01DyNW02cqFGx17XUcNnDIVtuU36RSTuXsmeas405uKtnK03nPpbabUbA0cO1tjE5kRacuMpcw7MVo+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPswdKAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPswdKAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7957C116C6;
	Thu, 19 Feb 2026 13:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771506593;
	bh=Qf/IhL6LDxdsjv0mbEXZVrFpMYnXJUOXV8R0zDKBT/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PPswdKABLEl6sbE8+U4+1v821YXCR0ocA8x3XVIBHRWMAs4XGpVNVjvPqkg30Oi22
	 pyouay4ZWFCiA87X0tNwYpoI/CXg2kG8N7sVlhd64y8i9Qq6yYuTXKLhFiqRGMLEe6
	 l9SItAkAjk15Ou3kIClV1q2umPHWA4a2dcMQbhUuwp8QBk5n5imD+NLJ0K0gdv6BSL
	 Ifwcam8OAp8ljXw1jt1LQzGZrFVvc9U+6cz+QiEkBo/NyBPpquSmkEDBsEhC99mFTc
	 sCZYUd5Njyxjpaibj3jszvW99L2DVYPePVUE1CRlf91kVqKsYCGwOaMoHXC9j/Qpgq
	 oPAp+4AaZ/PJA==
Date: Thu, 19 Feb 2026 14:09:49 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, pankaj.raghav@linux.dev, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: fix potential pointer access race in
 xfs_healthmon_get
Message-ID: <aZcLVXE2DUH_AAP1@nidhogg.toxiclabs.cc>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925494.401799.17980890890269795712.stgit@frogsfrogsfrogs>
 <aZaxI4PzJKqUc7a_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZaxI4PzJKqUc7a_@infradead.org>

On Wed, Feb 18, 2026 at 10:43:47PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 18, 2026 at 10:01:45PM -0800, Darrick J. Wong wrote:
> >  
> > -	XFS_M((struct super_block *)hm->mount_cookie)->m_healthmon = NULL;
> > +	rcu_assign_pointer(XFS_M(
> > +			(struct super_block *)hm->mount_cookie)->m_healthmon,
> > +			NULL);
> 
> Just a nitpick, but factoring the cookie to sb thing into a helper
> or at least separate assignment would really clean this up.

Or perhaps just factor out a struct super_block *sb from it to untangle
it a bit.

I'm fine with any of the approaches though.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
