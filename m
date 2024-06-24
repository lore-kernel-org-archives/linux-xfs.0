Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A906C13E024
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 17:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719248779; cv=none; b=o3N0+2WQK1537Xycif4JicUFLCvRg4iubk0MIc/A9GD8jMeNGDObOpLKtWVQVPucLGEzVhFTRMg91kLa8JdkzXvYpPzKqvuTT2jnx2RsBbZiy/ngad/RVePdhASf1BJFN/dBFHKyJyV9I8fcITezkXEepppjC2TU47yIixqxEts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719248779; c=relaxed/simple;
	bh=bvK3AgOWWlPKts+tYH6wchUkX6pq4Nq9T/RTjdft8GE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=adXI5kZFFnAJJUP5g3B/FzKMjQRTcz8Q1VyLb9upFjjKgzBc7bCmmyfQTapzpiUYncQXwKTqId/QPf9Y9C3rUgbhyXgrddIV47TXI4pf+KqWQMhuhlzLuq14JOShhco/jDplU7ErOgo+wXVE2Jz7EUGOvJ9NnT8SpTPVS3UJmuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dbc9lFYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dbc9lFYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EB8C32782;
	Mon, 24 Jun 2024 17:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719248779;
	bh=bvK3AgOWWlPKts+tYH6wchUkX6pq4Nq9T/RTjdft8GE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dbc9lFYtkQrMbyDfyG51kgjdgkMSH+uFxUgzvmsHFZ3120L4uAgwRR+bXVIKomx7W
	 AjNuXIMdgfXY0AZGjvukFsxaGI4YrNhnIpd1+lYdfMDksHF2WIBpG8lqU3ILlD2yin
	 Jukafh9E3Sokf4z7SB/qqCvlRyplP2uHssx/mNrvpLzg85gaLpTElpup979ToXnwiC
	 czooBXsm3nkIADt+RYsodjtgBUUq9JKEuV1SnQ1piJq5p9I1YpJSENqs/CERZ0VCE8
	 WrKBXvkUOIyqD3yGNkOAgHucEykM315Ys2Rk58GOcQZVW6CvLGUB0O0CpQAEs/XvgY
	 3skGqOWyAutUQ==
Date: Mon, 24 Jun 2024 10:06:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: reclaim speculative preallocations for append
 only files
Message-ID: <20240624170618.GN103057@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-11-hch@lst.de>
 <20240624155443.GN3058325@frogsfrogsfrogs>
 <20240624160735.GA15941@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624160735.GA15941@lst.de>

On Mon, Jun 24, 2024 at 06:07:35PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 24, 2024 at 08:54:43AM -0700, Darrick J. Wong wrote:
> > >  
> > >  		if (xfs_get_extsz_hint(ip) ||
> > > -		    (ip->i_diflags &
> > > -		     (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))
> > > +		    (ip->i_diflags & XFS_DIFLAG_PREALLOC))
> > 
> > The last time you tried to remove XFS_DIFLAG_APPEND from this test, I
> > noticed that there's some fstest that "fails" because the bmap output
> > for an append-only file now stops at isize instead of maxbytes.  Do you
> > see this same regression?
> 
> No.   What test did you see it with?  Any special mkfs or mount options?

IIRC /think/ it was xfs/009.  No particularly special mkfs/mount
options, though my memory of 10 days ago is a bit hazy now. :(

--D
