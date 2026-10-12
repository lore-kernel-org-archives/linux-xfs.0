Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522F3377AAA;
	Mon, 12 Oct 2026 13:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811068; cv=none; b=Vr4LqllKHsyJbKb128puLPOj2mGaP3WO7uyqatpDg/4NUtXh/CCe3rN8qdxxfwPOafIMXZww3ZQ6e0PNLSROlmJ+kuzXcdqdzb59AhfmKWzzL08xD/f7jmYJ5p3pj+AChUXKT5YO7/j0GSLdlL5ufoo/EU1A0VkmCQqr/BoClJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811068; c=relaxed/simple;
	bh=hWhXXyK8zO8rk2qbEY7AZqaVO4v8ruwpPLj9wYnqRNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y02eWKewq2oooPNTTGQxOoRMHG4E0pe9WGS9x1OH7gsSFAmWPxD5o4fEZReMJlvC303mT/jIxjlvUYg2yMLZafVYUGJq1KtJ0mF+NjabNmhA95rB1qsjKdbA4Z2TG9pLbC7o9NI1nItqzeDBMzLllE653bZQEWNmslqdN5i9lF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fn5z7/Hl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fn5z7/Hl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5n0E5RKhQJvZ+RAqonSRCHpL9yj12f5Gvck4pAx/dBE=; b=fn5z7/Hl8xGycoiNXo+GVv5Lh3
	eSu7YdwxjQEiD7jGV1A82FnD6bl7dlTVapsCXKxvouqSt0cLiRwxmkVMUIXWq3UzPXrpCCs2lmIk0
	IIiR6TMReYy0Ths3bWrdrUlViWQkJ24j20s789OVxglKjMR4CamKwJV5vbKNlJESkJVET43r1vBLY
	VXFaCZYeFpc2GmPMNensv7ywKU3XRxxcASkQ3vYDBFStAPzow1wiJOb367OJhT0cpWY7d0cKqZcqw
	4UVuRpqY4yv7JFOkkmPl3SFhsbfOaCvaOEAS5FzBwnCtO8U01YuofIEuQAQ3zFkpf2fkbdAlISK0F
	Wc7pC7ig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFuU-0000000AXrs-3r2R;
	Mon, 12 Oct 2026 13:17:46 +0000
Date: Mon, 12 Oct 2026 06:17:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: update quota flags on secondary supers when
 metadir enabled
Message-ID: <aszd-kWFK1cCJ2oR@infradead.org>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178065902.1058822.9213708539877630364.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065902.1058822.9213708539877630364.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 11, 2026 at 11:00:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs/085 exposes an interesting bug when metadir is enabled, quotas are
> enabled via mount option, and the primary superblock crc fails
> validation:

The code looks ok, but I think the Sashiko complaints about non-metadir
fses at least are valid.  Handling the errors seems fine, but maybe the
comments shouldn't mislead it that the update is purely opportunistic?

