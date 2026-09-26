Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAF2367B72
	for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2026 06:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790403121; cv=none; b=qkYI7ekUv1AFSOtBMdgHhkSS5ZXr1BH4DRqVd4rJrIVnfwVoPrdFymcwsu5WAIwupr0B91iEfUOgmzRZh7UCDNV+HHfYyLd/jPo8cp4O3Ub2RbtC7IZAzNLpi7jbjo0bEBYIWTsjLbSj5ggRcfbra7AVhbVIxFbXqwTcap8xRGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790403121; c=relaxed/simple;
	bh=IGAe94L6HTuACoRIZyJ3YjKldqrqeKMD8LesjxjAN3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sA806ny21aVnLs7BWTeXOVbM7I2WuLtVC1TqPgjbzB4+aUV4pv4E0vBWgI8s1CWbQ4coMXoXzVnGLZtkA0gKuXYXzODWW/w4fykjqNBqW3fqzR9zmTM8D03II9cow6OxwzhHwoNTxLypZqZd+xyUDkyftbqutadYVSDxWbcVhaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8E24968C4E; Sat, 26 Sep 2026 08:11:54 +0200 (CEST)
Date: Sat, 26 Sep 2026 08:11:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] libxfs: use xfs_trans.h from the kernel source
Message-ID: <20260926061154.GD20636@lst.de>
References: <20260925152107.3386097-1-hch@lst.de> <20260925152107.3386097-13-hch@lst.de> <3dc56354-728b-451f-9d70-8c135e0b1962@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3dc56354-728b-451f-9d70-8c135e0b1962@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 25, 2026 at 03:53:50PM -0500, Eric Sandeen wrote:
> On 9/25/26 10:20 AM, Christoph Hellwig wrote:
> > Replace the the existing xfs_trans.h with a copy of the kernel versions.
> 
> after this, inode.c, init.c, and logitem.c all #include "xfs_trans.h" twice?
> 
> and trans.c includes xfs_buf_item.h twice.
> 
> (perhaps the existing #includes just needed to be moved up?)

Some need to be moved up, some are just duplicate.  I made a bit of
a mess splitting up my original bigger patch which resulted in this.

> Also after this I think we have both libxfs/xfs_trans.h and libxfs/stubs/xfs_trans.h
> with the same guard, did you mean to remove the one in stubs/ ?

The same mess as above left the old xfs_trans.h around in the patch as I
only removed it locally after fixing up the split..
> 
> (ugh, why do I sound like Sashiko LOL)

You sound way more human!

