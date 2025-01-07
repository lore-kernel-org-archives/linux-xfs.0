Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D5518DF62
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 08:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736239042; cv=none; b=rDdXHu7jHM8IEsQ22hFGwzW3gEPjnrG1vKMk49++CzrqvM77NT27TaNUL8k7/uOiR1rrCiK+XZY+AcbxBthFuiN5zM3D0oy61DDJM4QClXCawfm520bX5+iijV+8WjELDLIWYTZLWrIkTrEex/pzBxMx/XzSSuuMPjuTpgGPqlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736239042; c=relaxed/simple;
	bh=CIo5CpJxi2GL4MoLbIboUJmkYVtodJfDR3FcoQ8BxNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBwsrqmZHi7Pp2hS1M31xCXTkV8j0HiMDlMEwfQaNVjcYgo8ixEeEkU7AwuDk/q6TGcdZBkAlVRI3gGUc+ieP/n5ffkwxvaQV1SSM1hjs0BxnoxrBwkG3nLDJ2YM5gLPlq76i7Oyj4Eu09Wkmidw9QcEW1s7Xr/2SEjxfL3JihM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KxK444t0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KxK444t0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C+4KFCcz341eEghdLldp/GSgpSCATcY5wmyemWy7uHU=; b=KxK444t0hO5U2CYIRbc4gQgWs3
	vcFFD2MGoGtfVxe3jgNN/78qaD2KBoYMizBE/S6M6H6JaLdHFvsp1TQH+ail6ixOSSszEfpmCbg/g
	piXx5FbButhmkQouYeb4NT2hS1fVyTl7P8/eDF5ELQO25Hp5WEyTsTxOartjAFpkiCNVLrMkHG3Ez
	scjFSiRQhUHJUyoxyk93TdoXcgzrGB58LDwA2F22i4/u3XwI1m13HWv94s/8x5zoZuzqAb8Q1HJ7Z
	hoZWcrdJzwearPA3MFJ1xscWLyfBOzM4VAB+S8fqP/p0kOYZqH4V9E0WpHyKHvVS11ZqclKbMbeNy
	zzN8EVQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tV55U-00000003xLC-43Ep;
	Tue, 07 Jan 2025 08:37:20 +0000
Date: Tue, 7 Jan 2025 00:37:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Sai Chaitanya Mitta <mittachaitu@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: Re: Approach to quickly zeroing large XFS file (or) tool to mark XFS
 file extents as written
Message-ID: <Z3znwD53VIBdrlbL@infradead.org>
References: <CAN=PFfLfRFE9g_9UveWmAuc5_Pp_ihmc7x_po0e6=sTt2dynBQ@mail.gmail.com>
 <20241223215317.GR6174@frogsfrogsfrogs>
 <CAN=PFfKDd=Y=14re01hY970JJNG7QCKUb6NOiZisQ0WWNmhcsw@mail.gmail.com>
 <20250106194639.GH6174@frogsfrogsfrogs>
 <Z3zGS9Ha13I8VBtI@infradead.org>
 <20250107070459.GI6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107070459.GI6174@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 06, 2025 at 11:04:59PM -0800, Darrick J. Wong wrote:
> I get this funny feeling that a lot of programs might like to lease
> space and get told by the kernel when someone wants/took it back.
> Swapfiles and lilo ftw.

Well, for swapfiles we can't really take them back.  Similarly the lilo
model is just broken as any chance of the mapping would actually require
re-installing the boot load in the boot block pointing to the blocks.

