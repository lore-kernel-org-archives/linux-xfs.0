Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5DF35EEC
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 20:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nOXCsXOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BB3C433C9;
	Mon,  4 Dec 2023 20:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701722174;
	bh=Ik1j3xGBUvxT648+BpaPJy6D1lNZV6AaFp+RBLrpRrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nOXCsXOVaf9Nzp6DLmds/7g9vn4fWDTeVwPawRXz7VWgjW6x8gHKENexNq3ywpEm9
	 sZmtIqcV2BgLCT6ofrUovjwjmGy7es1Eh4kzmyr+3RngpFZqCBDWe8PCWLJVpx86lM
	 LH9Ii+KGaiZIGffvwR9eYJZFvBiadC2dNj3RVuSHbhfn4JFlc308i6dx7ZeB8q12+b
	 ntm0Ksa/OsAGlE7wq8tsYRnFn4QtLka8JEzYdWo/a8xGjR9sakX48xlO7IbRVSAX1v
	 ogJ6/Y0zYOiE6R/Q8COX+rtqn1n1GpKIgMIdwC1J5coLC53MdK7VNvVYQYfCZM+HgW
	 86uob9fQXDong==
Date: Mon, 4 Dec 2023 12:36:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: move xfs_ondisk.h to libxfs/
Message-ID: <20231204203613.GF361584@frogsfrogsfrogs>
References: <20231204200719.15139-1-hch@lst.de>
 <20231204200719.15139-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204200719.15139-3-hch@lst.de>

On Mon, Dec 04, 2023 at 09:07:19PM +0100, Christoph Hellwig wrote:
> Move xfs_ondisk.h to libxfs so that we can do the struct sanity checks
> in userspace libxfs as well.  This should allow us to retire the
> somewhat fragile xfs/122 test on xfstests.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yay build time checks!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/{ => libxfs}/xfs_ondisk.h | 0
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  rename fs/xfs/{ => libxfs}/xfs_ondisk.h (100%)
> 
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
> similarity index 100%
> rename from fs/xfs/xfs_ondisk.h
> rename to fs/xfs/libxfs/xfs_ondisk.h
> -- 
> 2.39.2
> 
> 
