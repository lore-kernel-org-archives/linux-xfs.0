Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B4213B58D
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 21:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711748121; cv=none; b=l/yn3oHXJcXMmuzTn8Dc/uqcAMuBx3mevQiyeU8l1SgUsg3j2Fk7eo+JG6+5sSFuWPob15ANZDtbXtcvoEGf1iViJdD9Q8L3tW05lghTUqNqM8SRhfJAKu6KuXn60RZCoVijL23VqaGBMorTNjRxGa3Iz7/ffKGM8v89M4F2hzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711748121; c=relaxed/simple;
	bh=QiP/ZfWarUHwow5oVu6U27kxTSP1oIlLq8ONVxvzTf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCTS+Fy8ZfgzgHGvnCiHhi/6LIdsDxpCfle9ZhbLg62e3shKznrh1ustcX7xYvNmrESqOw+dq38lzKdnQ+EODoHC7CsIvSybpO3xCGxQFyuDKR9K1P+pHsZX34N7bpz8h+DdAuuynFbqLxTtrw5eZTYR7k4XN68FTFpVDz0Or4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IFPLEugZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IFPLEugZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4BCC433C7;
	Fri, 29 Mar 2024 21:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711748121;
	bh=QiP/ZfWarUHwow5oVu6U27kxTSP1oIlLq8ONVxvzTf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IFPLEugZ5Vf5X4LXwenbaqqvzXgefbpVLDiNr4XMv+zz34BAh1yKQ7FFeuoyU7m87
	 jQ+SzgZMRNbzs/a9gV9P07MtnPKBVPrhKbPbpPUsZBmx4R81D2i2MLGZu0zo8rWIC/
	 fXF6zfqxuAvO+7MCwRyZpYgaY5HJvYKeucfv6oCChGyXhEF6bjpRFAFSVkB4/B7RBX
	 dzDsFc+AqrZROKiTyB9LFr29j+nv3GqB93JFSgP+7KorNx+GrF+zIAsxwu8cxiSSXB
	 2oVtYGrblZVHXH1YKOzJIeqFwyLFmxwNhyziLzMKzuJ3bLoQ12bRgwR4HpJCUNDOBt
	 JGHDNdDXcRCHA==
Date: Fri, 29 Mar 2024 14:35:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix severe performance problems when fstrimming
 a subset of an AG
Message-ID: <20240329213520.GQ6390@frogsfrogsfrogs>
References: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
 <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>
 <ZgQEcLACdVZSxJ1_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgQEcLACdVZSxJ1_@infradead.org>

On Wed, Mar 27, 2024 at 04:35:12AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 26, 2024 at 07:07:58PM -0700, Darrick J. Wong wrote:
> > periodically to allow other threads to do work.  This implementation
> > avoids the worst problems of the original code, though it lacks the
> > desirable attribute of freeing the biggest chunks first.
> 
> Do we really care much about freeing larger area first?  I don't think
> it really matters for FITRIM at all.
> 
> In other words, I suspect we're better off with only the by-bno
> implementation.

Welll... you could argue that if the underlying "thin provisioning" is
actually just an xfs file, that punching tons of tiny holes in that file
could increase the height of the bmbt.  In that case, you'd want to
reduce the chances of the punch failing with ENOSPC by punching out
larger ranges to free up more blocks.

--D
