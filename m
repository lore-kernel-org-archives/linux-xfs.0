Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DCC3346A1;
	Wed, 18 Feb 2026 21:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771451853; cv=none; b=Ie8h0i8MQYy4vJT5u9BajV77KvMQrT9cJV3bjmLGjvWCBsfaU2DsE1Zq8qB2t8gM8ZXOy4+vnOHeV4nPg2c2ivSIJcEvktJNhRwCI/zOEsHhGp6PQniMPLI5nw36Rkrbsnz4jQ8LeSXvcQHPZ2RBIBKBtuiM+1Yf8o3c5OYe3Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771451853; c=relaxed/simple;
	bh=2KTgrZINFImOkvBB6SqVSKrrzd6RnELpnqMzoGwBZFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QIRKD7tODSf9BpM5h1AW6DwzHdlWp9x0Repa/tCzxmls1pgcsap2dw1yNLQXuSkTJklK1WF9eSSKuGUr2tv4pyuR08dLBcE1Jm8AgLSnB44AVvtv/qdxeyNrFi6MjYNAfhVFTG8s1RrHLg4Xdxo5xLligVYxw0cvkduoUZuL0dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Re8YTldK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Re8YTldK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6156C116D0;
	Wed, 18 Feb 2026 21:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771451852;
	bh=2KTgrZINFImOkvBB6SqVSKrrzd6RnELpnqMzoGwBZFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Re8YTldKxxUfXNh/3lH8CRUsqe0SbroUAMXnskJiUIxOPavMdaMVy4mqnpHWMAD+9
	 wNNKT2VWvVML5ZO3NZmnqUYndDSE57hQQe1PNtOB7PIDkd7a5coNuOs35HTtbO6TA+
	 3hedwx+u456MIbEEvdHcnrrd3hvcIh83ECpxnUjsj9oFNy+YxW0g1cm7j5zy76X+DU
	 0ZqE+H9u/rsgDmvr09mLKST2FyvQiQL8pS28d5lDHUCnqW5/Afqz8Iv/o2XXFKdKnv
	 6LTZTdzpiKDcpFxbs5YVEG5uSK20x+SBbhapP4fy+6KG38/w6gg6U22hD0bGGLxg0C
	 p0JClDJQfZ4aw==
Date: Wed, 18 Feb 2026 13:57:32 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Subject: Re: [PATCH v3 03/35] fsverity: add consolidated pagecache offset for
 metadata
Message-ID: <20260218215732.GC6467@frogsfrogsfrogs>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-4-aalbersh@kernel.org>
 <20260218061707.GA8416@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218061707.GA8416@lst.de>

On Wed, Feb 18, 2026 at 07:17:07AM +0100, Christoph Hellwig wrote:
> On Wed, Feb 18, 2026 at 12:19:03AM +0100, Andrey Albershteyn wrote:
> > Filesystems implementing fsverity store fsverity metadata on similar
> > offsets in pagecache. Prepare fsverity for consolidating this offset to
> > the first folio after EOF folio. The max folio size is used to guarantee
> > that mapped file will not expose fsverity metadata to userspace.
> > 
> > So far, only XFS uses this in futher patches.
> 
> This would need a kerneldoc comment explaining it.  And unless we can
> agree on a common offset and have the translation in all file systems,
> it probably makes sense to keep it in XFS for now.   If you have spare
> cycles doing this in common code would be nice, though.

fsverity_metadata_offset definitely ought to have a kerneldoc explaining
what it is (minimum safe offset for caching merkle data in the pagecache
if large folios are enabled).

and yes, it'd be nice to do trivial conversions, but ... I think the
only filesystem that has fscrypt and large folios is btrfs?  And I only
got that from dumb grepping; I don't know if it supports both at the
same time.

OTOH I think the ext4 conversion is trivial...

static struct page *ext4_read_merkle_tree_page(struct inode *inode,
					       pgoff_t index,
					       unsigned long num_ra_pages)
{
	index += fsverity_metadata_offset(inode) >> PAGE_SHIFT;
	...
}

...and btrfs as well.

--D
