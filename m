Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50702DBF49;
	Mon, 20 Oct 2025 07:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760943684; cv=none; b=T4vbcWkKCfK1lfhWNySVV8GNSobp/MdrjF6geh3kqZIW+FHIvXjvH3Th4tTxy5pJCgAukLuGSR6VYWSQPI2DxjGW72ARu8keaver+tWPOWRq0g8oj03dw7CSL0jSZlvp4+meyHDXIKu8ANlnVJRpWWugSU6AKI7L9SkLP5P1ATU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760943684; c=relaxed/simple;
	bh=g/1j01oNt6bwgLy6AnV/ZrCZYdGblbMcqisxaUHD+rM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kK+lur5BMhz+8OjRknu6EtTBqUfw0OJHYcTuddJP81qYkbrTFgmckUZwAjNpDH/fsOvtIgarkPN9NcTrhOi2XlhACPVB5kEjzSw/OMz5jcH0b0ihul7sM3DxXtJRdLSajZJXfH5CpeQeHxxNY/NK9ORveVG3A7AE4p3wx+d5mNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fD9Lkv6m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fD9Lkv6m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eWBMg/aDFwI5fXnArlCdjNcoh/AFadl2ipzbdGcQTGI=; b=fD9Lkv6mVFUASTo/bWl8UbY+w7
	Uq2bgr8jfUNJ1obYZ+C7bS7dIKoeudnud0hxCctmWAzjbIqNh+ek4TDvJ3ZUE4hafc39vE7wBw2cP
	6ROvYTcpLUyy1UNE6Cl3kUDqshkxQ/inCY/Cs0FMjtxjsqwP9a2100MvMMQCxtVQTThewt2Gj+if4
	CnI9JQu55KZNIO1M+TMfUaxn76YliQr60B3uf2JFxIHBEbLNpgaYD633YRUIJMRgIRHw8bGpebVqB
	FmuS7f0KQxxipXKuh69G4Mcjb/G0PXsi8319VmdvkSqVxsBw2wnvpMV27lomB1wO2IisHgwdkEY3H
	fvgVI6BQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAjtR-0000000C7u0-3ZCT;
	Mon, 20 Oct 2025 07:01:21 +0000
Date: Mon, 20 Oct 2025 00:01:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] common/filter: fix _filter_file_attributes to handle
 xfs file flags
Message-ID: <aPXeQW0ISn6_aCoP@infradead.org>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054618007.2391029.16547003793604851342.stgit@frogsfrogsfrogs>
 <aPHE0N8JX4H8eEo6@infradead.org>
 <20251017162218.GD6178@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017162218.GD6178@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 17, 2025 at 09:22:18AM -0700, Darrick J. Wong wrote:
> > What XFS flags end up in lsattr?
> 
> Assuming you're asking which XFS flags are reported by ext4 lsattr...
> 
> append, noatime, nodump, immutable, projinherit, fsdax
> 
> Unless you meant src/file_attr.c?  In which case theyr'e

I'm actually not sure.  I was just surprised about the flags showing
up.

> 
> > Is this coordinated with the official
> > registry in ext4?
> 
> Only informally by Ted and I talking on Thursdays.
> 
> The problem here is that _filter_file_attributes ... probably ought to
> say which domain (ext4 lsattr or xfs_io lsattr) it's actually filtering.

Oooh.  That explains my confusion.

> Right now the only users of this helper are using it to filter
> src/file_attr.c output (aka xfs_io lsattr) so I think I should change
> the patch to document that.

Yes, please.  And we really need to figure out central authoritisied
to document the lsattr and fsxattr domain flags.

