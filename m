Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D2F8C0B;
	Wed, 19 Feb 2025 07:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949553; cv=none; b=Bi1Uu/C7stCfV/skORGwqHrVulYbsnKefacKgpGyoHVfF8E/zPyDRpXpksIBT/pOKBqP566WjgJTPOGd64mZyve+DSFJDlFLv93QoUddU0v90WpvO5R1x+c8hJQaVInC4RoRKQGbyzs3YD1v/eo3bBJxR0vOOxUdNcf4sb37H6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949553; c=relaxed/simple;
	bh=O745cCgZzXUAaoJSae7vXGxohF64pxd4dVvWZ+45+7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=meJYl3n27VxZKq4FAb5oPWswlktlq9cEOukDoXTwbofy4XDPLr9gRPb0gOMlt8wqn4Y0VzndOpxXnQd0Z5B6HKDjUl9AOJYwwXm+OwQOKUwp5juk4yPq0VL4BLqg4xmR/79UVIfbNMa0TvdxG8cJ1Rd+r4mJbzXFkiDv2vd+SSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VHl0m2xU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VHl0m2xU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MLkvdd0w48adyd7hhAWN1JMTIibC9M0eTm9C7gGiGPg=; b=VHl0m2xUkSrCulUotpnZX07liG
	oevqdkf5K8LUWyiNxcbk6aYjssSDdoXktD0dfRaD9jMzvQeFSaYrJivEqNIsYYOHsbJ+Pa9WsRwDs
	MHeY5aIFX9+uvZ61d2yNXBQ/bHZ3c4M7xpi3f19zTY+1dM7zFYK8Jbn4X9igOkjyzP4P6s96nj3cM
	5TcriV3bk5G8sAyl4y17ZJ8ooQszRCUwUQm5IjLXda4DQVBvsLYrcgVWt+S4eE0KPhJajAxjOapgJ
	lzmloIkBSe0E8l+nFdreBzb4/n1X+DrTM8+H4hnA+WG1Y+ttribO6pafJ+3ZjrguTSWMZMc+Qd+6R
	eVPTPifA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeMR-0000000BCm9-1qJx;
	Wed, 19 Feb 2025 07:19:11 +0000
Date: Tue, 18 Feb 2025 23:19:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCHSET v6.4 07/12] fstests: store quota files in the metadir
Message-ID: <Z7WF70dbtoNGfOIY@infradead.org>
References: <20250219004353.GM21799@frogsfrogsfrogs>
 <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:47:40PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Store the quota files in the metadata directory tree instead of the superblock.
> Since we're introducing a new incompat feature flag, let's also make the mount
> process bring up quotas in whatever state they were when the filesystem was
> last unmounted, instead of requiring sysadmins to remember that themselves.

This sentence looks like it was erroneously copied from the kernel
series.

