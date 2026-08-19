Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323903D16F4;
	Wed, 19 Aug 2026 06:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787120463; cv=none; b=JOO2RIPMWKuF9zJ3qL/nqDhE+YKeXnzdoeECpJBJXhcBxFfFiZTLNF3yZLHcVQtavHI44QZCadEkw99KlEXHJi5O+No+LuXrGyCLY9MlNIzmSFwk4JtkzdsUtfQHKxf+KYGitTcqAb8UDLFI0Qlz48PTfZDb5EhF7SUWz9j4SoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787120463; c=relaxed/simple;
	bh=bp61XSrj9e//rlKtAeEHBc1XXJcQu+ytUFjrCB9eDf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOJuR6O1lDrtV7ylS3DCf+FImLxr+W1rnsnAzclBQzlv4yy+kb2wNa5jTQRmJIT/PLbIuGORgZNl15+AYJMWdTqTN7BXo6+QLappDWcxIoMEPEqJdoZP0hhCcLUw48yqn+cGclsNBnWXXYPpAhY7gIwAV09dx7AHq0eaCmziwOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pgk3a5YZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pgk3a5YZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pe8dvxczk3BBx5dATG4l5hl7aXfMoZFDbFhHA73wb4k=; b=Pgk3a5YZGXNPEF7iHD7mTAbkL7
	TlmKaIRApO5a5uAI5OLEikXt5WjjEJLbXEsmWovw/HcBKwFmqgLxQHnbx+cAFdlK9iOBaMxv/b3Yd
	UBO2ba8T53siFDXofMNOhQp3UaJ4SXPOU5iC+7zFep9cMn39/d3c1obaGTVQe/+D1LSgrEezGRGyy
	gCvlj74U+HnSIDzePkkZzJY0DabYvZ0ZEkLauRorFTkfHPt6Iw+TmHehEN+6kXA2Fs4aSfeUCLrKB
	Ryd/u9u1BIk5zFguNfgodoSMtCe9/6klRP6WMHxjSFIo+xrGkGrDX32+I9rGLd6RL1V2M03fXZ9Li
	f4ZhB0OA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwZfZ-000000095hX-2bRg;
	Wed, 19 Aug 2026 06:21:01 +0000
Date: Tue, 18 Aug 2026 23:21:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: actually recover intended file sizes in
 xfs_xmi_item_recover_intent
Message-ID: <aoVLTXX5ij7mozSa@infradead.org>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
 <178659861961.833922.14504822154596349205.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178659861961.833922.14504822154596349205.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 12, 2026 at 10:26:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that xfs_xmi_item_recover_intent doesn't actually
> restore the isize1 and isize2 fields that were recovered from an
> unfinished exchmaps log intent item.  Instead, xfs_exchmaps_init_intent
> sets the wrong isize values from the recovered inodes, with the result
> that the file sizes are not set correctly when item recovery finishes.
> Fix this by restoring isize[12] from the log item.

Eww.  Can we come up with a test cases for this that uses error
injection to shut down the file system at just the right time?

The fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
