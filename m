Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30112E7F3A;
	Tue, 10 Mar 2026 14:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773154763; cv=none; b=iSFz8xr9eVaCbtrQSZENWj9Y7tFgrWZH35e61s4HpXwPTZxNBXgdjdoBxkKpDZmUbWIIAmOlZ2y4An9nplPqIbJgnqB/rg2n42IQ7mxIvojl2tdCjD04Vx3/lJN/mo11+Bwisgh+NUZvkKpME3ypCEZLtvH24y8LC9GgHhXu57c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773154763; c=relaxed/simple;
	bh=X6NG3IpgwJ5O5UAl+yBvYmWqOasAuXGOjONkg6PGTXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+FU6jCcx1KprB/JegEcuUVZn+1im5638mKhW0UAPSb9fzFRUyiOh2jbUscFXjCuMbKpAPC2enNhETvZwfs62qey3UbygRc7bbbshdDfrYo9o5dzeljGz2nRpe9RmyikSfktMjaIzqoSjsUgFo2aQ1ym6Y32aQYwl2iF86EBCIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qGQUMAFt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qGQUMAFt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6BQoDt+m6u6N20P2MpYTm3D824xlK0sDz1yEkLcwtNc=; b=qGQUMAFt2BibDKC6H/8hsbqiyv
	0IEr7PFwPi1aKHiZ94mhsuI/kTGlpCuAfa2eqqfgSoejR/nrc5NOwTzdvwD9DfVGKrXaCljfqxFl1
	hTsrvbjSsD9Jg/m36JpPB7iDUnThvQIjYE3f5zlsPnrIKqiGC5HvkMelPPbRh3NAJU3z8fM+zXfwE
	PtCIT5TNq/sTawCZZRPIlbrHsQ9M9tSfgLJTWaJtBscMkf/2lyg2XOgoLQ5zKeUg2aJcg0qtG2gJk
	INg9x4gQfHkqIev7TsHAquzfpMbG7TJuN983TgsJEJKvqJcyqIY3+s3NXmKL0RLvyYanYcwRGd4eU
	4q3SNUjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzyYL-00000009kGL-1h7F;
	Tue, 10 Mar 2026 14:59:21 +0000
Date: Tue, 10 Mar 2026 07:59:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 8/8] xfs: report cow mappings with dirty pagecache for
 iomap zero range
Message-ID: <abAxyZur6jWeC_yv@infradead.org>
References: <20260309134506.167663-1-bfoster@redhat.com>
 <20260309134506.167663-9-bfoster@redhat.com>
 <20260309175602.GR6033@frogsfrogsfrogs>
 <aa-_IM8JBdqnMKRw@infradead.org>
 <20260310145215.GN1105363@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310145215.GN1105363@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 10, 2026 at 07:52:15AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 09, 2026 at 11:50:08PM -0700, Christoph Hellwig wrote:
> > On Mon, Mar 09, 2026 at 10:56:02AM -0700, Darrick J. Wong wrote:
> > > Hrmm.  I wonder if IOMAP_REPORT should grow this new "expose dirty
> > > unwritten cow fork mappings over a data fork hole" behavior too?  I
> > > guess the only user of IOMAP_REPORT that might care is swapfile
> > > activation, but that fsyncs the whole file to disk before starting the
> > > iteration so I think it won't matter?
> > 
> > swapfile really should not be using IOMAP_REPORT, as IOMAP_REPORT
> > implies just reporting what is there, while swapfile actually uses
> > this as an I/O mapping..
> 
> Swapfiles are really a read-write lease on the entire file's layout,
> right?  Maybe we ought to just have an IOMAP_LAYOUT opflag for it and
> pnfs?

I thought about that.  It's basically like a pnfs layout, except that
it can't ever be recalled.

