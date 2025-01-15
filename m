Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B002F4C6C
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 05:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736918522; cv=none; b=KCrnrZdjtVmwsX1zM1zVMzQpM+pDLaDpPfWi4f/Wmm5xIS0kKuDEeJdZ9v9+j+2zdjVn+28i4iPW5uYBOkAoQx8fuFjW9RgeEKgPKGgKUDXCCBKInA2jlUjc3VUFD+k4rv67417uK4gR86DSGKuYdSggNbhNdptBITMqZAo18M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736918522; c=relaxed/simple;
	bh=jvMxghZJpuS7cYYn7GEZO5NLYleQfjO93tZDiR/+EjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbpfHAjwQzIJWoa6uucrdBMu7fUb7qQASdr56DuSijASvrpoPzJ0gk9ZVG7dj2VKbvgaqaunswWwLLfJ9AawgULi2MW++i3yuMsA2094RCqkhDGDSMAbWNlDa5wobcPC9+qwafXP0I/eCdPPT3xP0XKTtEzIvhR5rroxJjnjWe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 112CE68B05; Wed, 15 Jan 2025 06:21:56 +0100 (CET)
Date: Wed, 15 Jan 2025 06:21:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/5] build: initialize stack variables to zero by
 default
Message-ID: <20250115052155.GD28609@lst.de>
References: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs> <173689081941.3476119.6143322419702468919.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173689081941.3476119.6143322419702468919.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 14, 2025 at 01:41:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Newer versions of gcc and clang can include the ability to zero stack
> variables by default.  Let's enable it so that we (a) reduce the risk of
> writing stack contents to disk somewhere and (b) try to reduce
> unpredictable program behavior based on random stack contents.  The
> kernel added this 6 years ago, so I think it's mature enough for
> xfsprogs.

Hmm, this tends to paper of bugs quite badly.  But I guess we'd better
paper over bugs in the same way as the kernel code.

Reluctantly-Reviewed-by: Christoph Hellwig <hch@lst.de>

