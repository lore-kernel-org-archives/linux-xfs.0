Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA1A22FE0A
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765387122; cv=none; b=bs9NIhyYqMlQNhgT6Vr8hPpbWX5eFcdW2ZydS0iP5UB8zvVn/Y3b2WYtsHwca4kOblIbl8KKUOGH1iyAe0/KViV2Q1/pJ4Gczc8qNqC492rfeP/xUmcJVZ3lulp6OLq8dQCHaIjKKZAuE1KvXShMVLhZXsbid2xFaxf2kklpYC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765387122; c=relaxed/simple;
	bh=ab4tIdLhdFWZQKxYVLLHtBJUpQadiYB+rMdb7OtwL2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BIZinvVDeBDobppayXzos9I+pIruuT5Vbd/t7J3nGqLjMm+C+pV9wLojQhEUDqhXNBLpa8OTjK7czZ1vXg5wiXy2gUNWpI5HcQ5cbPLhgGwcA0EdQa4eJ3L1OUG6hrFxobos8t0gO+RUf9/B5fnqbKnObHhIUfwub75Li5+Odps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 58CE368AA6; Wed, 10 Dec 2025 18:18:37 +0100 (CET)
Date: Wed, 10 Dec 2025 18:18:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <20251210171837.GA10275@lst.de>
References: <20251210090400.3642383-1-hch@lst.de> <aTmTl_khrrNz9yLY@bfoster> <20251210154016.GA3851@lst.de> <aTmqe3lDL2BkZe3b@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTmqe3lDL2BkZe3b@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 10, 2025 at 12:14:35PM -0500, Brian Foster wrote:
> Well yeah, it would look something like this at the current site:
> 
> 	if (!is_inode_zoned() && XFS_TEST_ERROR(...) ||
> 	    ac->reserved_blocks == magic_default_res + len)
> 		xfs_zero_range(...);
> 	else
> 		xfs_free_file_space(...);
> 
> ... and the higher level zoned code would clone the XFS_TEST_ERROR() to
> create the block reservation condition to trigger it.
> 
> Alternatively perhaps you could make that check look something like:
> 
> 	if (XFS_TEST_ERROR() && (!ac || ac->res > len))
> 		...
> 	else
> 		...
> 
> ... and let the res side always bump the res in DEBUG mode, with a
> fallback on -ENOSPC or something.

That would be less invasive for sure.  But also a bit weird, as it
encodes quite a lot of detailed knowledge of the reservations here.

I could live with it, but I fear it would have a chance to break
in not very nice ways in the future.

