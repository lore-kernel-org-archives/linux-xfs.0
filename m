Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6532C18A
	for <linux-xfs@vger.kernel.org>; Wed,  3 Sep 2025 19:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756928332; cv=none; b=qw8BI5CA1HU0WOSQWbyq1EtUfFSS98Ze4BGreT2RCrYxthatrIXBIYXAcgWccTpdVRJGbwi0QGd8xNGWGsqXg8+hUgT//V0ZdkUntqHkGCYcCY/hDzKb2DTGefCcqxC1fHIO6LyDq1gySxEp6Bl9HpiMlM579NvSLTdPBYLlm8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756928332; c=relaxed/simple;
	bh=2XIXODfSLgNuQdtDAvEkeSwHc/+9MkmelBBjsms2A08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ci7U6lkL+dLvTKgYCMCz0sTF15M2Yh03KbVLM+kRAwhw0vUJ58DfsY2WG89Xel971h7UZ4fZutzH+Mf4uiFMDjpNkJPgL3MgQkHTzWIxLO8PhC/mSkkjVhalaW4Afhg5RWCO9AT0n15Qmq/Z4VQqYJKZxA8hEgcTX5L/xFTBJv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IIDr2ZVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IIDr2ZVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7FFC4CEE7;
	Wed,  3 Sep 2025 19:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756928331;
	bh=2XIXODfSLgNuQdtDAvEkeSwHc/+9MkmelBBjsms2A08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IIDr2ZVVoeePiP7tUdpFn/4S1C8ZX7eki6L7lw9FtCnVQ3mNts5xRgKILGpDiqrUm
	 yiC4zoXm0o+gifurpgCntRkh74kW2tANzLVlkDl1G6nqGhXVSbZ5v32mrrohJqHt7e
	 GQuq0WKd8/QWouilgmV6rHkcgV9A9bFtUYRl3yhCBwNKGJdePrmxNKuY5DpWWRKjOf
	 xtUKanBkpT415ToXkgYBdi1nK/zZC/gLctV3uWDJME8XoA8sjvDIeZ4gTtPFVWAWL/
	 +rS3+dconhzut4F19qCTkg5AN9izOBR5p/fge5E1u3m/eRsnu0rvEiiVLvumAflx0a
	 4aOpL2WwZ5dZA==
Date: Wed, 3 Sep 2025 12:38:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: enable online fsck by default in Kconfig
Message-ID: <20250903193851.GK8096@frogsfrogsfrogs>
References: <175691147603.1206750.9285060179974032092.stgit@frogsfrogsfrogs>
 <175691147712.1206750.10415065465026735526.stgit@frogsfrogsfrogs>
 <0b88c35a-9616-4ad9-9dec-978902f0e901@suse.cz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b88c35a-9616-4ad9-9dec-978902f0e901@suse.cz>

On Wed, Sep 03, 2025 at 08:07:29PM +0200, Vlastimil Babka wrote:
> On 9/3/25 17:00, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Online fsck has been a part of upstream for over a year now without any
> > serious problems.  Turn it on by default in time for the 2025 LTS
> > kernel.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  fs/xfs/Kconfig |    8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> > index ecebd3ebab1342..dc55bbf295208d 100644
> > --- a/fs/xfs/Kconfig
> > +++ b/fs/xfs/Kconfig
> > @@ -137,7 +137,7 @@ config XFS_BTREE_IN_MEM
> >  
> >  config XFS_ONLINE_SCRUB
> >  	bool "XFS online metadata check support"
> > -	default n
> > +	default y
> >  	depends on XFS_FS
> >  	depends on TMPFS && SHMEM
> >  	select XFS_LIVE_HOOKS
> > @@ -150,8 +150,6 @@ config XFS_ONLINE_SCRUB
> >  	  advantage here is to look for problems proactively so that
> >  	  they can be dealt with in a controlled manner.
> >  
> > -	  This feature is considered EXPERIMENTAL.  Use with caution!
> > -
> >  	  See the xfs_scrub man page in section 8 for additional information.
> >  
> >  	  If unsure, say N.
> 
> Should it still say that with default y?

I suppose not. :D

--D

> > @@ -175,7 +173,7 @@ config XFS_ONLINE_SCRUB_STATS
> >  
> >  config XFS_ONLINE_REPAIR
> >  	bool "XFS online metadata repair support"
> > -	default n
> > +	default y
> >  	depends on XFS_FS && XFS_ONLINE_SCRUB
> >  	select XFS_BTREE_IN_MEM
> >  	help
> > @@ -186,8 +184,6 @@ config XFS_ONLINE_REPAIR
> >  	  formatted with secondary metadata, such as reverse mappings and inode
> >  	  parent pointers.
> >  
> > -	  This feature is considered EXPERIMENTAL.  Use with caution!
> > -
> >  	  See the xfs_scrub man page in section 8 for additional information.
> >  
> >  	  If unsure, say N.
> 
> Ditto
> 
