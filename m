Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC15B314D13;
	Tue, 14 Jul 2026 05:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784006416; cv=none; b=u/yTG/SFhtZThHBqjEhJEy7Ca80jZTS9TEvgGjUpJ/itQBvcZpUOSzPV5tZqrCVWml2Bq6exnEvgyofhF9xA5XACBW8V3f3aK3RSksqehHKnxuNSqiZT/leg4Vne5Ql0Qa+1mQ4tD5zLgIk8FfXK2X8rCiixhDc4qtOkGSCHHEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784006416; c=relaxed/simple;
	bh=MitakgT13Ss/MpEJIxEJ1E/XKAuOsJV6Ppty4ExJX/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvJKvvdeHyg5hxk5bIiVTE/9vxFn1Gekahf9ZakdcyuXh8EkjwOpeIAYFMvNkGtxmDGRJ5w0oUtc4RY7uLL7VoXx724jQT0JwdVa5XRGzZttJUcRO/17WpouCE+KRgOz+ML0vuXERZlvX8cylvgQH5IHtYENLx83GylNoDWkY2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 41EB868BFE; Tue, 14 Jul 2026 07:20:12 +0200 (CEST)
Date: Tue, 14 Jul 2026 07:20:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: write the rg superblock when fixing it
Message-ID: <20260714052011.GA31796@lst.de>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs> <178346726193.1271589.8429966417697809477.stgit@frogsfrogsfrogs> <20260713064105.GA29416@lst.de> <20260713215857.GG7195@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713215857.GG7195@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 13, 2026 at 02:58:57PM -0700, Darrick J. Wong wrote:
> Hrmm.  Right now both superblock scrubbers don't do much for group 0,
> because both buffers are pinned to the xfs_mount, so they assume that
> there's no need to check anything.  However, the ondisk super could have
> gotten corrupted (or blown away by fdisk), in which case an immediate
> crash could render the filesystem unmountable.
> 
> So, I could (a) teach the super scrubbers to read the primary / rt
> super; and (b) teach them both to log the superblock and bwrite it
> immediately to shorten the window in which this could happen.
> 
> What do you think?

I guess the only sensible time to scrub the sb would be early during
mount? 

> Also, this patch should be calling xfs_log_sb *after* xfs_trans_getsb,
> so I'll fix that for the repost.

Oops.

