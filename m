Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D30DF9F5
	for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2024 02:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708481876; cv=none; b=ePeJyIGEuU11hoZPmMBXT8ef4MIk4ar/tuerv11N6YzxObuEU6BYZiEHgoTdqll10xkkxqgMRckykGTgyMU6tkgkUfNbkswYNS2aSHrkyx69CbJw7AdliZj6cywaZYGoIqtqzmswQ+a1HcA2vkIT+5UuAGCkeFAP8s1BF2JckUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708481876; c=relaxed/simple;
	bh=LvEHLFcLjOxIFDUr54wNiVZ8DXFw1S3BWSPUXevmi34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z3GU+CEFWbWi1Y3k8l8TjVimCKhPPqJ3WdG6qwEK0W3bVToWQodA2nBH14B1l8jsZro8cNgXFIf1LTPmQkYLD0Ad5NvImEmPUn5Bp3IZUfjXzqCV4tzEbxu2iCpeYNRx5pl8/8WkNx2loUPi0lGa1tNZC6UmVaN5a91+UFxyROk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXAokH4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXAokH4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B24C433C7;
	Wed, 21 Feb 2024 02:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708481876;
	bh=LvEHLFcLjOxIFDUr54wNiVZ8DXFw1S3BWSPUXevmi34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BXAokH4muhwf047+cmFjjyeUiJBOR7xaoTsAm36BDOPubbBWo+TVySUn6YqzfZABF
	 qc2jcN98ZWkyETT+COJRaN0/kaf7v8eQgjRgpgeLLQ9HpdNCz/IdBBtNhGbGyWT1zF
	 JdyBB+ySMjnI3JLuzIbsMQzILZAz5MRaLWbNbZF5F0BtGybEvS2E/+6SGaIuD88RIc
	 zlNtSTDp8pRRfRLNwpALkbtp2XcszNOi7cRva+l0zEVtCOQtorpLoRDtRXeJp9wjt4
	 AwazJ80HfUckevZA+De61Je6t7UGzHdKyCfTsuV2ayHcSZ5FSb/6ibviFF0+3URv3r
	 xwY/ez4vtxwCw==
Date: Tue, 20 Feb 2024 18:17:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 22/22] xfs: remove xfile_{get,put}_page
Message-ID: <20240221021755.GE616564@frogsfrogsfrogs>
References: <20240219062730.3031391-1-hch@lst.de>
 <20240219062730.3031391-23-hch@lst.de>
 <ZdU8elkTrE/t8kkv@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdU8elkTrE/t8kkv@dread.disaster.area>

On Wed, Feb 21, 2024 at 10:57:46AM +1100, Dave Chinner wrote:
> On Mon, Feb 19, 2024 at 07:27:30AM +0100, Christoph Hellwig wrote:
> > From: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > These functions aren't used anymore, so get rid of them.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  .../xfs/xfs-online-fsck-design.rst            |   2 +-
> >  fs/xfs/scrub/trace.h                          |   2 -
> >  fs/xfs/scrub/xfile.c                          | 104 ------------------
> >  fs/xfs/scrub/xfile.h                          |  20 ----
> >  4 files changed, 1 insertion(+), 127 deletions(-)
> 
> Looks fine.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thank you!

--D

> -- 
> Dave Chinner
> david@fromorbit.com
> 
