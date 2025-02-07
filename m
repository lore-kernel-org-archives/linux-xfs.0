Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F267FD
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903578; cv=none; b=GPvwrnh2iUoogFjiyoLcbUV9YyB191mlsy4VuB4dOzjIPaHrR9ZHJ2hqGV1i2SQBH4DNulUb+nqf5F76r/LKM7KoTDQQrVDNy/z6iVfF8nA2SfFo0sq7xh5GuMHNAWul0v6ZNFWeCLlZqmVy3oVmGys6sJYGlTd3TJksukIDpo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903578; c=relaxed/simple;
	bh=+ffKv83qUPDYlLFZsJ0iBwj6vNHUOqn3gPfN85WRTJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YBSoJPJJCYt5Qz+XzdCAdjxtSvTK9P9cbt7am7dVaG3ZEHVJsvQC4G+Q2B0Xc2RWhpSxB89BApPDEiU9VO09mfxIsP36kmjVjRdQPDVAi9YhM4MoPIlJ59FQcxY5ecaHIxeiLJZr7OX33SRbV9fcRaKpPbZzrDIDn/kxgXmI81U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lSz6vjL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lSz6vjL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4F7C4CED1;
	Fri,  7 Feb 2025 04:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738903576;
	bh=+ffKv83qUPDYlLFZsJ0iBwj6vNHUOqn3gPfN85WRTJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lSz6vjL2LrzZZx+w+HUGS3huvHkaoMOYLVImXe5vZRrVujMRrmTtGUFSbHTR1cKNs
	 i75PrQhTUTA6Lgc7NldAZX1/lAf6bxcRZT5m29gJ/hBjFiVxfGTgF5pkMx8wj4F8E9
	 of8sYcFoMZEBPMTF4YQcpplhSz4Y0kRgDtnqfnsYEIDjq2kAbCWJie2ayHRVDpuPDY
	 t+AaZIz/aukj5IJJejFcwV/1HdIjOGOMkWMJpKHHRQD7E5NXVAfCCsVG811nnJKq0L
	 BgvCtC+hmqXfdSN8hcpU8B4zlbkAXXkKamIBZ3zB+N+yVyPBfuY60iVc0zknjkzwF9
	 tuoTkdJiBZUPw==
Date: Thu, 6 Feb 2025 20:46:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/17] xfs_scrub: don't report data loss in unlinked
 inodes twice
Message-ID: <20250207044616.GQ21808@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086136.2738568.12499263697186080933.stgit@frogsfrogsfrogs>
 <Z6WNljC0UV4LbxPB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6WNljC0UV4LbxPB@infradead.org>

On Thu, Feb 06, 2025 at 08:35:34PM -0800, Christoph Hellwig wrote:
> On Thu, Feb 06, 2025 at 02:31:57PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If parent pointers are enabled, report_ioerr_fsmap will report lost file
> > data and xattrs for all files, having used the parent pointer ioctls to
> > generate the path of the lost file.  For unlinked files, the path lookup
> > will fail, but we'll report the inumber of the file that lost data.
> 
> Maybe also add this to the code as a comment?

Will do.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D

