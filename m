Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB11967C72
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 15:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706281760; cv=none; b=X0oYRo+r4bhrUSdvp+2In6qAOET1/ioSC9IFAwb0NCVPQ5Y/JB/RfZ5IMyX6JMyOhi3pwUjuzBJ2OkhChzeKEcxRNeYcUrxOo4sj5jrkkis3O3h7ryL/3c4OghDHMLvt/70a1YHHGFB+A4unwHx7N60nuslpjl9sGJlD2iz43No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706281760; c=relaxed/simple;
	bh=B5w1SbViDsHiZp/KBjw9pg+yiqI+hKWc50wMshhRDPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HLjmZOB06YmYudd5Ug6KaDrN95gFZ9G69WwSDOopv/K65TSdrx0dewp1/duimS5pIskI++GTA7OosSS0mffubMKlH2uAEohQhNcPGoNnrrkbXgvhl8104PcrTrL0Dp8DYr2bhjQp2TlQfuPYnD9dcI4UUq/ywbj4tmrEBmpSTr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VADE/Az4; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VADE/Az4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8L0jm29tcG02zXNZ+/jR0wDkovkQ7cRxzzvSVHRCJek=; b=VADE/Az43i7Ov/BojlhYvE8tGd
	18BdkqrJHnXPK032ZK8eFlKh/u3dtcRQbik+1nv0ib5y+caBlUCQRHql9BXk2CbQz+ufEr8SmGus8
	Lme6vMyme64vf8l95utyk/z93EX4ey9DdY7MYvCToHsXdbsdB2HAvy3cbXFPVeiPojXDGARQTSjrZ
	9T0+5eYp1YpCJBjuxHK0FtUe8COwFchzyusH8MCgNu4EovmFbE+gGpOdScb1AA7YdURYdMfV4Qilp
	Q4dWkF6A7PxajAx6/IxU+GZrhr9hJb68WWAKQOGhOHcj/Gw696jByxQrBov2QONlZzEz3DAv8CG4J
	ZolU5JyQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTNpR-0000000DyYG-0kFu;
	Fri, 26 Jan 2024 15:09:13 +0000
Date: Fri, 26 Jan 2024 15:09:13 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 04/21] shmem: move the shmem_mapping assert into
 shmem_get_folio_gfp
Message-ID: <ZbPLGXS7sTjnLrC4@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-5-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:46PM +0100, Christoph Hellwig wrote:
> Move the check that the inode really is a shmemfs one from
> shmem_read_folio_gfp to shmem_get_folio_gfp given that shmem_get_folio
> can also be called from outside of shmem.c.  Also turn it into a
> WARN_ON_ONCE and error return instead of BUG_ON to be less severe.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
