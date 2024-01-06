Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BAD3C07
	for <linux-xfs@vger.kernel.org>; Sat,  6 Jan 2024 06:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4eyM5Nvd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jFK8d3bEooUYN5jnT8LTSjww8fGYCaB91YvoPSZvdG8=; b=4eyM5NvdoQiXEyo0t6ekKDyufg
	fgoEvz6n5HzEKJbLS3DGiH60zfG/IHMR145XoCP3vj5W+dXzowE9EAjovImmQ7S+ewn5rGPVvV4jn
	hf1RACMAYuVIE+O+M3BLokELhIe7VfV5Fw8Z7HhJwKtCXcjCw949J9dNnwcQ/aFujq8hE9HiFM1jU
	Bl7x3aSPvQwi378pfwdCGcQQP+hBvsRVnAv53Xba1yy2dI2NZL1KEtc6VI/V26lxiC0jpTVXhhPnh
	W4vq+OBciXz9uJWDVs59rm5SvSLm5Y8+9hSLMZ44ISxeJxLOF5Hqe/w6vVMR+LLU92//rjg9Ck8xK
	BNVmKLhA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rM0Nd-000qtr-1y;
	Sat, 06 Jan 2024 06:42:01 +0000
Date: Fri, 5 Jan 2024 22:42:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: create a blob array data structure
Message-ID: <ZZj2OZooCt8QWnTB@infradead.org>
References: <170404835198.1753315.999170762222938046.stgit@frogsfrogsfrogs>
 <170404835229.1753315.13978723246161515244.stgit@frogsfrogsfrogs>
 <ZZeZXVguVfGz+wyD@infradead.org>
 <20240106013316.GL361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240106013316.GL361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 05, 2024 at 05:33:16PM -0800, Darrick J. Wong wrote:
> (Unless you want to sponsor a pwrite variant that actually does "append
> and tell me where"? ;))

Damien and I have adding that on our TODO list (through io_uring) to
better support zonefs and programming models like this one on regular
files.

But I somehow doubt you'd want xfs_repair to depend on it..
