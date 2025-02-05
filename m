Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87F9195FEC;
	Wed,  5 Feb 2025 16:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738771659; cv=none; b=njIlzA9UM7pAL/qxsQsYvrhapYdb9jihoy8DhdxAkquT/koIhii5xTV0JDZ8wS1oTwOdXCJlVZkRtqD+rx9reYSp4Y8eQ9Rk+Z/ZkYgTX4b6/CaTtZcLFDn6qmT9afMhZIeJ6f2W60Ao/ajm7A9gF9UQ3g9LCt7x9q6xmp6EmZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738771659; c=relaxed/simple;
	bh=vlyRHcMacUd4QN8icBQzqVvO0mZOkCTjbLGbBmCMOhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F21rAYVgRbtnysl9o0lzQS9UZoHRbFgTFb6a0vHCbAfo02uNdwcKbIzUa2jnrm4bNHbcvAYa+SJEqIBm+/1T3dGpNDeoiVNgusobdDw23FC82xjsU7O3dnsjmqvSpGfDZWQHKPKj2HOicn2JiPIfP5Dv03C6/rwnyl4pKp025hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E45EF68BFE; Wed,  5 Feb 2025 17:07:32 +0100 (CET)
Date: Wed, 5 Feb 2025 17:07:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/614: query correct direct I/O alignment
Message-ID: <20250205160732.GA15787@lst.de>
References: <20250204134707.2018526-1-hch@lst.de> <20250204171258.GD21799@frogsfrogsfrogs> <20250205154422.GC13814@lst.de> <20250205155111.GE21828@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205155111.GE21828@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 05, 2025 at 07:51:11AM -0800, Darrick J. Wong wrote:
> It's one of the few zoned changes I have in the fstests branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=zoned_2025-02-04

Oh, you probably want to pull this in to make your life easier:

http://git.infradead.org/?p=users/hch/xfstests-dev.git;a=shortlog;h=refs/heads/xfs-zoned-rebase

Note that the dio size mismatch also happens when using a 4k LBA rt
device with a 512 byte LBA data device without any zoned code.

