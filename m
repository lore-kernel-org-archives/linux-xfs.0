Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699D715B543;
	Wed, 22 Jan 2025 03:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737516551; cv=none; b=Y86CHcC16KjxJqn67qNlSDTAMMv2N6ZEGLt6u8AR4EqFuD2qqiFMjwCkVAuAnveuPlZ8CamVG8CWeDOOGKUnEfYCA9AfvAw3rE376tD50vICgsM9dhnmLgJ4KatDAZArXjpwv8JJNOoRb9zLsthJwAMfGfIZNeTpTVuNShOhxuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737516551; c=relaxed/simple;
	bh=1ZJ3DKFYAG37vUTuc4mvpVAbhirgIbWGCdp+aUp0eNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gi4nA/BYcFUGvBQUtdAsUvgs3iDEewG7aW0MTpdmkKWJIzBxFbPIccdNs0nwDCdJRUkft5EFTv36syNfPB9nsO84eiWX6m5H6o3NDz37VAB6YhHpwinnJZ+3YtAe/17ux2hl+ZKKrqr2hlhZ3ZUj1ezmWB/OcBdHdAftaNUjYAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=llsKDdvo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="llsKDdvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54B0C4CED6;
	Wed, 22 Jan 2025 03:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737516550;
	bh=1ZJ3DKFYAG37vUTuc4mvpVAbhirgIbWGCdp+aUp0eNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=llsKDdvoGJO+RvjUiaVs0txA7XUK6d1ajG/aBFKl+0Q9zqB4mEYv0KfMQFNDxaW66
	 fLEsdVLOu+f90s4yfWn2HyA8m2D6oOmQxtYl+13G73wTouPLb6P9ztlJRK6h9kQnmU
	 TrZieoi8yWID9p8hRcWmyYxp+GVPZJvIH7XqHEfF2yX50Qes7xs+8q5F4OVHhQsQnq
	 JFb3YNsEg3E7H1ibG+g9xFpQMbLaaCTlrLwaFXGpJHz7FPHjMQ9FYNtlbYufo5C6SN
	 L1PB8lZsoy7QJ9bTcDh1ZSllu/wapzBOG/sxmvZ/j95OfpdVdSgv9JcDG0T81gSgwO
	 UTpEK+bqFvZ2w==
Date: Tue, 21 Jan 2025 19:29:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/23] unmount: resume logging of stdout and stderr for
 filtering
Message-ID: <20250122032910.GO1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974213.1927324.1385565534988725161.stgit@frogsfrogsfrogs>
 <Z48aA5-wMRNrXKER@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z48aA5-wMRNrXKER@dread.disaster.area>

On Tue, Jan 21, 2025 at 02:52:35PM +1100, Dave Chinner wrote:
> On Thu, Jan 16, 2025 at 03:27:31PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > There's a number of places where a test program calls a variant of
> > _unmount but then pipes the output through a _filter script or
> > something.  The new _unmount helper redirects stdout and stderr to
> > seqres.full, which means that those error messages (some of which are
> > encoded in the golden outputs) are suppressed.  This leads to test
> > regressions in generic/050 and other places, so let's resume logging.
> 
> Huh. g/050 hasn't been failing in my test runs. Bizarre.

Yeah, it's bombing out here on the ro block device while trying to
enable quotas.

> Anyway, change looks fine.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks!

--D

> -- 
> Dave Chinner
> david@fromorbit.com
> 
