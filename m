Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01EA38171D
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 09:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768297109; cv=none; b=MvKP4x0vaZYKw1OXt0bzMNVDcG6gGMA77euPE8hKEgaiVakjVEAPyq0GfQ/ZqHsz92nTERE8c0Xl68fD/ly/GpdHut56hRYFgL6o8hsrUtkYFv6pCAw/hoz52aOyOcMbQ70ECSGDHz/S/tBbWXSmU/oD+KhEMMhiPIV1z3MU2Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768297109; c=relaxed/simple;
	bh=DytsDHd+0V3f9tdPqsN9I/BouZesdpx6vvOvbiIyrXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F27zWBmav+chm9p6ZmVjVBhU8jHUeqrr+mPgQgfeA9YCk26FLF0mXm/3DNLYToKzsL0/UUzHONaI5osxDwBJkbTVfUubkJR9CDzu9yUKjCLB/EfJPPo37JSFeN3sAhEcL70RoFgk4Hc2JJq0nFyeM7/hcUrqbY9pvEcWi5SavXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NIZW5RSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NIZW5RSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CA4C19423;
	Tue, 13 Jan 2026 09:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768297109;
	bh=DytsDHd+0V3f9tdPqsN9I/BouZesdpx6vvOvbiIyrXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NIZW5RSuKFE8mwYgmEmzc9MtftjgGg2hKyfMCn3e9EIDNTxHvv30MaWusOF1b+v8W
	 CC9x9UmI3a2hhIUukCPdb1aep+QVWIsl3penaobiTPdsE+kBXCtzHol8L3Egs/GFLk
	 9xsgLvXkD7Kn5cna2huNXiPn6w7pM+VoyH/T45KNSXR9Irm4K+W886xUuD4tJpgC1Y
	 SEG2+35kWU0VG1W7JSPZBR9spY8ROIkq0bJwlrb2BaDELaQ1F65JY54ZK+BfJDUhQ2
	 y+kLoGEnn0ypm6BDVwfWhftaXcpFTJL9xpkER8dcCRtxcNWeiYk+lDfnNP2M6GmSWH
	 20JDfMAw5p+OA==
Date: Tue, 13 Jan 2026 10:38:25 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, 
	mark.tinguely@oracle.com
Subject: Re: [PATCH] xfs: remove xfs_attr_leaf_hasname
Message-ID: <aWYSdZFviucuzeK0@nidhogg.toxiclabs.cc>
References: <20260109151741.2376835-1-hch@lst.de>
 <20260109162911.GR15551@frogsfrogsfrogs>
 <20260109163706.GA16131@lst.de>
 <20260109174127.GF15583@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109174127.GF15583@frogsfrogsfrogs>

On Fri, Jan 09, 2026 at 09:41:27AM -0800, Darrick J. Wong wrote:
> On Fri, Jan 09, 2026 at 05:37:06PM +0100, Christoph Hellwig wrote:
> > On Fri, Jan 09, 2026 at 08:29:11AM -0800, Darrick J. Wong wrote:
> > > Blerrgh, xfs_attr3_leaf_lookup_int encoding results with error numbers
> > > makes my brain hurt every time I look at the xattr code...
> > 
> > Same.  I've been really tempted to pass a separate bool multiple times.
> > Maybe we should finally go for it?  That would also remove most (but
> > all of the issues) due to the block layer -ENODATA leak.
> 
> I support that.

+1.

Should I pick this patch and you send and incremental one or should I
just wait for a new one?

^ hch

> 
> --D
> 
