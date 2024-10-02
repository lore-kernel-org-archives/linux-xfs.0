Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BEE8002A
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848395; cv=none; b=ClaUy9F+y30M8TIuTQ+0Ba7w4xAhb3J7W80NIqw/P0pU7VMlK6TLO3o34A0Brskuu5FwNYQdIIHWAypP2zNB/bXDqUYoQT+GlpRaf101uNqPsWKxtJI+UefZYkQzMBhONp7bgPMjONZlWGUBpIkdqI4OZGtHF5etlTzdsr31tcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848395; c=relaxed/simple;
	bh=q4QyQS+HleGi4QAOYPyywwZwsTZOYdSe+0SpurJi8as=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kv2l8IUxzT/MTCc8uUK77K2jVIB71Bl1zTGHbFIdlPEeBHgyDgRoynDWOCOwTDf3UxOyO03JkkIWOWv6HwePwn32wZmGhMtLgzIjRXNeWcag6wdG14q18L15IfkKQJ5KnT3qcsE/vTJ5YKjIOMcKOSD/lPwPKPQS0hmXkdmafu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OJ+UDwBI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OJ+UDwBI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yP/dQISVXcGH/m2QXZv5lRMvQl6ReIFQyfXKpguYvcU=; b=OJ+UDwBIXXruNh/Iu3uyx0M/l8
	ixyOdurPS/BOnuC/xjTmokcAEm60VSvN169iAsf5Jib0PPsk68zhQcSWQW6lMVfkXE1myHtnY7a9U
	PpgtCDAKULb0OxVM5j4AllZsN/ZwWsHclLpWt7Jj04fI8caIhFvgFuOuMOrfsFFI+fXkuVaTOZ2En
	a+OB0VjxMR6HQHLJ2RBZZ2jiX963+w/ZH8jw9DOpePXN0FxFTiYCHM516VdGV93V2rc5MCFXNyP3O
	ApZEhGjTPB4h81l5dyqMDafHZJORWdV/V8gbuzyDNVCz95zsiWyFyVSWxBvawZX02cgWS28AfEUDs
	UWSVShmw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsIU-00000004sLm-1J4d;
	Wed, 02 Oct 2024 05:53:14 +0000
Date: Tue, 1 Oct 2024 22:53:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_db/mkfs/xfs_repair: port to use
 XFS_ICREATE_UNLINKABLE
Message-ID: <ZvzfytE-q1WwJULo@infradead.org>
References: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
 <172783103061.4038482.13766864255481933120.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783103061.4038482.13766864255481933120.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 01, 2024 at 06:25:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Source kernel commit: b11b11e3b7a72606cfef527255a9467537bcaaa5

How is this a source kernel commit when it purely touched non-libxfs
code?

The code changes themselves look good, though:

Reviewed-by: Christoph Hellwig <hch@lst.de>
