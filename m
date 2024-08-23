Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A973FB3B
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 18:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724437609; cv=none; b=KpS0v0uJCSDq3nt6T/IOp7ZmGHQk2BwWPw//hEKuJ1h2bjRe08nZY8xB6GgQo2DGCZuGHLV/efkHPJzcGBEMu1+7EtgI+CB5Dqwx1lo+V9b/PDLm1lt9tnUhxx8P9sixZtv6dXbBN/AqdP6/TLIhDjOTQPncNxeNwDbkChdWaJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724437609; c=relaxed/simple;
	bh=XPOdsv+1tFfmzFGMwYDICq3NQ2hUoZ9k0Z2pvl3M4do=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L7DqkSoocmAfU9DFUyAGcwhiFhQl41LE0/kYMfS94EtE0Un+oFlAMH5/xeDxadoDMnhI4MZGDbCP0rWlvLbCgrLJZjSz44CGQhBspBBxQTMfHRC84uQXiySoBjPgePQ6/3NXN9j3y2iujlC2SR34c3V++CzOeZc8wrHrpIBi6ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXp+zEYw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXp+zEYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E3AC32786;
	Fri, 23 Aug 2024 18:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724437608;
	bh=XPOdsv+1tFfmzFGMwYDICq3NQ2hUoZ9k0Z2pvl3M4do=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LXp+zEYw60KhdbW3Zyj8SV0JUkQnNQ27dNHSgMMHTbbKOIJCdznaPDr47oF7HXi91
	 l44HwM8rKaDq6TqHSSegH5/2K58hlEhGQgFYjpYyRt4uom7cwpInhEwrstkJulbOu8
	 yLdQ/Ti9MOXXtBr71TawZBvnpZKwU1d9nsgOwqYOE9DgnlEWVJ6Oix6V8Dghy7hU5H
	 xCbAmM4WbWtsPCGCd85M07xi8lJo8mv3ugfm2IP6A6O5sosRdMLesk9bRJacOQT68M
	 JdGjtM2n+FQsv5RK/tV/ZclcgvDPt49qsOct+KHfWNd7D+VwCu/RTBK7iQfmznzlNM
	 1KQvtFqtZb+lg==
Date: Fri, 23 Aug 2024 11:26:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: enable metadata directory feature
Message-ID: <20240823182648.GR865349@frogsfrogsfrogs>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089467.61495.6398228533025859603.stgit@frogsfrogsfrogs>
 <Zsgk_5jBdVVxpaPq@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zsgk_5jBdVVxpaPq@infradead.org>

On Thu, Aug 22, 2024 at 10:58:23PM -0700, Christoph Hellwig wrote:
> On Thu, Aug 22, 2024 at 05:29:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Enable the metadata directory feature.
> 
> Maybe put in just a little bit more information.  E.g.:
> 
> With this feature all metadata inodes are places in the metadata
> directory and no sb root metadata except for the metadir itself it left.
> 
> The RT device is now shared into a number of rtgroups, where 0 rtgroups
> mean that no RT extents are supported, and the traditional XFS stub
> RT bitmap and summary inodes don't exist, while a single rtgroup gives
> roughly identical behavior to the traditional RT setup, just with
> checksummed and self identifying metadata.
> 
> For quota the quota options are read from the superblock unless
> explicitly overridden.

I've massaged that into:

"With this feature all metadata inodes are places in the metadata
directory and no sb root metadata except for the metadir itself it left.

"The RT device is now shared into a number of rtgroups, where 0 rtgroups
mean that no RT extents are supported, and the traditional XFS stub RT
bitmap and summary inodes don't exist, while a single rtgroup gives
roughly identical behavior to the traditional RT setup, just with
checksummed and self identifying metadata.

"For quota the quota options are read from the superblock unless
explicitly overridden."

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for all your help getting this ready!

--D
