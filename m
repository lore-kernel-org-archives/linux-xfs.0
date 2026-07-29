Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BC5EEB3;
	Wed, 29 Jul 2026 06:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785307945; cv=none; b=dzi6d207yvipihIepYWbe8noKeM9AX+ANuM3CnZJm5Nmi/p1AUBnTVxHH2RKDEaUusCQUCPdRVP8CI2pbjmgDYLizWmKnF86qFKLh/eEu60lvkouA7CD9bxDhp0lnEuH4RlHdfTqYXMEOQhax4zzcIN4MLWWKXgvR+5sdG57mrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785307945; c=relaxed/simple;
	bh=2AjAfBh3PVT7jRhQmwKUUUXnQMKve0RUhX/1CLv/7f0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CNiw5QDeERPaAAc88gFoMtVSTbCP0qeROhCzAfXOALUkT8T8VOSi1xgKcwk3cISMVosDLOB7Gg2JkoX+C+OdWUzg3F1ED46gS5HOAgsX1cpwTUXsVCnl9s8xOotXjWT2aj+8NlqLp+FYkkEWS+I4hM7JVL7ujk3/oIGo7d31/BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JRVS5xp5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JRVS5xp5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G8PvX1ncWHGXTxhJOn+Gnajkbtvsm1bV8NGcf0dUhfU=; b=JRVS5xp5ZfEv831jHfTpKkSXog
	7IunM/SyLt+MNlcssV7FRpO0oBSgVlxF0AG+YQmFeQKI9+8BQuRTkFXAv2d/0mypHWJo5T6cDhwOo
	fhyOdMYf5BIAJHd7GSESE3UJ0sbf+/rqJ/7sXYxswZF3XxiPimq/n9DuVS/oa68bW0AIYgoJfSrw+
	sgdvLiaSOToWphapEA2t1QsbnNU3WB9LsF4FKJhkU31ANgRg5zDQAk6FFCm1KT9VgbGBK09hMl6En
	AZtcPyEru6Cm2z70pVrpNC04ka6yAjWmERlVEYLWO1J8piIJksTgt5ynbL7kaAUEF5ZS0s/JSBnWJ
	n0zAsKqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woy9N-000000074A1-1BIp;
	Wed, 29 Jul 2026 06:52:21 +0000
Date: Tue, 28 Jul 2026 23:52:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: cem@kernel.org, djwong@kernel.org, hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhongling0719@126.com, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: check split_sectors validity before bio_split call
Message-ID: <ammjJTqoOHsW9AXJ@infradead.org>
References: <20260729063117.54540-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729063117.54540-1-zenghongling@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 29, 2026 at 02:31:17PM +0800, Hongling Zeng wrote:
> Fix by changing the check from !split_sectors to split_sectors <= 0
> immediately after bio_split_rw_at() and before any arithmetic operations.
> This prevents both the negative error code propagation and the undefined
> behavior from left-shifting negative values.
> 
> When NULL is returned, the caller's while loop naturally terminates,
> which is the correct behavior for "cannot split" cases.
> 
> Fixes: 080d01c41d44f ("xfs: implement zoned garbage collection")
> Cc: <stable@vger.kernel.org>

Nothing can actually hit that.  It only happens for invalid flags,
or unaligned I/O, none of which can happen for GC I/O.

I think checking all cases of the return value is fine, but the fixes
is a bit bogus, and it really is not stable material.

