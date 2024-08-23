Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6528259C
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724387882; cv=none; b=Zq8xsVkFCa8gqYMnfZGw2Q9ydtWlrJZZ0YgGLZbzUAhO597E90JC9XMjj7YggSTUnWDmIH8RYFboGm5BkLAXsSESipq2invwJbQp0md8O3IChrSlJgg/PaA3yCA0kPL3c32S02n/0ZIbuSykuHEnQ95d2AB7dsKPbCcAiwQl9WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724387882; c=relaxed/simple;
	bh=cYGK3nmpJMGgslTAK3GmS+HFGIJgfuWtChSTQFYLLvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oufUOjrz2s0y2yQBoofFm55AX5NhADcVb+E4TDzMZ1d0z/QP8a0/c1qSL7VXuWJbRw7yFjnOFgM5yQkk82uTnrapXEc7MIZ/0vo4oxOi/rfbvE5JP7d3l3PYywbljYyehmooSqyEqO3nQKNRjrpX+vFLqZ25TERxPqShn1YjtpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z9yzk/A3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z9yzk/A3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KM9bhjbdCJZslEw5z7R7MD5cJG3ilcGZ+7wQ/r2wwvs=; b=Z9yzk/A3gcZe7Y/p3wq0sEtZQ8
	L4ytugQwVQJ/tHKSuRK9e0gZxBWnXqKlQKhbHjqLh6K/rdmGB7UG3jEcUHL9ws9MJpvc4qUlyaq2C
	KcH6UPeZy8X8hp0ndtqEPQK4ZAVtKMqr4LY1px+O/Vs2kTJp8OkyOvecOx9KWFGlgaOxDzM66RE5r
	SzoZ+wMxG1uS9AcGPjOYaB+i9XkF4zRMaXvzPRtFf9QtTb7oSGK7PdKzO8wOHCi3cvUhIURvliqKV
	uCnvPGXRIS7aM5mQp1THtqOnfjKFVtLs7IRbnTopfHrN+AgPn9L5At/GNlkUOJ6TKXp3j2ZPC/u+L
	eqlPG88g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shM3k-0000000FD8J-2GyY;
	Fri, 23 Aug 2024 04:38:00 +0000
Date: Thu, 22 Aug 2024 21:38:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs: enforce metadata inode flag
Message-ID: <ZsgSKIpnSEYQKWRB@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085258.57482.14715560733408039930.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085258.57482.14715560733408039930.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	/* Mandatory directory flags must be set */

s/directory/inode/ ?

> +/* All metadata directory files must have these flags set. */

s/directory files/directories/ ?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
