Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6E21547CC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734070303; cv=none; b=rJqHlAC8xvjVa0rbnxNlfhzKhhLAjaYgK3YHotnYdmxpF0C5ZjKKZpqhBn6dwYUwXXKmfsO3Cuoy6bvhN3qhH+Jks+F2dzLLjxexUwLc5WBLPV+UigSWaUtLzlMM/7dUbZf5KplxhwIFLlDLLp90ynqVeW85i4ZnF4vvzYDH0zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734070303; c=relaxed/simple;
	bh=Uu6FPqsBPz5FspPogV3D+JVUOV7tWxdabjye8E7DLas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cDWkCnkjRoXpsJWtkwZQLo4QLIF1A27QXuA5KRWBc2/td9J3opLCzw5vG4L2b1/MYp95Zt4ujn4k3ZzgdpicQfzW+J++Bs/xkCzqtATmd0mgfc90pPkj0CXXm/XMGgH8fTTpT+cfcspgpGIUjE1a5HBz+mAiIhv//09IOFWNMec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vLvqmXyK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vLvqmXyK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+5gvC8i7L+CYjVY/aqf1R7I8rc9A6l3U3tmqKXMznSU=; b=vLvqmXyKNtZPGAc0FOTukXVhnp
	HJJsD5YUZ9tA7+7jXONvc6rUCKkPODXPUPqPr3Xdi1Ca5rzYVfwzOpRjsvjhlLOmhoZSMY9MSSaK1
	P1hTGUmVmI43knLgd0nRW4xNUc6HSrS+KoOqAx6xQL7bDAWMYvkXX8JPuF8JRT6YruELCE76NOFQY
	8yxXYHc2dV7skdXB8YydbcUQNjqkiPhV1SG/hV/7TSpO3j32lEysQJiDV015RZ9LRte+NZSZa3HqP
	JDu6cowwTuOWe51ibXw1W/Oc4zZj+maNH6z3nhRXzeahMR37XJoN97WY1KhNSDMRSibJNM9Hw0//D
	F4ymye1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLytq-00000002qNu-0YP5;
	Fri, 13 Dec 2024 06:11:42 +0000
Date: Thu, 12 Dec 2024 22:11:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/37] xfs: add some rtgroup inode helpers
Message-ID: <Z1vQHmahZVMnnOdi@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123329.1181370.17404943645784258939.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123329.1181370.17404943645784258939.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:00:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create some simple helpers to reduce the amount of typing whenever we
> access rtgroup inodes.  Conversion was done with this spatch and some
> minor reformatting:

I remember this change from somewhere :)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

