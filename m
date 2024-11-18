Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B48145A16;
	Mon, 18 Nov 2024 06:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731911395; cv=none; b=i3At7/JEMcUUhBwAx8bgdSmw88hbOqs1ZPSgKO7T1J6CiWL5TY3oJ0stdnZzLw7WszQNBvUVXgMEGyH0gqP/WJZLsho/xsk+eq5D1N/K21JQLZvxJ+htGzrfIMEKKDjjfIGhcsZh4sTV6+cWRjNFkV7RE/JfPQIpuYZTa0Xe9Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731911395; c=relaxed/simple;
	bh=ev9BjSlw7zUkqO3HRQh7AV1acr5gaD2o5YncQjhHz60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UpMnf7tl7tj9wPhkrmBJSdLQxNM8Hpxz5BZxUh1reGDLXNLbtJbrQLWfgcYANHqTgLUFUTKGPCtJadekrypvsEOaG0ePsk4lF9Q7R1lLIpPyXA++tdvAyIGb6x4vaBTWCuLO57RJyrtkzURTzMqv9g3ZKb20XXH4+3mdO44VlgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u30vy4Q9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u30vy4Q9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ejQ0qHYa2a9aJP6wtBIMu6a8RqHn3rX65MiWqvDFrAg=; b=u30vy4Q9W3DUEbpgh/V6Ly0WAs
	Bm+qSl+cQrUowh4THbT+EoPmNmxrGluQZBOVN4yPznvL3P6GVAkvhczUqR31M07E6dLJ1aDhT3DFy
	m0iL8fxDrD3R1abiryjK/clMG4dX9a0Sv1ZWkWVUO03cPh9p7g6Pd5BCLtzZI3JA8qZgQ/az+fTqz
	DsmpSxQvkRDTnxuNnFje37nEZHuxe6wSNDV19vdHSFiB8tpYDETJGUIGjijF54BiuOqP7rn6khGjs
	V0fkdC7GyTucgtukO8k3HPgggn9HlQTbvHkNh3A1DI0RlQZTHJJTETber57iZnvrOVf4kYAFXNi8Y
	e19q4Qrg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tCvGg-00000008WnI-3BYx;
	Mon, 18 Nov 2024 06:29:50 +0000
Date: Sun, 17 Nov 2024 22:29:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@infradead.org, djwong@kernel.org
Subject: Re: [PATCH v4 2/3] iomap: lift zeroed mapping handling into
 iomap_zero_range()
Message-ID: <Zzre3i7UZARRpVgC@infradead.org>
References: <20241115200155.593665-1-bfoster@redhat.com>
 <20241115200155.593665-3-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115200155.593665-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 15, 2024 at 03:01:54PM -0500, Brian Foster wrote:
> In preparation for special handling of subranges, lift the zeroed
> mapping logic from the iterator into the caller. Since this puts the
> pagecache dirty check and flushing in the same place, streamline the
> comments a bit as well.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

I don't want to block this improvement on stylistic things, but
I still don't like moving more code than the function invocation into
the iter body.  I hope you're okay with me undoing that sooner or later.

