Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8740E34E751
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 16:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771605819; cv=none; b=J4Ys7qShp6RHecPir9wh+CM64kbLe9P5sCzF9deIDleaK0rcuYnuWf8LQtGNffloLFuOPL9exS5bliuDf0vwAmW+WRj9WzOttJjsT25F/CXz8rqi+e1z+tcKbV5NiperR6S5aJif/iYMkVrdgCNLYZC8nvhZxbe/GMumfQBZuPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771605819; c=relaxed/simple;
	bh=lbUaWGFeMf/gYHDoa8VV+gO0Me0LjATyNuU2h2QO3zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EWQWRack7gefkfPwewFjoc1gx9dfXvPs9Weppsr6gfF38onc/8NdGX4+KqCuJpMNCInd9uRYKf42Rd7hByZ+NljIteu21wJvhLkJ6gkTQd06doj1UlR4sJPpQeWH9RShe3497UHyPlxmGOBPWKl71hMM/opsZL23aYmy9liwPwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MmlfPqUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MmlfPqUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2181CC116C6;
	Fri, 20 Feb 2026 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771605819;
	bh=lbUaWGFeMf/gYHDoa8VV+gO0Me0LjATyNuU2h2QO3zc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MmlfPqUbcLP4i6iSHCsxnPwBVwavlwB6B1NvGtewygKAtYbm4u8iLJbfLUi+Dr1mI
	 Wfio+Aw40ZrxMeKYOI+XlMfjxX8q6tKK1TWz5GH4qyZSy5cZiUJiTd8Anw0qG26WcI
	 4Xf+2c0wiOo2KJm/KlE4tCXZ2/5PtkhBA9U057LKGeN4IHTTqqB+MCmH5RXE0N4gnY
	 F0tBabkxDmx6FscEiAoDzATYldG/Z1Uymq9OIhVrbW0PUGZDnbHVR9kAmmFvVAlo4G
	 Wo6IYvFcGRsLWWsVJ3PAxyhmYxZiQ9ePbb2SbY/0SkRhpE6VuY8vZJYuxRtKhVaYU1
	 Qz3r0ZhwYfWbw==
Date: Fri, 20 Feb 2026 08:43:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, axboe@kernel.dk, dlemoal@kernel.org,
	martin.petersen@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: use blkdev_report_zones_cached()
Message-ID: <20260220164338.GY6490@frogsfrogsfrogs>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
 <177154456766.1285810.14453766592409357328.stgit@frogsfrogsfrogs>
 <aZh_k0ierLk6iHAZ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZh_k0ierLk6iHAZ@infradead.org>

On Fri, Feb 20, 2026 at 07:36:51AM -0800, Christoph Hellwig wrote:
> A different userspace port of this already is in xfsprogs for-next.
> 
> I'm a little biassed as I did it, but I prefer not having to deal
> with autoconf :)

Aha, I see commit f5f2bad67a45cd ("block: make the new blkzoned UAPI
constants discoverable") makes it so we don't need the autoconf junk
at all!  That's far less annoying than adding more autoconf.

This patch should be dropped, but the rest of the libxfs 6.19 port still
looks good.

--D
