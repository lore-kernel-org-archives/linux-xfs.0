Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F6D4ADD8F;
	Tue,  4 Aug 2026 17:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785865433; cv=none; b=SAM6DyZivtXBWoQV2RIW3zqXBEDOfbtluaDI6wW9KTRbhpFlGzKTkRqZMku9/zYJQBWtZcjnEI4S4MjH20jFfDK2Ygeehilw3GwL8x+BZyK9HmxsRcpC+nMJztAYOBBPf2lAGdcJ1oUcl3P6UH3kfgN/gjL4U9VQBNiHfYdHeKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785865433; c=relaxed/simple;
	bh=NxGVmzuUM25d1cHXaLgUR7DeLjHeQXw5xmNSdkgqV20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OsXd8TBgiP0lLPDgEj9nlyTehJodQY9lR7hZ+DFzy077Ci2M2z6V5AAQl9F7J/8HitBkstGTvr9w/AEbYXwCmjrJvqIFy0HLlqlG46aORQs6IfaX76BREPQbROZcERD8vVWkdAihYIQtJ/zD/PKl4lboAUgmNT24wb2DArjYVKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 02A256732A; Tue,  4 Aug 2026 19:43:48 +0200 (CEST)
Date: Tue, 4 Aug 2026 19:43:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v14 11/21] xfs: don't report dio_mem_align and
 dio_offset_align for fsverity files
Message-ID: <20260804174347.GC14046@lst.de>
References: <20260803200820.393203-1-aalbersh@kernel.org> <20260803200820.393203-12-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803200820.393203-12-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 03, 2026 at 10:08:01PM +0200, Andrey Albershteyn wrote:
> Sashiko.dev reported that while fsverity files falls back to the
> buffered IO for Direct I/O, they should not report non-zero values in
> dio_mem_align and dio_offset_align, meaning it's not supported.

This doesn't make much sense to me.  If we didn't want to report
we'd also want to not set STATX_DIOALIGN | STATX_DIO_READ_ALIGN.
But in the end there is very little upside of this while adding
extra special cases.

