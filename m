Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE4C2DC79B;
	Thu, 21 May 2026 09:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779354430; cv=none; b=mOv7wUdvUURO03BPqmRtmFxLxcyqAByG4GoJlJlSLlxhLOo4CCrFZjICMo7ld1yPO5JYAce5bUSdxSGELlsIG9QZmxHezSRV3F8waDToi9eS9orspil1Gw4xHaoPerl85hOng+3X5g79mdsqW2ndzbj9KNRV6NPxvPsSAhH81ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779354430; c=relaxed/simple;
	bh=HXye9rt/KAbTu5nJ72pECmU4M+JCduAXX9rmPhkcyZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dWIaPXQmHiCsvLEPtjjCcyW/JGf5bpmuDX4ePoI3G+tH55KSqUQy4i5V8Bcc3kAosxRsTs0hF15IFpeLKCIIfJv61gZynC80Q6aKL9iZwsCQ+uu0wM/f01EqSZL1h5JlmVJ7Xz+HD5CGdztHyvZZZ8zk+4F/O3LkVfPIYAAxP+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EBB3568BFE; Thu, 21 May 2026 11:07:05 +0200 (CEST)
Date: Thu, 21 May 2026 11:07:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF
 merkle tree
Message-ID: <20260521090705.GA14254@lst.de>
References: <20260520123722.405752-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 20, 2026 at 02:36:58PM +0200, Andrey Albershteyn wrote:
> This series based on v7.1-rc4.

How are we going to merge this?  It touches at three subsystem trees
(fsverity, vfs/iomap, xfs) so some coordination will be needed.

