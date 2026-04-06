Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB673090D7
	for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2026 05:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775454707; cv=none; b=fCNjoOdnQtnmApsCqgQYe8Qdyr+6sg9OmcTvQZkHzAdGkISw0AbVzXjbA91hjkIyp3ZnVGFHv6pEoOKdVgEAZmQRyI+/Lb/J2urJ2pdk8ANXxVSBG1M9m8BXmTFHb4LhuUmvukcqG19a6wao96PzIHyD0bs7pRJMPk+8eAOtp2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775454707; c=relaxed/simple;
	bh=fEF7uVSnG2ClImBkPB2G+BDShSaG3luFfVKH9RdrJ/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KR5GzD3pt0Od6e4KxyyELtAvtkEi1dxCNjecf+Ae7tr9R3bjgzEZHvlHmGeD1SCnTy+KDb+MwInSpJ2i7KOWIVdi93olTxHHnk+fBG0udwp3HPnhNcPtjWhjwf8CqJcc+xroLX9kLwNDJyPQ/0RKqpt3NARy68Zx4a81CJul7SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2D81F68BFE; Mon,  6 Apr 2026 07:51:44 +0200 (CEST)
Date: Mon, 6 Apr 2026 07:51:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, "cem@kernel.org" <cem@kernel.org>,
	"dlemoal@kernel.org" <dlemoal@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix number of GC bvecs
Message-ID: <20260406055142.GD16443@lst.de>
References: <20260401135801.124987-1-hch@lst.de> <c052461d-31d4-4296-8268-8fe3c7863bc3@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c052461d-31d4-4296-8268-8fe3c7863bc3@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 02, 2026 at 07:25:44AM +0000, Hans Holmberg wrote:
> On 01/04/2026 15:58, Christoph Hellwig wrote:
> > GC scratch allocations can wrap around and use the same buffer twice, and
> > the current code fails to account for that.  So far this worked due to
> > rounding in the block layer, but changes to the bio allocator drop the
> > over-provisioning and generic/256 or generic/361 will not usually fail
> > when running against the current block tree.
> 
> I have a hard time understanding the "will not usually fail" part,
> but apart from that, the patch looks good:

The not should be a now.

