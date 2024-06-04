Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB17A136986;
	Tue,  4 Jun 2024 05:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717477752; cv=none; b=GRo1CcMMVGqwOq6QC4k1W7pmOUBtUXnt7QWC3x8PMlxaxKqhF+M/pEsFy+lnktp4FdP8c7MEaetmC0LbnBjYv45jcQeFkglyOX7u3egJgItvg0js/YBlwrAtL7HPrFaHsw2EvUD1++QM9sExh4PIsGW7J3vWtlgAbfy1OV8eV1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717477752; c=relaxed/simple;
	bh=TjIBME276weQmygj2RR68afhsFt7ayiQDjbfvJDN+sw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O+1i2RLa8DFWgj7SqfRMIFahSxI/mj2zaddw6BQkgfKNnXhS4yiGtP3Xa9ofuWgWgQdDvrOL8z0pMr0Nd2ezEL/k6lw1wkfR9o5T9u6GkFjZJlsdcMcXJmhHzT6gIJxh06j/EWJXDEnHv1M2MFnGjkrNWYVAHSJcGpaBAHJruTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3MZ2sFfJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3MZ2sFfJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=y1lZtO0jq0bp0JgHqrx2QCl572I9AnYtUdJNzGUaxRE=; b=3MZ2sFfJO+YAxJPmtHwk0lYz9R
	uFKxhgP0/LFxAn3F0Bs0c8zv1b5RfZjVmeVJ7kLoN9HQx1LQwZ95QCmLYHW4yTyQKzQfIUv1eH/fq
	3ZGk64VdO5e1nUaaVuyiDOPA8LPpNJjyPblqWH647M/kdf73QuCnkzDIiRxqEVgjK/avEb01e86Qw
	bYjjhzjYMg9pQyP4gxSLZEHvA+yIAbU8H6nlxm68LPvUSXLFKthq6D8dO9K45OtDI/u/aa0iyi+Ds
	5HT0scFI65FCoEGkMM6pOQECFXFQ7NgZgSJlRvaWL8ezNS6IhGm8yOphM0kiEW/qUKJQXqK8ENOhK
	f/Dhjx9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEMQ2-00000001Dy3-1vdL;
	Tue, 04 Jun 2024 05:09:10 +0000
Date: Mon, 3 Jun 2024 22:09:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	guan@eryu.me
Subject: Re: [PATCHSET 3/3] xfsprogs: scale shards on ssds
Message-ID: <Zl6hdo1ZXQwg2aM0@infradead.org>
References: <171744525781.1532193.10780995744079593607.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171744525781.1532193.10780995744079593607.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 03, 2024 at 01:12:05PM -0700, Darrick J. Wong wrote:
> This patchset adds a different computation for AG count and log size
> that is based entirely on a desired level of concurrency.  If we detect
> storage that is non-rotational (or the sysadmin provides a CLI option),
> then we will try to match the AG count to the CPU count to minimize AGF
> contention and make the log large enough to minimize grant head
> contention.

Do you have any performance numbers for this?

Because SSDs still have a limited number of write streams, and doing
more parallel writes just increases the work that the 'blender' has
to do for them.  Typical number of internal write streams for not
crazy expensive SSDs would be at most 8.

