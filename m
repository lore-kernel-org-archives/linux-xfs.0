Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D8D18641
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736233074; cv=none; b=XC1WpBbrgXPGPi5cs8egdYfTTl9gLi6SKxyFMI6KCS2RXk+mIOpNA9Sh48lvTjHOdjtDHQET3hTfs5k3wO6u4jbQ/VTraPryVjAfMDNgGI6+db0YuURnjPYhAo4slqig9V/qV5EJWmbYXo3eb3FKpptdwO5cKjuwonCvFd4NLxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736233074; c=relaxed/simple;
	bh=gjdbGLTDmWXDPYBxP5PJt7nnFMFAKVhl89DJLl0Qsa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VDdkNX0a4mspqe7i4sAcHZ903ClFtrgWE45lAEDlYrQ8FlT9Unq5hfMaecmkYtUzJmDMF4dHvgg/YYbKCBCKCgcXhfF++LyL+rfUOIQpneS2fJP1m885v7FfIgGl5rkbskWPQwl/7wWw3EeQKRmMaW6Ww9TjRlAm62qcbvBesmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+xOOWT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+xOOWT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380EBC4CED6;
	Tue,  7 Jan 2025 06:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736233074;
	bh=gjdbGLTDmWXDPYBxP5PJt7nnFMFAKVhl89DJLl0Qsa0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T+xOOWT65xD9hShCPbWuywF8uh5znfR+XNaSjcFVyhXIkwpB4YvuNE1Am7DN1mNUv
	 WrhKLIg5JF8PyMRW+L5z6xP91UQilTF3ZHjF+80YCv5MFFkp5MgCamUhJ41fR3VY+C
	 MxgvV81GZ9FVzpKA/Z8HXJPLSp8Y4CLteBNm3gxUrqIbH7o5qrgvV4ab9wIOznYxnf
	 ZiwsQOOwQSDCyz/98AElB5DXso+jSf5u7orOlXqcQTDcUUGB2m6n9rD1KtKV96+DzI
	 LwpKmGofAr88fTZqL6C3RYo9YZKH5J1FLkuFxn0QASNtX7UoDo+e6Vsl1W86YlxsSF
	 x3oUi6zbgsLyw==
Date: Mon, 6 Jan 2025 22:57:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/15] xfs: simplify buffer I/O submission
Message-ID: <20250107065753.GF6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-10-hch@lst.de>
 <20250107064224.GA6174@frogsfrogsfrogs>
 <20250107064637.GA14460@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107064637.GA14460@lst.de>

On Tue, Jan 07, 2025 at 07:46:37AM +0100, Christoph Hellwig wrote:
> On Mon, Jan 06, 2025 at 10:42:24PM -0800, Darrick J. Wong wrote:
> > So I guess b_io_remaining was the count of in-flight bios?
> 
> Yes.  Plus a bias of 1 for the submitting context so that the
> completion isn't run until all bios are submitted.
> 
> > And making a
> > chain of bios basically just moves all that to the bio layer, so all
> > xfs_buf needs to know is whether or not a bio is in progress, right?
> 
> Yes.
> 
> > Eerrugh, I spent quite a while trying to wrap my head around the old
> > code when I was writing the in-memory xfs_buf support.  This is much
> > less weird to look at...
> > 
> > > +	for (map = 0; map < bp->b_map_count - 1; map++) {
> > 
> > ...but why isn't this "map < bp->b_map_count"?
> 
> Because the final ("main") bio is submitted outside the loop as the
> loop body chains the ones before to it.  I guess this should go into
> a comment to confuse the readers a little less.

Ah, right, because we start with one bio for N maps, which means we need
to split it N-1 times to end up with N (chained) bios, one for each map.

Yes, comment please. :)

--D
