Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD691D68F;
	Thu, 18 Apr 2024 06:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713423460; cv=none; b=ptyCbJ47DCBINcD2gwZc8IlAV62a5WegdUhvDVlByCBP3faW8aU490PGvCraL6Bu4XOkOHePDyfmPWwSS5WQuTOnqtNn8vI2v7IszDKyJgigbJpgXGwNx2U4E08T4P60PBOVRLw0iCzW3EiOOUajdhZ/00WYRjb2KM1Hlt4o8HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713423460; c=relaxed/simple;
	bh=hdMRk1LSH/lnEkyfJAy19Lc0gZf3hJSMMD4sQObLMV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQsXgyWUVPk+UKY29MkNfnbIw3rVvSBq9UJkuAHEU+nqkNRVB+yP6NsGbd8vezzXYRNF2x07/01zjUn+YMXbWOC66qMfwmvzvCRUWf3rJbqORarLZvVDU4zIKQQD/RDgrM0aOKT5yK67PQdqm9NGr/78Y6Rw2F1Keq467HSEO0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fhg3fK0M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fhg3fK0M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=p/wnFP4mdXA5Mm/wJGf3pRXfWmVzoZ2R9xyuxxlwO3Q=; b=fhg3fK0MsHRh2wnDOWN84YdHFo
	6KCBe8bCNjkROH4/ybblEjrHL0Uf3pZhxMhCpr3BS+sn5ZY3Cw6eTd6DutubyO9DhUsc7Ns2UvYQG
	FnsLdYETr1IHHwis7sjuTF/QKVAvs4SvaQGTaGE4VaFxxofVA/BwgPB+eMSr5IBzDLj0VtRDGF/Vx
	WG71/gBcJLCgNm+81iMH4FM0AeoxZi7KaeXu3rj6MoQZtvtul2Po93890x4gkJ3/bpYpup3e4zJkE
	yALUMoU/TW7XTP50lVZ3yzXwg8Jw7yNywfUCt5RZ3MInKJqdz4TEiobgzc9g5UzgkaAeoWXpCcbs5
	+TUuLfUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxLiE-00000001CEE-0bAs;
	Thu, 18 Apr 2024 06:57:38 +0000
Date: Wed, 17 Apr 2024 23:57:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, fstests@vger.kernel.org,
	kdevops@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, david@redhat.com,
	linmiaohe@huawei.com, muchun.song@linux.dev, osalvador@suse.de,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] fstests: add fsstress + compaction test
Message-ID: <ZiDEYrY479OdZBq2@infradead.org>
References: <20240418001356.95857-1-mcgrof@kernel.org>
 <ZiB5x-EKrmb1ZPuf@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZiB5x-EKrmb1ZPuf@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Apr 18, 2024 at 02:39:19AM +0100, Matthew Wilcox wrote:
> > Running compaction while we run fsstress can crash older kernels as per
> > korg#218227 [0], the fix for that [0] has been posted [1] but that patch
> > is not yet on v6.9-rc4 and the patch requires changes for v6.9.
> 
> It doesn't require changes, it just has prerequisites:
> 
> https://lore.kernel.org/all/ZgHhcojXc9QjynUI@casper.infradead.org/

How can we expedite getting this fix in?

