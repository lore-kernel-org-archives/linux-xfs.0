Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BC817E;
	Fri, 14 Feb 2025 21:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739567479; cv=none; b=ZOP8TiCuu3AATIWA9A9bW9GsaDNslJqQwLl06GrMDig5bPDO3EVe5W+CPBZVSL1VdMguR3Qyg59sVig7R034FeChZvYtOI+aLRhHESgHjNpdyRG/IqPNFuWyUptKIrpJQO8zvRBgaJwRv5Kw1DSxGQHUbanb+emq9MU+UeDqbNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739567479; c=relaxed/simple;
	bh=aMKlA6SNZr7Rwd3DklKPWlU6Pes9nxzl9UA0eWjK2JI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uX9iCqG4lhk0epjxLWdWrynqNJpnFiwz9eczcMuaZgvjwOpGfrgx1QHJGu1HWFIzpHXsbZAsD5zUZF93zf1kNYu3rONWH0B3emqCk6JtgpfuicTgSXlTxb/1287I7aywZhiGbjE20wULW9ToDkTm6vb5BcsZEF4D/o0l3YVjmS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l9NSoqyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l9NSoqyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEE6C4CED1;
	Fri, 14 Feb 2025 21:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739567478;
	bh=aMKlA6SNZr7Rwd3DklKPWlU6Pes9nxzl9UA0eWjK2JI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l9NSoqyORmD9S8/2hj7I9XzK55F6ikNrrlgtP7HVtizU6ipD6g9i6Ij7geZNNnBw1
	 j+RKqFioviVrtaHzgKQXRunEcH5lBIN4d12NNO+OSdFaG3cfN3uSACeKJOeIFsfGVz
	 oYWQrfFPBl4RslRw4MJRqRH5BbMwTT48XZ3IRJGQR9jRowK9cFppECv2eOcPbhSJ5J
	 xVThFIVejBJFWb8gQ6Bbe//YKWCCX8IGO8PCu7TlGZPzcd9clg0+L6wjwXHWSkvgr5
	 a41siuuKoBsS0bz+nMDL83Mh1SGfEfi/JucGjNLFIN3KEIAcNbsFZniHqA8PodDuY5
	 w/oPJKF3WyjVQ==
Date: Fri, 14 Feb 2025 13:11:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Zorro Lang <zlang@redhat.com>, dchinner@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/34] common: fix pkill by running test program in a
 separate session
Message-ID: <20250214211118.GD21799@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094569.1758477.13105816499921786298.stgit@frogsfrogsfrogs>
 <20250214173406.pf6j5pbb3ccoypui@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20250214175644.GN3028674@frogsfrogsfrogs>
 <20250214205031.GA509210@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214205031.GA509210@mit.edu>

On Fri, Feb 14, 2025 at 03:50:31PM -0500, Theodore Ts'o wrote:
> On Fri, Feb 14, 2025 at 09:56:44AM -0800, Darrick J. Wong wrote:
> > > The tools/ directory never be installed into /var/lib/xfstests. If someone runs
> > > xfstests after `make install`, all tests will be failed due to:
> > > 
> > >   Failed to find executable ./tools/run_setsid: No such file or directory
> > 
> > Urrrk, yeah, I didn't realize that tools/ doesn't have a Makefile,
> > therefore nothing from there get installed.  Three options:
> > 
> > 1) Add a tools/Makefile and an install target
> > 2) Update the top level Makefile's install target to install the two
> >    scripts
> > 3) Move tools/run_* to the top level and (2)
> 
> Looking at tools, it seems like there are a couple of different
> categories of scripts in the directory.  Some are useful to people who
> are developing fstests (mkgroupfile, nextid, mvtest); some are useful
> when debugging a test failure (dm-logwrite-replay); some are useful
> only to xfs developers (ag-wipe, db-walk).
> 
> And to this we are adding utility programs that would be used during a
> test execution.
> 
> I wonder if we should split out these scripts into different
> directories?

I chatted with zorro on irc, who proposed doing (2) so he could finally
merge all these fixes, and getting back to any other discussions later.
I'll send the additional patch and minor tweaks to patches 14 and 15
shortly.

--D

> 
> 	  	       	      	    	- Ted
> 				
> 
