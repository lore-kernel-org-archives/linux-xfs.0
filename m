Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0FFCA49
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SePaBnzy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0mPEveNIhJcwaw6Li4gkYFmoQFyGdDKhbh8j9K1hbt8=; b=SePaBnzyYfTxA47InmbwqjChxh
	bYVb/3jNAeIM2VBm31Jcfn7pTuobADrusj419jsLUEOlnFhCYau51UK4Q70H+urWed0SrTJJvyA49
	+WH4A7xBEw8bRHBBMg8AAlLZ+vZqLug9EE/f8EM6neaE4TdbHAlmqvvnN7mvGNrrTrnCUAtPPY3Fm
	BPhczVD4EwdORpqTf5FDU18zfLZvzp9M2H35Mxr3igwwvcXJu6Ji+p+FSDnfF22PMdLpyjSlwRfWa
	9PNwr6rcaOxcELT6yHE84M5qBhaScagZxczzF/t38G8NoaHINcog+/9PvMsRSGPVSS/pHCC/DWp+r
	5xSjvljw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rK5lg-0089ql-QE; Mon, 01 Jan 2024 00:02:56 +0000
Date: Mon, 1 Jan 2024 00:02:56 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: dump xfiles for debugging purposes
Message-ID: <ZZIBMC1E8nz4uNiV@casper.infradead.org>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829594.1748854.13298793357113477286.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404829594.1748854.13298793357113477286.stgit@frogsfrogsfrogs>

On Sun, Dec 31, 2023 at 12:13:49PM -0800, Darrick J. Wong wrote:
> +	error = xfile_stat(xf, &sb);
> +	if (error)
> +		return error;
> +
> +	printk(KERN_ALERT "xfile ino 0x%lx isize 0x%llx dump:", inode->i_ino,
> +			sb.size);
> +	pflags = memalloc_nofs_save();

Hm, why?  What makes it a bad idea to call back into the filesysteam at
this point?

> +			page = shmem_read_mapping_page_gfp(mapping,
> +					datapos >> PAGE_SHIFT, __GFP_NOWARN);

This GFP flag looks wrong.  Why can't we use GFP_KERNEL here?

I'm also not thrilled about the use of page APIs instead of folio APIs,
but given how long this patchset has been in development, I understand why
you didn't start out with folio APIs.  It's not a blocker by any means.

I can come through and convert it later when I decide that it's finally
time to get rid of shmem_read_mapping_page_gfp(), which is going to take
a big gulp because it now means touching GPU drivers ...

