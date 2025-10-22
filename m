Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452432F363B
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 07:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761117452; cv=none; b=rRUkdCUjG/B1WaK9oMHhjT4180oHg+sXYgcx5BO6OHxQMKavAafxEOz7p9ohPyi9GAMaS1hd1A/qS5fb0dt5NsQxpwnhJ/MdcLaGXbE+pj1xppsRdz4hZgDZpHoX+B36pSU9OtHrlOC2VbCCx5gd5ydH5nTfbaNXE+wOvTzwqjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761117452; c=relaxed/simple;
	bh=OF0P8RNjxhHOHuIMdbr2wGENUmPpPxjbqW8mDgdgPy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BoHCtLuVIWsXPbJt9znualjtZQjEW3VP8BePzQXjkc8WyURnERhLYXiwQCNYDPJDJ/BJzJVbBNB+VFl77Y3IkLkIGcyBH0X9sT0RcJQdoeUPa5+WGTjkcWChnTiv/evbRBp6NI2A3q4VoAqsKYK+KrXFJ4PYOeiKALEYpSuSoDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rZnTTXt/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rZnTTXt/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FHkwb5VPaNOxuaQMfCg2cFdgZRRdyNo1KmYkc0VR+ak=; b=rZnTTXt/8Q+HUMfQlUWwhbV2hx
	XghHTqvSUqo6+VODRTShtcDw9VKoe2RFjJowwWvHM1XX69MipRogJfLZj3hvwgZxOozvkLLqUpokh
	yoKL2bA0stqyptEqgr6UYKOhn9dcbNv17ONSBH1FJto3Qmosl8YiMeHcLprbvqRJdUGelOKf+W9zP
	72IbOIIotRAWAEskVsBlduLwGyp8cZUljV9VtEEZjzQi7S8X68cGBNjTO10bSFVfbp42SMvonaqT+
	jRMQcipGlURahWaZzPrG49qDqXae7O+q+GXK+n4Q84n/Lz0qw3pMfCdwRwyLRbvu2rZUa8ZSdK9eY
	BKMd0Dcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBT67-00000001pzC-19p9;
	Wed, 22 Oct 2025 07:17:27 +0000
Date: Wed, 22 Oct 2025 00:17:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	djwong@kernel.org, bfoster@redhat.com, david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: Re: [RFC V3 0/3] xfs: Add support to shrink multiple empty AGs
Message-ID: <aPiFBxhc34RNgu5h@infradead.org>
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 20, 2025 at 09:13:41PM +0530, Nirjhar Roy (IBM) wrote:
> This work is based on a previous RFC[1] by Gao Xiang and various ideas
> proposed by Dave Chinner in the RFC[1].
> 
> Currently the functionality of shrink is limited to shrinking the last
> AG partially but not beyond that. This patch extends the functionality
> to support shrinking beyond 1 AG. However the AGs that we will be remove
> have to empty in order to prevent any loss of data.
> 
> The patch begins with the re-introduction of some of the data
> structures that were removed, some code refactoring and
> finally the patch that implements the multi AG shrink design.
> The final patch has all the details including the definition of the
> terminologies and the overall design.

I'm still missing what the overall plan is here.  For "normal" XFS
setups you'll always have inodes that we can't migrate.  Do you plan
to use this with inode32 only?  Also it would be nice to extent this
to rtgroups, as we are guaranteed to not have non-migratable metadata
there and things will actually just work.

