Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7796FC7
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jul 2024 04:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721192357; cv=none; b=WCU0EXrFzUbrz2tD8+ImuI/7s84AObYfdkPuDGpd3Ge9FwDhRHWTpDE5oe5KGeGK5lePAJmCMHYn923GuDU+RQ0crSJ2Tsx+Ig53uVxnzQExLbweCJnXp7JDGdx4rbrhx2wVvd77eQssGuoZ009xkm4+iGoAN8dgNZV9qRoxAe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721192357; c=relaxed/simple;
	bh=T1b5QZ18qyB1eP1fr1CnRxoy2cZKjkp5ZReEIjXALco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n1bX9lvXW56QcQg50gk6QObXqwEKroR4Xb2YJc7Pc4cgdZELg1td5dkUGkkPoDvNuvSx70sHV/iEwyw5zrUZb0u0s1fsSmOE4COlibu4/6fJHDXc5dOizahVr0m88W1nHuXchtqxKpI0FIo6k5JNOWG7jrR3PCxLfolFr8SVxTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F0B4768AFE; Wed, 17 Jul 2024 06:59:04 +0200 (CEST)
Date: Wed, 17 Jul 2024 06:59:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer
 services by default
Message-ID: <20240717045904.GA8579@lst.de>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs> <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs> <20240702054419.GC23415@lst.de> <20240703025929.GV612460@frogsfrogsfrogs> <20240703043123.GD24160@lst.de> <20240703050154.GB612460@frogsfrogsfrogs> <20240709225306.GE612460@frogsfrogsfrogs> <20240710061838.GA25875@lst.de> <20240716164629.GB612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240716164629.GB612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 16, 2024 at 09:46:29AM -0700, Darrick J. Wong wrote:
> Hm, xfs could do that, but that would clutter up the mount options.
> Or perhaps the systemd service could look for $mountpoint/.autoheal or
> something.
> 
> It might be easier still to split the packages, let me send an RFC of
> what that looks like.

So I think the package split makes sense no matter what we do,
but I really want a per file system choice and not a global one.

As a fіle system developer I always have scratch file systems around
that I definitely never want checked.  I'd also prefer scrub to not
randomly start checking external file system that are only temporarily
mounted and that I want to remove again.

Maybe we'll indeed want some kind of marker in the file system.

Btw, the code in scrub_all that parses lsblk output to find file systems
also looks a bit odd.  I'd expect it to use whatever is the python
equivalent of setmntent/getmntent on /proc/self/mounts.


