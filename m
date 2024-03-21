Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453DF17F7
	for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 02:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710988806; cv=none; b=YCxQOp0+9f2CMBFtd8vCcanjxtMn5wrIOpbG6nmG11hWKsLy9y5giCrvoNv+HUguATYE1tzZ1Mw9FAoPuwxVsxPDe+bS6N/pUI59uaHeqvBIVeOr1e4iC1Gvcw0vG7JD9L31o+gfGUDnu/HOesMYVG3AGZHTZnA5DxTzkAtWaBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710988806; c=relaxed/simple;
	bh=LpoI1GTZ9/Bm5nYLOwLHwYW9bd4e1RAJQEHtCnP0rc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZJk+WdUiYLaxTpx6Yp0rbfsZmti4Z5D/PbaOKONIsjf8un5NV1+qUVcqn4PCAURi7kPUHnMRSd9TkQXNcP/ajQgVL8VMGFCnJ+jtXYh/9GcAGIk/CNG2Ky1wxBI7j9uSKISal1uvBKOxUNRkf8UijutLIBkcFj4avy+HMn31xI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jiqS/oV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jiqS/oV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6D2C433C7;
	Thu, 21 Mar 2024 02:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710988805;
	bh=LpoI1GTZ9/Bm5nYLOwLHwYW9bd4e1RAJQEHtCnP0rc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jiqS/oV817SnFbXqMx5zbPPkIQKNRmm3F6ge3FX3gV7Wyi91DJNGbqWkAbxkhtLag
	 Lces2cteaIgj/C+gCTieoJgBZUvVhm0MxMEgy38/CL6m6r2HXnGtCOV1NK0OaIZl4O
	 QpmZOCoITprNdWwpG5eMhJZGShk9lHdd/wE5nh8QVUIEseBDOsJikRTezvy9o48OSF
	 qT4UWQOrEkqm77u1gx1GeuoM5EbVfjUT0qcoOTVzwrpWSGyKwwESNTKe63ma7g10Z8
	 X2OyoYcYKYFQK9GGI6ahU35fq9WJMhXOgOyJhKdEYGilehHYXjVyLJY9BIWpc8Sgm9
	 GjfBdrdmRZ/ig==
Date: Wed, 20 Mar 2024 19:40:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <20240321024005.GB1927156@frogsfrogsfrogs>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
 <20240319172909.GP1927156@frogsfrogsfrogs>
 <ZfoEVAxVyPxqzapN@infradead.org>
 <20240319213827.GQ1927156@frogsfrogsfrogs>
 <ZfoGh53HyJuZ_2EG@infradead.org>
 <20240321021236.GA1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240321021236.GA1927156@frogsfrogsfrogs>

On Wed, Mar 20, 2024 at 07:12:36PM -0700, Darrick J. Wong wrote:
> On Tue, Mar 19, 2024 at 02:41:27PM -0700, Christoph Hellwig wrote:
> > On Tue, Mar 19, 2024 at 02:38:27PM -0700, Darrick J. Wong wrote:
> > > 64k is the maximum xattr value size, yes.  But remote xattr value blocks
> > > now have block headers complete with owner/uuid/magic/etc.  Each block
> > > can only store $blksz-56 bytes now.  Hence that 64k value needs
> > > ceil(65536 / 4040) == 17 blocks on a 4k fsb filesystem.
> > 
> > Uggg, ok.  I thought we'd just treat remote xattrs as data and don't
> > add headers.  That almost asks for using vmalloc if the size is just
> > above a a power of two.
> > 
> > > Same reason.  Merkle tree blocks are $blksz by default, but storing a
> > > 4096 blob in the xattrs requires ceil(4096 / 4040) == 2 blocks.  Most of
> > > that second block is wasted.
> > 
> > *sad panda face*.  We should be able to come up with something
> > better than that..
> 
> Well xfs_verity.c could just zlib/zstd/whatever compress the contents
> and see if that helps.  We only need a ~2% compression to shrink to a
> single 4k block, a ~1% reduction for 64k blocks, or a 6% reduction for
> 1k blocks.

...or we just turn off the attr remote header for XFS_ATTR_VERITY merkle
tree block values and XOR i_ino, merkle_pos, and the fs uuid into the
first 32 bytes.

--D

> --D
> 
