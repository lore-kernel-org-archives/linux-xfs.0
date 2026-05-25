Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ED64C6C;
	Mon, 25 May 2026 05:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779687969; cv=none; b=QscpQK1fXdsAW7htUQyzu42YJpb8EMJk3hNIsoYw1PtCWtn64L6XBNaOif2+8dKyLRMV3pk7SOiukD68S8/dKP8ZfKdlOHh4aWK4hC0G86DI60eQbT3XWyprWEy7YJkCrxM+rAYQT3yYnD5U8gMz8ERWHocgZb9VpvinOwhAvTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779687969; c=relaxed/simple;
	bh=/GBEXiJOQ9iVyh3wxD8nfcKej4CigHNC+aqUWVebcZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uNt2cBzmpPTWu2B0qpbZ5e49bihAir3gZDF8N7WaFZ5uWCoRyEBvWQUyPkXm6SCI0H5Qfoe2xkkn8Szqz4zMeSPAHxOdl8UNbcS8QnAqwngi3BqeM2UouJBHYelhxXIrkH7Rff/hB7c9FmDOMYtyFX0n43YtIGkdtO7xajbJDJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EIzoPeyB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EIzoPeyB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3NagG/NgweZdgeta53PE7ol2Vpe8KLdnMkAzX0cduo0=; b=EIzoPeyBcWMy5fkRY1dFho4/LT
	xYytPyVxv7QzDixyD/pxmfjGoVfcpQrhV/S606o7Dz+K8EKmEIhHLe3TeUaNeaqBu5ynKQ07gWLhj
	LXD14kIC0qd9yvBuwEYoksw8X6bKghXCgfe98Je+R8A0HEsfPSnkMfqezlwEr02Jv9wfM7ngRWLOz
	VyoiTpcicOBJrL3CDmcG3HIOBNbohN69p/dNaTwCAzC4POJZ58UlXd0CGTqUsc5iTuDnNVuEk3Eca
	8jUjZhl7aKh3UdO4ysp4mKdiJKgLQEm6Wcumd4gNbJGGKmS0Hq6D0izxvpo9AaG89hN3cn/2JhoP3
	w3ecsIag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRO8e-0000000GM4y-1gKV;
	Mon, 25 May 2026 05:46:08 +0000
Date: Sun, 24 May 2026 22:46:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs/21[67]: fix mkfs log concurrency detection
Message-ID: <ahPiIAJNwjiZ9PTR@infradead.org>
References: <20260520185202.GD9544@frogsfrogsfrogs>
 <20260520190112.GE9544@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520190112.GE9544@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, May 20, 2026 at 12:01:12PM -0700, Darrick J. Wong wrote:
> +_mkfs_xfs_supported()

Can you add a top of function comment explaininging this helper?

> +{
> +	local mkfs_opts=$*
> +
> +	$MKFS_XFS_PROG -f -N $MKFS_OPTIONS $mkfs_opts
> +	local mkfs_status=$?
> +
> +	# a mkfs failure may be caused by conflicts between $MKFS_OPTIONS and
> +	# $mkfs_opts, try again without $MKFS_OPTIONS
> +	if [ $mkfs_status -ne 0 -a -n "$mkfs_opts" ]; then
> +		$MKFS_XFS_PROG -f -N $mkfs_opts
> +		mkfs_status=$?
> +	fi

Do we want this for a helper like this?  The automatic dropping of
options has been a major source of mess, and if we're using a helper
that checks to see if mkfs works, returning false and then _notrun()ing
would seem like the saner option in general.

