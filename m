Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993A015CD6A
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709141989; cv=none; b=EizN86cuu7VTx9w2m/Nfs7Pi3cj5pAiHlHc88xMEw5I0PtPVhxKZwhfc8/XH2w3MAMTnkpxn9W/JHngQ10plECD4Ud9/IJDr2wHGxxOeZblz/VZgCjIYdu2s+XRsYxy/v6Qikyix5k91MEP92lHmx/h7Dp7EerR0QKW//wnIXu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709141989; c=relaxed/simple;
	bh=+pzRLXFuLNDZ51pLITlpfjrMf2NTbnKZ3en8aEIHo/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grpAIv38OvBCMKc/0FqPNLXJlt9xXwyBc4TUMj7NbXGakqzBVEH3i7NvaG1obFe+6VYLn7tq1K65XScHXSgcDX/g/L1N+iEjuqhToEQsvh3iZYf9sbsHE4nzSd/R1osoECX0KaCLXIkHrPZFoavcdjqaG1/6WlSR/rrpQETzo1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yYbH4b9Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yYbH4b9Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YWbGa7Po+ujkqNQHDx/o1ZmAt4z6vIdiyeCKflncTDo=; b=yYbH4b9ZWSWQigk7aHnpvYbDGG
	iBtuZGeMUFbr7TMcvg0D1erm4tK5watmlm/LEJ+cA27EFZPwrLby+cJODb43XjzVBkj+9ZMNP8hz+
	8xmfmqcG11rx28skzLJ46a6hl59Nahz4rKojdWTsOsCKsuM9XmxJpw34kGpxvXeKC2S3p1yMHJwG+
	B5ANK7umLIOMxe06YEnW63V0Vyv5TV+lFWrjgHYivyQTaWoGo4cDudXF6aV7OzIcKypn03S4VZhWb
	HqGy83bOWvfI0gRJ+GM9u0mtxwM+q542/H3iGbh/VIFYWecw8kwsPrRnOrSivGxma9QWuSTDbZpDu
	t8ZgKQow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNuF-0000000AKTh-1AJQ;
	Wed, 28 Feb 2024 17:39:47 +0000
Date: Wed, 28 Feb 2024 09:39:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: hide private inodes from bulkstat and handle
 functions
Message-ID: <Zd9v41rTlllf424I@infradead.org>
References: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
 <170900012232.938660.16382530364290848736.stgit@frogsfrogsfrogs>
 <Zd4mxB5alRUsAS7o@infradead.org>
 <20240228165227.GH1927156@frogsfrogsfrogs>
 <Zd9nJj3Lw4kUYIY6@infradead.org>
 <20240228173325.GI1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228173325.GI1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 28, 2024 at 09:33:25AM -0800, Darrick J. Wong wrote:
> "We're about to start adding functionality that uses internal inodes
> that are private to XFS.  What this means is that userspace should never
> be able to access any information about these files, and should not be
> able to open these files by handle.
> 
> "To prevent userspace from ever finding the file, or mis-interactions
> with the security apparatus, set S_PRIVATE on the inode.  Don't allow
> bulkstat, open-by-handle, or linking of S_PRIVATE files into the
> directory tree.  This should keep private inodes actually private."

Sounds good.
