Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E341A9B3B
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 13:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612743; cv=none; b=UxRbM66cm8+U18I/mFeGWcr3MscEEoFHlCerqYCueHo0eyqwjFxLfWOtZCiDqz4DCol895lHsSiRKAwvFS+bJ6TYO5NQIC7kYPOU9By6ZofeTHbRcJ9/7x6bdE212hafM8HPMQ3huvMCzibVUr7/hI5hXXxNycNcc2Wli58bdYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612743; c=relaxed/simple;
	bh=ehdTopphTFgdCrzOJEc6biZPvtv85AtbJxsewOdCnP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cbCVzwdAWcMw6Ls+1nke9hoxcf5pHBFaVGSx5tj2jiwmlJP2hMt4iDReFt+0zmyPOZ3MK7eb2wjcgi3PhAWxtDALhiW1zUSXR/Tp0G+B7vWEVIZ1JyiqqDlwuhItVpULbvSZSsOa4KgWhuJR12wbmxDehvBKq8QZi1vEd00qOFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5DF5567373; Mon, 10 Mar 2025 14:18:55 +0100 (CET)
Date: Mon, 10 Mar 2025 14:18:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: convert buffer cache to use high order
 folios
Message-ID: <20250310131854.GB8546@lst.de>
References: <20250305140532.158563-1-hch@lst.de> <20250305140532.158563-8-hch@lst.de> <Z8i5HSS1ppbtQiJc@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8i5HSS1ppbtQiJc@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 06, 2025 at 07:50:37AM +1100, Dave Chinner wrote:
> The only thing extra that I would do here is take a leaf from the
> kmalloc() call in xlog_kvmalloc() and turn off direct reclaim for
> this allocation because >= 32kB allocations are considered "costly"
> and so will enter the compaction code if direct reclaim is enabled.
> 
> Given that we fall back to vmalloc, clearing __GFP_DIRECT_RECLAIM
> and setting __GFP_NORETRY here means that we don't burn lots of CPU
> on memory compaction if there is no high order folios available for
> immediate allocation. And on a busy machine, compaction is likely to
> fail frequently and so this is all wasted CPU time.
> 
> This may be one of the reasons why you don't see any change in real
> performance with 64kB directory blocks - we spend more time in
> folio allocation because of compaction overhead than we gain back
> from avoiding the use of vmapped buffers....

FYI, this did not make any difference in my testing.

