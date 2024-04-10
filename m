Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A3E19BA6
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712728281; cv=none; b=n60h9XbMCHKHvvL9IVeGCtA4vT3VHzwbkjToTw3FLBXQFOrfBxhu+YDsRMb43eJWEe+F7tyKROUamRgZA8TssELEg0+U3FN1QFMWK+lHOjatUp1EunZDaDhbBaUnrn7gLP1ERlNEjQNIFA8fjIi42/sCdWwrybEmHoE2JNw6yqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712728281; c=relaxed/simple;
	bh=GLPMJbZd4JGpeBzlQKIB8n+MYabICtakLzowXxqmmlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QbwgzKAYR7lBq4a25A9PvceP+22RumCBjisHbyiCpcKRlzxcEhnj3zJAi1oAANDGcj8M3q1g3askm1lDcHHaMGH/DBkM/OupyvffMSMcalrr4z/6om8Du9hy7A2+5+ZNfDcS//jSW7wxYzT8FqEEZObWyvpxJBJorm7u4bnC6Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C9HFqqv2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C9HFqqv2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Vs3RlfwFVYVhIZUo9OhaC/MzqpEiKkPY2p+p981carE=; b=C9HFqqv2aT19DmE6KAWDR5CTPF
	If65BgtBHo0e1KF4Nw+TclnFtbntxiz7dBbq73MuBRiOjWsKgPPj041b4gAf+BTkH4M80thdOMfN6
	GTC0p3lg3/S/LYPgYjg19hyWoMbeanzN4n5iguNkEjNzIERTAdAVDIXL0xny54cdnKItQbY/8Mx5f
	kyG611XaV/O6LkbGBfAdOPWWdthJNgYUNtI2jxiFhq5zfPnld0YCDB/C+eBDOWpbPfIiv8e2n2zvW
	rb9dxF9WQuF4Rz65Ku2c7aYHz61bG+qvyeuKBbifDwy1cHVF5lBzgIfVpgIESHjVr6jHhVTHsRr2y
	MHAOq7RQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQre-00000005GLX-436U;
	Wed, 10 Apr 2024 05:51:18 +0000
Date: Tue, 9 Apr 2024 22:51:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/32] xfs: Filter XFS_ATTR_PARENT for getfattr
Message-ID: <ZhYo1hcMYpYQ4gcv@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969941.3631889.11060276222007768999.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969941.3631889.11060276222007768999.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 05:59:30PM -0700, Darrick J. Wong wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Parent pointers returned to the get_fattr tool cause errors since
> the tool cannot parse parent pointers.  Fix this by filtering parent
> parent pointers from xfs_xattr_put_listent.

With the new format returning the attrs should not cause parsing errors.
OTOH we now have duplicate names, which means a get operation based on
the name can't actually work in that case.

I'd also argue that parent pointers are internal enough that they
should not be exposed through the normal xattr interfaces.

> +/*
> + * This file defines functions to work with externally visible extended
> + * attributes, such as those in user, system, or security namespaces.  They
> + * should not be used for internally used attributes.  Consider xfs_attr.c.
> + */

As long as xfs_attr_change and xfs_attr_grab_log_assist are xfs_xattr.c
that is not actually true.  However I think they should be moved to
xfs_attr.c (and in case of xfs_attr_change merged into xfs_attr_set)
to make this comment true.

However I'd make it part of the top of file comment above the include
statements.  And please add it in a separate commit as it has nothing
to do with the other changes here.

