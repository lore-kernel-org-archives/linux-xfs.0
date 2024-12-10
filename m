Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5814A79FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 04:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806536; cv=none; b=QUfYDUrnMmy4jqHm9VZg3/vjdLiKoucD4fGbkXUl+CiAXRql8IHxwpvmesRj7RqdwAvWztg1YTE/OLgqJ+/avb74sQHnl2bbLjfl1GIsoRqyOKaml/aLf+kqtQYXARcAjRILRYZVsspt7PTnfsRl3wdsnUVg0DGy3BYG+SDylYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806536; c=relaxed/simple;
	bh=C/SUEuO6p+F1CjNPGRjrR8/xoCkmGtKFCgJlaemjJTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GduSkKt+OzFuhoMy9mdbvOx4vL35KJooHu2n7bZFRkk+D7sd5KeXBPhxA312xTh1cjF8wexxSW+lbk4RtNHU2MEG86qfHLaAmbEvIVUPvkbDY0gdx9xJYcqlCo00kaharnHitVAKJLkoGUun9wKGGwf8FzejkJ7jSYUu4VwpMQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c6LU6ULg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c6LU6ULg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i5ime3PGOGO3muhEg2IUG0RwsQaIv8eo7/+kxkq5sqQ=; b=c6LU6ULgLMnnBWpLzFactNSls5
	kHVYPDq7PN6Ie1tXrwQTCRUXPiDZeIt8Cb7J2IdksffEegZPBakpPN5UJRhHPRSL6lL6d/dcl63Wd
	MKnUZZgkw0TnxIrr3QABfv1qt+TD4crhOrfTKAciVoEfhRoUcbXu+2l3IY5g8Kt+gcmEfNhj9nmAG
	08MUbPTVjdSHX/0+DanXvGK5AYKq/h8hyhKNB5fZb2KBZtiwI160c/O8fgnbsroUiKG8DJ5VO4Qgt
	kV/lHxoe4sX5ITRBnKabQxLOrgRX7lxlkY4LvAAUMejXLcUO8+G/eBXDHvGUW8z6sLbe2qvDaxvqC
	+KW15uMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsHX-0000000AEeE-043Y;
	Tue, 10 Dec 2024 04:55:35 +0000
Date: Mon, 9 Dec 2024 20:55:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/41] xfs_db: disable xfs_check when metadir is enabled
Message-ID: <Z1fJxuvjsExuYbye@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748376.122992.14095194470830359878.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748376.122992.14095194470830359878.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 03:41:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As of July 2024, xfs_repair can detect more types of corruptions than
> xfs_check does.  I don't think it makes sense to maintain the xfs_check
> code anymore, so let's just turn it off for any filesystem that has
> metadata directory trees.

Puh, long overdue.  Would be great to also have a deprecation schedule
for it in general..

Reviewed-by: Christoph Hellwig <hch@lst.de>

> +
>  	check_rootdir();
>  	/*
>  	 * Check that there are no blocks either
> 
> 
---end quoted text---
