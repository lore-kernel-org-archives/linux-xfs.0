Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D05259C9C;
	Tue, 10 Mar 2026 06:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773125244; cv=none; b=j53ZpVRi2re3doyBuArK0ZoJx//kEdc3wHUrNuPpu1VKMrab+1tQekn3kLnz2reU6PdwnRuhLJWvHpxIahLL6jEnkiTk61XnY6rObDxBcOPuszUdOOtAyzXJUi44Q32nWEMwRdfBN2Bo29HoePTz1jn9w1TqR306CzY0/4I400o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773125244; c=relaxed/simple;
	bh=Fa58jgR/aff/qxeQpXjIHBvNy54cbzqPacj4NnlhUGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDgL8UfNJYmrAjVlgy6GF6xDaAFijTk8uOcda0R2Q+tI5ll8waLTkpQ3d+HSlfOw8OuyHYgDJWRoWHpWgxn+M8IiBFRB9ITaMPe/3sf2BroDyoHBovTNrQzEtiVQhc90t33A7skgB6ZVqd8VaBDANHuOtRvFmy/Tymupzij/1PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=olmnvXY8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="olmnvXY8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dW42+LLMbfGMyD+eBUSQjypUfJx7uNUJTtV75/I8RUI=; b=olmnvXY8lmBgUFD/tZkdTTGYnL
	4JjYmhgpR2x6XAquzTsZ8oroKytvQHQkcISflFn8nzRX7k8U1QWGAAoGCgZ4Vfm00l4qZCzVkn2eg
	RffeOWIUhp876fCaITLsq3cWbXGp5+wFc1rH8ge8tFioKfI0dqSznYLHOAPx9RPYwEuAYQ1fNaRvl
	gLAZc9tTyywnx2LS4QeD/s8s96LS3gJKwSw1eO1Lhe50WmKtvrEHsK7TqUB7EdQdMO+k6MgwxsBXn
	27Q1VuN0gDrN9vkLercWHiMhWffx9hfMYS1GbK+kwTj8SkVXOiJ/0P8S0pW4AFFgBMRVELGcgRDOe
	H855NrEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzqsF-00000008o1v-0H9x;
	Tue, 10 Mar 2026 06:47:23 +0000
Date: Mon, 9 Mar 2026 23:47:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/8] xfs: flush dirty pagecache over hole in zoned
 mode zero range
Message-ID: <aa--e9z5MZ9MOAFu@infradead.org>
References: <20260309134506.167663-1-bfoster@redhat.com>
 <20260309134506.167663-3-bfoster@redhat.com>
 <20260309172219.GM6033@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309172219.GM6033@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 09, 2026 at 10:22:19AM -0700, Darrick J. Wong wrote:
> Why does the mapping disappear out of both data and cow forks between
> writeback setup and completion?  IIRC it is because the writeback ioend
> effectively owns the unwritten mapping.  We want another writer thread
> to see the hole and reserve its own out-of-place write because the write
> mapping that writeback's working on is immutable once the disk actually
> writes it.  Right?

Mostly because we don't have good code to turn a COW fork delalloc
mapping into a data fork written one.  Unwritten extents do not actually
exist for zoned RT forks.

> I wonder if we could stash a delalloc mapping in the cow fork with zero
> indlen during writeback to signal "get a real zoned space reservation"?

What would that help with?

