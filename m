Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED5C2FD7CA
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 07:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764660527; cv=none; b=hFGC0gYOnp74ggEPmJsW9evrgjIZhT3j6HUHAYmc78zjXvEdo1zxr4ENcwFk4PMnRpVLqzKlY4fTetf5Y3O6dOzOPlokygAmK9nbTtqxkjix5XQ8qQIVaVHBie/GOHYYykffuuYsElPXUjeCl0O4LzWmopPUT/bylLc67EtE1R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764660527; c=relaxed/simple;
	bh=phiEbZ4lLyFcSpGXfL3g5mfrN7bTqvBvGHNBDgt5bV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=keSNeY/4CQryk/OxsKbVzRZLQUZwuY3WudQEFsKBhFaJf/IohQheiBYFuq1EH8H8xUzDcA8No6+hTfGSE0bBdx0eEmIcBq5RwZLUGHRODm/AnP1Hk4Y0OK7uHyd80viQ6miN+J7DfUFCWzZPVk9zKYbo2hCNZ+QVzbwBz7Efuwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3C62768AA6; Tue,  2 Dec 2025 08:28:42 +0100 (CET)
Date: Tue, 2 Dec 2025 08:28:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/25] logprint: move xfs_inode_item_format_convert up
Message-ID: <20251202072841.GB18046@lst.de>
References: <20251128063007.1495036-1-hch@lst.de> <20251128063007.1495036-12-hch@lst.de> <xn4vun7i6b4af5erbnao3bbskoogicgf22tc27fqprpio7b47c@6y3eewehvcyx>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xn4vun7i6b4af5erbnao3bbskoogicgf22tc27fqprpio7b47c@6y3eewehvcyx>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 01, 2025 at 07:32:18PM +0100, Andrey Albershteyn wrote:
> > +struct xfs_inode_log_format *
> > +xfs_inode_item_format_convert(
> > +	char			*src_buf,
> > +	uint			len,
> > +	struct xfs_inode_log_format *in_f)
> 
> one more tab here will also align with in_f32 declaration

That means we'll need to reindent the whole function.   But yes, given
the long type names it might make sense here.

> > +	struct xfs_log_dinode	dino;
> > +	struct xlog_op_header	*op_head;
> > +	struct xfs_inode_log_format dst_lbuf;
> > +	struct xfs_inode_log_format src_lbuf;
> > +	struct xfs_inode_log_format *f;
> 
> Maybe make it one column with arguments then? (seems like one more
> tab will align everything)

Sure, same as above.

