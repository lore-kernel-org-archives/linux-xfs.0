Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B2B1DA60D;
	Thu, 16 Apr 2026 05:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776316426; cv=none; b=ePpSA/09RK2cbw1GVH0OU2UPRqC1mVmp05e/42fGGagGnM5r6tVa2CSQrbhaDEXZOiiI2OfKf4iV3A0EmyYy5Hrc+REixmUtVbBfxb1e9jtJruIxHSO3qDD69E91SrhUQ0F6/p3cXGcj+NCnTzfDJ56wkdD/jN6iWpTECstPM2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776316426; c=relaxed/simple;
	bh=weAGeBlyKHUCb4md0QeCaUzTIAbRt5+M52A+4lO6gmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cE52qxxCmt+TFSainRWeIqkcAdvjEsUb2CF+q4VRbaDsuYBvzNX2Fx1HEKVatVC4PcKbfAuLH8890g+3N8uKWDwSL8QrKMWfd9BFj6MpfrAtwTuD6Dg8xP9SKoHS6tku5Q7SkgFPA1v3npyRBE4zZ1R18V5903sTQPvcAb3dTX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dtsnmjDx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dtsnmjDx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=weAGeBlyKHUCb4md0QeCaUzTIAbRt5+M52A+4lO6gmQ=; b=dtsnmjDxVBT5h45xekmWOAO3I7
	v4DAaXT75EUfrZw9OHiesHEm0rDEdc+c6PFsnpVVNzpI+/1kajf/6xJ193DwW303wZA9hmazFrFlS
	GPEW7mkd4+UcTTllSO83Xy4QZyivN9064YGCtESsUpdtadxXaU77pOy/nF1y/6edjXdTAzRA2m7FE
	WiTJ44C3aadDKNbPluFJeH4m9RDnF5zW2MaZW89FQzfUMqpgN6tW5CW+FXuJ8M0kOmVuf3IeEfljG
	QvBpw3omEcZYOyJi2YjczYBjuEHOu+jxndO83r6j6Zxo/c99jlSvuzcv4l+5fGYiSlO7j2rOEPPFR
	Q9AGniRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDF2l-00000001yeH-2UAL;
	Thu, 16 Apr 2026 05:13:35 +0000
Date: Wed, 15 Apr 2026 22:13:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ravi Singh <ravising@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dchinner@redhat.com, esandeen@redhat.com, cem@kernel.org
Subject: Re: [PATCH] xfs: flush delalloc blocks on ENOSPC when creating
 symlinks
Message-ID: <aeBv_xvDTmuzEhV1@infradead.org>
References: <20260415071657.23412-1-ravising@redhat.com>
 <ad88TluB4FIP3yJV@infradead.org>
 <CAF-d4OvKZOsez5589KUYTjRz05PQHCQ-uRkXu-3iaO3tOjcavA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF-d4OvKZOsez5589KUYTjRz05PQHCQ-uRkXu-3iaO3tOjcavA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 15, 2026 at 06:54:00PM +0530, Ravi Singh wrote:
> > While we're at it - do we also want it for tempfiles and scrub?
> > i.e., should we move this logic into xfs_trans_alloc_icreate,
> > similar to the quota logic?
> >
> tmpfiles and scrub tempfiles are created without
> directory entries, so they don't need a new directory block
> allocation and don't hit this ENOSPC path.


But we still ned the ialloc space reservation for all these cases.

> As for moving the logic into xfs_trans_alloc_icreate(),
> xfs_flush_inodes() is a heavier operation (sync_inodes_sb).
> Pushing it down into xfs_trans_alloc_icreate() would make every
> caller pay for that flush, including paths that don't need it.

Only if we git enospc and need to restart the underlying
xfs_trans_alloc call, similar to how it handles quotas.

