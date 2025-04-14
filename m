Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC2F1862
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609151; cv=none; b=eq+7WcrBNT21Vt8mZgvq3uauTXw5KpAnal/h2c/uiD8mpMiPllID/K8dRLvmudeocZb9GA1RFKAWtNF7hd0DRvza4Gd4UZMeO+59Y81CCMIXwII0QjT1eDZv4g7jXHSWYNyeMfwszQmh34EsXR3xJ/pRZB/a2KFQvV0ue5IJTY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609151; c=relaxed/simple;
	bh=xLuJ4NGSd8nqwChUYD9epv4C3pT3FNOBzFNHiF4o/hI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UMOYtGC8zqtQlfufBSsWt4cG6ilHt6ssXHAVxbYbaTjPLNu6GoRhJmk/pr1RP7g6KvdDvP4r3NW1RqmxXkDU8GHkLfAMHp1Vh03yooXjcHwpBExlw9n2MClMAjui4ncg8Xv7JOJ6fCh7cPttkofu1Q8aEmZs+R3q0IOdYd2EzyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zjppLXzb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zjppLXzb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vmBcnyRSDwNA1U7V5W4X8Nk7yvDkEUX5TPjlHFwrGo8=; b=zjppLXzbDXUCiGLs9q0/ZEx4Gx
	5qvfNEy0dqGbWpDlMGTm2W6rI7LCKev1BpDH+ZciO7UxT8NL/fsLjIJGWLPkkER8B72rwrRr5htM9
	cG8yL1x/ytHpSpV39P43OWWkuwPBywv1GfEsoroDMoxhiz3PY8uQ15Hk2iDONas8P7lVwxmk4e1NO
	ehTmvb7kT0/ZXzzvqLKh4+0w/TU2OR93ChWFVn2XjiSA7fN3zPiwfBrOc1cF41ELQ22lAH2dysmyQ
	IjzX082ZQOtGIHSgujiWmrsuK1u5CNmma4jb+2VwuaDVKh8GDZeHxmkrGIQNY+PHXFdLK+bvp7cHG
	as6vMbgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CXF-00000000iYW-2KXd;
	Mon, 14 Apr 2025 05:39:09 +0000
Date: Sun, 13 Apr 2025 22:39:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luca DiMaio <luca.dimaio@chainguard.dev>
Cc: linux-xfs@vger.kernel.org, Scott Moser <smoser@chainguard.dev>,
	Dimitri Ledkov <dimitri.ledkov@chainguard.dev>
Subject: Re: Reproducible XFS Filesystems Builds for VMs
Message-ID: <Z_yffXTi0iU6S_st@infradead.org>
References: <CAKBQhKVi6FWNWJH2PWUA4Ue=aSrvVcR_r2aJOUh45Nd0YdnxVA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKBQhKVi6FWNWJH2PWUA4Ue=aSrvVcR_r2aJOUh45Nd0YdnxVA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Luca,

On Fri, Apr 11, 2025 at 04:38:10PM +0200, Luca DiMaio wrote:
> EXT4 addresses this issue with the -d flag, which allows populating
> from an archive or directory without mounting.
> Is there similar functionality available for XFS, or is there interest
> in developing a method for generating reproducible XFS root
> filesystems?
> 
> I'm asking this because we'd be interested in using XFS as a filesystem for the
> final product.

mkfs.xfs supports the -p protofile option which allows populating the
file system with existing files and directories at mkfs time.  Can you
that and reports if it helps?  If not we might be able to look into
fixing issues with note.  Note that the protofile is a little arcane
so read the documentation carefully.

