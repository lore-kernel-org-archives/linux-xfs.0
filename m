Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D06739F190;
	Wed,  7 Oct 2026 13:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378224; cv=none; b=Jmnn+Wpn+mCWQbHjjnvutN9Ge5m0LUQw0MBTBKuypuW0dyi2xXT9klQLiIj5zak9UZfroK0OAkQn39witCSbecZ05OZx+FBcO3EQZvsI0hGybVThX4LJ+2j3QJqYgvrWAXcfdtRB2lF7L0Bdacd7bzFztcNgxdFfvqG1OyMbWKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378224; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=js2wqRl8sJj97aHrlJGaDMxWBdh4mVXVvwNI3sDQHnzgiamDqH3BhTnBVuvyz95kxTIwdo4tMOPX3KdihYsDUvyrPTcNQ6ovqKxgtRNKfeG50QbcbECyzynkC26VFC4zlh8MvVLgl1mewcawytn94EU3BgEQ4t1nVCyKvmahrws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CWulOdL3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CWulOdL3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CWulOdL3r+IBtzzDKZgAuy6u6Z
	AdMQQyDXjBxLuhlikKUuWV4/X2bZnNkTq2jF1eDjF3tvegHJS/yUnEFbF7PQuVsft8f0+q3/LZXTV
	/nzKQN3goHeWSzbFZeBkEdqlSJ8TQ6B7HpEEcz7B2npOx++Cl5Bxpq1+pprWE0FMV0+irBu5J1fGG
	ty79wLIQJ48hZKqvDaQ/1AqYD39eBl0NI8Ml8usV/jfxWS9NZJj1Inc/HIfqBfM7tulqyyEUWKjtx
	I0Gfk5c7lYNPSbGZzSS3VfJyNqWZqK3vVjVnCfcJUoKekawJUFsga7xYglC0CYliCi5ypBv28qC+7
	cHUVuDTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xERJ1-00000002V23-2yZm;
	Wed, 07 Oct 2026 13:03:36 +0000
Date: Wed, 7 Oct 2026 06:03:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: forcibly reset quota timers when upgrading to
 bigtime during repair
Message-ID: <asZDJx9COkmvDtJX@infradead.org>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
 <179117965073.614350.15394600697823793893.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179117965073.614350.15394600697823793893.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

