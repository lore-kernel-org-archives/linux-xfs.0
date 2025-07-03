Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE392176ADE
	for <linux-xfs@vger.kernel.org>; Thu,  3 Jul 2025 13:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751550131; cv=none; b=fuMH2cHfIMlTjf+5JVh5ZUMvwCGG7eY5quTpeVuBl2iZbl/xXWYdV2vA61/nPwvlYmCpl7niZ42Cm/TIlwHioXko4LSnVlapf36lvuQdFlVuPcOD82NIoRZzpdTOQYlnl85xkr0bU/OMJjrgyO9E5MziRufOBJQutDLQ4O6Is/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751550131; c=relaxed/simple;
	bh=US4+tA3ehkpRfMpwXPE4esap5/e4b/BiXUhl4q9d2sU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PGAo0ztDob2jznLQJFgtE46dU0XhF1yTXvmrg/76NhL1sLp/yeJ7rrcHQd1uu39sEVkCZLwWmBk/IVRFTvgKcGHHCGDb0kJjqL5S4Egul3ToyY+R9r1XIlSIJJdQfbW99Zv8MTAso6IYCWCFVzZEn141nuPWV/7CLPSj0v3xf7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 37ED668C4E; Thu,  3 Jul 2025 15:42:05 +0200 (CEST)
Date: Thu, 3 Jul 2025 15:42:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: remove the call to sync_blockdev in
 xfs_configure_buftarg
Message-ID: <20250703134204.GA26473@lst.de>
References: <20250701104125.1681798-1-hch@lst.de> <20250701104125.1681798-3-hch@lst.de> <d779b905-5704-44bc-ba8b-0d520de37f2f@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d779b905-5704-44bc-ba8b-0d520de37f2f@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 01, 2025 at 12:03:53PM +0100, John Garry wrote:
> BTW, the comment would need to be removed as well:
>
> 	/*
> 	 * Flush the block device pagecache so our bios see anything dirtied
> 	 * before mount.
> 	 */
> 	if (bdev_can_atomic_write(btp->bt_bdev))
> 		xfs_configure_buftarg_atomic_writes(btp);
>
> 	return sync_blockdev(btp->bt_bdev);
> }
>
> This all seems to have come from 6e7d71b3a0, which is a strange resolution 
> to me.

Yes, including having the comment in the wrong place.
