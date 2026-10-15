Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D03F4FD260;
	Thu, 15 Oct 2026 14:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792076074; cv=none; b=abhNNV81VO1gJFHhFFAtEr10oPbwjKS/jhh3Fr6WiXh7TSheGdq0s43UPcISE5cax7wOSrQjA7Mr11mRZKkfnD03ozxDJPzHjonbvuMBdYp9JfeB6aheXLhuAZwI6duSVS7Yuyuvhn5m1Aj1F4xe3aGe8RovFEKmwtXkE2WGFoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792076074; c=relaxed/simple;
	bh=J4o8SIkPXGdJVwImhbAGW5mNPE3/x5jZBZqcQc7txYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EmHxm/Irfa7UbGvA82QUcQ2lN7y+x01HmGFDlKAprsVGXvZ5MxY7xCqJC2Am/T8HFAbimHtNKbmpfN5H+zlqN+AAU97yjs61GXGzSvmi2J0Eo+ogXnXcYSfpL1nVlCL0ARFRiPxJdaSWcfCjHQTLEi2LYp8pitQ1/jPf4j9B3B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eWnu7Goe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eWnu7Goe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FPf/s8IL87O3vyjbpjAmgK3FzSxMbHOjYI/DnvuSQIw=; b=eWnu7GoeVZaaHX6GYSjroB4r2T
	YKQHod4C5wf531EOYVZPbScPyM/49A7bh7qMA4Kck46c8WCBMme+CSD+94rDs6Yqq4UgZnXshZq2v
	en0pIUaoCyLISg51djiJlhnW8evGB2PUE21ZZLnCnU56cTih5o0Y8Gu/MY8rWByjq/O/GWEbSqFXv
	KgebwdNac0Z36MVnSE+V4GNCnOlJHAXA2H/plYFIhVS5o+/vna81wMsxd54Zz4PfzL+Sy562zxKSU
	swqiunySJqjQ55UWVAOsTDCec/Q7hspfKK6E4Iq5VeRbrPI5yjccG/b9OzUgrqa9b+oaETJEAjVpg
	Es/p1MYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xHMqg-00000000SBe-1l2O;
	Thu, 15 Oct 2026 14:54:26 +0000
Date: Thu, 15 Oct 2026 07:54:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Zorro Lang <zlang@kernel.org>,
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH] generic/805: mask unmount failures on cleanup
Message-ID: <atDpInBpIksOo_cj@infradead.org>
References: <20261015033236.GV6253@frogsfrogsfrogs>
 <atBr0ViKkOt0wZ12@infradead.org>
 <20261015143649.GM2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015143649.GM2705364@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 15, 2026 at 07:36:49AM -0700, Darrick J. Wong wrote:
> The test vm boots off NFS to test XFS, so / and /mnt are NFS.
> SCRATCH_DEV is XFS, so when SCRATCH_MNT is mounted, /mnt/s will be XFS.
> After unmounting SCRATCH_MNT, /mnt/s will look like it's NFS, so that's
> why umount does what it does:
> 
> # mkfs.xfs -f /dev/sda
> # mount /dev/sda /mnt/s
> # umount /mnt/s
> # umount /mnt/s
> umount.nfs: remote share not in 'host:dir' format
> umount.nfs: /mnt/s: not mounted
> 
> (I'm not fstesting NFS, I left that to Chuck and Anna.)

Ah.  The patch looks good then:

Reviewed-by: Christoph Hellwig <hch@lst.de>

