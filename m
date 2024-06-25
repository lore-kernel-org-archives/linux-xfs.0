Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03F61494A8;
	Tue, 25 Jun 2024 11:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719314101; cv=none; b=oY/0UIHBHbJxlBlQ1zpEywWWoXTeOjAKxzVrb31JF097G9vjeB4AlGg0NYK2xBueM1gdENoYk0hdhMK/zmjW5wz2kXCmRPgGd3ensznfnHzoB1aMhPIFRzi8ffOqYx4GwXyMDiUrVrJZvbI9bqO6283WXHg88tzjNXH4W7GiIvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719314101; c=relaxed/simple;
	bh=8MBnL0CiEQXlt4JrauiPmJszJMYo2tDQkSCVZHRCQOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N6o8U2zVv84zdBzWktkjMa2iyr/0JBKz7EoL/Aauh2Ftox+0DgucgK1p1xZ3zF/wyjnS3l+5qwCuw0zvsRJSOryOAljDO9NwXMKWkvl5ewGS6ZdhKP7nkumFA2hja8Q2peMJe+4PDXhw3FLwz1AP1+PCqlpcURHiLTvHXrJOSmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RCqwTvNo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RCqwTvNo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=56AFJbUXa8ufpLqSNwpW4BeYMS/Ip45Y1/frq6urfAo=; b=RCqwTvNoYj0qreSoiMOWPWNv8M
	OM9y+LyCZHl4YQoNVN3Mke3vRMRRlgtvi8jT/uDhWbit/Oq24+zDqYhf+iibKUKIcbttrv2nJm2Go
	xDMXsIJiy47Ke8H4Qxi29uvydUW9/hMLwbxx5wBcV6nOGokGsQYm6otsrmc8cEnx3nxBCVUTddo5I
	r+WhYO1PWzrIVYPD30HM4HxLc7DMozEv3QdwKJWn9k0GfSj9ekLFJTfJs/qsWDL8eB1r6pweULHor
	AGvMXMSybMJy12vmRf1AjZRiUACV0rSZLbmvTE3ISfhwUb0t9kWKfKoXrzAeqCTKdm+vn2Cf/eZ67
	nvWL2BFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM48V-00000002Vao-30Pc;
	Tue, 25 Jun 2024 11:14:55 +0000
Date: Tue, 25 Jun 2024 04:14:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: djwong@kernel.org, alexjlzheng@tencent.com, chandan.babu@oracle.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH] xfs: make xfs_log_iovec independent from xfs_log_vec and
 release it early
Message-ID: <Znqmr3Iki4Q8BkxJ@infradead.org>
References: <20240624152529.GD3058325@frogsfrogsfrogs>
 <20240624160614.1984901-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624160614.1984901-1-alexjlzheng@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 25, 2024 at 12:06:14AM +0800, Jinliang Zheng wrote:
> xfs_log_iovec is where all log data is saved. Compared to xfs_log_vec itself,
> xfs_log_iovec occupies a larger memory space.
> 
> When their memory spaces are allocated together, the memory occupied by
> xfs_log_iovec can only be released after iclog is written to the disk log
> space. But when xfs_log_iovec is written to iclog, its existence becomes
> meaningless, because a copy of its content is already saved in iclog at this
> time.
> 
> And if they are separated, we can release its memory when the data in
> xfs_log_iovec is written to iclog. The interval between these two time points
> is not too small.
> 
> Since xfs_log_iovec is the area that currently uses the most memory in
> xfs_log_vec, this means that we have released quite a lot of memory. Freeing
> memory that occupies a larger size earlier means smaller memory usage.

This all needs to go into the commit log.  Preferably including the
actual quantity of memory saved for a useful workload.
