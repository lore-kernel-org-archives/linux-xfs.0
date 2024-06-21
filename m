Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CF0EBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944365; cv=none; b=Xn9oHPIEpJTNRO91CJ9WxZhq8rm8Bqp/eMd5rZpjBu9Ki7W7elEhxj3VAXgb5h/yXfxYmBmZROeSnhyyxEoIt4cZb6w0wQ8i7JoM3Wd/ZZHSl4bLp7oOfHq6LOAAgngJ+b63NZ1ZUqH2q00JoT5l58RWgCXIT8gJutU80AU84Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944365; c=relaxed/simple;
	bh=ZZyC45AUOYcI/StuQbU/SUSv9n8rtUnhthDYFzKuBbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FdgCzzB8fhUgj8bESiVi9Kih4/xMOlbk0XBqrkbMiZMJIhHdb/KWokE8++2BSqP0YN611UJAQ/6rgZR+YcLCfih5Q8YcxZ2l83bHVH9dxO+HjA/VSa6rqPkcfBeWlUfU6YxwPQNLLvPj3zH4z+1t7UQ2HUrGskHmhCZVXPmU7EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mSUnyXeD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mSUnyXeD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3qLMXaYOsKpEaA5wBR4Jfd2Yy0G8tlOZOdPQ9aNTUaA=; b=mSUnyXeDErjOq0qGatyVjqNtaH
	JJsvGTYhSjoohb6HvmBiboBzx13yc9CUVJFxtjcrOoVCL7VNKk75cw63pAmdUhmkEGYDi2JsQPUEL
	kzsL9gT1C1e8BFq1XOaIChPk/ZBT/fB/VvJc09s3cUGFk/HoCQh7VVD7zOHs2iIDQCHuJwsZhB4PX
	Zo/RNWdcO3QA63NmyE+PIhBCwlDHpsRzI3nUtY/hSG8VOz2C3c4tW+OZc8ru1xeyC1ajg/tUzk3+2
	PSrak/Fp33HT3zyxP61eIq+cK+66ZeKDTGad4Dow/6VOfsiLVTMc1i/fLIX0TBi56drOcznlzFj8L
	h8A4zZHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKVx2-00000007eVV-1U51;
	Fri, 21 Jun 2024 04:32:40 +0000
Date: Thu, 20 Jun 2024 21:32:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: fix direction in XFS_IOC_EXCHANGE_RANGE
Message-ID: <ZnUCaCOJA5WMIsZN@infradead.org>
References: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
 <171892459317.3192151.14305994848485102437.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892459317.3192151.14305994848485102437.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 20, 2024 at 04:14:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The kernel reads userspace's buffer but does not write it back.
> Therefore this is really an _IOW ioctl.  Change this before 6.10 final
> releases.

Eww, yes:

Reviewed-by: Christoph Hellwig <hch@lst.de>

