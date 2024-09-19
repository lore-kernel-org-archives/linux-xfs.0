Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF3E19FA91
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 14:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726754447; cv=none; b=mYbSTfMALbqR4JGj9I+GR0umwO0ngJBhYHBVFWK4Okt6b9M8EhB/0CF1rHPNros5aIJK9NBB7N2G3KgP9KIhPy4gOd73e3u1iglJwy755zJa74qpeac7gINH7jUmjh4ezr8c08dMBc0KaIktvRTJG3S60zC90fbbZuCaMu6wnyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726754447; c=relaxed/simple;
	bh=+dvbsa49f15SPP+YeKDL3QctnUYV4ofzGy1aGbw/jSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5FCiI9zUeM/loVlc/aSlafuMgAAO3YA6Yg4bsuV+6r2/nu2QMnA1PRUtfpzSKwQ9OjIXpZtblbQIc0384eDaV4XZrPYiu+1NDRiO+htXQUCJt0Tlu7VRWBDXzebvApgwFC+iOxRCb/KAfSTAbOW158Mslg1wRYLdToAwV3WT44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pEknH0HY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pEknH0HY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=the1Z2x74Nhqt9q2JVi/FvqWQgpjtbR3Y4a87TspLJs=; b=pEknH0HYJX4hyb25zC8JpcKxYj
	4orTQ4cCa313TC8GtnNEwPCIHXznWndYh+Mi4nWxBVGaQ3A8KX5mpop5tNki2mhcMiXk+GoqK0DZG
	w1EI2LqFVEyJpjxNiqvyebiA53APdNcYKd0qLj0bq5SE0i50b0xngGl8GYmfl9IY+WD7z8kqF8uBu
	+fhzW0JkuU+WmvLcHyBBJcEPuoPTying5U5jmWx/01PTR+271CYXSlFgRK7Ew6gClFnrkaFbM3RGA
	skCqWG60UJtAHDEUp1CLbiQKQV5/Pk1J2Nw03MdwGC8IxJ4j3/1RtLMfgNc3Lpu9zJyk1BMwdA6VR
	zyug5Lig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1srHi3-0000000AOja-0OiF;
	Thu, 19 Sep 2024 14:00:39 +0000
Date: Thu, 19 Sep 2024 07:00:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libfrog: emulate deprecated attrlist functionality in
 libattr
Message-ID: <ZuwuhwTDwvUyqXj1@infradead.org>
References: <20240918210010.GP182194@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240918210010.GP182194@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright (c) 2024 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <djwong@kernel.org>
> + */
> +#ifndef __LIBFROG_FAKELIBATTR_H__
> +#define __LIBFROG_FAKELIBATTR_H__
> +
> +struct attrlist_cursor;

Maybe this file could use a common that it emulates libattr APIs /
helpers?

> +	struct xfs_attrlist_cursor	cur = { };
>  	char				attrbuf[XFS_XATTR_LIST_MAX];
>  	char				keybuf[XATTR_NAME_MAX + 1];
> -	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
> -	struct attrlist_ent		*ent;
> +	struct xfs_attrlist		*attrlist = (struct xfs_attrlist *)attrbuf;

Overly long line.  And as mentioned in reply to Carlos version of this
we're probably better of just dynamically allocating the buffer here and
do away with the casting.

The rest looks good to me.
