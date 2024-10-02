Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A272BDDD2;
	Wed,  2 Oct 2024 22:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727909221; cv=none; b=honlR+bPDRkTlqU+EGm1OehggLQScIm9tiZ33CGqbqNVC4iCOZ5+WgswDyrzW1u2iZfWYrqyyVwnGQh3/Jg6GNx4y4/2jC+qH1IzRVWUqrHRhRlx5fUELcHBeISBvqYTQsnfgpXsBLv3r6qfvQ5irqDGXEypqVIEYIou7nIbvPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727909221; c=relaxed/simple;
	bh=iD00yBJpkMO/cDIN2lYXgO+ZWJPfEjkYzWMRUtXwLtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUDK1zlL57DRgHVPUUs7DetUUWVdvcL2t5N3fEe3N+fyfi2lAI+aIlaXjydixcjEreu6JxfQcDoH/oHYTQ4N0UDeIo9gXhG+e41Nz3/k6d9JY/HYFh3+0FpJfh0tvm/nsyLT8DywHzw3PbY+WcrofS5ULhPJVlJr3bXfz0xlwGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lW2RXlmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lW2RXlmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239E7C4CEC2;
	Wed,  2 Oct 2024 22:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727909221;
	bh=iD00yBJpkMO/cDIN2lYXgO+ZWJPfEjkYzWMRUtXwLtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lW2RXlmVhu6YMd0fw0TMpfvfMywea7hCAPLIeMjl8lmPopHZTfA4FguU2e6AjnF+B
	 gMCuZieEtjaDNhtpfr0Qt5hUY+Kx7yjeuMDrcVRUfFY8e8E/s56vbbhmQGVVdg0N5i
	 OpdsjMMpkYJwFBIDtYvlnqmpNOXQt3Fi4lWsOKImnrwouccfCTN7Q/4LuvunCVgAch
	 JG3pgyPripvqnN/PVE/z0/JY9qQLblxqgcBz/lBe66qQLJp0OZd9f/w6ginMIfFNP7
	 ySJJZm5JutkArFi583IUBJ6Gbb3cvArrCpmOA1Ncna3yCjKta8jZAwXdjYpzx1OiqI
	 6c2D7uZ5sHc2Q==
Date: Wed, 2 Oct 2024 15:47:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/122: add tests for commitrange structures
Message-ID: <20241002224700.GG21853@frogsfrogsfrogs>
References: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
 <172780126049.3586479.7813790327650448381.stgit@frogsfrogsfrogs>
 <ZvzeDhbIUPEHCP2D@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvzeDhbIUPEHCP2D@infradead.org>

On Tue, Oct 01, 2024 at 10:45:50PM -0700, Christoph Hellwig wrote:
> On Tue, Oct 01, 2024 at 09:49:27AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Update this test to check the ioctl structure for XFS_IOC_COMMIT_RANGE.
> 
> Meh.  Can we please not add more to xfs/122, as that's alway just
> a pain?  We can just static_assert the size in xfsprogs (or the
> xfstests code using it) instead of this mess.

Oh right, we had a plan to autotranslate the xfs/122 stuff to
xfs_ondisk.h didn't we... I'll put that back on my list.

--D
