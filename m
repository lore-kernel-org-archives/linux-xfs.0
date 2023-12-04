Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UAHISOJH"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D2F92
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 20:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KfsuonrU0eTHQE4wD2j94Fdk7dtO7PaNYmCvG2oJEsk=; b=UAHISOJHha+1SPfZJc5wOyyOWj
	DExXrbbHIluLcLiXzGcOm0Mlwda0V7xohDSs8WbGUOcl4PxrApYB4lBVwjpxYUFmC2mABVfqVZx1g
	y+CQPNl4aBF1du1+p4vcawGuMgc6FrDps1rp9/VbYw/YGRnO/7F3gpcwJGdlV7jRAuxSFe5blm7/h
	27G+Ediq+YzbWkz8LLmm6o2LY7sMfk/5GhxtIReJU5ZF8twnsf5es+kTL57mnKok1CXSwIMvoCxoy
	dUe8eW8e2uJWwzJgLH7QIzSkMkoJBIiBjoM4Suj5O5w7Xdcu5GWIshe8O6KT8UMtroaFbIw0dQK50
	GvM6BCBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rA0lZ-002ztq-3D;
	Mon, 04 Dec 2023 04:41:10 +0000
Date: Sun, 3 Dec 2023 20:41:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: abort directory parent scrub scans if we
 encounter a zapped directory
Message-ID: <ZW1YZanmEFilB5cv@infradead.org>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927520.2771142.16263878151202910889.stgit@frogsfrogsfrogs>
 <ZWgT5u9GwGC+R7Rm@infradead.org>
 <20231130213709.GP361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130213709.GP361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 30, 2023 at 01:37:09PM -0800, Darrick J. Wong wrote:
> Hmm.  A single "zapped" bit would be a good way to signal to
> xchk_dir_looks_zapped and xchk_bmap_want_check_rmaps that a file is
> probably broken.  Clearing that bit would be harder though -- userspace
> would have to call back into the kernel after checking all the metadata.

Doesn't sound too horrible to have a special scrub call just for that.

> A simpler way might be to persist the entire per-inode sick state (both
> forks and the contents within, for three bits).  That would be more to
> track, but each scrubber could clear its corresponding sick-state bit.
> A bit further on in this series is a big patchset to set the sick state
> every time the hot paths encounter an EFSCORRUPTED.

That does sound even better.

> IO operations could check the sick state bit and fail out to userspace,
> which would solve the problem of keeping programs away from a partially
> fixed file.
> 
> The ondisk state tracking like an entire project on its own.  Thoughts?

Incore for now sounds fine to me.

