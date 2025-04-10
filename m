Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C401E5B94;
	Thu, 10 Apr 2025 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744298755; cv=none; b=Q0NL2DNYjjhGMKoKqAl47DmYF9x4SWBOEcK5OovpwfZfwpYM3vbUbrb8b2G0+RwLRKW8CzZh1ac5Xl/rBo7QqIiVXXcByif6ovFf0IaXN2PODuUFUkLWGEdNnARs4TtDwohNoAmek3r59+4mzHYWylbUxZW9k+MMEbfnH6qoLX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744298755; c=relaxed/simple;
	bh=XsL8pvigLhE5H8MAreEhkqAdgb3uoyx3yP4EbZnSggg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWvAUwYU+NwS/cz/C68pm7QzF/45OkKEuL97hIPyuiSXsLFzB/tl/zWkdC3ElzSm8uzqWimmwF4IdwY8SqxQGU4KVsEeRGm+4SZMgzaz9aNoiYjUWLgmwAhuiT/juugmKDHEjIZ+8xWOeZNvEhDaylBy5DAeepkE7qidpIYDBmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrdCEDY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrdCEDY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0FAC4CEE8;
	Thu, 10 Apr 2025 15:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744298754;
	bh=XsL8pvigLhE5H8MAreEhkqAdgb3uoyx3yP4EbZnSggg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lrdCEDY7+CZpSbOBEGAt0AExcytkp3ECH+gD02YWdvrDnmzs1zmaPC6fOh/pw3YWH
	 e0/izyPYs4MXjAFTR5C1erFcuTwp4BBVC6MEEopEhg2/vEjyPYgqC4VOa4RdKGxqb7
	 CxuNvJsfwIgS2Mx5xrySgVjbObhV/j7cxFUuk5Mj2i5AT4jD9PC353YhRPSz454Kr5
	 cuEXqHCi1xIOhYFp40P+nVCO9fY1qsy+XEkRGwYs4yJhjfx/Yw2oo3tuit/VXIdpYe
	 bUULl9yotm080Zwm2d/rwpXL+eNzunh3q7n0wnm1vz9kejX/63yax0ICj5NQdKfv1o
	 5IsdE3l3SUD0A==
Date: Thu, 10 Apr 2025 08:25:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	linux-block <linux-block@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: Weird blockdev crash in 6.15-rc1?
Message-ID: <20250410152554.GP6307@frogsfrogsfrogs>
References: <20250408175125.GL6266@frogsfrogsfrogs>
 <20250409173015.GN6266@frogsfrogsfrogs>
 <20250409190907.GO6266@frogsfrogsfrogs>
 <Z_d13yReJn2vqxCL@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_d13yReJn2vqxCL@infradead.org>

On Thu, Apr 10, 2025 at 12:40:15AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 09, 2025 at 12:09:07PM -0700, Darrick J. Wong wrote:
> > Subject: [PATCH] block: fix race between set_blocksize and IO paths
> > 
> > With the new large sector size support, it's now the case that
> > set_blocksize needs to change i_blksize and the folio order with no
> > folios in the pagecache because the geometry changes cause problems with
> > the bufferhead code.
> 
> Urrg.  I wish we could just get out of the game of messing with
> block device inode settings from file systems.  I guess doing it when
> using buffer_heads is hard, but file systems without buffer heads
> should have a way out of even propagating their block size to the
> block device inode.  And file systems with buffer heads should probably
> not support large folios like this :P

Heh.  Why does xfs still call set_blocksize, anyway?  I can understand
why we want to validate the fs sector size is a power of 2, greater than
512, and not smaller than the LBA size; and flushing the dirty bdev
pagecache.  But do we really need to fiddle with i_blksize or dumping
the pagecache?

--D
